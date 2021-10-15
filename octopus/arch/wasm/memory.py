# This file is the memory emulation
# Can refer the corresponding description in EOSAFE

from z3 import *
import re

from octopus.arch.wasm.utils import getConcreteBitVec

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

    # determine how many bytes should be loaded
    # the dict is like {'8': 1}
    bytes_length_mapping = {str(k): k//8 for k in range(8, 65, 8)}
    instr_name = instr.split(' ')[0]
    if len(instr_name) == 8:
        load_length = bytes_length_mapping[instr_name[1:3]]
    else:
        load_length = bytes_length_mapping[re.search(
            r"load([0-9]+)\_", instr_name).group(1)]

    val = lookup_symbolic_memory(
        state.symbolic_memory, data_section, addr, load_length)

    # cast to other type of bit vector
    float_mapping = {
        'f32': Float32,
        'f64': Float64,
    }
    if len(instr_name) == 8 and instr_name[0] == "f":
        val = simplify(fpBVToFP(val, float_mapping[instr_name[:3]]()))
    elif instr_name[-2] == "_":
        if instr_name[-1] == "s":  # sign extend
            val = simplify(SignExt(int(instr_name[1:3]) - load_length*8, val))
        else:
            val = simplify(ZeroExt(int(instr_name[1:3]) - load_length*8, val))

    # if can not load from the memory area
    if val is not None:
        state.symbolic_stack.append(val)
    else:
        state.symbolic_stack.append(getConcreteBitVec(
            instr_name[:3], f'load_{instr_name[:3]}*({str(addr)})'))


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
    if is_bv_value(addr):
        addr = addr.as_long()

    # determine how many bytes should be stored
    # the dict is like {'8': 1}
    bytes_length_mapping = {str(k): k//8 for k in range(8, 65, 8)}
    instr_name = instr.split(' ')[0]
    if len(instr_name) == 9:
        if instr_name[0] == 'f':
            val = fpToIEEEBV(val)
        state.symbolic_memory = insert_symbolic_memory(
            state.symbolic_memory, addr, bytes_length_mapping[instr_name[1:3]], val)
    else:
        stored_length = bytes_length_mapping[re.search(
            r"store([0-9]+)", instr_name).group(1)]
        val = simplify(Extract(stored_length*8-1, 0, val))
        state.symbolic_memory = insert_symbolic_memory(
            state.symbolic_memory, addr, stored_length, val)


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


# dest type can only be bitvecref or int
def lookup_symbolic_memory(symbolic_memory, data_section, dest, length):
    # if dest type is `BitVecRef`
    # try to directly load from symbolic memory
    if type(dest) == BitVecRef:
        return symbolic_memory.get((dest, simplify(dest + length)), None)

    # other cases, lookup the interval in data section and memory
    tmp_result = lookup_overlapped_symbolic_memory(
        symbolic_memory, data_section, dest, length)
    # we assert the loaded interval can only cover at most one intervals
    assert len(
        tmp_result) == 1, f"the loaded data covers two and more intervals, please check"
    in_symbolic_memory, is_existed, existed_start, existed_end = tmp_result[0]

    # if it cannot be found in either data section nor memory
    if not is_existed:
        return None

    overlapped_start, overlapped_end = calc_overlap(
        existed_start, existed_end, dest, length)
    high, low = overlapped_end - existed_start, overlapped_start - existed_start
    # in data section
    if not in_symbolic_memory:
        # convert data section piece into BitVecVal
        data_section_bitvec = BitVecVal(int.from_bytes(data_section[(
            existed_start, existed_end)], 'little'), len(data_section[(existed_start, existed_end)])*8)
        data = simplify(Extract(high * 8 - 1, low * 8, data_section_bitvec))
    else:
        data = simplify(Extract(high * 8 - 1, low * 8,
                        symbolic_memory[(existed_start, existed_end)]))

    if data.size() < length * 8:
        data = simplify(Concat(BitVecVal(0, length * 8 - data.size()), data))
    return data


# dest type can only be bitvecref or int
def insert_symbolic_memory(symbolic_memory, dest, length, data):
    # if dest type is `BitVecRef`, insert directly
    if type(dest) == BitVecRef:
        symbolic_memory[(dest, simplify(dest + length))] = data
    # if dest type is `int`
    else:
        # the existed_start and existed_end are all int
        tmp_result = lookup_overlapped_symbolic_memory(
            symbolic_memory, dict(), dest, length)

        # step 1:
        # mark the updated part
        used_sub_intervals = []
        for item in tmp_result:
            _, is_overlapped, existed_start, existed_end = item
            if not is_overlapped:
                continue

            to_concat = []
            overlapped_start, overlapped_end = calc_overlap(
                existed_start, existed_end, dest, length)
            # step 1.1: pop the original
            original = symbolic_memory.pop((existed_start, existed_end))

            # step 1.2: calculate the first part
            high, low = overlapped_start - existed_start, 0
            if high != low:
                to_concat.insert(0, simplify(
                    Extract(high * 8 - 1, low * 8, original)))

            # step 1.3: calculate the second part
            high, low = overlapped_end - dest, overlapped_start - dest
            if high != low:
                to_concat.insert(0, simplify(
                    Extract(high * 8 - 1, low * 8, data)))

            # step 1.4: calculate the third part
            high, low = existed_end - existed_start, overlapped_end - existed_start
            if high != low:
                to_concat.insert(0, simplify(
                    Extract(high * 8 - 1, low * 8, original)))

            # step 1.5: concat
            to_insert = simplify(Concat(to_concat)) if len(
                to_concat) > 1 else to_concat[0]

            # step 1.6: insert into the memory
            symbolic_memory[(existed_start, existed_end)] = to_insert

            # step 1.7: record in `used_sub_intervals`
            used_sub_intervals.append([overlapped_start, overlapped_end])

        # step 2:
        # insert the sub-intervals of the incoming interval that were not marked in `used_sub_intervals` into the memory
        used_sub_intervals.append([dest-1, dest])
        used_sub_intervals.append([dest+length, dest+length+1])
        used_sub_intervals.sort(key=lambda a: a[0])
        free_intervals = []
        for i in range(1, len(used_sub_intervals)):
            prevEnd = used_sub_intervals[i - 1][1]
            currStart = used_sub_intervals[i][0]
            if prevEnd < currStart:
                free_intervals.append([prevEnd, currStart])

        for i in free_intervals:
            high, low = i[1] - dest, i[0] - dest
            symbolic_memory[(i[0], i[1])] = simplify(
                Extract(high * 8 - 1, low * 8, data))

    # step 3:
    # merge and return
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
    '''
    return four elements:
    1. whether it is in the symbolic memory
    2. is it overlapped with existed interval
    3&4. the start and end indexes of the overlapped interval
    '''
    # iterate to find
    def iterate_find_overlap(target_dict):
        overlapped_intervals = []
        existed_start, existed_end = None, None

        for k, _ in target_dict.items():
            # k is a tuple, i.e. (start, end)
            existed_start, existed_end = k[0], k[1]
            # if the key's element type is BitVecRef, jump over
            if is_bv(existed_start):
                continue

            # found a overlap
            if is_overlapped(existed_start, existed_end, dest, length):
                overlapped_intervals.append(
                    [existed_start, existed_end])
        return overlapped_intervals

    # in data section
    tmp_result = iterate_find_overlap(data_section)
    assert len(
        tmp_result) <= 1, f"the data section can only have 0 or 1 overlapped interval"
    if tmp_result:
        existed_start, existed_end = tmp_result[0]
        return [[False, True, existed_start, existed_end]]

    # if it is not in data section, find it in the memory
    tmp_result = iterate_find_overlap(symbolic_memory)
    if tmp_result:  # found at least one overlapped interval
        return [[True, True] + i for i in tmp_result]
    else:  # found no overlapped interval in memory
        return [[True, False, None, None]]


def is_overlapped(existed_start, existed_end, dest, length):
    if dest + length <= existed_start:
        # case 1, 2
        return False

    if dest >= existed_end:
        # case 12, 13
        return False

    # remained cases
    return True
