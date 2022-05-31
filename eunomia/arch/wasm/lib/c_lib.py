import logging
import math

from eunomia.arch.wasm.configuration import Configuration
from eunomia.arch.wasm.dwarfParser import (decode_vararg,
                                           get_func_index_from_state,
                                           get_source_location)
from eunomia.arch.wasm.exceptions import (UnexpectedDataType,
                                          UnsupportExternalFuncError)
from eunomia.arch.wasm.lib.utils import _extract_params, _loadN, _storeN
from eunomia.arch.wasm.utils import (C_TYPE_TO_LENGTH, bin_to_float,
                                     calc_memory_align, getConcreteBitVec,
                                     my_int_to_bytes, parse_printf_formatting,
                                     readable_internal_func_name)
from z3 import (BitVec, BitVecRef, BitVecVal, Float64, FPNumRef, FPVal, If,
                fpBVToFP, fpToReal, is_bv, simplify)


class CPredefinedFunction:
    def __init__(self, name, cur_func_name):
        self.name = name
        self.cur_func = cur_func_name

    def output_pattern_string(self, param_p, pattern_p, state, data_section):
        pattern = C_extract_string_by_mem_pointer(
            pattern_p, data_section, state)

        the_string = ""
        parsed_pattern = parse_printf_formatting(pattern)

        # For memory align, e.g.,
        # %s %f %c would be 4 bytes (%s), None (4 bytes), 8 bytes (%f), 4 bytes (%c)
        # the memory align would occur at most once
        align_offset = calc_memory_align(parsed_pattern)

        i = 0
        while i < len(parsed_pattern):
            index, cur_pattern = parsed_pattern[i][1], parsed_pattern[i][2]

            middle_p = _loadN(
                state, data_section, param_p,
                C_TYPE_TO_LENGTH[cur_pattern[-1]])
            if is_bv(middle_p):
                tmp_data = str(middle_p)
            else:
                if cur_pattern[-1] == 's':
                    tmp_data = C_extract_string_by_mem_pointer(
                        middle_p, data_section, state)
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

        logging.info(
            f"================Output a string: {the_string.encode()}=================")
        state.stdout_buffer += the_string
        string_length = BitVecVal(len(the_string), 32)
        state.symbolic_stack.append(string_length)

    def emul(self, state, param_str, return_str, data_section, analyzer):
        if self.name == 'printf' or self.name == 'iprintf' or self.name == '__small_printf':
            param_p, pattern_p = _extract_params(param_str, state)
            self.output_pattern_string(param_p, pattern_p, state, data_section)

        elif self.name == 'vfprintf':
            param_p, pattern_p, stream_p = _extract_params(param_str, state)
            stream = _loadN(state, data_section, stream_p, 4)

            possible_callee = analyzer.elements[0]['elems']
            offset = analyzer.elements[0]['offset']
            fp_func = '$func' + str(possible_callee[stream - offset])
            fp_func = readable_internal_func_name(
                Configuration.get_func_index_to_func_name(), fp_func)
            if fp_func == '__stdio_write':
                pass
            else:
                exit(f'the vfprintf stream func is: {fp_func}')

            self.output_pattern_string(param_p, pattern_p, state, data_section)
        elif self.name == 'scanf':
            param_p, pattern_p = _extract_params(param_str, state)

            # parse the scanf's argument's type
            # get addr of vararg 0.
            addr = decode_vararg(state, param_p, 0)

            # TODO disable dwarf temporarily
            # var_type, var_size = decode_var_type(analyzer, state, addr)

            pattern = C_extract_string_by_mem_pointer(
                pattern_p, data_section, state)

            # in scanf, the loaded_data is the pattern string, like '%d %d'
            parsed_pattern = parse_printf_formatting(pattern)

            i = 0
            # print('pattern: ', parsed_pattern)
            while i < len(parsed_pattern):
                index, cur_pattern = parsed_pattern[i][1], parsed_pattern[i][2]
                middle_p = _loadN(
                    state, data_section, param_p,
                    C_TYPE_TO_LENGTH[cur_pattern[-1]])
                if is_bv(middle_p):
                    tmp_data = str(middle_p)
                else:
                    if cur_pattern[-1] == 's':
                        # TODO we insert a `abc` here, maybe we should insert a symbol
                        _storeN(state, middle_p, 6513249, 4)
                        logging.info(
                            f"================Initiated an scanf string: abc=================")
                    elif cur_pattern[-1] in {'d', 'u', 'x', 'c'}:
                        func_ind = get_func_index_from_state(analyzer, state)
                        func_offset = state.instr.offset
                        original_file, line_no, col_no = get_source_location(
                            analyzer, func_ind, func_offset)
                        inserted_variable = BitVec(
                            f"scanf_{original_file}_{line_no}_{col_no}_[{i}]_{middle_p}",
                            C_TYPE_TO_LENGTH[cur_pattern[-1]] * 8)
                        _storeN(state, middle_p, inserted_variable,
                                C_TYPE_TO_LENGTH[cur_pattern[-1]])
                        logging.info(
                            f"============Initiated an scanf integer: scanf_{original_file}_{line_no}_{col_no}_[{i}]_{middle_p}============")
                    else:
                        exit("$scanf error")

                param_p += C_TYPE_TO_LENGTH[cur_pattern[-1]]

                i += 1

            # the scanf returns how many items are inputted
            state.symbolic_stack.append(BitVecVal(len(parsed_pattern), 32))
        elif self.name == 'swap':
            the_one, the_other = _extract_params(param_str, state)
            the_one_mem = _loadN(state, {}, the_one, 1)
            the_other_mem = _loadN(state, {}, the_other, 1)
            _storeN(state, the_one, the_other_mem, 1)
            _storeN(state, the_other, the_one_mem, 1)
            logging.info(
                f"================$swap! Swap the two: %s and %s=================\n",
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
            else:  # if it is a symbol, z3 does not support
                raise UnsupportExternalFuncError
        elif self.name == 'getchar':
            ret = getConcreteBitVec(
                return_str,
                f'{self.name}_ret_{return_str}_{self.cur_func}_{str(state.instr.offset)}')
            state.symbolic_stack.append(ret)
        elif self.name == 'putchar':
            the_char, = _extract_params(param_str, state)

            if isinstance(the_char, int):
                logging.info(
                    f"================Output a string: {chr(the_char).encode()}=================")
                state.stdout_buffer += chr(the_char)
                the_char = BitVecVal(the_char, 32)
            elif is_bv(the_char):
                logging.info(
                    f"================Output a string: {str(the_char).encode()}=================")
                state.stdout_buffer += str(the_char)
            state.symbolic_stack.append(the_char)
        elif self.name == 'abs':
            candidate_num, = _extract_params(param_str, state)
            abs_num = simplify(If(candidate_num > 0, BitVecVal(
                candidate_num, 32), BitVecVal(-candidate_num, 32)))
            state.symbolic_stack.append(abs_num)
        elif self.name == 'emscripten_resize_heap':
            '''
            dlmalloc in C may call this function, which is imported.
            Therefore, we have to manually emulate its behavior according to https://github.com/emscripten-core/emscripten/blob/be2fe9cdf2d6b7b9d0fc375177b9a18a2810fca4/system/lib/standalone/standalone.c#L104
            However, return 1, meaning a success memory growth would lead to imbalance stack, which reason is unclear yet
            I have to return 0 to indicate the memory growth is forbidden
            '''
            # TODO better emulate this function
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'puts':
            mem_pointer, = _extract_params(param_str, state)
            the_string = C_extract_string_by_mem_pointer(
                mem_pointer, data_section, state)
            # the '\n' is added according to semantic of puts
            logging.info(
                f"================Output a string: {the_string.encode()}=================")
            state.stdout_buffer += the_string
            state.symbolic_stack.append(BitVecVal(1, 32))
        elif self.name == 'atof':
            str_p, = _extract_params(param_str, state)
            number_string = C_extract_string_by_mem_pointer(
                str_p, data_section, state, 8)

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
        elif self.name == 'atoi':
            str_p, = _extract_params(param_str, state)
            number_string = C_extract_string_by_mem_pointer(
                str_p, data_section, state, 4)

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
        elif self.name == 'system':
            state.symbolic_stack.append(BitVec("cmd_system", 32))
        elif self.name == 'fopen':
            mode_ptr, filename_ptr = _extract_params(param_str, state)

            # mode = C_extract_string_by_mem_pointer(
            #     mode_ptr, data_section, state)
            filename = C_extract_string_by_mem_pointer(
                filename_ptr, data_section, state)

            if filename not in state.fd:
                filename_fd = max(state.fd.values()) + 1
                state.fd[filename] = filename_fd
            else:
                exit(f"the file: {filename} is opened already")

            # each FILE * is 60 bytes long
            # the last 4 bytes are the fd
            _storeN(state, 100000000, 0, 60)
            _storeN(state, 100000056, filename_fd, 4)
            # these two are the offset of __stdio_read and __stdio_close
            # TODO may dynamically adjust
            _storeN(state, 100000028, 6, 4)
            _storeN(state, 100000012, 7, 4)
            # return the FILE *
            state.symbolic_stack.append(BitVecVal(100000000, 32))
        else:
            raise UnsupportExternalFuncError


def C_extract_string_by_mem_pointer(
        mem_pointer, data_section, state, default_len=None):
    """
    Extract string by the memory pointer from data section
    or symbolic memory
    """
    if default_len:
        loaded_data = _loadN(state, data_section, mem_pointer, default_len)
    else:
        i = 1
        while True:
            loaded_data = _loadN(state, data_section, mem_pointer + i, 1)
            if isinstance(loaded_data, int) and loaded_data == 0:
                break
            i += 1
        loaded_data = _loadN(state, data_section, mem_pointer, i)

    # if loaded_data is int, transfer it to the string
    if isinstance(loaded_data, int):
        loaded_string = my_int_to_bytes(loaded_data).decode()
    elif is_bv(loaded_data):
        loaded_string = str(loaded_data).encode()
    else:
        UnexpectedDataType

    return loaded_string
