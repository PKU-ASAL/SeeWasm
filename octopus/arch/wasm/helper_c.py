# this file is for the implementation of C library functions

import logging
from octopus.arch.wasm.helper import lookup_symbolic_memory, insert_symbolic_memory

def C_extract_string_by_start_pointer(start_pointer, mem_pointer, state):
    for k, v in state.symbolic_memory.items():
        if k[0] <= start_pointer <= k[1]:
            v_int = v.as_long()
            mem_data = v_int.to_bytes((v_int.bit_length() + 7) // 8, 'big')[start_pointer - k[0]:]
            break
    mem_data = mem_data[:mem_data.find(b'\x00')]
    mem_data = mem_data.decode("utf-8")

    if mem_pointer != 0:
        mem_data = lookup_symbolic_memory(state.symbolic_memory, mem_pointer, 4)
    
    return mem_data