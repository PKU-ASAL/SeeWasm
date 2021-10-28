# This file is related to the implementation of some C library functions

import logging
import re
from z3 import *

from octopus.arch.wasm.memory import lookup_symbolic_memory


def C_extract_string_by_start_pointer(start_pointer, mem_pointer, data_section, symbolic_memory):
    for k, v in data_section.items():
        if k[0] <= start_pointer <= k[1]:
            mem_data = v
            break
    # slice
    mem_data = mem_data[start_pointer - k[0]:]

    mem_data = mem_data[:mem_data.find(b'\x00')]
    mem_data = mem_data.decode("utf-8")
    logging.warning(
        "===============Print! In data section: %s=================", repr(mem_data))

    if is_bv(mem_pointer) or mem_pointer != 0:
        loaded_data = lookup_symbolic_memory(
            symbolic_memory, data_section, mem_pointer, 4)
        pattern = mem_data
        return pattern, loaded_data
    else:
        return "string_literal", mem_data


def C_extract_string_by_mem_pointer(mem_pointer, data_section, symbolic_memory):
    # TODO the string may not be 4 bytes in length
    # for example, the RorateArray, the scanf takes a string,
    # the strlen will measure the length of the string,
    # so we can not assume that the length would be 4
    i = 1
    previous_string = ""
    while True:
        mem_data = lookup_symbolic_memory(
            symbolic_memory, data_section, mem_pointer, i)

        mem_data = mem_data.as_long()
        mem_data_string = mem_data.to_bytes(
            (mem_data.bit_length() + 7) // 8, 'little').decode("utf-8")
        # as the b"\x00" cannot be loaded from the memory
        # thus we have to compare the current string with the previous round's
        if mem_data_string == previous_string:
            break

        i += 1
        previous_string = mem_data_string

    return mem_data_string


def parse_printf_formatting(lines):
    cfmt = '''\
(                                  # start of capture group 1
%                                  # literal "%"
(?:                                # first option
(?:[-+0 #]{0,5})                   # optional flags
(?:\d+|\*)?                        # width
(?:\.(?:\d+|\*))?                  # precision
(?:h|l|ll|w|I|I32|I64)?            # size
[cCdiouxXeEfgGaAnpsSZ]             # type
) |                                # OR
%%)                                # literal "%%"
'''

    # tuple list, in which each element consisting of line number, begin position and pattern
    result = []
    for line_num, line in enumerate(lines.splitlines()):
        for m in re.finditer(cfmt, line, flags=re.X):
            result.append([line_num, m.start(1), m.group(1)])
    return result
