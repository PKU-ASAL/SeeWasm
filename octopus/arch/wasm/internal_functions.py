# These functions are predefined and we will emulate their behaviors

from octopus.arch.wasm.dawrf_parser import decode_var_type, decode_vararg, get_source_location
from octopus.arch.wasm.helper_c import C_extract_string_by_start_pointer, C_extract_string_by_mem_pointer
from octopus.arch.wasm.utils import getConcreteBitVec
from octopus.arch.wasm.utils import Enable_Lasers, bcolors, Configuration
from octopus.arch.wasm.modules.BufferOverflowLaser import BufferOverflowLaser
from octopus.arch.wasm.exceptions import UnsupportExternalFuncError
from octopus.arch.wasm.memory import insert_symbolic_memory, lookup_symbolic_memory
from z3 import *
import logging
import math


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

        if self.name == 'printf' or self.name == 'iprintf':
            # has to use as_long()
            mem_pointer = param_list[0].as_long() if is_bv_value(
                param_list[0]) else param_list[0]
            start_pointer = param_list[1].as_long() if is_bv_value(
                param_list[1]) else param_list[1]

            pattern, loaded_data = C_extract_string_by_start_pointer(
                start_pointer, mem_pointer, data_section, state.symbolic_memory)

            pattern_list = pattern.split()
            pattern_list = [i.strip() for i in pattern_list]

            the_string = ""
            for pattern_str in pattern_list:
                if pattern_str == '%d' or pattern_str == '%x' or pattern_str == '%u':
                    the_string += str(loaded_data)
                elif pattern_str == '%c':
                    the_string += chr(loaded_data.as_long())
                elif pattern_str == '%s':
                    the_string += str(C_extract_string_by_mem_pointer(
                        loaded_data.as_long(), data_section, state.symbolic_memory))
                elif pattern == 'string_literal':  # return "string literal"
                    the_string += str(loaded_data)
                else:
                    the_string += (str(pattern_str) + " ")
            # elif isinstance(the_string, str) and the_string.isspace():
            #     the_string = f"'{ord(the_string)}'"
            logging.warning("%s\n", the_string)
        elif self.name == 'scanf':
            mem_pointer = param_list[0].as_long() if is_bv_value(
                param_list[0]) else param_list[0]
            start_pointer = param_list[1].as_long() if is_bv_value(
                param_list[1]) else param_list[1]

            # parse the scanf's argument's type
            # get addr of vararg 0.
            addr = decode_vararg(state, mem_pointer, 0)
            var_type, var_size = decode_var_type(analyzer, state, addr)

            pattern, loaded_data = C_extract_string_by_start_pointer(start_pointer, 0, data_section,
                                                                     state.symbolic_memory)

            # in scanf, the loaded_data is the pattern string, like '%d %d'
            pattern_list = loaded_data.split()
            pattern_list = [i.strip() for i in pattern_list]

            for i, pattern_str in enumerate(pattern_list):
                if pattern_str == '%d' or pattern_str == '%x' or pattern_str == '%u':
                    # as the basic unit in wasm is i32.load
                    target_mem_pointer = lookup_symbolic_memory(state.symbolic_memory, data_section,
                                                                mem_pointer, 4)
                    if is_bv_value(target_mem_pointer):
                        target_mem_pointer = target_mem_pointer.as_long()
                    # TODO recheck here
                    # move to the next position where the new variable should be inserted
                    mem_pointer += 4

                    inserted_variable = BitVec(
                        f"variable{str(i)}_{state.current_func_name}", 32)
                    state.symbolic_memory = insert_symbolic_memory(
                        state.symbolic_memory, target_mem_pointer, 4, inserted_variable)
                    logging.warning(
                        f"================Initiated an scanf integer: variable{str(i)}_{state.current_func_name}!=================\n")
                elif pattern_str == '%s':
                    # as the basic unit in wasm is i32.load
                    target_mem_pointer = lookup_symbolic_memory(state.symbolic_memory, data_section,
                                                                mem_pointer, 4).as_long()
                    # mem_pointer += 4

                    # insert an 'abc\x00', little endian: 6513249
                    # big endian: 1633837824
                    state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, target_mem_pointer, 4,
                                                                   BitVecVal(6513249, 32))
                    logging.warning(
                        "================Initiated an scanf string: abc=================\n")
                else:
                    exit("$scanf error")
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
            the_one_mem = lookup_symbolic_memory(
                state.symbolic_memory, {}, the_one, 1)
            the_other_mem = lookup_symbolic_memory(
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
            src_string, _ = C_extract_string_by_start_pointer(
                src, _, data_section, state.symbolic_memory)
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
        elif self.name == 'strncpy':
            length, src, dest = param_list[0].as_long(
            ), param_list[1].as_long(), param_list[2].as_long()

            # extract the string according to the src pointer
            src_string, _ = C_extract_string_by_start_pointer(
                src, _, data_section, state.symbolic_memory)
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
            raw_src_data = lookup_symbolic_memory(
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
    val_81328 = simplify(lookup_symbolic_memory(
        state.symbolic_memory, data_section, 81328, 4) + 15) & 4294967280  # calculate heap start
    val_81328 = simplify(val_81328)
    state.symbolic_memory = insert_symbolic_memory(
        state.symbolic_memory, 81328, 4, val_81328)  # save the heap start
    val_85336 = lookup_symbolic_memory(
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
            heapStart = lookup_symbolic_memory(
                state.symbolic_memory, data_section, 81328, 4)
            # bytes per block == 16
            neededBlocks = simplify(
                (BitVecVal(15, 32) + sz) >> BitVecVal(4, 32))
            nextAlloc = lookup_symbolic_memory(
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
            manually_constructed = True
        elif self.name == 'memcpy':
            length, src, dest = param_list[0], param_list[1], param_list[2]
            src_addr = src.as_long()
            dest_addr = dest.as_long()
            len_v = length.as_long()
            vlis = [lookup_symbolic_memory(
                state.symbolic_memory, data_section, src_addr + i, 1) for i in range(len_v)]
            for i, v in enumerate(vlis):
                state.symbolic_memory = insert_symbolic_memory(
                    state.symbolic_memory, dest_addr + i, 1, v)
            state.symbolic_stack.append(dest)
            manually_constructed = True
        elif self.name == 'syscall/js.valueGet':
            p_len, p_str, v_addr, retval = param_list[2], param_list[3], param_list[4], param_list[5]
            prop = lookup_symbolic_memory(
                state.symbolic_memory, data_section, p_str.as_long(), p_len.as_long())
            value = lookup_symbolic_memory(
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

        if not manually_constructed and return_str:
            tmp_bitvec = getConcreteBitVec(return_str,
                                           self.name + '_ret_' + return_str + '_' + self.cur_func + '_' + str(
                                               state.instr.offset))
            state.symbolic_stack.append(tmp_bitvec)
