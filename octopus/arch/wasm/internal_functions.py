# These functions are predefined and we will emulate their behaviors

import logging
import math

from octopus.arch.wasm.dawrf_parser import (decode_var_type, decode_vararg,
                                            get_func_index_from_state,
                                            get_source_location)
from octopus.arch.wasm.exceptions import UnsupportExternalFuncError
from octopus.arch.wasm.memory import (insert_symbolic_memory,
                                      lookup_symbolic_memory_data_section)
from octopus.arch.wasm.modules.BufferOverflowLaser import BufferOverflowLaser
from octopus.arch.wasm.utils import (C_TYPE_TO_LENGTH,
                                     Configuration, Enable_Lasers,
                                     bin_to_float, calc_memory_align,
                                     getConcreteBitVec,
                                     parse_printf_formatting)
from z3 import *


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
                    state.symbolic_memory, data_section, param_p, C_TYPE_TO_LENGTH[cur_pattern[-1]])
                if isinstance(middle_p, BitVecRef) and not isinstance(middle_p, BitVecNumRef):
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
                    pattern[index+len(cur_pattern):]
                # update the following index
                parsed_pattern = [
                    [x[0], x[1] + len(tmp_data) - len(cur_pattern), x[2]] for x in parsed_pattern]
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
            while i < len(parsed_pattern):
                index, cur_pattern = parsed_pattern[i][1], parsed_pattern[i][2]

                middle_p = lookup_symbolic_memory_data_section(
                    state.symbolic_memory, data_section, param_p, C_TYPE_TO_LENGTH[cur_pattern[-1]])
                if isinstance(middle_p, BitVecRef) and not isinstance(middle_p, BitVecNumRef):
                    tmp_data = str(middle_p)
                else:
                    middle_p = middle_p.as_long()
                    if cur_pattern[-1] == 's':
                        # TODO we insert a `abc` here, maybe we should insert a symbol
                        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, middle_p, 4,
                                                                       BitVecVal(6513249, 32))
                        logging.warning(
                            "================Initiated an scanf string: abc=================\n")
                    elif cur_pattern[-1] in {'d', 'u', 'x'}:
                        func_ind = get_func_index_from_state(analyzer, state)
                        func_offset = state.instr.offset
                        original_file, line_no, col_no = get_source_location(
                            analyzer, func_ind, func_offset)
                        inserted_variable = BitVec(
                            f"scanf_{original_file}_{line_no}_{col_no}_[{i}]", C_TYPE_TO_LENGTH[cur_pattern[-1]] * 8)
                        state.symbolic_memory = insert_symbolic_memory(
                            state.symbolic_memory, middle_p, C_TYPE_TO_LENGTH[cur_pattern[-1]], inserted_variable)
                        logging.warning(
                            f"================Initiated an scanf integer: variable{str(i)}_{state.current_func_name}!=================\n")
                    else:
                        exit("$scanf error")

                param_p += C_TYPE_TO_LENGTH[cur_pattern[-1]]

                i += 1
        elif self.name == 'strlen':
            mem_pointer = param_list[0].as_long()
            the_string = C_extract_string_by_mem_pointer(
                mem_pointer, data_section, state.symbolic_memory)

            string_length = len(the_string)
            state.symbolic_stack.append(BitVecVal(string_length, 32))

            manually_constructed = True
            logging.warning(
                "================$strlen! The length is: %s=================\n", string_length)
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
            logging.warning("================$swap! Swap the two: %s and %s=================\n", the_one_mem,
                            the_other_mem)
        elif self.name == 'strcpy':
            src, dest = param_list[0].as_long(), param_list[1].as_long()

            # extract the string according to the src pointer
            src_string = C_extract_string_by_mem_pointer(
                src, data_section, state.symbolic_memory)
            src_string_len = len(src_string) + 1  # the tailing \x00

            # enable the buffer overflow check
            if Configuration.get_lasers() & Enable_Lasers.BUFFER.value:
                buffer_overflow_laser = BufferOverflowLaser()
                buffer_overflow_laser.fire(
                    analyzer, state, dest, src_string, src_string_len)

            # the little endian refers to the implementation of scanf
            little_endian_num = int.from_bytes(
                str.encode(f'{src_string}\x00'), "little")

            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, dest, src_string_len, BitVecVal(little_endian_num, 8*src_string_len))
            state.symbolic_stack.append(param_list[1])
            manually_constructed = True
        elif self.name == 'strncpy':
            length, src, dest = param_list[0].as_long(
            ), param_list[1].as_long(), param_list[2].as_long()

            # extract the string according to the src pointer
            src_string = C_extract_string_by_mem_pointer(
                src, data_section, state.symbolic_memory)

            # if the length of src_string exceeds the required length
            # trunc it, or padding by \x00
            if len(src_string) >= length:
                src_string = src_string[:length]
            else:
                src_string += '\x00'*(length - len(src_string))

            # the little endian refers to the implementation of scanf
            little_endian_num = int.from_bytes(
                str.encode(f'{src_string}'), "little")

            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, dest, length, BitVecVal(little_endian_num, 8*length))
            state.symbolic_stack.append(param_list[1])
            manually_constructed = True
        elif self.name == 'strcat':
            src, dest = param_list[0].as_long(), param_list[1].as_long()

            # extract the string according to pointers
            src_string = C_extract_string_by_mem_pointer(
                src, data_section, state.symbolic_memory)
            dest_string = C_extract_string_by_mem_pointer(
                dest, data_section, state.symbolic_memory)

            # concatenate two strings
            string_len = len(dest_string) + len(src_string) + 1

            # enable the buffer overflow check
            if Configuration.get_lasers() & Enable_Lasers.BUFFER.value:
                buffer_overflow_laser = BufferOverflowLaser()
                buffer_overflow_laser.fire(
                    analyzer, state, dest, dest_string + src_string, string_len)

            little_endian_num = int.from_bytes(str.encode(
                f'{dest_string}{src_string}\x00'), "little")
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, dest, string_len, BitVecVal(little_endian_num, 8*string_len))
            state.symbolic_stack.append(param_list[1])
            manually_constructed = True
        elif self.name == 'strncat':
            length, src, dest = param_list[0].as_long(
            ), param_list[1].as_long(), param_list[2].as_long()

            # extract the string according to pointers
            src_string = C_extract_string_by_mem_pointer(
                src, data_section, state.symbolic_memory)
            dest_string = C_extract_string_by_mem_pointer(
                dest, data_section, state.symbolic_memory)

            if len(src_string) >= length:
                src_string = src_string[:length]
            else:
                src_string += '\x00'*(length - len(src_string))

            # concatenate two strings
            string_len = len(dest_string) + len(src_string) + 1

            # different with strncpy, strncat would explicitly append \x00
            little_endian_num = int.from_bytes(str.encode(
                f'{dest_string}{src_string}\x00'), "little")
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, dest, string_len, BitVecVal(little_endian_num, 8*string_len))
            state.symbolic_stack.append(param_list[1])
            manually_constructed = True
        elif self.name == 'strcmp':
            str2_p, str1_p = param_list[0].as_long(), param_list[1].as_long()
            str1 = C_extract_string_by_mem_pointer(
                str1_p, data_section, state.symbolic_memory)
            str2 = C_extract_string_by_mem_pointer(
                str2_p, data_section, state.symbolic_memory)

            # if both str1 and str2 are string literal
            if isinstance(str1, str) and isinstance(str2, str):
                ret = 1 if str1 > str2 else (-1 if str1 < str2 else 0)
                state.symbolic_stack.append(BitVecVal(ret, 32))
                manually_constructed = True
        elif self.name == 'strstr' or self.name == 'strchr':
            needle_p, haystack_p = param_list[0].as_long(
            ), param_list[1].as_long()
            if self.name == 'strchr':
                # needle_p is not a pointer, ascii code instead
                needle = chr(needle_p)
            else:
                needle = C_extract_string_by_mem_pointer(
                    needle_p, data_section, state.symbolic_memory)
            haystack = C_extract_string_by_mem_pointer(
                haystack_p, data_section, state.symbolic_memory)

            # if both haystack and needle are string literals
            if isinstance(needle, str) and isinstance(haystack, str):
                offset = haystack.find(needle)
                # found it
                if offset != -1:
                    ret = haystack_p + offset
                    state.symbolic_stack.append(BitVecVal(ret, 32))
                    manually_constructed = True
        elif self.name == 'exp':
            exponent = param_list[0]
            if isinstance(exponent, FPNumRef):
                # we have to adopt this trick to convert it to a float number
                exponent = simplify(fpToReal(exponent)).as_string()
                if '/' in exponent:
                    i = exponent.find('/')
                    exponent = int(exponent[:i]) / int(exponent[i+1:])
                else:
                    exponent = float(exponent)

                ret = math.e ** exponent
                state.symbolic_stack.append(FPVal(ret, Float64()))
                manually_constructed = True
            else:  # if it is a symbol, z3 does not support
                raise UnsupportExternalFuncError
        elif self.name == 'getchar':
            ret = getConcreteBitVec(return_str, self.name + '_ret_' +
                                    return_str + '_' + self.cur_func + '_' + str(state.instr.offset))
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

            # try to convert such a string to float
            if isinstance(number_string, BitVecRef):
                the_number = number_string
            else:
                try:
                    the_number = int(number_string)
                except ValueError:
                    # if it cannot be converted into int
                    # default is 0
                    the_number = 0
            # append into stack
            state.symbolic_stack.append(the_number)
            manually_constructed = True
        elif self.name == 'srand' or self.name == 'rand':
            # we have not emulated the seed generating algorithm for C
            pass
        elif self.name == 'log':
            pass
        elif self.name == 'system':
            pass
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
            tmp_bitvec = getConcreteBitVec(return_str,
                                           self.name + '_ret_' + return_str + '_' + self.cur_func + '_' + str(
                                               state.instr.offset))
            state.symbolic_stack.append(tmp_bitvec)


_values = {0: BitVec("NaN", 32), 1: BitVecVal(0, 32), 2: BitVec("null", 32), 3: BoolVal(True),
           4: BoolVal(False), 5: BitVec("global", 32), 6: BitVec("global.Go", 32)}  # module the memory map in wasm_exec.js


def calculateHeapAddresses(state, data_section):
    val_81328 = simplify(lookup_symbolic_memory_data_section(
        state.symbolic_memory, data_section, 81328, 4) + 15) & 4294967280  # calculate heap start
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

        # ------------------------ TinyGO Library -------------------------------
        # could be step in, remain for understanding the memory structure.
        if self.name == 'runtime.calculateHeapAddresses':
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
                state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, alloc_at, 8,
                                                               simplify(Extract(63, 0, BitVecVal(0, 64))))
                state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, alloc_at + 8, 8,
                                                               simplify(Extract(63, 0, BitVecVal(0, 64))))
            headPtr = simplify(heapStart + BitVecVal(thisAlloc_v << 4, 32))
            state.symbolic_stack.append(headPtr)
            print(headPtr, sz, heapStart, thisAlloc)
            manually_constructed = True
        elif self.name == 'memcpy':
            length, src, dest = param_list[0], param_list[1], param_list[2]
            src_addr = src.as_long()
            dest_addr = dest.as_long()
            len_v = length.as_long()
            vlis = [lookup_symbolic_memory_data_section(
                state.symbolic_memory, data_section, src_addr + i, 1) for i in range(len_v)]
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
            _bs_lis = [_bs[max(i-8, 0):i] for i in range(len(_bs), 0, -8)]
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
                state.symbolic_memory, retval.as_long() + 4, 4, BitVecVal(2146959360 | 4, 32))
            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, retval.as_long(), 4, BitVecVal(idx, 32))
            manually_constructed = True
        elif self.name == 'runtime.putchar':
            ch = param_list[0]
            print(chr(ch.as_long()), end='')
        elif self.name == 'fmt.Fscanf':
            print(param_list)
            print(state)
            addr1, addr2 = param_list[0], param_list[1]
            val1 = lookup_symbolic_memory_data_section(
                state.symbolic_memory, data_section, addr1.as_long(), 4)
            val2 = lookup_symbolic_memory_data_section(
                state.symbolic_memory, data_section, addr2.as_long(), 4)
            print(val1, val2)
            raise ValueError

        else:
            print(param_list)

        if not manually_constructed and return_str:
            tmp_bitvec = getConcreteBitVec(return_str,
                                           self.name + '_ret_' + return_str + '_' + self.cur_func + '_' + str(
                                               state.instr.offset))
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

        if return_str:
            tmp_bitvec = getConcreteBitVec(return_str,
                                           self.name + '_ret_' + return_str + '_' + self.cur_func + '_' + str(
                                               state.instr.offset))
            state.symbolic_stack.append(tmp_bitvec)


def C_extract_string_by_mem_pointer(mem_pointer, data_section, symbolic_memory, default_len=None):
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

        if loaded_data is None:
            return BitVec('string*'+str(mem_pointer), default_len*8)

        loaded_data = loaded_data.as_long()
        loaded_string = loaded_data.to_bytes(
            (loaded_data.bit_length() + 7) // 8, 'little').decode("utf-8")
        # as the b"\x00" cannot be loaded from the memory
        # thus we have to compare the current string with the previous round's
        if loaded_string == previous_string:
            break

        i += 1
        previous_string = loaded_string

    return loaded_string
