import os
from elftools.dwarf.descriptions import describe_form_class


def get_real_addr(func_ind, func_offset, imports_func, func_offsets):
    """converts function id and instruction offset within function to instruction offset within Code Section"""
    # is not import function, and prevents negative index
    assert func_ind >= len(imports_func)
    return func_offsets[func_ind - len(imports_func)] + func_offset


def get_source_location(func_ind, func_offset, imports_func, func_offsets, dwarfinfo, full_path=True):
    """get source location by function id and instruction offset within function"""
    return get_source_location_by_addr(get_real_addr(func_ind, func_offset, imports_func, func_offsets), dwarfinfo, full_path)


def get_func_name(func_ind, func_offset, imports_func, func_offsets, dwarfinfo):
    """get source function name by function id and instruction offset within function"""
    return get_func_name_by_addr(get_real_addr(func_ind, func_offset, imports_func, func_offsets), dwarfinfo)


def get_source_location_by_addr(addr, dwarfinfo, full_path=True):
    """
    get source location by instruction offset within Code Section
    if absolute directory infomation is recorded, set full_path to True, returns absolute path in filename.
    it's possible that column is 0. which means not recorded.
    """
    # from https://github.com/eliben/pyelftools/blob/master/examples/dwarf_decode_address.py
    # Go over all the line programs in the DWARF information, looking for
    # one that describes the given address.
    for CU in dwarfinfo.iter_CUs():
        # First, look at line programs to find the file/line for the address
        lineprog = dwarfinfo.line_program_for_CU(CU)
        prevstate = None
        for entry in lineprog.get_entries():
            # We're interested in those entries where a new state is assigned
            if entry.state is None:
                continue
            # Looking for a range of addresses in two consecutive states that
            # contain the required address.
            if prevstate and prevstate.address <= addr < entry.state.address:
                if full_path:
                    filename = lpe_filename(lineprog, prevstate.file)
                else:
                    filename = lineprog['file_entry'][prevstate.file - 1].name
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


def get_func_name_by_addr(addr, dwarfinfo):
    """get source function name by instruction offset within Code Section"""
    # from https://github.com/eliben/pyelftools/blob/master/examples/dwarf_decode_address.py
    # Go over all DIEs in the DWARF information, looking for a subprogram
    # entry with an address range that includes the given address. Note that
    # TODO this simplifies things by disregarding subprograms that may have
    # split address ranges.
    for CU in dwarfinfo.iter_CUs():
        for DIE in CU.iter_DIEs():
            try:
                if DIE.tag == 'DW_TAG_subprogram':
                    lowpc = DIE.attributes['DW_AT_low_pc'].value

                    # DWARF v4 in section 2.17 describes how to interpret the
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
                        print('Error: invalid DW_AT_high_pc class:',
                              highpc_attr_class)
                        continue

                    if lowpc <= addr < highpc:
                        return DIE.attributes['DW_AT_name'].value
            except KeyError:
                continue
    return None


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
