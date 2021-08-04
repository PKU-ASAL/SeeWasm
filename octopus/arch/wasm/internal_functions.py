from .helper import ImportFunction, lookup_symbolic_memory, insert_symbolic_memory
from .helper_c import C_extract_string_by_start_pointer, C_extract_string_by_mem_pointer
from .type2z3 import getConcreteBitVec
from z3 import *
import logging
import gvar

class PredefinedFunction:
    def __init__(self, name, cur_func_name):
        self.name = name
        self.cur_func = cur_func_name

    def emul(self, state, internal_name, param_str, return_str, data_section):
        # if the return value is dependent on the library function, we will manually contruct it
        # and jump over the process in which it append a symbol according to the signature of the function
        manually_constructed = False

        param_list = []
        if param_str:
            num_arg = len(param_str.split(' '))
            for _ in range(num_arg):
                param_list.append(state.symbolic_stack.pop())

        if self.name == '$printf':
            # has to use as_long()
            mem_pointer, start_pointer = param_list[0].as_long(), param_list[1].as_long()
            the_string = C_extract_string_by_start_pointer(start_pointer, mem_pointer, data_section,
                                                           state.symbolic_memory)
            if isinstance(the_string, str) and the_string.isspace():
                the_string = f"'{ord(the_string)}'"
            logging.warning("========================Print!=========================\n%s", the_string)
        elif self.name == '$scanf':
            mem_pointer, start_pointer = param_list[0].as_long(), param_list[1].as_long()
            the_string = C_extract_string_by_start_pointer(start_pointer, 0, data_section,
                                                           state.symbolic_memory)

            pattern_strs = the_string.split()
            for i, pattern_str in enumerate(pattern_strs):
                if pattern_str == '%d':
                    # as the basic unit in wasm is i32.load
                    target_mem_pointer = lookup_symbolic_memory(state.symbolic_memory, data_section,
                                                                mem_pointer, 4).as_long()
                    # TODO recheck here
                    # move to the next position where the new variable should be inserted
                    mem_pointer += 4

                    state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, target_mem_pointer, 4,
                                                                   BitVec('variable' + str(i), 32))
                    logging.warning("================Initiated an scanf integer: %s!=================\n", '$scanf_variable' + str(i))
                elif pattern_str == '%s':
                    # as the basic unit in wasm is i32.load
                    target_mem_pointer = lookup_symbolic_memory(state.symbolic_memory, data_section,
                                                                mem_pointer, 4).as_long()
                    # mem_pointer += 4

                    # insert an 'abc\x00', little endian: 6513249
                    # big endian: 1633837824
                    state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, target_mem_pointer, 4,
                                                                   BitVecVal(6513249, 32))
                    logging.warning("================Initiated an scanf string: abc=================\n")
                else:
                    exit("$scanf error")
        elif self.name == '$strlen':
            mem_pointer = param_list[0].as_long()
            the_string = C_extract_string_by_mem_pointer(mem_pointer, data_section, state.symbolic_memory)
            the_string = the_string.as_long()

            string_length = len(the_string.to_bytes((the_string.bit_length() + 7) // 8, 'little'))
            state.symbolic_stack.append(BitVecVal(string_length, 32))

            manually_constructed = True
            logging.warning("================$strlen! The length is: %s=================\n", string_length)
        elif self.name == '$swap':
            the_one, the_other = param_list[0].as_long(), param_list[1].as_long()
            the_one_mem = lookup_symbolic_memory(state.symbolic_memory, {}, the_one, 1)
            the_other_mem = lookup_symbolic_memory(state.symbolic_memory, {}, the_other, 1)
            state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, the_one, 1, the_other_mem)
            state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, the_other, 1, the_one_mem)
            logging.warning("================$swap! Swap the two: %s and %s=================\n", the_one_mem,
                            the_other_mem)

        if not manually_constructed and return_str:
            tmp_bitvec = getConcreteBitVec(return_str,
                                            internal_name + '_ret_' + return_str + '_' + self.cur_func + '_' + str(
                                               state.pc))
            state.symbolic_stack.append(tmp_bitvec)
    # normal function call is processed here

class InternalFunction:
    def __init__(self, internal_function_name, param_list, return_str, state):
        self.internal_function_name = internal_function_name
        self.state = state
        self.import_func = ImportFunction(
            self.internal_function_name, param_list, return_str, self.state)

    def emul(self):
        if self.internal_function_name == 'eosio_assert':
            if self.import_func.halt:
                halt = self.import_func.get_halt()
                logging.debug('[+] eosio_assert failed')
                logging.debug('[x] current constraints:')
                for c in self.import_func.get_constraint():
                    logging.debug(' [x] %s' % c)
                logging.debug(
                    '[x] Therefore jump to the previous level')
                logging.debug('')
            elif self.import_func.constraint != None:
                self.state.constraints = self.import_func.get_constraint()

            if gvar.guided_emulation_flag:
                halt = False
        elif self.internal_function_name == 'eosio_assert_code':
            if self.import_func.halt:
                halt = self.import_func.get_halt()
                logging.debug('[+] eosio_assert_code failed')
                logging.debug('[x] current constraints:')
                for c in self.import_func.get_constraint():
                    logging.debug(' [x] %s' % c)
                logging.debug(
                    '[x] Therefore jump to the previous level')
                logging.debug('')
            elif self.import_func.constraint != None:
                self.state.constraints = self.import_func.get_constraint()

            if gvar.guided_emulation_flag:
                halt = False
        elif self.internal_function_name == 'memcpy':
            # void* memcpy(void*dest, const void *src, size_t n)
            # return is a pointer to dest
            # but sometimes the `memcpy` may fail, so halt
            if not self.import_func.get_halt():
                self.state.symbolic_stack.append(
                    self.import_func.return_result())
            else:
                halt = True
        elif self.internal_function_name == 'memmove':
            if not self.import_func.get_halt():
                self.state.symbolic_stack.append(
                    self.import_func.return_result())
            else:
                halt = True
        elif self.internal_function_name == 'sha256':
            if self.import_func.get_halt():
                halt = True
        elif self.internal_function_name == 'abort':
            halt = True
        elif self.internal_function_name == 'require_auth':
            self.state.constraints = self.import_func.get_constraint()
        elif self.internal_function_name == 'require_auth2':
            self.state.constraints = self.import_func.get_constraint()
        elif self.internal_function_name == 'memset':
            self.state.symbolic_stack.append(
                self.import_func.return_result())
        elif self.internal_function_name == 'eosio_exit':
            halt = True
        elif self.internal_function_name == 'db_get_i64':
            self.state.symbolic_stack.append(
                self.import_func.return_result())
        elif self.internal_function_name in self.key_self.import_functions:
            self.state.key_self.import_func_visited.append(
                self.import_func.format_key_self.import_func())
            # print(self.import_func.format_key_self.import_func())

            self.import_func_result = self.import_func.return_result()
            if self.import_func_result is not None:
                self.state.symbolic_stack.append(
                    self.import_func.return_result())

            # TODO for ruiyi, what's the purpose
            # if self.internal_function_name == 'db_find_64' or internal_function_name == 'db_store_i64':
            #     halt = True
        else:
            self.import_func_result = self.import_func.return_result()
            if self.import_func_result is not None:
                # to distinguish between different function with same self.name
                self.state.symbolic_stack.append(self.import_func_result)
