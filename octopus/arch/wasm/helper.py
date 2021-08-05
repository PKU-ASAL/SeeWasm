import logging
from z3 import *

from octopus.arch.wasm.memory import *

# some functions which return the iterator
can_jump_function = ['malloc_ret_i32']


class ImportFunction():

    def __init__(self, func_name, args, returns, state):
        self.func_name = func_name
        self.args_list = args
        self.returns = returns

        self.constraint = state.constraints
        self.halt = False

        # for memory operation
        self.state = state

        self.analyze()

    # analyze some special function which would influence the control flow
    def analyze(self):
        if self.func_name == 'eosio_assert' and len(self.args_list) == 2:
            # eosio_assert(condition, msg)
            # only if condition satisfied the flow will continue
            # or it will be halted
            assert is_bv(self.args_list[0]) or is_bool(self.args_list[
                                                           0]), f"the eosio_assert condition type is {type(self.args_list[0])} instead of bv or bool"
            if is_bv_value(self.args_list[0]):
                if self.args_list[0].as_long() == 0:
                    self.halt = True
                    # the constraint should always contain only type of BoolRef
                    self.constraint.append(BoolVal(False))
                else:
                    return
            else:
                s = Solver()

                if is_bv(self.args_list[0]) and self.args_list[0].__str__() not in can_jump_function:
                    s.add(self.args_list[0] != 0)
                    # need to be generify
                elif is_bv(self.args_list[0]) and self.args_list[0].__str__() in can_jump_function:
                    return
                else:
                    s.add(self.args_list[0])

                logging.debug('[+] eosio_assert function')
                logging.debug('[+] current constraint:')
                for c in self.constraint:
                    logging.debug(' [x] %s' % c)
                logging.debug(' [x] %s' % self.args_list[0])
                logging.debug('')

                if sat == s.check():
                    # can be solved, so use this condition as constraint
                    if is_bv(self.args_list[0]):
                        self.constraint.append(simplify(self.args_list[0] != 0))
                    else:
                        assert isinstance(self.args_list[0], BoolRef)
                        self.constraint.append(self.args_list[0])
                else:
                    # can not be solved, so halt this call
                    self.halt = True
                    assert isinstance(self.args_list[0], BoolRef)
                    self.constraint.append(self.args_list[0])
        elif self.func_name == 'eosio_assert_code' and len(self.args_list) == 2:
            if self.args_list[0] == 0:
                self.halt = True
            else:
                pass
        elif self.func_name == 'memcpy' and len(self.args_list) == 3:
            dest, src, length = self.args_list[0], self.args_list[1], self.args_list[2]
            assert is_bv(dest), f"in memcpy, the dest type is {type(dest)}"
            assert is_bv(src), f"in memcpy, the src type is {type(src)}"
            assert is_bv(length), f"in memcpy, the length type is {type(length)}"

            if type(length) == BitVecRef:
                length_in_size = int(length.size() / 8)
            elif type(length) == BitVecNumRef:
                length_in_size = length.as_long()
            else:
                raise Exception(f"the length type in memcpy is {type(length)}")

            try:
                # logging.warning(f"length in byte size is {length_in_size}")
                if type(src) == BitVecNumRef:
                    src = src.as_long()

                source_data = lookup_symbolic_memory(self.state.symbolic_memory, self.data_section, src, length_in_size)
                if source_data is None:
                    source_data = BitVecVal(0, length_in_size * 8)
                assert source_data.size() == length_in_size * 8, f"in memcpy, source data loaded is not compatible with length {length}"
            except Exception:
                self.halt = True
                logging.info(f"encountered a unusual length in func `memcpy`, the length is {length_in_size}")
            else:
                assert is_bv(dest), f"dest type in memcpy is {type(dest)} instead of bv"
                if type(dest) == BitVecNumRef:
                    dest = dest.as_long()
                self.state.symbolic_memory = insert_symbolic_memory(self.state.symbolic_memory, dest, length_in_size,
                                                                    source_data)
        elif self.func_name == 'memmove' and len(self.args_list) == 3:
            dest, src, length = self.args_list[0], self.args_list[1], self.args_list[2]
            assert is_bv(dest), f"in memmove, the dest type is {type(dest)}"
            assert is_bv(src), f"in memmove, the src type is {type(src)}"
            assert is_bv(length), f"in memmove, the length type is {type(length)}"

            if type(length) == BitVecRef:
                length_in_size = int(length.size() / 8)
            elif type(length) == BitVecNumRef:
                length_in_size = length.as_long()
            else:
                raise Exception(f"the length type in memmove is {type(length)}")

            try:
                # logging.warning(f"length in byte size is {length_in_size}")
                if type(src) == BitVecNumRef:
                    src = src.as_long()

                source_data = lookup_symbolic_memory(self.state.symbolic_memory, self.data_section, src, length_in_size)
                if source_data is None:
                    source_data = BitVecVal(0, length_in_size * 8)

                assert source_data.size() == length_in_size * 8, f"in memmove, source data loaded is not compatible with length {length}"
            except Exception:
                self.halt = True
                logging.info(f"encountered a unusual length in func `memmove`, the length is {length_in_size}")
            else:
                assert is_bv(dest), f"dest type in memmove is {type(dest)} instead of bv"
                if type(dest) == BitVecNumRef:
                    dest = dest.as_long()
                self.state.symbolic_memory = insert_symbolic_memory(self.state.symbolic_memory, dest, length_in_size,
                                                                    source_data)
        elif self.func_name == 'memset' and len(self.args_list) == 3:
            dest, val, length = self.args_list[0], self.args_list[1], self.args_list[2]
            assert is_bv(dest), f"in memset, the dest type is {type(dest)}"
            assert is_bv(length), f"in memset, the length type is {type(length)}"

            if type(length) == BitVecRef:
                length_in_size = int(length.size() / 8)
            elif type(length) == BitVecNumRef:
                length_in_size = length.as_long()

            assert is_bv(val), f"in memset, the val is {type(val)} instead of bitVecVal"
            if is_bv_value(val):
                val = BitVecVal(val.as_long(), 8)
            else:
                val = simplify(Extract(7, 0, val))

            val = simplify(RepeatBitVec(length_in_size, val))

            assert is_bv(dest), f"dest type in memset is {type(dest)} instead of bv"
            if type(dest) == BitVecNumRef:
                dest = dest.as_long()
            self.state.symbolic_memory = insert_symbolic_memory(self.state.symbolic_memory, dest, length_in_size, val)

        elif self.func_name == 'require_auth' and len(self.args_list) == 1:
            # the argument, i.e. the name, must has permission
            constraint = Bool(str(self.args_list[0]) + '_HasPermission')
            self.constraint.append(constraint)

            logging.debug('[+] require_auth function')
            logging.debug('[+] current constraint:')
            for c in self.constraint:
                logging.debug(' [x] %s' % c)
            logging.debug(' [x] %s' % self.args_list[0])
            logging.debug('')

        elif self.func_name == 'require_auth2' and len(self.args_list) == 2:
            # the arg[0] has the permission level arg[1]
            name, permission_level = str(self.args_list[0]), str(self.args_list[1])

            constraint = Bool(name + '_HasPermission_' + permission_level)
            self.constraint.append(constraint)

        elif self.func_name == 'sha256' and len(self.args_list) == 3:
            src, length, dest = self.args_list[0], self.args_list[1], self.args_list[2]
            # eosiolib's function do that thing
            if 'transaction_size' in str(src) and ' read_transaction' in str(length):
                self.state.symbolic_memory = insert_symbolic_memory(self.state.symbolic_memory, dest, 8,
                                                                    BitVec('transaction_id', 64))
                return
            if '0' == str(src):
                return
            assert is_bv(src), f"in sha256, the src type is {type(src)}"
            assert is_bv(length), f"in sha256, the length type is {type(length)}"
            assert is_bv(dest), f"in sha256, the dest type is {type(dest)}"

            if type(length) == BitVecRef:
                length_in_size = int(length.size() / 8)
            elif type(length) == BitVecNumRef:
                length_in_size = length.as_long()

            # change the type of `src` to match the func assertion
            if type(src) == BitVecNumRef:
                src = src.as_long()

            # pre-process
            dest = dest.as_long() if type(dest) == BitVecNumRef else dest

            # print(src, length, dest)
            # # do the hack
            # try:
            #     # load
            #     data = self.state.symbolic_memory[(src, src + length_in_size)]
            #     # copy
            #     self.state.symbolic_memory[(dest, dest + length_in_size)] = data
            #     # merge
            #     merge_symbolic_memory(self.state.symbolic_memory)
            # except Exception:
            #     logging.warning(f"it seems like the hack in `sha256` is not feasible")
            #     exit()
            try:
                data = lookup_symbolic_memory(self.state.symbolic_memory, self.data_section, src, length_in_size)

                # to be inserted is the data itself
                to_be_inserted = data
                self.state.symbolic_memory = insert_symbolic_memory(self.state.symbolic_memory, dest, length_in_size,
                                                                    to_be_inserted)
            except Exception:
                self.halt = True
                logging.info(f"encountered a unusual length in func `sha256`, the length is {length_in_size}")

        elif self.func_name == 'db_get_i64':
            itr, data, length = self.args_list[0], self.args_list[1], self.args_list[2]
            assert is_bv(itr), f"in db_get, the src type is {type(itr)}"
            assert is_bv(data), f"in db_get, the length type is {type(data)}"
            assert is_bv(length), f"in db_get, the dest type is {type(length)}"

            # if the length is 0, means it will return the itr length in bit
            if is_bv_value(length) and length.as_long() == 0:
                self.returns = BitVec('itr_length_' + str(itr.size()), itr.size())
            else:
                data = itr
                if is_bv_value(length):
                    length = length.as_long()
                else:
                    length = length.size()
                dest = data

                # insert into memory
                self.state.symbolic_memory = insert_symbolic_memory(self.state.symbolic_memory, dest, length, data)
                # for temp use
                self.returns = BitVec(self.func_name + '_i32' + '_' + self.func_name + '_' + str(self.state.pc), 32)

        # simplify the constraints
        self.constraint = list(set(self.constraint))

    def return_result(self):
        if self.func_name == 'memcpy':
            return self.args_list[0]
        elif self.func_name == 'memset':
            return self.args_list[0]
        elif self.func_name == 'db_get_i64':
            return self.returns
        else:
            if self.returns:
                assert len(self.returns.split(
                    ' ')) == 1, 'the import function has multiple returns which case is not been considered'
                if self.returns == 'i32':
                    return BitVec(self.func_name + '_i32' + '_' + self.func_name + '_' + str(self.state.pc), 32)
                elif self.returns == 'i64':
                    return BitVec(self.func_name + '_i64' + '_' + self.func_name + '_' + str(self.state.pc), 64)
                elif self.returns == 'f32':
                    return FP(self.func_name + '_f32' + '_' + self.func_name + '_' + str(self.state.pc), Float32())
                elif self.returns == 'f64':
                    return FP(self.func_name + '_f64' + '_' + self.func_name + '_' + str(self.state.pc), Float64())
                else:
                    raise Exception(
                        'func: return_result in ImportFunction does not match any type')
            else:
                return None

    def get_halt(self):
        return self.halt

    def get_constraint(self):
        return self.constraint

    def format_key_import_func(self):
        self.args_list = [str(x) for x in self.args_list]

        return self.func_name + '(' + ', '.join(self.args_list) + ')'


def uleb128_calculate(str):
    i = 0
    j = 0
    result = 0
    temp = int(str[i:i + 2], 16)
    while temp & 0x80:
        i += 2
        temp = int(str[i:i + 2], 16)
    while j < i:
        result += (int(str[j:j + 2], 16) - 128) << 7 * math.floor(j / 2)
        j += 2
    result += temp << 7 * math.floor(i / 2)
    return result