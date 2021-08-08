# this file is for the implementation of C library functions

import logging
from octopus.arch.wasm.helper import lookup_symbolic_memory, insert_symbolic_memory

def C_extract_string_by_start_pointer(start_pointer, mem_pointer, data_section, symbolic_memory):
    for k, v in data_section.items():
        if k[0] <= start_pointer <= k[1]:
            mem_data = v
            break
    # slice
    mem_data = mem_data[start_pointer - k[0]:]

    mem_data = mem_data[:mem_data.find(b'\x00')]
    mem_data = mem_data.decode("utf-8")
    logging.warning("===============Print! In data section: %s=================", repr(mem_data))

    if mem_pointer != 0:
        mem_data = lookup_symbolic_memory(symbolic_memory, data_section, mem_pointer, 4)
    
    return mem_data

def C_extract_string_by_mem_pointer(mem_pointer, data_section, symbolic_memory):
    # TODO the string may not be 4 bytes in length
    # for example, the RorateArray, the scanf takes a string,
    # the strlen will measure the length of the string,
    # so we can not assume that the length would be 4
    mem_data = lookup_symbolic_memory(symbolic_memory, data_section, mem_pointer, 4)
    
    return mem_data