# These functions are predefined and we will emulate their behaviors

from octopus.arch.wasm.dawrf_parser import decode_var_type, decode_vararg, get_source_location
from octopus.arch.wasm.memory import lookup_symbolic_memory, insert_symbolic_memory
from octopus.arch.wasm.helper_c import C_extract_string_by_start_pointer, C_extract_string_by_mem_pointer
from octopus.arch.wasm.utils import getConcreteBitVec
from octopus.arch.wasm.utils import Enable_Lasers, bcolors, Configuration
from octopus.arch.wasm.modules.BufferOverflowLaser import BufferOverflowLaser
from z3 import *
import logging


class PredefinedFunction:
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

            # the little endian is refer to the implementation of scanf
            little_endian_num = int.from_bytes(
                str.encode(f'{src_string}\x00'), "little")

            state.symbolic_memory = insert_symbolic_memory(
                state.symbolic_memory, dest, src_string_len, BitVecVal(little_endian_num, 8*src_string_len))
        elif self.name == 'strcat':
            # TODO implement
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
        # ------------------------ GO Library -------------------------------
        elif self.name == 'fmt.Fprintln':
            logging.warning("=============$fmt.Fprintln============")

        if not manually_constructed and return_str:
            tmp_bitvec = getConcreteBitVec(return_str,
                                           self.name + '_ret_' + return_str + '_' + self.cur_func + '_' + str(
                                               state.instr.offset))
            state.symbolic_stack.append(tmp_bitvec)
