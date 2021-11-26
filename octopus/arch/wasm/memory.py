# This file is the memory emulation
# Can refer the corresponding description in EOSAFE
# only export lookup_symbolic_memory_data_section and insert_symbolic_memory

from z3 import *


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


def lookup_symbolic_memory_data_section(symbolic_memory, data_section, dest, length):
    """
    This funciton is used to determine if the dest existed in data section
    or symbolic memory, and retrieve it from corresponding area
    """
    # if dest is bitvecref:
    # 1. assume the loaded value is in memory instead of data section
    # 2. the returned value is packed by `ite` from z3
    if is_bv(dest) and not is_bv_value(dest):
        return _lookup_symbolic_memory_with_symbol(symbolic_memory, dest, length)

    # in data section?
    in_symbolic_memory, is_overlapped, _, _ = _lookup_overlapped_interval(
        symbolic_memory, data_section, dest, length)[0]

    # if there is no overlapped exiting interval
    if not is_overlapped:
        return BitVecVal(0, 8*length)

    if not in_symbolic_memory:
        return _lookup_data_section(data_section, dest, length)
    else:
        return _lookup_symbolic_memory(symbolic_memory, dest, length)


def _lookup_symbolic_memory_with_symbol(symbolic_memory, dest, length):
    """
    return an `ite` value that enumerate all possible value from memory

    Args:
        symbolic_memory (dict): symbolic memory
        dest (BitVecRef): from where the data would be loaded
        length (int): length of bytes that would be loaded
    """
    # Heuristic: if dest contains a number, just enumerate that interval
    for i in range(dest.num_args()):
        if is_bv_value(dest.arg(i)):
            chosen_num = dest.arg(i).as_long()
            break

    # look for the interval
    for k in symbolic_memory.keys():
        lower_bound, higher_bound = k[0], k[1]
        if lower_bound <= chosen_num < higher_bound:
            # start to construct ite
            return _construct_ite(symbolic_memory, lower_bound, higher_bound, dest, length)

    print('here')
    exit()


def _construct_ite(symbolic_memory, lower_bound, higher_bound, dest, length):
    """
    Recursively construct ite expression

    Args:
        symbolic_memory (dict): symbolic memory
        lower_bound (int): lower bound of interval
        higher_bound (int): higher bound of interval
        dest (BitVecRef): from where the data would be loaded
        length (int): length of bytes that would be loaded
    """
    if lower_bound + length > higher_bound:
        return BitVec('no_such_memory', 8*length)
    return If(dest == lower_bound, _lookup_symbolic_memory(symbolic_memory, lower_bound, length), _construct_ite(symbolic_memory, lower_bound+length, higher_bound, dest, length))


def _lookup_data_section(data_section, dest, length):
    """
    Retrieve data from data section according to dest and length
    """
    # calculate the existing interval that overlapped
    # with the dest from data section
    _, _, existed_start, existed_end = _lookup_overlapped_interval(
        dict(), data_section, dest, length)[0]
    overlapped_start, overlapped_end = _calc_overlap(
        existed_start, existed_end, dest, length)
    high, low = overlapped_end - existed_start, overlapped_start - existed_start

    data_section_bitvec = BitVecVal(int.from_bytes(data_section[(
        existed_start, existed_end)], 'little'), len(data_section[(existed_start, existed_end)])*8)
    data = simplify(Extract(high * 8 - 1, low * 8, data_section_bitvec))
    return data


def _lookup_symbolic_memory(symbolic_memory, dest, length):
    """
    Retrieve data from symbolic memory according to dest and length
    """
    _, _, existed_start, existed_end = _lookup_overlapped_interval(
        symbolic_memory, dict(), dest, length)[0]
    overlapped_start, overlapped_end = _calc_overlap(
        existed_start, existed_end, dest, length)
    high, low = overlapped_end - existed_start, overlapped_start - existed_start

    data = simplify(Extract(high * 8 - 1, low * 8,
                    symbolic_memory[(existed_start, existed_end)]))
    return data


def insert_symbolic_memory(symbolic_memory, dest, length, data):
    # if dest type is `BitVecRef`, insert directly
    if type(dest) == BitVecRef:
        symbolic_memory[(dest, simplify(dest + length))] = data
    # if dest type is `int`
    else:
        # the existed_start and existed_end are all int
        tmp_result = _lookup_overlapped_interval(
            symbolic_memory, dict(), dest, length)

        # step 1:
        # mark the updated part
        used_sub_intervals = []
        for item in tmp_result:
            _, is_overlapped, existed_start, existed_end = item
            if not is_overlapped:
                continue

            to_concat = []
            overlapped_start, overlapped_end = _calc_overlap(
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
    return _merge_symbolic_memory(symbolic_memory)


def _merge_symbolic_memory(symbolic_memory):
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
            int_keys.insert(i, (current_key[0], next_key[1]))
            continue
        else:
            i += 1

    return symbolic_memory_dup


def _calc_overlap(existed_start, existed_end, dest, length):
    if dest <= existed_start:
        overlapped_start = existed_start
    else:
        overlapped_start = dest

    if dest + length <= existed_end:
        overlapped_end = dest + length
    else:
        overlapped_end = existed_end
    return overlapped_start, overlapped_end


def _lookup_overlapped_interval(symbolic_memory, data_section, dest, length):
    '''
    return four elements:
    1. whether it is in the symbolic memory
    2. is it overlapped with existed interval
    3&4. the start and end indexes of the overlapped interval
    '''
    # iterate to find
    def _iterate_find_overlap(target_dict):
        overlapped_intervals = []
        existed_start, existed_end = None, None

        for k, _ in target_dict.items():
            # k is a tuple, i.e. (start, end)
            existed_start, existed_end = k[0], k[1]
            # if the key's element type is BitVecRef, jump over
            if is_bv(existed_start):
                continue

            # found a overlap
            if _is_overlapped(existed_start, existed_end, dest, length):
                overlapped_intervals.append(
                    [existed_start, existed_end])
        return overlapped_intervals

    # in data section
    tmp_result = _iterate_find_overlap(data_section)
    assert len(
        tmp_result) <= 1, f"the data section can only have 0 or 1 overlapped interval"
    if tmp_result:
        existed_start, existed_end = tmp_result[0]
        return [[False, True, existed_start, existed_end]]

    # if it is not in data section, find it in the memory
    tmp_result = _iterate_find_overlap(symbolic_memory)
    if tmp_result:  # found at least one overlapped interval
        return [[True, True] + i for i in tmp_result]
    else:  # found no overlapped interval in memory
        return [[True, False, None, None]]


def _is_overlapped(existed_start, existed_end, dest, length):
    if dest + length <= existed_start:
        # case 1, 2
        return False

    if dest >= existed_end:
        # case 12, 13
        return False

    # remained cases
    return True
