# These functions are predefined and we will emulate their behaviors

import logging
import math
from ast import If
from datetime import datetime

from eunomia.arch.wasm.dwarfParser import (decode_vararg,
                                           get_func_index_from_state,
                                           get_source_location,
                                           get_source_location_string)
from eunomia.arch.wasm.exceptions import (UnexpectedDataType,
                                          UnsupportExternalFuncError)
from eunomia.arch.wasm.instruction import WasmInstruction
from eunomia.arch.wasm.memory import (insert_symbolic_memory,
                                      lookup_symbolic_memory_data_section)
from eunomia.arch.wasm.utils import (C_TYPE_TO_LENGTH, bcolors, bin_to_float,
                                     calc_memory_align, getConcreteBitVec,
                                     parse_printf_formatting,
                                     str_to_little_endian_int)
from z3 import (RNE, Z3_OP_ITE, ArithRef, BitVec, BitVecNumRef, BitVecRef,
                BitVecVal, BoolVal, Extract, Float64, FPNumRef, FPVal, If, Or,
                fpBVToFP, fpRealToFP, fpToReal, is_bv, is_bv_value, is_const,
                is_eq, is_expr, is_not, simplify)

PANIC_FUNCTIONS = {'runtime.nilPanic': 'nil pointer dereference',
                   'runtime.lookupPanic': 'index out of range',
                   'runtime.slicePanic': 'slice out of range',
                   'runtime.sliceToArrayPointerPanic': 'slice smaller than array',
                   'runtime.divideByZeroPanic': 'divide by zero',
                   'runtime.unsafeSlicePanic': 'unsafe.Slice: len out of range',
                   'runtime.chanMakePanic': 'new channel is too big',
                   'runtime.negativeShiftPanic': 'negative shift',
                   'runtime.blockingPanic': 'trying to do blocking operation in exported function'}

# supported functions in WASIFunction class
WASI_FUNCTIONS = {'fd_read', 'fd_write'}


class CPredefinedFunction:
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

        if self.name == 'printf' or self.name == 'iprintf' or self.name == '__small_printf':
            import datetime
            logging.warning(f'Current Time: {datetime.datetime.now()}')
            # has to use as_long()
            param_p, pattern_p = param_list[0].as_long(
            ), param_list[1].as_long()

            pattern = C_extract_string_by_mem_pointer(
                pattern_p, data_section, state.symbolic_memory)

            the_string = ""
            parsed_pattern = parse_printf_formatting(pattern)

            # For memory align, e.g.,
            # %s %f %c would be 4 bytes (%s), None (4 bytes), 8 bytes (%f), 4 bytes (%c)
            # the memory align would occur at most once
            align_offset = calc_memory_align(parsed_pattern)

            i = 0
            while i < len(parsed_pattern):
                index, cur_pattern = parsed_pattern[i][1], parsed_pattern[i][2]

                middle_p = lookup_symbolic_memory_data_section(
                    state.symbolic_memory, data_section, param_p,
                    C_TYPE_TO_LENGTH[cur_pattern[-1]])
                if isinstance(
                        middle_p, BitVecRef) and not isinstance(
                        middle_p, BitVecNumRef):
                    tmp_data = str(middle_p)
                else:
                    middle_p = middle_p.as_long()
                    if cur_pattern[-1] == 's':
                        tmp_data = str(C_extract_string_by_mem_pointer(
                            middle_p, data_section, state.symbolic_memory))
                    elif cur_pattern[-1] == 'c':
                        tmp_data = chr(middle_p)
                    elif cur_pattern[-1] == 'f':
                        tmp_data = str(bin_to_float(bin(middle_p)))
                    elif cur_pattern[-1] in {'d', 'u', 'x'}:
                        tmp_data = str(middle_p)

                param_p += align_offset[i]

                pattern = pattern[:index] + tmp_data + \
                    pattern[index + len(cur_pattern):]
                # update the following index
                parsed_pattern = [
                    [x[0],
                     x[1] + len(tmp_data) - len(cur_pattern),
                     x[2]] for x in parsed_pattern]
                i += 1

            the_string = pattern

            logging.warning("%s\n", the_string)
        elif self.name == 'scanf':
            param_p, pattern_p = param_list[0].as_long(
            ), param_list[1].as_long()

            # parse the scanf's argument's type
            # get addr of vararg 0.
            addr = decode_vararg(state, param_p, 0)

            # TODO disable dwarf temporarily
            # var_type, var_size = decode_var_type(analyzer, state, addr)

            pattern = C_extract_string_by_mem_pointer(
                pattern_p, data_section, state.symbolic_memory)

            # in scanf, the loaded_data is the pattern string, like '%d %d'
            parsed_pattern = parse_printf_formatting(pattern)

            i = 0
            # print('pattern: ', parsed_pattern)
            while i < len(parsed_pattern):
                index, cur_pattern = parsed_pattern[i][1], parsed_pattern[i][2]
                middle_p = lookup_symbolic_memory_data_section(
                    state.symbolic_memory, data_section, param_p,
                    C_TYPE_TO_LENGTH[cur_pattern[-1]])
                if isinstance(
                        middle_p, BitVecRef) and not isinstance(
                        middle_p, BitVecNumRef):
                    tmp_data = str(middle_p)
                else:
                    middle_p = middle_p.as_long()
                    if cur_pattern[-1] == 's':
                        # TODO we insert a `abc` here, maybe we should insert a symbol
                        state.symbolic_memory = insert_symbolic_memory(
                            state.symbolic_memory, middle_p, 4, BitVecVal(6513249, 32))
                        logging.warning(
                            "================Initiated an scanf string: abc=================")
                    elif cur_pattern[-1] in {'d', 'u', 'x', 'c'}:
                        func_ind = get_func_index_from_state(analyzer, state)
                        func_offset = state.instr.offset
                        original_file, line_no, col_no = get_source_location(
                            analyzer, func_ind, func_offset)
                        inserted_variable = BitVec(
                            f"scanf_{original_file}_{line_no}_{col_no}_[{i}]_{middle_p}",
                            C_TYPE_TO_LENGTH[cur_pattern[-1]] * 8)
                        state.symbolic_memory = insert_symbolic_memory(
                            state.symbolic_memory, middle_p,
                            C_TYPE_TO_LENGTH[cur_pattern[-1]],
                            inserted_variable)
                        logging.warning(
                            f"============Initiated an scanf integer: scanf_{original_file}_{line_no}_{col_no}_[{i}]_{middle_p}============")
                    else:
                        exit("$scanf error")

                param_p += C_TYPE_TO_LENGTH[cur_pattern[-1]]

                i += 1
        elif self.name == 'strlen':
            mem_pointer = param_list[0]
            if is_bv_value(mem_pointer):
                mem_pointer = mem_pointer.as_long()

                the_string = C_extract_string_by_mem_pointer(
                    mem_pointer, data_section, state.symbolic_memory, 1)

                if is_bv_value(the_string):
                    string_length = len(the_string)
                    state.symbolic_stack.append(BitVecVal(string_length, 32))
                elif is_bv(the_string):
                    # if the loaded string is a bv, we assign a symbol here
                    string_length = BitVec("string_length", 32)
                    state.symbolic_stack.append(string_length)
                else:
                    raise UnexpectedDataType

                manually_constructed = True
            elif is_bv(mem_pointer):
                raise UnsupportExternalFuncError
            else:
                raise UnexpectedDataType
        elif self.name == 'swap':
            the_one, the_other = param_list[0].as_long(
            ), param_list[1].as_long()
            the_one_mem = lookup_symbolic_memory_data_section(
                state.symbolic_memory, {}, the_one, 1)
            the_other_mem = lookup_symbolic_memory_data_section(
                state.symbolic_memory, {}, the_other, 1)
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, the_one, 1, the_other_mem)
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, the_other, 1, the_one_mem)
            logging.warning(
                "================$swap! Swap the two: %s and %s=================\n",
                the_one_mem, the_other_mem)
        elif self.name == 'exp':
            exponent = param_list[0]
            if isinstance(exponent, FPNumRef):
                # we have to adopt this trick to convert it to a float number
                exponent = simplify(fpToReal(exponent)).as_string()
                if '/' in exponent:
                    i = exponent.find('/')
                    exponent = int(exponent[:i]) / int(exponent[i + 1:])
                else:
                    exponent = float(exponent)

                ret = math.e ** exponent
                state.symbolic_stack.append(FPVal(ret, Float64()))
                manually_constructed = True
            else:  # if it is a symbol, z3 does not support
                raise UnsupportExternalFuncError
        elif self.name == 'getchar':
            ret = getConcreteBitVec(
                return_str,
                f'{self.name}_ret_{return_str}_{self.cur_func}_{str(state.instr.offset)}')
            state.symbolic_stack.append(ret)
            manually_constructed = True
        elif self.name == 'putchar':
            if isinstance(param_list[0], BitVecNumRef):
                the_char = param_list[0].as_long()
                logging.warning("%s\n", chr(the_char))
            else:
                the_char = param_list[0]
                logging.warning("%s\n", the_char)
        elif self.name == 'abs':
            candidate_num = param_list[0]
            abs_num = simplify(
                If(candidate_num > 0, candidate_num, -candidate_num))
            state.symbolic_stack.append(abs_num)
            manually_constructed = True
        elif self.name == 'emscripten_resize_heap':
            '''
            dlmalloc in C may call this function, which is imported.
            Therefore, we have to manually emulate its behavior according to https://github.com/emscripten-core/emscripten/blob/be2fe9cdf2d6b7b9d0fc375177b9a18a2810fca4/system/lib/standalone/standalone.c#L104
            However, return 1, meaning a success memory growth would lead to imbalance stack, which reason is unclear yet
            I have to return 0 to indicate the memory growth is forbidden
            '''
            # TODO better emulate this function
            state.symbolic_stack.append(BitVecVal(0, 32))
            manually_constructed = True
        elif self.name == 'puts':
            mem_pointer = param_list[0].as_long()
            the_string = str(C_extract_string_by_mem_pointer(
                mem_pointer, data_section, state.symbolic_memory))
            logging.warning("%s\n", the_string)
        elif self.name == '__memcpy':
            length, src, dest = param_list[0].as_long(
            ), param_list[1].as_long(), param_list[2].as_long()

            # lookup the raw data
            raw_src_data = lookup_symbolic_memory_data_section(
                state.symbolic_memory, data_section, src, length)
            # insert the raw data into the memory
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, dest, length, raw_src_data)

            # indicating the memcpy is successful
            state.symbolic_stack.append(BitVecVal(0, 32))
            manually_constructed = True
        elif self.name == 'memcmp':
            length, str2_p, str1_p = param_list[0].as_long(
            ), param_list[1].as_long(), param_list[2].as_long()
            str1 = C_extract_string_by_mem_pointer(
                str1_p, data_section, state.symbolic_memory)
            str2 = C_extract_string_by_mem_pointer(
                str2_p, data_section, state.symbolic_memory)

            # if both str1 and str2 are string literal
            if isinstance(str1, str) and isinstance(str2, str):
                str1, str2 = str1[:length], str2[:length]
                ret = 1 if str1 > str2 else (-1 if str1 < str2 else 0)
                state.symbolic_stack.append(BitVecVal(ret, 32))
                manually_constructed = True
        elif self.name == 'atof':
            str_p = param_list[0]
            if isinstance(str_p, BitVecNumRef):
                str_p = str_p.as_long()
            number_string = C_extract_string_by_mem_pointer(
                str_p, data_section, state.symbolic_memory, 8)

            # try to convert such a string to float
            if isinstance(number_string, BitVecRef):
                the_number = simplify(fpBVToFP(number_string, Float64()))
            else:
                try:
                    the_number = float(number_string)
                except ValueError:
                    # if it cannot be converted into float
                    # default is 0.0
                    the_number = 0.0
                # wrap it into a float64
                the_number = FPVal(the_number, Float64())

            # append into stack
            state.symbolic_stack.append(the_number)
            manually_constructed = True
        elif self.name == 'atoi':
            str_p = param_list[0]
            if isinstance(str_p, BitVecNumRef):
                str_p = str_p.as_long()
            number_string = C_extract_string_by_mem_pointer(
                str_p, data_section, state.symbolic_memory, 4)

            # try to convert such a string to int
            if isinstance(number_string, BitVecRef):
                the_number = number_string
            else:
                try:
                    the_number = int(number_string)
                except ValueError:
                    # if it cannot be converted into int
                    # default is 0
                    the_number = 0
                # convert the number into the BitVecVal
                the_number = BitVecVal(the_number, 32)

            # append into stack
            state.symbolic_stack.append(the_number)
            manually_constructed = True
        # elif self.name == 'log':
        #     pass
        elif self.name == 'system':
            state.symbolic_stack.append(BitVec("cmd_system", 32))
            manually_constructed = True
        elif self.name == 'pow':
            """
            Note: we can step in library pow function
            Do not need this part emulation
            """
            exp, base = param_list[0], param_list[1]

            if isinstance(base, FPNumRef):
                base = eval(str(base))
            else:
                base = fpToReal(base)

            if isinstance(exp, FPNumRef):
                exp = eval(str(exp))
            else:
                exp = fpToReal(exp)

            result = simplify(base ** exp)

            if isinstance(result, ArithRef):
                result = simplify(fpRealToFP(RNE(), result, Float64()))
            else:
                result = simplify(FPVal(result, Float64()))

            state.symbolic_stack.append(result)
            manually_constructed = True
        else:
            raise UnsupportExternalFuncError

        if not manually_constructed and return_str:
            tmp_bitvec = getConcreteBitVec(
                return_str,
                f'{self.name}_ret_{return_str}_{self.cur_func}_{str(state.instr.offset)}')
            state.symbolic_stack.append(tmp_bitvec)


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
                    from eunomia.arch.wasm.graph import Graph
                    func_index2func_name = Graph.wasmVM.func_index2func_name
                    runtime_alloc_ind = -1
                    for ind, name in func_index2func_name.items():
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
                    logging.warning(
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
            logging.warning("fmt.printf:" + repr(format_str))
            logging.warning(out_bytes)
            store32(pret, len(out_bytes))
            store32(pret + 4, 0)
            manually_constructed = True
        elif self.name == 'runtime.divideByZeroPanic':
            # Not(If(scanf_symbol == 0, 1, 0) == 0)
            divisor = None
            constraint = simplify(state.constraints[-1])
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
            logging.warning(f'Current Time: {datetime.datetime.now()}')
            logging.warning(
                f'{bcolors.WARNING}Div-zero! In {get_source_location_string(analyzer, func_ind, func_offset)}{bcolors.ENDC}')
            if divisor is not None:
                logging.warning(
                    f'{bcolors.WARNING}The op2 ({divisor}) may be zero, which may result in Div-Zero vulnerability!{bcolors.ENDC}')
            manually_constructed = True
        elif self.name == 'runtime.lookupPanic':
            func_ind = get_func_index_from_state(analyzer, state)
            func_offset = state.instr.offset
            import datetime
            logging.warning(f'Current Time: {datetime.datetime.now()}')
            logging.warning(
                f'{bcolors.WARNING}{self.name} is possible! In {get_source_location_string(analyzer, func_ind, func_offset)}{bcolors.ENDC}')
            manually_constructed = True
        elif self.name in PANIC_FUNCTIONS:
            func_ind = get_func_index_from_state(analyzer, state)
            func_offset = state.instr.offset
            import datetime
            logging.warning(f'Current Time: {datetime.datetime.now()}')
            logging.warning(
                f'{bcolors.WARNING}{PANIC_FUNCTIONS[self.name]}! In {get_source_location_string(analyzer, func_ind, func_offset)}{bcolors.ENDC}')
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
                return_str, f'{self.name}_ret_{return_str}_{self.cur_func}_{str(state.instr.offset)}')
            state.symbolic_stack.append(tmp_bitvec)


class ImportFunction:
    """
    Balance stack for all imported functions as we do not know its behavior
    """

    def __init__(self, name, cur_func_name):
        self.name = name
        self.cur_func = cur_func_name

    def emul(self, state, param_str, return_str, data_section, analyzer):
        # if the return value is dependent on the library function, we will manually contruct it
        # and jump over the process in which it append a symbol according to the signature of the function
        if self.name == 'args_sizes_get':
            arg_buf_size_addr, argc_addr = state.symbolic_stack.pop(), state.symbolic_stack.pop()
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, argc_addr, 4, BitVecVal(1, 32))
            # the length of 'base64'
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, arg_buf_size_addr, 4,
                BitVecVal(7, 32))

            # append a 0 as return value
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'args_get':
            # this is not the complete version
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIArgsEnvs.cpp
            arg_buf_addr, argv_addr = state.symbolic_stack.pop(), state.symbolic_stack.pop()
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, arg_buf_addr, 7,
                BitVecVal(str_to_little_endian_int('base64'), 56))
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, argv_addr, 4,
                arg_buf_addr)

            # append a 0 as return value
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'environ_sizes_get':
            env_buf_size_addr, env_count_addr = state.symbolic_stack.pop(), state.symbolic_stack.pop()
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, env_count_addr, 4, BitVecVal(0, 32))
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, env_buf_size_addr, 4, BitVecVal(0, 32))

            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_advise':
            # ref: https://man7.org/linux/man-pages/man2/posix_fadvise.2.html
            advice, length, offset, fd = state.symbolic_stack.pop(), state.symbolic_stack.pop(
            ), state.symbolic_stack.pop(), state.symbolic_stack.pop()
            print(
                f"Encounter fd_advise, fd: {fd}, offset: {offset}, length: {length}, advice: {advice}")

            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_fdstat_get':
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L717
            fd_stat_addr, fd = state.symbolic_stack.pop(), state.symbolic_stack.pop()
            # fs_filetype is 1 byte, possible 0-7
            fs_filetype = BitVec(
                f'fs_filetype_{datetime.timestamp(datetime.now()):.0f}', 8)
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, fd_stat_addr, 1, fs_filetype)
            state.constraints.append(
                Or(
                    fs_filetype == 0, fs_filetype == 1,
                    fs_filetype == 2, fs_filetype == 3,
                    fs_filetype == 4, fs_filetype == 5,
                    fs_filetype == 6, fs_filetype == 7))
            # align
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, fd_stat_addr + 1, 1, BitVecVal(0, 8))

            # fs_flags is 2 bytes, possible from {0, 1, 2, 3, 4, 5, 6, 7, 10, 11, 14, 15}
            fs_flags = BitVec(
                f'fs_flags_{datetime.timestamp(datetime.now()):.0f}', 16)
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, fd_stat_addr + 2, 2, fs_flags)
            state.constraints.append(
                Or(
                    fs_flags == 0, fs_flags == 1, fs_flags
                    == 2, fs_flags == 3, fs_flags == 4,
                    fs_flags == 5, fs_flags == 6, fs_flags
                    == 7, fs_flags == 10, fs_flags == 11,
                    fs_flags == 14, fs_flags == 15))
            # align
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, fd_stat_addr + 4, 4, BitVecVal(0, 32))

            # fs_rights_base and fs_rights_inheriting is 0, 8 bytes for each
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, fd_stat_addr + 8, 8, BitVecVal(0, 64))
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, fd_stat_addr + 16, 8, BitVecVal(0, 64))

            print(
                f"Encounter fd_fdstat_get, fd: {fd}, fd_stat_addr: {fd_stat_addr}")

            state.symbolic_stack.append(BitVecVal(0, 32))
            return

        if return_str:
            tmp_bitvec = getConcreteBitVec(
                return_str,
                f'{self.name}_ret_{return_str}_{self.cur_func}_{str(state.instr.offset)}')
            state.symbolic_stack.append(tmp_bitvec)


class WASIFunction:
    """
    Model WASI system call related functions. Usually as import function.
    """

    def __init__(self, name, cur_func_name):
        self.name = name
        self.cur_func = cur_func_name

    def emul(self, state, param_str, return_str, data_section, analyzer):
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

        if self.name == 'fd_read':
            # https://github.com/WebAssembly/wasi-libc/blob/main/libc-bottom-half/headers/public/wasi/api.h#L1851 __wasi_fd_read
            # sematic based on https://man7.org/linux/man-pages/man2/writev.2.html
            # __wasi_errno_t __wasi_fd_read( __wasi_fd_t fd, const __wasi_iovec_t *iovs, size_t iovs_len, __wasi_size_t *retptr0 )
            # (func (param i32 i32 i32 i32) (result i32))
            # due to previous pop operation, arguments are reversed
            params = [concrete_value(i) for i in param_list]
            fd, iov, iovcnt, pnum = params[-1], params[-2], params[-3], params[-4]
            logging.warning(f"fd_read to fd: {fd}")
            # currently only support stdin
            assert fd == 0, 'invalid file descriptor:'
            # TODO we insert a `123` here, maybe we should provide a stdin buffer for each case
            num = 0  # bytes written
            out_bytes = []
            for i in range(iovcnt):
                ptr = load32(iov + 8 * i)
                length = load32(iov + (8 * i + 4))
                written_num = min(len(state.stdin_buffer), length)
                for j in range(written_num):
                    out_bytes.append(state.stdin_buffer[0])
                    store8(ptr + j, state.stdin_buffer.pop(0))
                    num += 1
                if len(state.stdin_buffer) == 0:
                    break
            logging.warning(
                f"================Initiated an fd_read string: {bytes(out_bytes)}=================")
            # set pnum to num
            logging.warning(f'{num} bytes read.')
            store32(pnum, num)
            # return 0
            # manually_constructed = True
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_write':
            # based on https://github.com/tinygo-org/tinygo/blob/release/targets/wasm_exec.js
            # .. seealso:: https://github.com/emscripten-core/emscripten/blob/main/src/library_wasi.js
            # u32 _fd_write(u32 fd, u32 iov, u32 iovcnt, u32 pnum)
            # due to previous pop operation, arguments are reversed
            params = [concrete_value(i) for i in param_list]
            fd, iov, iovcnt, pnum = params[-1], params[-2], params[-3], params[-4]
            if fd == 2:
                logging.warning(f"fd_write to stderr")
            elif fd == 1:
                logging.warning(f"fd_write to stdout")

            num = 0
            for i in range(iovcnt):
                ptr = load32(iov + 8 * i)
                length = load32(iov + (8 * i + 4))
                # print from ptr, length is len
                out_str = []
                for j in range(length):
                    c = lookup_symbolic_memory_data_section(
                        state.symbolic_memory, data_section, ptr + j, 1)
                    c = concrete_value(c)
                    out_str.append(c)
                # without assuming encoding ?
                # sys.stdout.buffer.write(bytes(out_str))
                # sys.stdout.flush()
                logging.warning(bytes(out_str))
                num += length
            # set pnum to num
            store32(pnum, num)
            # return 0
            # manually_constructed = True
            state.symbolic_stack.append(BitVecVal(0, 32))
        else:
            raise UnsupportExternalFuncError


def C_extract_string_by_mem_pointer(
        mem_pointer, data_section, symbolic_memory, default_len=None):
    """
    Extract string by the memory pointer from data section
    or symbolic memory
    """
    # TODO the string may not be 4 bytes in length
    # for example, the RorateArray, the scanf takes a string,
    # the strlen will measure the length of the string,
    # so we can not assume that the length would be 4
    i = 1
    previous_string = ""
    while True:
        loaded_data = lookup_symbolic_memory_data_section(
            symbolic_memory, data_section, mem_pointer, i)

        # if loaded_data is None:
        #     return BitVec('string*'+str(mem_pointer), default_len*8)
        if is_bv_value(loaded_data):
            loaded_data = loaded_data.as_long()
            loaded_string = loaded_data.to_bytes(
                (loaded_data.bit_length() + 7) // 8, 'little').decode("utf-8")
        elif is_bv(loaded_data):
            assert default_len is not None, f"extract {mem_pointer} from memory, however, the loaded part is a symbol, the default len should not be None"
            return BitVec('string_of_' + str(lookup_symbolic_memory_data_section(
                symbolic_memory, data_section, mem_pointer, 4)), default_len * 8)
        else:
            raise UnexpectedDataType

        # as the b"\x00" cannot be loaded from the memory
        # thus we have to compare the current string with the previous round's
        if loaded_string == previous_string:
            break

        i += 1
        previous_string = loaded_string

    return loaded_string


def C_extract_possible_strings_by_mem_pointer(
        mem_pointer, symbolic_memory, string_length):
    """
    Extract all possible strings by ite statements

    Args:
        mem_pointer (int): from where the string start
        symbolic_memory (dict): the symbolic memory
        string_length (BitVecRef): the length of each string
    """
    maximum_length = -1
    # find the maximum length of the possible string
    for k in symbolic_memory:
        lower_bound, upper_bound = k[0], k[1]
        if lower_bound <= mem_pointer < upper_bound:
            maximum_length = upper_bound - mem_pointer
            break
    assert maximum_length != -1, f"no string exists from {mem_pointer}"

    def construct_possible_strings(
            mem_pointer, symbolic_memory, string_length, maximum_length,
            current_length):
        if current_length == maximum_length:
            return C_extract_string_by_mem_pointer(
                mem_pointer, dict(),
                symbolic_memory, current_length)
        return If(
            string_length == current_length,
            C_extract_string_by_mem_pointer(
                mem_pointer, dict(),
                symbolic_memory, current_length),
            construct_possible_strings(
                mem_pointer, symbolic_memory, string_length, maximum_length,
                current_length + 1))

    current_length = 1
    return construct_possible_strings(
        mem_pointer, symbolic_memory, string_length, maximum_length,
        current_length)
