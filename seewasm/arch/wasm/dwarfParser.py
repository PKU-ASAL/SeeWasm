import logging
import os

from elftools.dwarf.descriptions import describe_form_class
from elftools.dwarf.dwarf_expr import DWARFExprOp, DWARFExprParser
from seewasm.arch.wasm.configuration import bcolors
from seewasm.arch.wasm.memory import lookup_symbolic_memory_data_section

dwarf_section_names = ('.debug_info', '.debug_aranges', '.debug_abbrev',
                       '.debug_str', '.debug_line', '.debug_frame',
                       '.debug_loc', '.debug_ranges', '.debug_pubtypes',
                       '.debug_pubnames', '.debug_addr', '.debug_str_offsets')
EMSCRIPTEN_SP_GLOBAL_INDEX = 0


def get_real_addr(ana, func_ind, func_offset):
    """converts function id and instruction offset within function to instruction offset within Code Section"""
    # is not import function, and prevents negative index
    assert func_ind >= len(ana.imports_func)
    return ana.func_offsets[func_ind - len(ana.imports_func)] + func_offset


def get_source_location(ana, func_ind, func_offset, is_full_path=True):
    """get source location by function id and instruction offset within function"""
    return get_source_location_by_addr(
        ana.dwarf_info, get_real_addr(ana, func_ind, func_offset),
        is_full_path)


def get_source_location_range(ana, func_ind, func_offset, is_full_path=True):
    """
    get source location range by function id and instruction offset within function
    returns ((start_file, line_no, col_no), (next_file, next_line_no, next_col_no))
    """
    return get_source_location_by_addr(
        ana.dwarf_info, get_real_addr(ana, func_ind, func_offset),
        is_full_path, is_range=True)


def get_source_location_string(ana, func_ind, func_offset, is_full_path=True):
    """
    get source location string to be printed, according to debug info precision
    returns 'In file xxx, line no: xxx, col no: xxx'
    or 'In file xxx, line no: xxx to xxx'
    """
    loc_start, loc_end = get_source_location_range(
        ana, func_ind, func_offset, is_full_path)
    start_file, line_no, col_no = loc_start
    end_file, end_line_no, end_col_no = loc_end
    if start_file != end_file:
        # due to function inlining, this case should be rare
        # TODO probably should find next entry until meet same file?
        return f'From file {start_file}, line no: {line_no}, To file {end_file}, line no: {end_line_no}'
    elif line_no == end_line_no:
        # same line, locations is exact
        # possibly end_col_no < col_no
        return f'In file {start_file}, line no: {line_no}, col no: {col_no}'
    else:  # same file, but not same line
        return f'In file {start_file}, line no: {line_no} to {end_line_no}'


def get_func_DIE(ana, func_ind, func_offset):
    """get source function name by function id and instruction offset within function"""
    return get_func_DIE_by_addr(
        ana.dwarf_info, get_real_addr(ana, func_ind, func_offset))


def get_source_location_by_addr(
        dwarf_info, addr, is_full_path=True, is_range=False):
    """
    get source location by instruction offset within Code Section
    if absolute directory infomation is recorded, set is_full_path to True, returns absolute path in filename.
    it's possible that column is 0. which means not recorded.
    if is_range is True, then returns ((filename, line, column), (filename, line, column))
    """
    # from https://github.com/eliben/pyelftools/blob/master/examples/dwarf_decode_address.py
    # Go over all the line programs in the DWARF information, looking for
    # one that describes the given address.

    def get_filename(lineprog, state, is_full_path=True):
        if is_full_path:
            filename = lpe_filename(lineprog, state.file)
        else:
            filename = lineprog['file_entry'][state.file - 1].name
        return filename

    for CU in dwarf_info.iter_CUs():
        # First, look at line programs to find the file/line for the address
        lineprog = dwarf_info.line_program_for_CU(CU)
        prevstate = None
        for entry in lineprog.get_entries():
            # We're interested in those entries where a new state is assigned
            if entry.state is None:
                continue
            # Looking for a range of addresses in two consecutive states that
            # contain the required address.
            if prevstate and prevstate.address <= addr < entry.state.address:
                filename = get_filename(lineprog, prevstate, is_full_path)
                if is_range:
                    prev_loc = (filename, prevstate.line, prevstate.column)
                    next_filename = get_filename(
                        lineprog, entry.state, is_full_path)
                    next_loc = (next_filename, entry.state.line,
                                entry.state.column)
                    if filename != next_filename:
                        logging.warning(
                            f"{bcolors.WARNING}Source location range filename mismatch! probably due to aggressive optimization (function inlining){bcolors.ENDC}")
                    return (prev_loc, next_loc)
                line = prevstate.line
                column = prevstate.column
                return filename, line, column
            if entry.state.end_sequence:
                # For the state with `end_sequence`, `address` means the address
                # of the first byte after the target machine instruction
                # sequence and other information is meaningless. We clear
                # prevstate so that it's not used in the next iteration. Address
                # info is used in the above comparison to see if we need to use
                # the line information for the prevstate.
                prevstate = None
            else:
                prevstate = entry.state
    return None, None, None


def get_func_DIE_by_addr(dwarf_info, addr):
    """get source function Debug Info Entry by instruction offset within Code Section"""
    # from https://github.com/eliben/pyelftools/blob/master/examples/dwarf_decode_address.py
    # Go over all DIEs in the DWARF information, looking for a subprogram
    # entry with an address range that includes the given address. Note that
    # TODO this simplifies things by disregarding subprograms that may have
    # split address ranges.
    for CU in dwarf_info.iter_CUs():
        for DIE in CU.iter_DIEs():
            try:
                if DIE.tag == 'DW_TAG_subprogram':
                    lowpc = DIE.attributes['DW_AT_low_pc'].value

                    # DWARF v4 in section 2.17 describes how to interpret the
                    # print(function_len_dict)
                    # DW_AT_high_pc attribute based on the class of its form.
                    # For class 'address' it's taken as an absolute address
                    # (similarly to DW_AT_low_pc); for class 'constant', it's
                    # an offset from DW_AT_low_pc.
                    highpc_attr = DIE.attributes['DW_AT_high_pc']
                    highpc_attr_class = describe_form_class(
                        highpc_attr.form)
                    if highpc_attr_class == 'address':
                        highpc = highpc_attr.value
                    elif highpc_attr_class == 'constant':
                        highpc = lowpc + highpc_attr.value
                    else:
                        logging.warning(
                            f"Error: invalid DW_AT_high_pc class: {highpc_attr_class}")
                        continue

                    if lowpc <= addr < highpc:
                        return DIE
            except KeyError:
                continue
    return None


op2name = {0x0: "wasm-local", 0x1: "wasm-global",
           0x2: "wasm-operand-stack", 0x3: "wasm-global"}


def parse_expr(dwarf_info, expr):
    """
    decode variable location expression
    additional support for DW_OP_WASM_location(0xED)
    .. seealso:: https://yurydelendik.github.io/webassembly-dwarf/#DWARF-expressions-and-location-descriptions
    """
    exps = []
    if expr[0] == 0xED:
        exps.append(DWARFExprOp(expr[1], op2name[expr[1]], [expr[2]]))
        expr = expr[3:]
    exps += DWARFExprParser(dwarf_info.structs).parse_expr(expr)
    return exps


def decode_vararg(state, addr_stack, index):
    """
    decode index-th argument in vararg function.
    index starting from 0.

    vararg implemented in wasm backend as placing variable at stack top,
    and pass an additional argument, (usually equals to stack pointer)
    this function decode argument by the additional argument as address
    to access memory for real vararg argument.
    """
    addr = addr_stack + index * 4
    addr = lookup_symbolic_memory_data_section(
        state.symbolic_memory, dict(), addr, 4).as_long()
    return addr


def get_size_by_type(die):
    """
    Get size of a DW_AT_type Debug Info Entry.
    Used by decode_var_type to decide if the address points into an variable.
    """
    if die.tag == 'DW_TAG_base_type':
        return die.attributes['DW_AT_byte_size'].value
    elif die.tag in ('DW_TAG_pointer_type', 'DW_TAG_subroutine_type'):
        return 4
    elif die.tag == 'DW_TAG_array_type':
        ele_size = get_size_by_type(die.get_DIE_from_attribute('DW_AT_type'))
        for child in die.iter_children():
            if child.tag == 'DW_TAG_subrange_type':
                ele_count = child.attributes['DW_AT_count'].value
        return ele_size * ele_count
    elif die.tag == 'DW_TAG_typedef':
        return get_size_by_type(die.get_DIE_from_attribute('DW_AT_type'))
    else:
        logging.error(f"Unknown type tag: {die.tag}")
        return 4


def get_value(func_DIE, ana, state):
    fb_expr = func_DIE.attributes['DW_AT_frame_base'].value
    fb_loc = parse_expr(ana.dwarf_info, fb_expr)
    assert fb_loc[1].op_name == 'DW_OP_stack_value'
    fb_loc = fb_loc[0]  # type: DWARFExprOp
    if fb_loc.op_name == 'wasm-local':
        fb_value = state.local_var[fb_loc.args[0]].as_long()
    elif fb_loc.op_name == 'wasm-global':
        fb_value = state.globals[fb_loc.args[0]].as_long()
    else:  # operand stack
        raise Exception("Unimplemented")


def decode_var_type(ana, state, addr_stack, use_global_sp=False):
    """
    Get variable die by stack address.
    Using function address in state to find related function DIE.
    returns type_die, variable_size

    when use_global_sp=True, it implies that the module keeps a global stack pointer
    in global 0 (__stack_pointer), and now it is executing this function's body (after
    prologue which sets setting stack pointer).
    TODO recursive search in caller frame and more robust decode algorithm
    .. seealso:: https://github.com/emscripten-core/emscripten/blob/4d864df0a57024d667e8db171aab2c3385d04c30/system/lib/compiler-rt/stack_limits.S#L17
    """
    func_ind = get_func_index_from_state(ana, state)
    func_offset = state.instr.offset
    func_DIE = get_func_DIE(ana, func_ind, func_offset)
    if func_DIE is None:
        print(
            f"{bcolors.WARNING}unable to get function DIE! index: {func_ind}, instruction offset in function: {func_offset}{bcolors.ENDC}")
        logging.warning(
            f"{bcolors.WARNING}unable to get function DIE! index: {func_ind}, instruction offset in function: {func_offset}{bcolors.ENDC}")
        return None, None
    func_name = func_DIE.attributes['DW_AT_name'].value.decode()
    if not use_global_sp:
        fb_expr = func_DIE.attributes['DW_AT_frame_base'].value
        fb_loc = parse_expr(ana.dwarf_info, fb_expr)
        assert fb_loc[1].op_name == 'DW_OP_stack_value'
        fb_loc = fb_loc[0]  # type: DWARFExprOp
        if fb_loc.op_name == 'wasm-local':
            fb_value = state.local_var[fb_loc.args[0]].as_long()
        elif fb_loc.op_name == 'wasm-global':
            fb_value = state.globals[fb_loc.args[0]].as_long()
        else:  # operand stack
            raise Exception("Unimplemented")
    else:
        fb_value = state.globals[EMSCRIPTEN_SP_GLOBAL_INDEX].as_long()
    delta = addr_stack - fb_value
    for die in func_DIE.iter_children():
        if die.tag == 'DW_TAG_variable':
            variable_name = die.attributes['DW_AT_name'].value.decode()
            loc_expr = die.attributes['DW_AT_location'].value
            variable_loc = parse_expr(ana.dwarf_info, loc_expr)[0]
            if variable_loc.op_name == 'DW_OP_fbreg':
                start = variable_loc.args[0]
                type_die = die.get_DIE_from_attribute('DW_AT_type')
                size = get_size_by_type(type_die)
                if start <= delta and delta < start + size:
                    return type_die, size
    logging.warning(
        f"{bcolors.WARNING}unable to decode variable type: function: {func_name}, offset: {delta}{bcolors.ENDC}")
    return None, None


def get_func_index_from_state(ana, state):
    func_ind = -1
    assert(len(ana.names) == len(ana.func_prototypes))
    for i, item in enumerate(ana.names):
        if str(item[2], 'UTF-8') == state.current_func_name:
            func_ind = i
            break
    assert func_ind != - \
        1, f"Cannot find the func index of func: {state.current_func_name}"
    return func_ind


def lpe_filename(line_program, file_index):
    """
    Retrieving the full filename associated with a line program entry.
    """
    # from https://github.com/eliben/pyelftools/blob/master/examples/dwarf_lineprogram_filenames.py#L68
    lp_header = line_program.header
    file_entries = lp_header["file_entry"]

    # File and directory indices are 1-indexed.
    file_entry = file_entries[file_index - 1]
    dir_index = file_entry["dir_index"]

    # A dir_index of 0 indicates that no absolute directory was recorded during
    # compilation; return just the basename.
    if dir_index == 0:
        return file_entry.name.decode()

    directory = lp_header["include_directory"][dir_index - 1]
    return os.path.join(directory, file_entry.name).decode()
