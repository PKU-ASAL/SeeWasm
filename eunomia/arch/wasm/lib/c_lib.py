import logging
import math

from eunomia.arch.wasm.dwarfParser import (decode_vararg,
                                           get_func_index_from_state,
                                           get_source_location)
from eunomia.arch.wasm.exceptions import (UnexpectedDataType,
                                          UnsupportExternalFuncError)
from eunomia.arch.wasm.lib.utils import _extract_params, _loadN, _storeN
from eunomia.arch.wasm.memory import (insert_symbolic_memory,
                                      lookup_symbolic_memory_data_section)
from eunomia.arch.wasm.utils import (C_TYPE_TO_LENGTH, bin_to_float,
                                     calc_memory_align, getConcreteBitVec,
                                     parse_printf_formatting)
from z3 import (RNE, ArithRef, BitVec, BitVecNumRef, BitVecRef, BitVecVal,
                Float64, FPNumRef, FPVal, If, fpBVToFP, fpRealToFP, fpToReal,
                is_bv, is_bv_value, simplify)


class CPredefinedFunction:
    def __init__(self, name, cur_func_name):
        self.name = name
        self.cur_func = cur_func_name

    def emul(self, state, param_str, return_str, data_section, analyzer):
        # if the return value is dependent on the library function, we will manually contruct it
        # and jump over the process in which it append a symbol according to the signature of the function
        manually_constructed = False

        if self.name == 'printf' or self.name == 'iprintf' or self.name == '__small_printf':
            # has to use as_long()
            param_p, pattern_p = _extract_params(param_str, state)

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
            param_p, pattern_p = _extract_params(param_str, state)

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
            mem_pointer, = _extract_params(param_str, state)
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
            the_one, the_other = _extract_params(param_str, state)
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
            exponent, = _extract_params(param_str, state)
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
            the_char, = _extract_params(param_str, state)
            if isinstance(the_char, BitVecNumRef):
                the_char = the_char.as_long()
                logging.warning("%s\n", chr(the_char))
            else:
                the_char = the_char
                logging.warning("%s\n", the_char)
        elif self.name == 'abs':
            candidate_num, = _extract_params(param_str, state)
            abs_num = simplify(If(candidate_num > 0, BitVecVal(
                candidate_num, 32), BitVecVal(-candidate_num, 32)))
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
            mem_pointer, = _extract_params(param_str, state)
            the_string = str(C_extract_string_by_mem_pointer(
                mem_pointer, data_section, state.symbolic_memory))
            logging.warning("%s\n", the_string)
        elif self.name == 'atof':
            str_p, = _extract_params(param_str, state)
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
            str_p, = _extract_params(param_str, state)
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
        elif self.name == 'system':
            state.symbolic_stack.append(BitVec("cmd_system", 32))
            manually_constructed = True
        elif self.name == 'pow':
            """
            Note: we can step in library pow function
            Do not need this part emulation
            """
            exp, base = _extract_params(param_str, state)

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
