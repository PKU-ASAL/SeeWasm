# This file is the memory emulation
# Can refer the corresponding description in EOSAFE
# only export lookup_symbolic_memory_data_section and insert_symbolic_memory

import logging
from copy import deepcopy

from eunomia.arch.wasm.utils import (_extract_outermost_int,
                                     one_time_query_cache_without_solver)
from z3 import (And, BitVec, BitVecVal, Concat, Extract, If, is_bv,
                is_bv_value, sat, simplify)

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


def lookup_symbolic_memory_data_section(
        symbolic_memory, data_section, dest, length):
    """
    This funciton is used to determine if the dest existed in data section
    or symbolic memory, and retrieve it from corresponding area
    """
    # if dest is bitvecref:
    # 1. assume the loaded value is in memory instead of data section
    # 2. the returned value is packed by `ite` from z3
    if is_bv(dest) and not is_bv_value(dest):
        # we heuristically think the symbolic pointer will not point to the data_section
        return _lookup_symbolic_memory_with_symbol(
            symbolic_memory, dest, length,
            l_bound=max(data_section, key=lambda x: x[1])[1])

    # in data section?
    in_symbolic_memory, is_overlapped = _is_in_symbolic_memory(
        symbolic_memory, data_section, dest, length)

    # if there is no overlapped exiting interval
    if not is_overlapped:
        return BitVecVal(0, 8 * length)

    if not in_symbolic_memory:
        return _lookup_data_section(data_section, dest, length)
    else:
        return _lookup_symbolic_memory(symbolic_memory, dest, length)


def _lookup_symbolic_memory_with_symbol(
        symbolic_memory, dest, length, l_bound=2 << 31 - 1, h_bound=0):
    """
    return an `ite` value that enumerate all possible value of size length from memory

    Args:
        symbolic_memory (dict): symbolic memory
        dest (BitVecRef): from where the data would be loaded
        length (int): length of bytes that would be loaded
    """
    # Heuristic: if dest contains a number, construct ite from the interval, whose lower bound and higher bound can limit the number
    # For example, if the dest is: a+4, we need to find the interval like (a+2, a+8) instead of (a+6, a+10)
    chosen_num = _extract_outermost_int(dest)

    if chosen_num is not None:
        # look for the interval
        for k in symbolic_memory.keys():
            lower_bound, higher_bound = k[0], k[1]
            lower_bound_int, higher_bound_int = _extract_outermost_int(
                lower_bound), _extract_outermost_int(higher_bound)
            # if one of the bound_int is None, jump over it
            if lower_bound_int is None or higher_bound_int is None:
                continue
            if sat == one_time_query_cache_without_solver(lower_bound_int <= chosen_num) and sat == one_time_query_cache_without_solver(chosen_num < higher_bound_int):
                # slice the dict
                temp_symbolic_memory = {
                    (lower_bound, higher_bound): symbolic_memory[(lower_bound, higher_bound)]}
                # start to construct ite
                return _construct_ite(
                    temp_symbolic_memory, lower_bound, higher_bound, dest,
                    length, 0)

    # the heuristic does not work, because:
    #   1. the concrete number is not limited by any interval
    #   2. no concrete number at all
    # try all the possible situations

    def _big_construct_ite(symbolic_memory, dest, length):
        """
        Pop every item in symbolic memory to recursively construct all
        valid intervals through If and Extract
        """
        try:
            while True:
                k, v = symbolic_memory.popitem()
                l, h = k[0], k[1]
                if isinstance(l, int) and isinstance(h, int):
                    if length <= (h - l) and h < l_bound and l > h_bound:
                        break
                else:
                    if sat == one_time_query_cache_without_solver(
                            length <= (h - l)):
                        break

        except KeyError:
            # no key exists
            return BitVec("invalid-memory", length * 8)

        return If(And(k[0] <= dest, dest < k[1]),
                  _construct_ite({k: v},
                                 k[0],
                                 k[1],
                                 dest, length, 0),
                  _big_construct_ite(symbolic_memory, dest, length))

    # recursively construct ite statements
    dup_symbolic_memory = deepcopy(symbolic_memory)
    logging.info(f"Encounter a symbolic pointer: {dest}")
    tmp_result = _big_construct_ite(dup_symbolic_memory, dest, length)
    return tmp_result


def _construct_ite(
        symbolic_memory, lower_bound, higher_bound, dest, length, offset):
    """
    Recursively construct ite expression

    Args:
        symbolic_memory (dict): symbolic memory
        lower_bound (int): lower bound of interval
        higher_bound (int): higher bound of interval
        dest (BitVecRef): from where the data would be loaded
        length (int): length of bytes that would be loaded
        offset(int): the offset of how many bytes are shifted
    """
    # used for extract
    high = (length + offset) * 8 - 1
    low = (offset) * 8
    # print(f"offset: {offset}, length: {length}, high: {high}, low: {low}")

    if sat == one_time_query_cache_without_solver(
            (offset + length) == (higher_bound - lower_bound)):
        tmp_result = simplify(Extract(
            high, low, symbolic_memory[(lower_bound, higher_bound)]))
        # return _lookup_symbolic_memory(symbolic_memory, lower_bound, length)
    else:
        tmp_result = If(
            lower_bound + offset == dest,
            Extract(
                high, low, symbolic_memory[(lower_bound, higher_bound)]),
            _construct_ite(
                symbolic_memory, lower_bound,
                higher_bound, dest, length, offset + 1))
    return tmp_result


def _lookup_data_section(data_section, dest, length):
    """
    Retrieve data from data section according to dest and length
    """
    # retrieve the (existed_start, existed_end) from data section
    existed_overlapped_interval = _lookup_overlapped_interval(
        dict(), data_section, dest, length)
    assert len(
        existed_overlapped_interval) == 1, f"find more than 1 overlapped interval in _lookup_data_section"

    existed_start, existed_end = existed_overlapped_interval[0]
    overlapped_start, overlapped_end = _calc_overlap(
        existed_start, existed_end, dest, length)
    high, low = overlapped_end - existed_start, overlapped_start - existed_start

    # Original version:
    # data_section_bitvec = BitVecVal(
    #     int.from_bytes(data_section[(existed_start, existed_end)],
    #                    'little'),
    #     len(data_section[(existed_start, existed_end)]) * 8)
    # data = simplify(Extract(high * 8 - 1, low * 8, data_section_bitvec))
    # -------------------------
    # Updated version, just retrieve the necessary part:
    data_section_bytes = data_section[(existed_start, existed_end)][low:high]
    data_section_bitvec = BitVecVal(
        int.from_bytes(data_section_bytes, 'little'),
        len(data_section_bytes) * 8)
    data = simplify(Extract((high - low) * 8 - 1, 0, data_section_bitvec))

    return data


def _lookup_symbolic_memory(symbolic_memory, dest, length):
    """
    Retrieve data from symbolic memory according to dest and length
    """
    existed_overlapped_interval = _lookup_overlapped_interval(
        symbolic_memory, dict(), dest, length)
    assert len(
        existed_overlapped_interval) == 1, f"find more than 1 overlapped interval in _lookup_symbolic_memory"

    existed_start, existed_end = existed_overlapped_interval[0]
    overlapped_start, overlapped_end = _calc_overlap(
        existed_start, existed_end, dest, length)
    high, low = overlapped_end - existed_start, overlapped_start - existed_start

    data = simplify(Extract(high * 8 - 1, low * 8,
                    symbolic_memory[(existed_start, existed_end)]))
    return data


def insert_symbolic_memory(symbolic_memory, dest, length, data):
    # if dest type is a bit vector, insert directly
    if is_bv(dest) and not is_bv_value(dest):
        symbolic_memory[(dest, simplify(dest + length))] = data
    else:
        if is_bv_value(dest):
            dest = dest.as_long()

        is_in_symbolic_memory, is_overlapped = _is_in_symbolic_memory(
            symbolic_memory,
            dict(),
            dest,
            length)
        existed_overlapped_interval = _lookup_overlapped_interval(
            symbolic_memory,
            dict(),
            dest, length)

        assert len(
            existed_overlapped_interval) <= 2, f"find more than 2 overlapped interval in insert_symbolic_memory"
        if len(existed_overlapped_interval) == 2:
            # two overlapped intervals exist, [[existed_start_1, existed_end_1], [existed_start_2, existed_end_2]]
            # sort by interval's start address
            existed_overlapped_interval.sort(key=lambda x: x[0])
            existed_start_1, existed_end_1 = existed_overlapped_interval[0]
            existed_start_2, existed_end_2 = existed_overlapped_interval[1]
            # padding 0 between existed_end_1 and existed_start_2
            first_interval = symbolic_memory.pop(
                (existed_start_1, existed_end_1))
            second_interval = symbolic_memory.pop(
                (existed_start_2, existed_end_2))
            # NOTE here the order of intervals cannot be exchanged
            padded_interval = simplify(Concat(
                second_interval,
                BitVecVal(0, (existed_start_2 - existed_end_1) * 8),
                first_interval))
            symbolic_memory[(existed_start_1, existed_end_2)] = padded_interval
            # fetch new existed_start and existed_end
            existed_start, existed_end = existed_start_1, existed_end_2
        else:
            existed_start, existed_end = existed_overlapped_interval[
                0][0], existed_overlapped_interval[0][1]

        # step 1:
        # mark the updated part
        used_sub_intervals = []
        if is_overlapped:
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
        used_sub_intervals.append([dest - 1, dest])
        used_sub_intervals.append([dest + length, dest + length + 1])
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


def _is_in_symbolic_memory(symbolic_memory, data_section, dest, length):
    """
    Determine if dest is in symbolic memory, and if it is overlapped with any interval

    The return value has two flags:
    1. the (dest, dest+length) is in symbolic memory
    2. the (dest, dest+length) is overlapped with any interval
    """
    # if the (dest, dest+length) in the symbolic memory
    tmp_result = _iterate_find_overlap(symbolic_memory, dest, length)
    if tmp_result:  # found at least one overlapped interval
        return [True, True]

    # if (dest, dest+length) is not in symbolic memory, find it in data section
    tmp_result = _iterate_find_overlap(data_section, dest, length)
    if tmp_result:
        return [False, True]

    # the (dest, dest + length) is neither in symbolic memory nor in data section
    return [False, False]


def _iterate_find_overlap(target_dict, dest, length):
    """
    Iterate the given symbolic memory OR data section, and find
    if the (dest, dest+length) overlap on any intervals.
    If so, return these intervals as [[existed_start, existed_end], ...]
    """
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


def _lookup_overlapped_interval(symbolic_memory, data_section, dest, length):
    '''
    Given the (dest, dest+length), find the overlapped intervals (either in symbolic memory, or
    in the data section).
    Return it as [[existed_start_1, existed_end_1], ...].
    '''
    # if the (dest, dest+length) in the symbolic memory
    tmp_result = _iterate_find_overlap(symbolic_memory, dest, length)
    assert len(
        tmp_result) <= 2, f"the symbolic memory can only have 0 to 2 overlapped interval, but we found {len(tmp_result)} ({tmp_result})"
    if tmp_result:  # found at least one overlapped interval
        return tmp_result

    # if (dest, dest+length) is not in symbolic memory, find it in data section
    tmp_result = _iterate_find_overlap(data_section, dest, length)
    assert len(
        tmp_result) <= 2, f"the data section can only have 0 to 2 overlapped interval, but we found {len(tmp_result)} ({tmp_result})"
    if tmp_result:
        return tmp_result

    # the (dest, dest + length) is neither in symbolic memory nor in data section
    return [[None, None]]


def _is_overlapped(existed_start, existed_end, dest, length):
    if dest + length <= existed_start:
        # case 1, 2
        return False

    if dest >= existed_end:
        # case 12, 13
        return False

    # remained cases
    return True
