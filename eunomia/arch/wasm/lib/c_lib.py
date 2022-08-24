import logging
import math
from json import load

from eunomia.arch.wasm.configuration import Configuration
from eunomia.arch.wasm.dwarfParser import (decode_vararg,
                                           get_func_index_from_state,
                                           get_source_location)
from eunomia.arch.wasm.exceptions import (ProcFailTermination,
                                          UnsupportExternalFuncError)
from eunomia.arch.wasm.lib.utils import _extract_params, _loadN, _storeN
from eunomia.arch.wasm.utils import (C_TYPE_TO_LENGTH, bin_to_float,
                                     calc_memory_align, getConcreteBitVec,
                                     int_to_bytes, parse_printf_formatting,
                                     readable_internal_func_name)
from z3 import (BitVec, BitVecRef, BitVecVal, Extract, Float64, FPNumRef,
                FPVal, If, fpBVToFP, fpToReal, is_bv, simplify)


class CPredefinedFunction:
    def __init__(self, name, cur_func_name):
        self.name = name
        self.cur_func = cur_func_name

    def output_pattern_string(
            self, fp, param_p, pattern_p, state, data_section):
        pattern = C_extract_string_by_mem_pointer(
            pattern_p, data_section, state)

        parsed_pattern = parse_printf_formatting(pattern)

        # For memory align, e.g.,
        # %s %f %c would be 4 bytes (%s), None (4 bytes), 8 bytes (%f), 4 bytes (%c)
        # the memory align would occur at most once
        align_offset = calc_memory_align(parsed_pattern)

        the_string = []
        start = 0
        for i in range(len(parsed_pattern)):
            # used to collect bv into bytes
            parsed_parts = []

            _, end, cur_pattern = parsed_pattern[i]
            # insert the chars before the %x into the_string
            the_string += list(pattern[start:end].encode())

            middle_p = _loadN(
                state, data_section, param_p,
                C_TYPE_TO_LENGTH[cur_pattern[-1]])

            if is_bv(middle_p):
                exit(f"\tencounter a symbolic pointer ({middle_p}) for printf")
                parsed_part = str(middle_p)
            else:
                if cur_pattern[-1] == 's':
                    # decide to load a bv or a string
                    test_char = _loadN(state, data_section, middle_p, 1)
                    if is_bv(test_char):
                        parsed_part = C_extract_bv_by_mem_pointer(
                            middle_p, data_section, state)
                        # split into bytes
                        for j in range(parsed_part.size() // 8, 0, -1):
                            parsed_parts.append(
                                Extract(
                                    (j * 8) - 1, (j - 1) * 8,
                                    parsed_part))
                    else:
                        parsed_part = C_extract_string_by_mem_pointer(
                            middle_p, data_section, state)
                elif cur_pattern[-1] == 'c':
                    parsed_part = chr(middle_p)
                elif cur_pattern[-1] == 'f':
                    parsed_part = str(bin_to_float(bin(middle_p)))
                elif cur_pattern[-1] in {'d', 'u', 'x'}:
                    parsed_part = str(middle_p)
                else:
                    exit(
                        f"\tin printf, the pattern is {cur_pattern}, which is not supported")

            # insert the parsed part into the_string
            if parsed_parts:
                the_string += parsed_parts
            else:
                the_string += list(parsed_part.encode())

            start = end + len(cur_pattern)

            # increase the pointer according to alignment
            param_p += align_offset[i]

        # insert the chars after the %x into the_string
        the_string += list(pattern[start:].encode())

        logging.info(f"\tOutput a string: {the_string}")
        state.file_sys[fp]["content"] += the_string
        string_length = BitVecVal(len(the_string), 32)
        state.symbolic_stack.append(string_length)

    def open_file(self, state, filename, mode):
        # if filename starts with 'sym_arg', means this sym_arg is used as filename
        # change the name to distinguish
        if filename.startswith("sym_arg"):
            filename += "_as_file"

        # retrieve the first not opened fd
        open_file_fd = -1
        for fd, file_info in state.file_sys.items():
            if not file_info["status"]:
                open_file_fd = fd
                break

        if open_file_fd == -1:
            exit(f"no enough sym file in `fopen`")
        else:
            # modify status for this file
            state.file_sys[open_file_fd]["name"] = filename
            state.file_sys[open_file_fd]["status"] = True
            state.file_sys[open_file_fd]["flag"] = mode
            if 'r' in mode:
                _, length_limit = Configuration.get_sym_file_limits()
                content = BitVec(filename, length_limit * 8)
                state.file_sys[open_file_fd]["content"] = [
                    Extract(i * 8 - 1, (i - 1) * 8, content)
                    for i in range(length_limit, 0, -1)]
            elif 'w' in mode:
                state.file_sys[open_file_fd]["content"] = []
            else:
                exit(f"In fopen, the mode is {mode}, not support yet")
            logging.info(
                f"\topen {filename} with fd ({open_file_fd}) and mode ({mode})")
        return open_file_fd

    def emul(self, state, param_str, return_str, data_section, analyzer):
        if self.name == 'printf' or self.name == 'iprintf' or self.name == '__small_printf':
            param_p, pattern_p = _extract_params(param_str, state)
            logging.info(
                f"\tprintf, pattern_p: {pattern_p}, param_p: {param_p}")
            self.output_pattern_string(
                1, param_p, pattern_p, state, data_section)
        elif self.name == 'vfprintf':
            param_p, pattern_p, stream_p = _extract_params(param_str, state)
            logging.info(
                f"\tvfprintf, stream_p: {stream_p}, pattern_p: {pattern_p}, param_p: {param_p}")
            stream = _loadN(state, data_section, stream_p, 4)

            try:
                possible_callee = analyzer.elements[0]['elems']
                offset = analyzer.elements[0]['offset']
                fp_func = '$func' + str(possible_callee[stream - offset])
                fp_func = readable_internal_func_name(
                    Configuration.get_func_index_to_func_name(), fp_func)
                if fp_func == '__stdio_write':
                    logging.info(f"\tthe vfprintf points to {fp_func}")
                    fp = 1
                elif fp_func == '__stdout_write':
                    logging.info(f"\tthe vfprintf points to {fp_func}, a file")
                    for fp in range(3, len(state.file_sys)):
                        if state.file_sys[fp]["status"] and state.file_sys[fp][
                                "flag"] in ["w+", "w"]:
                            break
                else:
                    logging.warning(
                        f"\tin vfprintf, the stream is supposed to point to __stdio_write or __stdout_write")
                    logging.warning(f"\tbut here is {fp_func} instead")
                    logging.warning(f"\tjust omit this error and continue")
            except IndexError:
                logging.warning(
                    f"\tthe stream is {stream}, bigger than size of elem ({len(possible_callee)})")
                logging.warning(f"\tjust jump over the error and continue")

            self.output_pattern_string(
                fp, param_p, pattern_p, state, data_section)
        elif self.name == 'scanf':
            param_p, pattern_p = _extract_params(param_str, state)
            logging.info(
                f"\tscanf, pattern_p: {pattern_p}, param_p: {param_p}")

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
                            f"\tInput a scanf string: abc (hard-encoded)")
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
                            f"\tInput a scanf integer: {inserted_variable}")
                    else:
                        exit("$scanf error")

                param_p += C_TYPE_TO_LENGTH[cur_pattern[-1]]

                i += 1

            # the scanf returns how many items are inputted
            state.symbolic_stack.append(BitVecVal(len(parsed_pattern), 32))
        elif self.name == 'exit':
            status, = _extract_params(param_str, state)
            logging.info(f"\texit, status: {status}")
            raise ProcFailTermination(status)
        elif self.name == 'swap':
            the_one, the_other = _extract_params(param_str, state)
            logging.info(f"\tswap, the_one: {the_one}, the_other: {the_other}")
            the_one_mem = _loadN(state, {}, the_one, 1)
            the_other_mem = _loadN(state, {}, the_other, 1)
            _storeN(state, the_one, the_other_mem, 1)
            _storeN(state, the_other, the_one_mem, 1)
        elif self.name == 'exp':
            exponent, = _extract_params(param_str, state)
            logging.info(f"\texp, exponent: {exponent}")
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
            logging.info(f"\tInput a getchar char: {ret}")
            state.symbolic_stack.append(ret)
        elif self.name == 'putchar':
            the_char, = _extract_params(param_str, state)

            if isinstance(the_char, int):
                logging.info(
                    f"\tOutput a putchar char: {chr(the_char).encode()}")
                state.file_sys[1]["content"].append(the_char)
                the_char = BitVecVal(the_char, 32)
            elif is_bv(the_char):
                logging.info(
                    f"\tOutput a putchar char: {str(the_char).encode()}")
                # we have to manually extract from 7 to 0
                # because it is always 32 bit in wasm
                state.file_sys[1]["content"].append(
                    simplify(Extract(7, 0, the_char)))
            state.symbolic_stack.append(the_char)
        elif self.name == 'abs':
            candidate_num, = _extract_params(param_str, state)
            logging.info(f"\tabs, candidate_num: {candidate_num}")
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
            logging.info(f"\temscripten_resize_heap, just pass")
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'puts':
            mem_pointer, = _extract_params(param_str, state)
            logging.info(f"\tputs, mem_pointer: {mem_pointer}")
            the_string = C_extract_string_by_mem_pointer(
                mem_pointer, data_section, state).encode()
            # the '\n' is added according to semantic of puts
            logging.info(
                f"\tOutput a puts string: {the_string}")
            state.file_sys[1]["content"] += list(the_string)
            state.symbolic_stack.append(BitVecVal(1, 32))
        elif self.name == 'atof':
            str_p, = _extract_params(param_str, state)
            logging.info(f"\tatof, str_p: {str_p}")
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
            logging.info(f"\tatoi, str_p: {str_p}")
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
            logging.info(f"\tsystem, just pass")
            state.symbolic_stack.append(BitVec("cmd_system", 32))
        elif self.name == 'open':
            mode_ptr, flag, filename_ptr = _extract_params(param_str, state)
            logging.info(
                f"\topen, mode_ptr: {mode_ptr}, flag: {hex(flag)}, filename_ptr: {filename_ptr}")
            mode = C_extract_string_by_mem_pointer(
                mode_ptr, data_section, state)

            # transfer the mode
            if mode == '\x00':
                mode = 'r'
            elif mode == '\x01':
                mode = 'w'
            elif mode == '\x02':
                mode = 'rw'
            else:
                exit(f"mode value is {mode}, which is unrecognized in `open`")

            filename = C_extract_string_by_mem_pointer(
                filename_ptr, data_section, state)

            open_file_fd = self.open_file(state, filename, mode)

            state.symbolic_stack.append(BitVecVal(open_file_fd, 32))
        elif self.name == 'fopen':
            mode_ptr, filename_ptr = _extract_params(param_str, state)
            logging.info(
                f"\tfopen, filename_ptr: {filename_ptr}, mode_ptr: {mode_ptr}")

            mode = C_extract_string_by_mem_pointer(
                mode_ptr, data_section, state)
            filename = C_extract_string_by_mem_pointer(
                filename_ptr, data_section, state)
            logging.info(f"\topen file: {filename}")

            open_file_fd = self.open_file(state, filename, mode)

            # construct return value
            base_addr = open_file_fd * 100 + 100000000
            # each FILE * is 60 bytes long
            # the last 4 bytes are the fd
            _storeN(state, base_addr, 0, 60)
            _storeN(state, base_addr + 56, open_file_fd, 4)
            # these are the offset of __stdio_read and __stdio_close
            stdio_read_index = find_elem_index('__stdio_read', analyzer)
            _storeN(state, base_addr + 28, stdio_read_index, 4)
            stdio_close_index = find_elem_index('__stdio_close', analyzer)
            _storeN(state, base_addr + 12, stdio_close_index, 4)
            stdout_write_index = find_elem_index('__stdout_write', analyzer)
            _storeN(state, base_addr + 32, stdout_write_index, 4)
            # return the FILE *
            state.symbolic_stack.append(BitVecVal(base_addr, 32))
        elif self.name == 'setlocale':
            locale_ptr, category = _extract_params(param_str, state)
            logging.info(
                f"\tsetlocale, category: {category}, locale_ptr: {locale_ptr}")

            # for base64, the return pointer points to a string: b'C.UTF-8;C;C;C;C;C\x00' (int: 22877692121332503319371995581278433128003)
            state.symbolic_stack.append(BitVec("locale_return_string", 32))
        elif self.name == 'hard_locale':
            category, = _extract_params(param_str, state)
            logging.info(f"\thard_locale, category: {category}")

            # maybe we can directly return a false, ref: https://github.com/coreutils/gnulib/blob/master/lib/hard-locale.h
            state.symbolic_stack.append(BitVecVal(0, 32))
        # elif self.name == 'rpl_fclose':
        #     stream_ptr, = _extract_params(param_str, state)
        #     logging.info(f"\trpl_fclose, stream_ptr: {stream_ptr}")

        #     print(lookup_symbolic_memory_data_section(
        #         state.symbolic_memory, dict(), stream_ptr, 4))
        #     state.symbolic_stack.append(BitVecVal(0, 32))
        else:
            raise UnsupportExternalFuncError

        return [state]


def find_elem_index(func_name, ana):
    """
    Find the elem index by the given func_name
    """
    offset = ana.elements[0]['offset']
    for i, elem in enumerate(ana.elements[0]["elems"]):
        if func_name == readable_internal_func_name(
                Configuration.get_func_index_to_func_name(),
                "$func" + str(elem)):
            return i + offset
    exit(
        f"Cannot find the {func_name} in dealing with fopen call indirect index")


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
        loaded_string = int_to_bytes(loaded_data, i).decode()[::-1]
    elif is_bv(loaded_data):
        loaded_string = str(loaded_data)
    else:
        exit(
            f"in C_extract_string_by_mem_pointer, extract {type(loaded_data)} instead of int or bv")
    return loaded_string


def C_extract_bv_by_mem_pointer(
        mem_pointer, data_section, state, default_len=None):
    """
    Extract bitvec by the memory pointer from data section or symbolic memory
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

    assert is_bv(
        loaded_data), f"loaded_data type is: {type(loaded_data)} in C_extract_bv_by_mem_pointer"

    return loaded_data
