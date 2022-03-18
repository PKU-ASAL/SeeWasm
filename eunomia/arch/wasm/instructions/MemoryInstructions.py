# emulate the memory related instructions

import re

from eunomia.arch.wasm.exceptions import UnsupportInstructionError
from eunomia.arch.wasm.memory import (insert_symbolic_memory,
                                      lookup_symbolic_memory_data_section)
from eunomia.arch.wasm.utils import getConcreteBitVec
from z3 import (BitVecVal, Extract, Float32, Float64, SignExt, ZeroExt,
                fpBVToFP, fpToIEEEBV, is_bv_value, simplify)

memory_count = 2
memory_step = 2


class MemoryInstructions:
    def __init__(self, instr_name, instr_operand, instr_string):
        self.instr_name = instr_name
        self.instr_operand = instr_operand
        self.instr_str = instr_string

    def emulate(self, state, data_section):
        global memory_count, memory_step
        if self.instr_name == 'current_memory':
            state.symbolic_stack.append(BitVecVal(memory_count, 32))
        elif self.instr_name == 'grow_memory':
            prev_size = memory_count
            memory_count += memory_step
            state.symbolic_stack.append(BitVecVal(prev_size, 32))
        elif 'load' in self.instr_name:
            load_instr(self.instr_str, state, data_section)
        elif 'store' in self.instr_name:
            store_instr(self.instr_str, state)
        else:
            raise UnsupportInstructionError

        return False


def load_instr(instr, state, data_section):
    base = state.symbolic_stack.pop()
    # offset maybe int or hex
    try:
        offset = int(instr.split(' ')[2])
    except ValueError:
        offset = int(instr.split(' ')[2], 16)
    addr = simplify(base + offset)

    if is_bv_value(addr):
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

    val = lookup_symbolic_memory_data_section(
        state.symbolic_memory, data_section, addr, load_length)

    if val.size() != 8*load_length:
        # we assume the memory are filled by 0 initially
        val = ZeroExt(8*load_length-val.size(), val)

    if val is None:
        exit(f"the loaded value should not be None")
        # val = BitVec(f'load{load_length}*({addr})', 8*load_length)

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
