# These functions are predefined and we will emulate their behaviors

import logging

from eunomia.arch.wasm.configuration import Configuration, bcolors
from eunomia.arch.wasm.dwarfParser import (get_func_index_from_state,
                                           get_source_location,
                                           get_source_location_string)
from eunomia.arch.wasm.instruction import WasmInstruction
from eunomia.arch.wasm.memory import (insert_symbolic_memory,
                                      lookup_symbolic_memory_data_section)
from eunomia.arch.wasm.utils import (C_TYPE_TO_LENGTH, getConcreteBitVec,
                                     parse_printf_formatting)
from z3 import (Z3_OP_ITE, BitVec, BitVecVal, BoolVal, Extract, is_bv_value,
                is_const, is_eq, is_expr, is_not, simplify)

_values = {
    0: BitVec("NaN", 32),
    1: BitVecVal(0, 32),
    2: BitVec("null", 32),
    3: BoolVal(True),
    4: BoolVal(False),
    5: BitVec("global", 32),
    6: BitVec("global.Go", 32)}  # module the memory map in wasm_exec.js


def calculateHeapAddresses(state, data_section):
    val_81328 = simplify(
        lookup_symbolic_memory_data_section(
            state.symbolic_memory, data_section, 81328, 4) +
        15) & 4294967280  # calculate heap start
    val_81328 = simplify(val_81328)
    state.symbolic_memory = insert_symbolic_memory(
        state.symbolic_memory, 81328, 4, val_81328)  # save the heap start
    val_85336 = lookup_symbolic_memory_data_section(
        state.symbolic_memory, data_section, 85336, 4)  # heap end address
    val_diff = simplify((val_85336 - val_81328) >> 6)  # meta_data_size
    # heap end - meta_data_size (meta_data_start)
    val_85336 = simplify(val_85336 - val_diff)
    state.symbolic_memory = insert_symbolic_memory(
        state.symbolic_memory, 85464, 4, val_85336)  # save the meta data (of the heap) start
    # remain heap size (remain block numbers, per block 16 bytes)
    val_3 = simplify((val_85336 - val_81328) >> 4)
    state.symbolic_memory = insert_symbolic_memory(
        state.symbolic_memory, 85472, 4, val_3)  # save the remain block numbers (endBlock)


class GoPredefinedFunction:
    def __init__(self, name, cur_func_name):
        self.name = name
        self.cur_func = cur_func_name

    def emul(self, state, param_str, return_str, data_section, analyzer):
        # if the return value is dependent on the library function, we will manually contruct it
        # and jump over the process in which it append a symbol according to the signature of the function
        manually_constructed = False

        param_list = []
        if param_str:
            num_arg = len(param_str.split(' '))
            for _ in range(num_arg):
                param_list.append(state.symbolic_stack.pop())

        # helper function to convert from z3 value to python integer
        def concrete_value(x):
            return x.as_long() if is_bv_value(x) else x
        # helper functions to access memory

        def load32(x):
            return concrete_value(
                lookup_symbolic_memory_data_section(
                    state.symbolic_memory, data_section, x, 4))

        def load8(x):
            return concrete_value(
                lookup_symbolic_memory_data_section(
                    state.symbolic_memory, data_section, x, 1))

        def store32(addr, val):
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, addr, 4, BitVecVal(val, 32))

        def store8(addr, val):
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, addr, 1, BitVecVal(val, 8))

        def GO_extract_string_by_mem_pointer(addr, len):
            ret = []
            for i in range(len):
                ret.append(load8(addr + i))
            return bytes(ret)

        def decode_golang_string(addr):
            # type _string struct { ptr *byte, length uintptr }
            string_ptr = load32(addr)
            string_len = load32(addr + 4)
            return GO_extract_string_by_mem_pointer(string_ptr, string_len)

        # ------------------------ TinyGO Library -------------------------------
        # could be step in, remain for understanding the memory structure.
        if self.name == 'fmt.Scanf':
            # func Scanf(format string, a ...interface{}) (n int, err error)
            # define internal { i32, %runtime.funcValueWithSignature } @fmt.Scanf(i8* %format.data, i32 %format.len, %runtime.funcValueWithSignature* %a.data, i32 %a.len, i32 %a.cap, i8* %context, i8* %parentHandle)
            param_list[:] = map(concrete_value, param_list)
            pret, format_data, format_len, interface_slice_data = param_list[
                -1], param_list[-2], param_list[-3], param_list[-4]
            interface_slice_len, interface_slice_cap, context, parentHandle = param_list[
                -5], param_list[-6], param_list[-7], param_list[-8]
            num_scanned = 0
            format_str = GO_extract_string_by_mem_pointer(
                format_data, format_len).decode()

            parsed_patterns = parse_printf_formatting(format_str)

            for i, parsed_pattern in enumerate(parsed_patterns):
                line_num, str_ind, cur_pattern = parsed_pattern[0], parsed_pattern[1], parsed_pattern[2]
                # decode interface slice
                assert i < interface_slice_len
                param_interface_ptr = load32(interface_slice_data + 8 * i + 4)
                if cur_pattern[-1] == 's':
                    # we need to alloc memory to store string(call runtime.alloc),
                    # then store the pointer and size to the string struct in vargs.

                    # find the index of runtime.alloc
                    runtime_alloc_ind = -1
                    for ind, name in Configuration.get_func_index_to_func_name().items():
                        if name == 'runtime.alloc':
                            runtime_alloc_ind = ind
                    assert runtime_alloc_ind != -1
                    # TODO we insert a `abcd` here, maybe we should insert a symbol
                    write_bytes = b'abcd'
                    # runtime.alloc (param i32 i32 i32 i32) (result i32)
                    # i8* @runtime.alloc(i32 %size, i8* %layout, i8* %context, i8* %parentHandle)
                    alloc_size = len(write_bytes)
                    inst_call = WasmInstruction(
                        0x10, 'call', None, None, b'\x10', 0, 0,
                        'call a function', 'call ' + str(runtime_alloc_ind),
                        -1)
                    arguments = [BitVecVal(0, 32) for i in range(3)]
                    arguments.insert(0, BitVecVal(alloc_size, 32))
                    for a in arguments:
                        state.symbolic_stack.append(a)
                    new_states = Graph.wasmVM.emulate_one_instruction(
                        inst_call, state, 0, [True], 0)
                    assert len(new_states) == 1
                    # assign state to new state? TODO
                    state.symbolic_memory = new_states[0].symbolic_memory
                    state.symbolic_stack = new_states[0].symbolic_stack
                    heap_ptr = concrete_value(state.symbolic_stack.pop())
                    for j in range(alloc_size):
                        store8(heap_ptr + j, write_bytes[j])

                    # set string struct
                    store32(param_interface_ptr, heap_ptr)
                    store32(param_interface_ptr + 4, alloc_size)
                    num_scanned += 1
                elif cur_pattern[-1] in {'d', 'u', 'x', 'c'}:
                    # current = load32(param_interface_ptr)
                    func_ind = get_func_index_from_state(analyzer, state)
                    func_offset = state.instr.offset
                    original_file, line_no, col_no = get_source_location(
                        analyzer, func_ind, func_offset)
                    inserted_variable = BitVec(
                        f"scanf_{original_file}_{line_no}_{col_no}_[{i}]_{param_interface_ptr}",
                        C_TYPE_TO_LENGTH[cur_pattern[-1]] * 8)
                    # store symblic integer to memory address
                    state.symbolic_memory = insert_symbolic_memory(
                        state.symbolic_memory, param_interface_ptr,
                        C_TYPE_TO_LENGTH[cur_pattern[-1]],
                        inserted_variable)
                    logging.info(
                        f"============Initiated an scanf integer: scanf_{original_file}_{line_no}_{col_no}_[{i}]_{param_interface_ptr}============")
                    num_scanned += 1
            store32(pret, num_scanned)
            store32(pret + 4, 0)
            manually_constructed = True
        elif self.name == 'fmt.Printf':
            # currently only support %[scfdux]
            # func Printf(format string, a ...any) (n int, err error) {
            # define internal { i32, %runtime.funcValueWithSignature } @fmt.Printf(i8* %format.data, i32 %format.len, %runtime.funcValueWithSignature* %a.data, i32 %a.len, i32 %a.cap, i8* %context, i8* %parentHandle)
            # n is the number of bytes written.
            param_list[:] = map(concrete_value, param_list)
            pret, format_data, format_len, interface_slice_data = param_list[
                -1], param_list[-2], param_list[-3], param_list[-4]
            interface_slice_len, interface_slice_cap, context, parentHandle = param_list[
                -5], param_list[-6], param_list[-7], param_list[-8]
            format_str = GO_extract_string_by_mem_pointer(
                format_data, format_len).decode()

            parsed_patterns = parse_printf_formatting(format_str)
            out_bytes = b''
            parsed_ind = 0

            for i, parsed_pattern in enumerate(parsed_patterns):
                line_num, str_ind, cur_pattern = parsed_pattern[0], parsed_pattern[1], parsed_pattern[2]
                # decode interface slice
                assert i < interface_slice_len
                param_interface_ptr = load32(interface_slice_data + 8 * i + 4)
                out_bytes += format_str[parsed_ind:str_ind].encode()
                parsed_ind = str_ind + len(cur_pattern)
                if cur_pattern[-1] == 's':
                    out_bytes += decode_golang_string(param_interface_ptr)
                elif cur_pattern[-1] == 'c':
                    data = param_interface_ptr
                    if is_expr(data):
                        out_bytes += str(data).encode()
                    else:
                        out_bytes += chr(data).encode()
                elif cur_pattern[-1] == 'x':
                    data = param_interface_ptr
                    if is_expr(data):
                        out_bytes += str(data).encode()
                    else:
                        out_bytes += hex(data).encode()
                elif cur_pattern[-1] in {'d', 'u'}:
                    data = param_interface_ptr
                    out_bytes += str(data).encode()
            out_bytes += format_str[parsed_ind:].encode()
            logging.info(f"fmt.printf: {repr(format_str)}")
            logging.info(f"{out_bytes}")
            store32(pret, len(out_bytes))
            store32(pret + 4, 0)
            manually_constructed = True
        elif self.name == 'runtime.divideByZeroPanic':
            # Not(If(scanf_symbol == 0, 1, 0) == 0)
            divisor = None
            constraint = simplify(state.solver.assertions()[-1])
            # match the condition
            # Not -> == -> If --arg0--> condition
            if is_not(constraint) and \
                    is_eq(constraint.arg(0)) and \
                    is_const(constraint.arg(0).arg(1)) and \
                    constraint.arg(0).arg(1).as_long() == 0 and \
                    constraint.arg(0).arg(0).decl().kind() == Z3_OP_ITE and \
                    is_const(constraint.arg(0).arg(0).arg(1)) and constraint.arg(0).arg(0).arg(1).as_long() == 1 and \
                    is_const(constraint.arg(0).arg(0).arg(2)) and constraint.arg(0).arg(0).arg(2).as_long() == 0 and \
                    is_eq(constraint.arg(0).arg(0).arg(0)) and \
                    is_const(constraint.arg(0).arg(0).arg(0).arg(1)) and constraint.arg(0).arg(0).arg(0).arg(1).as_long() == 0:
                # get divisor
                divisor = constraint.arg(0).arg(0).arg(0).arg(0)
            # scanf_symbol == 0
            elif is_eq(constraint) and \
                    is_const(constraint.arg(1)) and constraint.arg(1).as_long() == 0:
                divisor = constraint.arg(0)
            func_ind = get_func_index_from_state(analyzer, state)
            func_offset = state.instr.offset
            import datetime
            logging.info(f"Current Time: {datetime.datetime.now()}")
            logging.warning(
                f"{bcolors.WARNING}Div-zero! In {get_source_location_string(analyzer, func_ind, func_offset)}{bcolors.ENDC}")
            if divisor is not None:
                logging.warning(
                    f"{bcolors.WARNING}The op2 ({divisor}) may be zero, which may result in Div-Zero vulnerability!{bcolors.ENDC}")
            manually_constructed = True
        elif self.name == 'runtime.lookupPanic':
            func_ind = get_func_index_from_state(analyzer, state)
            func_offset = state.instr.offset
            import datetime
            logging.info(f"Current Time: {datetime.datetime.now()}")
            logging.warning(
                f"{bcolors.WARNING}{self.name} is possible! In {get_source_location_string(analyzer, func_ind, func_offset)}{bcolors.ENDC}")
            manually_constructed = True
        elif self.name in PANIC_FUNCTIONS:
            func_ind = get_func_index_from_state(analyzer, state)
            func_offset = state.instr.offset
            import datetime
            logging.info(f"Current Time: {datetime.datetime.now()}")
            logging.warning(
                f"{bcolors.WARNING}{PANIC_FUNCTIONS[self.name]}! In {get_source_location_string(analyzer, func_ind, func_offset)}{bcolors.ENDC}")
            manually_constructed = True
        elif self.name == 'runtime.calculateHeapAddresses':
            calculateHeapAddresses(state, data_section)
            manually_constructed = True
        elif self.name == 'memset':
            length, byte_data, dest = param_list[0], param_list[1], param_list[2]
            state.symbolic_stack.append(dest)
            manually_constructed = True
        elif self.name == 'runtime.alloc':  # Assume the memory is enough, and never need to grow
            sz = param_list[0]
            heapStart = lookup_symbolic_memory_data_section(
                state.symbolic_memory, data_section, 81328, 4)
            # bytes per block == 16
            neededBlocks = simplify(
                (BitVecVal(15, 32) + sz) >> BitVecVal(4, 32))
            nextAlloc = lookup_symbolic_memory_data_section(
                state.symbolic_memory, data_section, 85468, 4)  # next alloc block index
            index = simplify(nextAlloc + neededBlocks)
            nextAlloc = index
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, 85468, 4, nextAlloc)
            thisAlloc = simplify(index - neededBlocks)
            thisAlloc_v = thisAlloc.as_long()
            nextAlloc_v = nextAlloc.as_long()
            for i in range(thisAlloc_v, nextAlloc_v):
                alloc_at = simplify(
                    heapStart + BitVecVal(i << 4, 32)).as_long()
                state.symbolic_memory = insert_symbolic_memory(
                    state.symbolic_memory, alloc_at, 8,
                    simplify(Extract(63, 0, BitVecVal(0, 64))))
                state.symbolic_memory = insert_symbolic_memory(
                    state.symbolic_memory, alloc_at + 8, 8,
                    simplify(Extract(63, 0, BitVecVal(0, 64))))
            headPtr = simplify(heapStart + BitVecVal(thisAlloc_v << 4, 32))
            state.symbolic_stack.append(headPtr)
            manually_constructed = True
        elif self.name == 'memcpy':
            length, src, dest = param_list[0], param_list[1], param_list[2]
            src_addr = src.as_long()
            dest_addr = dest.as_long()
            len_v = length.as_long()
            vlis = [
                lookup_symbolic_memory_data_section(
                    state.symbolic_memory, data_section, src_addr + i, 1)
                for i in range(len_v)]
            for i, v in enumerate(vlis):
                state.symbolic_memory = insert_symbolic_memory(
                    state.symbolic_memory, dest_addr + i, 1, v)
            state.symbolic_stack.append(dest)
            manually_constructed = True
        elif self.name == 'syscall/js.valueGet':
            p_len, p_str, v_addr, retval = param_list[2], param_list[3], param_list[4], param_list[5]
            prop = lookup_symbolic_memory_data_section(
                state.symbolic_memory, data_section, p_str.as_long(), p_len.as_long())
            value = lookup_symbolic_memory_data_section(
                state.symbolic_memory, data_section, v_addr.as_long(), 4)
            value = _values[value.as_long()]
            _bs = prop.as_binary_string()
            _bs_lis = [_bs[max(i - 8, 0):i] for i in range(len(_bs), 0, -8)]
            prop = ''.join(map(lambda x: chr(int(x, base=2)), _bs_lis))
            result = value.decl().name() + '_' + prop
            idx = None
            for _id in _values:
                if _values[_id].decl().name() == result:
                    idx = _id
                    break
            if idx is None:
                idx = len(_values)
                _values[len(_values)] = BitVec(result, 32)
            # print(_values)
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, retval.as_long() + 4, 4,
                BitVecVal(2146959360 | 4, 32))
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, retval.as_long(), 4, BitVecVal(idx, 32))
            manually_constructed = True
        elif self.name == 'runtime.putchar':
            ch = param_list[0]
            print(chr(ch.as_long()), end='')
        else:
            print(param_list)

        if not manually_constructed and return_str:
            tmp_bitvec = getConcreteBitVec(
                return_str,
                f'{self.name}_ret_{return_str}_{self.cur_func}_{str(state.instr.offset)}')
            state.symbolic_stack.append(tmp_bitvec)

        return [state]
