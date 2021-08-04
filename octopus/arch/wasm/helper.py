import logging

from z3 import *

# import gvar

# you can comment below
# logging.basicConfig(level=logging.DEBUG)

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


# deal with load instruction
def load_instr(instr, state, data_section):
    base = state.symbolic_stack.pop()
    assert is_bv(base), f"in load_instr `base` type is {type(base)}"

    # offset maybe int or hex
    try:
        offset = int(instr.split(' ')[2])
    except ValueError:
        offset = int(instr.split(' ')[2], 16)

    addr = simplify(base + offset)
    assert is_bv(addr), f"addr in load_instr is {type(addr)} instead of bv"

    if type(addr) == BitVecNumRef:
        addr = addr.as_long()

    instr_name = instr.split(' ')[0]
    if instr_name == 'i32.load':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 4)
        if val is not None:
            assert val.size() == 32, f"in i32.load the val loaded size is not 32"
    elif instr_name == 'i64.load':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 8)
        if val is not None:
            assert val.size() == 64, f"in i64.load the val loaded size is not 64"
    elif instr_name == 'f32.load':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 4)
        if val is not None:
            assert val.size() == 32, f"in f32.load the val loaded size is not 32"
            val = fpBVToFP(val, Float32())
    elif instr_name == 'f64.load':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 8)
        if val is not None:
            assert val.size() == 64, f"in f64.load the val loaded size is not 64"
            val = fpBVToFP(val, Float64())
    elif instr_name == 'i32.load8_s':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 1)
        if val is not None:
            assert val.size() == 8, f"in i32.load8_s the val loaded size is not 8"
            val = simplify(SignExt(24, val))
    elif instr_name == 'i32.load8_u':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 1)
        if val is not None:
            assert val.size() == 8, f"in i32.load8_u the val loaded size is not 8"
            val = simplify(ZeroExt(24, val))
    elif instr_name == 'i32.load16_s':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 2)
        if val is not None:
            assert val.size() == 16, f"in i32.load16_s the val loaded size is not 16"
            val = simplify(SignExt(16, val))
    elif instr_name == 'i32.load16_u':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 2)
        if val is not None:
            assert val.size() == 16, f"in i32.load16_u the val loaded size is not 16"
            val = simplify(ZeroExt(16, val))
    elif instr_name == 'i64.load8_s':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 1)
        if val is not None:
            assert val.size() == 8, f"in i64.load8_s the val loaded size is not 8"
            val = simplify(SignExt(56, val))
    elif instr_name == 'i64.load8_u':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 1)
        if val is not None:
            assert val.size() == 8, f"in i64.load8_u the val loaded size is not 8"
            val = simplify(ZeroExt(56, val))
    elif instr_name == 'i64.load16_s':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 2)
        if val is not None:
            assert val.size() == 16, f"in i64.load16_s the val loaded size is not 16"
            val = simplify(SignExt(48, val))
    elif instr_name == 'i64.load16_u':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 2)
        if val is not None:
            assert val.size() == 16, f"in i64.load16_u the val loaded size is not 16"
            val = simplify(ZeroExt(48, val))
    elif instr_name == 'i64.load32_s':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 4)
        if val is not None:
            assert val.size() == 32, f"in i64.load32_s the val loaded size is not 32"
            val = simplify(SignExt(32, val))
    elif instr_name == 'i64.load32_u':
        val = lookup_symbolic_memory(state.symbolic_memory, data_section, addr, 4)
        if val is not None:
            assert val.size() == 32, f"in i64.load32_u the val loaded size is not 32"
            val = simplify(ZeroExt(32, val))

    if val is None:
        if 'i32' in instr_name.split('.')[0]:
            state.symbolic_stack.append(BitVec('load_i32*(' + str(addr) + ')', 32))
        elif 'f32' in instr_name.split('.')[0]:
            state.symbolic_stack.append(FP('load_f32*(' + str(addr) + ')', Float32()))
        elif 'i64' in instr_name.split('.')[0]:
            state.symbolic_stack.append(BitVec('load_i64*(' + str(addr) + ')', 64))
        elif 'f64' in instr_name.split('.')[0]:
            state.symbolic_stack.append(FP('load_f64*(' + str(addr) + ')', Float64()))
    # elif type(val) == BitVecRef:
    #     if 'i32' in instr_name.split('.')[0]:
    #         state.symbolic_stack.append(BitVec('load_i32*(' + str(val) + ')', 32))
    #     elif 'f32' in instr_name.split('.')[0]:
    #         state.symbolic_stack.append(FP('load_f32*(' + str(val) + ')', Float32()))
    #     elif 'i64' in instr_name.split('.')[0]:
    #         state.symbolic_stack.append(BitVec('load_i64*(' + str(val) + ')', 64))
    #     elif 'f64' in instr_name.split('.')[0]:
    #         state.symbolic_stack.append(FP('load_f64*(' + str(val) + ')', Float64()))
    else:
        assert not is_bool(val), 'in load_instr, the value to be pushed in stack is a BoolRef'
        state.symbolic_stack.append(val)


# deal with store instruction
def store_instr(instr, state):
    # offset may be int or hex
    try:
        offset = int(instr.split(' ')[2])
    except ValueError:
        offset = int(instr.split(' ')[2], 16)

    val, base = state.symbolic_stack.pop(), state.symbolic_stack.pop()
    addr = simplify(base + offset)

    # change addr's type to int if possible
    # or it will be the BitVecRef
    if type(addr) == BitVecNumRef:
        addr = addr.as_long()

    instr_name = instr.split(' ')[0]

    if instr_name == 'i32.store':
        assert val.size() == 32, f"in i32.store the value to be stored size is {val.size()} not 32"
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 4, val)
    elif instr_name == 'i64.store':
        assert val.size() == 64, f"in i64.store the value to be stored size is {val.size()} not 64"
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 8, val)
    elif instr_name == 'f32.store':
        assert val.ebits() == 8 and val.sbits() == 24, f"in f32.store the value to be stored is ebits: {val.ebits()}, sbits: {val.sbits()}"
        val = fpToIEEEBV(val)
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 4, val)
    elif instr_name == 'f64.store':
        assert val.ebits() == 11 and val.sbits() == 53, f"in f64.store the value to be stored is ebits: {val.ebits()}, sbits: {val.sbits()}"
        val = fpToIEEEBV(val)
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 8, val)
    elif instr_name == 'i32.store8':
        assert val.size() == 32, f"in i32.store8 the value to be stored size is {val.size()} not 32"
        val = simplify(Extract(7, 0, val))
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 1, val)
    elif instr_name == 'i32.store16':
        assert val.size() == 32, f"in i32.store16 the value to be stored size is {val.size()} not 32"
        val = simplify(Extract(15, 0, val))
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 2, val)
    elif instr_name == 'i64.store8':
        assert val.size() == 64, f"in i64.store8 the value to be stored size is {val.size()} not 64"
        val = simplify(Extract(7, 0, val))
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 1, val)
    elif instr_name == 'i64.store16':
        assert val.size() == 64, f"in i64.store16 the value to be stored size is {val.size()} not 64"
        val = simplify(Extract(15, 0, val))
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 2, val)
    elif instr_name == 'i64.store32':
        assert val.size() == 64, f"in i64.store32 the value to be stored size is {val.size()} not 64"
        val = simplify(Extract(31, 0, val))
        state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, addr, 4, val)
    else:
        raise Exception('Forbidden area for store instruction')


# GUIDANCE:
# existed:          [____fixed____]                     is_overlapped
# case 1: [___]     |             |                         False
# case 2: [_________]             |                         False
# case 3: [_____________]         |                         True
# case 4: [_______________________]                         True
# case 5: [____________________________]                    True
# case 6:           [_____]       |                         True
# case 7:           [_____________]                         True
# case 8:           [___________________]                   True
# case 9:           |   [___]     |                         True
# case 10:          |   [_________]                         True
# case 11:          |   [_________________]                 True
# case 12:          |             [_________]               False
# case 13:          |             |        [______]         False

# def to_little_endian(data, length):
#     assert data is not None, f"in to_little_endian, the data is {data}, the length is {length}"
#     if isinstance(data, int):
#         data = BitVecVal(data, length * 8)

#     total_length = data.size()
#     if total_length == 8:
#         return data

#     result_list = []
#     for index in range(0, total_length, 8):
#         result_list.append(Extract(total_length - 1 - index, total_length - 8 - index, data))
#         # result_list.append(Extract(index + 7, index, data))

#     result_list.reverse()
#     return simplify(Concat(*result_list))


# def recover_from_little_endian(data, length):
#     return to_little_endian(data, length)


# dest type can only be bitvecref or int
def lookup_symbolic_memory(symbolic_memory, data_section, dest, length):
    assert isinstance(length, int), "length type in lookup_symbolic_memory is not int"
    assert type(dest) == BitVecRef or isinstance(dest, int), f"dest type in lookup_symbolic_memory is {type(dest)}"

    try:
        # if dest type is `BitVecRef`
        if type(dest) == BitVecRef:
            # TODO maybe I need merge the BitVecRef
            if (dest, simplify(dest + length)) in data_section.keys():
                assert data_section[(dest, simplify(
                    dest + length))].size() == length * 8, f"data size in lookup_symbolic_memory is not compatible with the length"
                return data_section[(dest, simplify(dest + length))]
            elif (dest, simplify(dest + length)) in symbolic_memory.keys():
                assert symbolic_memory[(dest, simplify(
                    dest + length))].size() == length * 8, f"data size in lookup_symbolic_memory is not compatible with the length"
                return data_section[(dest, simplify(dest + length))]
            else:
                return None

        # other cases
        is_symbolic_memory, is_existed, existed_start, existed_end = lookup_overlapped_symbolic_memory(symbolic_memory, data_section, dest, length)
        if not is_existed:
            return None
        
        # in data section
        if not is_symbolic_memory:
            overlapped_start, overlapped_end = calc_overlap(existed_start, existed_end, dest, length)
            high, low = overlapped_end - existed_start, overlapped_start - existed_start

            # convert data section piece into BitVecVal
            data_section_bitvec = BitVecVal(int.from_bytes(data_section[(existed_start, existed_end)], 'big'), len(data_section[(existed_start, existed_end)])*8)
            data = simplify(Extract(high * 8 - 1, low * 8, data_section_bitvec))

            if data.size() < length * 8:
                data = simplify(Concat(BitVecVal(0, length * 8 - data.size()), data))
            assert data.size() == length * 8, f"data size in lookup_symbolic_memory is not compatible with the length"
            return data
        else:
            overlapped_start, overlapped_end = calc_overlap(existed_start, existed_end, dest, length)
            high, low = overlapped_end - existed_start, overlapped_start - existed_start
            data = simplify(Extract(high * 8 - 1, low * 8, symbolic_memory[(existed_start, existed_end)]))

            if data.size() < length * 8:
                data = simplify(Concat(BitVecVal(0, length * 8 - data.size()), data))
            assert data.size() == length * 8, f"data size in lookup_symbolic_memory is not compatible with the length"
            return data
    except Exception:
        raise


# dest type can only be bitvecref or int
def insert_symbolic_memory(symbolic_memory, dest, length, data):
    assert isinstance(length, int), "length type in insert_symbolic_memory is not int"
    assert type(dest) == BitVecRef or isinstance(dest, int), f"dest type in insert_symbolic_memory is {type(dest)}"

    # simplify the data
    # data = simplify(data)
    # print('dest:', dest, 'length:', length, 'data:', data)

    # data is None because it is not the real path in the rollback detect
    if data is None:
        return symbolic_memory

    # if dest type is `BitVecRef`
    # in this case, don't use z3 add it in symbolic_memory directly
    if type(dest) == BitVecRef:
        # data = to_little_endian(data, length)

        symbolic_memory[(dest, simplify(dest + length))] = data
    # if dest type is `int`
    else:
        # the existed_start and existed_end are all int
        _, is_overlapped, existed_start, existed_end = lookup_overlapped_symbolic_memory(symbolic_memory, dict(), dest, length)
        if not is_overlapped:
            # data = to_little_endian(data, length)

            assert data.size() == length * 8, f"data is: {data}, data size is {data.size()}, length is {length}"
            # insert directly
            symbolic_memory[(dest, dest + length)] = data
        else:
            # case 3-11
            # existed:          [____fixed____]
            # case 3: [_____________]         |
            # case 4: [_______________________]
            # case 5: [____________________________]
            # case 6:           [_____]       |
            # case 7:           [_____________]
            # case 8:           [___________________]
            # case 9:           |   [___]     |
            # case 10:          |   [_________]
            # case 11:          |   [_________________]

            # the flag to tell whether the memory has been inserted
            is_inserted = False
            overlapped_start, overlapped_end = calc_overlap(existed_start, existed_end, dest, length)
            if dest < overlapped_start:
                # case 3-5
                if overlapped_end < existed_end:
                    # case 3
                    first_part = data
                    original = symbolic_memory.pop((existed_start, existed_end))
                    high, low = existed_end - existed_start, overlapped_end - existed_start 
                    second_part = simplify(Extract(high * 8 - 1, low * 8, original))
                    data = simplify(Concat(second_part, first_part))

                    assert data.size() == (
                            length + high) * 8, f"data is: {data}, data size is {data.size()}, length is {length + high}"
                    symbolic_memory[(dest, existed_end)] = data

                    is_inserted = True
                else:
                    # case 4 and 5
                    # pop original
                    symbolic_memory.pop((existed_start, existed_end))

                    assert data.size() == length * 8, f"data is: {data}, data size is {data.size()}, length is {length}"
                    symbolic_memory[(dest, dest + length)] = data

                    is_inserted = True

            if not is_inserted and overlapped_start == existed_start:
                # case 6-8
                if overlapped_end < existed_end:
                    # case 6
                    first_part = data
                    original = symbolic_memory.pop((existed_start, existed_end))
                    high, low = existed_end - existed_start, overlapped_end - existed_start
                    second_part = simplify(Extract(high * 8 - 1, low * 8, original))
                    data = simplify(Concat(second_part, first_part))

                    assert data.size() == (
                            existed_end - existed_start) * 8, f"data is: {data}, data size is {data.size()}, length is {existed_end - existed_start}"
                    symbolic_memory[(dest, existed_end)] = data

                    is_inserted = True
                else:
                    # case 7 and 8
                    symbolic_memory.pop((existed_start, existed_end))

                    assert data.size() == length * 8, f"data is: {data}, data size is {data.size()}, length is {length}"
                    symbolic_memory[(dest, dest + length)] = data

                    is_inserted = True

            if not is_inserted and overlapped_start > existed_start:
                # case 9-11
                if overlapped_end >= existed_end:
                    # case 10 and 11
                    original = symbolic_memory.pop((existed_start, existed_end))
                    high = overlapped_start - existed_start
                    first_part = simplify(Extract(high * 8 - 1, 0, original))
                    second_part = data
                    data = simplify(Concat(second_part, first_part))

                    assert data.size() == (high + length) * 8, f"data is: {data}, data size is {data.size()}, length is {high + length}"
                    symbolic_memory[(existed_start, dest + length)] = data
                else:
                    # case 9
                    original = symbolic_memory.pop((existed_start, existed_end))
                    # for first part
                    high = overlapped_start - existed_start
                    first_part = simplify(Extract(high * 8 - 1, 0, original))

                    second_part = data

                    # for third part
                    high, low = existed_end - existed_start, overlapped_end - existed_start
                    third_part = simplify(Extract(high * 8 - 1, low * 8, original))
                    data = simplify(Concat(third_part, second_part, first_part))

                    assert data.size() == (
                            existed_end - existed_start) * 8, f"data is: {data}, data size is {data.size()}, length is {existed_end - existed_start}"
                    symbolic_memory[(existed_start, existed_end)] = data

    return merge_symbolic_memory(symbolic_memory)


def merge_symbolic_memory(symbolic_memory):
    symbolic_memory_dup = symbolic_memory.copy()

    int_keys = []
    for k, _ in symbolic_memory_dup.items():
        if isinstance(k[0], int):
            int_keys.append(k)

    # sort the int_keys by the start position of key
    int_keys.sort(key=lambda x: x[0])
    # merge it
    i = 0
    while i < len(int_keys):
        if i + 1 >= len(int_keys):
            break

        # fetch current key and next one
        current_key, next_key = int_keys[i], int_keys[i + 1]
        if current_key[1] == next_key[0]:
            # merge!
            first_part = symbolic_memory_dup.pop(current_key)
            second_part = symbolic_memory_dup.pop(next_key)
            data = simplify(Concat(second_part, first_part))

            symbolic_memory_dup[(current_key[0], next_key[1])] = data

            int_keys.remove(current_key)
            int_keys.remove(next_key)
            int_keys.insert(0, (current_key[0], next_key[1]))
            continue
        else:
            i += 1

    return symbolic_memory_dup


def calc_overlap(existed_start, existed_end, dest, length):
    if dest <= existed_start:
        overlapped_start = existed_start
    else:
        overlapped_start = dest

    if dest + length < existed_end:
        overlapped_end = dest + length
    else:
        overlapped_end = existed_end

    return overlapped_start, overlapped_end


def lookup_overlapped_symbolic_memory(symbolic_memory, data_section, dest, length):
    found = False
    existed_start, existed_end = None, None

    # iterate the existed data_section
    for k, _ in data_section.items():
        # k is a tuple, i.e. (start, end)
        existed_start, existed_end = k[0], k[1]
        # if the key's element type is BitVecRef, jump over
        if is_bv(existed_start):
            continue

        if is_overlapped(existed_start, existed_end, dest, length):
            found = True
            break
    if found:
        return False, True, existed_start, existed_end

    # iterate the existed symbolic_memory
    for k, _ in symbolic_memory.items():
        # k is a tuple, i.e. (start, end)
        existed_start, existed_end = k[0], k[1]
        # if the key's element type is BitVecRef, jump over
        if is_bv(existed_start):
            continue

        if is_overlapped(existed_start, existed_end, dest, length):
            found = True
            break

    if found:
        return True, True, existed_start, existed_end
    else:
        return True, False, None, None


def is_overlapped(existed_start, existed_end, dest, length):
    if dest + length <= existed_start:
        # case 1, 2
        return False

    if dest >= existed_end:
        # case 12, 13
        return False

    # remained cases
    return True


# Whether target_func calls a function in the collection
def has_sidepath_call_keyimport(target_func, edges, target_set):
    upper_function_set = set()
    for edge in edges:
        # edge.node_to in {'send_inline'}
        if edge.node_to in target_set:
            if edge.node_from != target_func:
                if edge.node_from not in gvar.visited_func:
                    # if edge.node_from != func_name:
                    upper_function_set.add(edge.node_from)
                    gvar.visited_func.add(edge.node_from)
                else:
                    continue
            else:
                return True
        else:
            continue

    if upper_function_set:
        return has_sidepath_call_keyimport(target_func, edges, upper_function_set)
    else:
        return False

def main():
    # memory_mapping = {}
    # val = BitVec('test', 32)
    # memory_mapping = insert_symbolic_memory(memory_mapping, 0, 4, val)
    # print(memory_mapping)
    # print(lookup_symbolic_memory(memory_mapping, 2, 2))
    a = BitVec('a', 32)
    b = BitVec('b', 32)
    c = a + b
    print(c)


if __name__ == "__main__":
    main()