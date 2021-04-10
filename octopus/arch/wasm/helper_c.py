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

    if mem_pointer != 0:
        mem_data = lookup_symbolic_memory(symbolic_memory, data_section, mem_pointer, 4)
    
    return mem_data