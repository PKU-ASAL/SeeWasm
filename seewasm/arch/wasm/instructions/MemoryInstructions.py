# emulate the memory related instructions

import re

from seewasm.arch.wasm.exceptions import UnsupportInstructionError
from seewasm.arch.wasm.memory import (insert_symbolic_memory,
                                      lookup_symbolic_memory_data_section)
from seewasm.arch.wasm.utils import getConcreteBitVec
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
        elif self.instr_name == "memory.copy":
            # memory.copy
            # The instruction has the signature [i32 i32 i32] -> []. The parameters are, in order:
            # top-0: Number of bytes to copy
            # top-1: Source address to copy from
            # top-2: Destination address to copy to
            # example:
            #   ;; Copy data in default memory from [100, 125] to [50, 75]
            #   i32.const 50 ;; Destination address to copy to (top-2)
            #   i32.const 100 ;; Source address to copy from (top-1)
            #   i32.const 25 ;; Number of bytes to copy (top-0)
            #   memory.copy  ;; Copy memory
            len_v = state.symbolic_stack.pop().as_long()
            src_addr = state.symbolic_stack.pop().as_long()
            dest_addr = state.symbolic_stack.pop().as_long()
            # copy memory from src to dst
            vlis = [
                lookup_symbolic_memory_data_section(
                    state.symbolic_memory, data_section, src_addr + i, 1)
                for i in range(len_v)]
            for i, v in enumerate(vlis):
                state.symbolic_memory = insert_symbolic_memory(
                    state.symbolic_memory, dest_addr + i, 1, v)
            print(f"memory.copy: src_addr={src_addr}, dest_addr={dest_addr}, len={len_v}")
        elif self.instr_name == "memory.fill":
            # memory.fill
            # The instruction has the signature [i32 i32 i32] -> []. The parameters are, in order:
            # top-0: The number of bytes to update
            # top-1: The value to set each byte to (must be < 256)
            # top-2: The pointer to the region to update
            # example:
            #   ;; Fill region at offset/range in default memory with 255
            #   i32.const 200 ;; The pointer to the region to update (top-2)
            #   i32.const 255 ;; The value to set each byte to (must be < 256) (top-1)
            #   i32.const 100 ;; The number of bytes to update (top-0)
            #   memory.fill ;; Fill default memory
            len_v = state.symbolic_stack.pop().as_long()
            val = state.symbolic_stack.pop().as_long()
            addr = state.symbolic_stack.pop().as_long()
            print(f"memory.fill: addr={addr}, val={val}, len={len_v}")
        elif 'load' in self.instr_name:
            load_instr(self.instr_str, state, data_section)
        elif 'store' in self.instr_name:
            store_instr(self.instr_str, state)
        else:
            print('\nErr:\nUnsupported instruction: %s\n' % self.instr_name)
            raise UnsupportInstructionError

        return [state]


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
    bytes_length_mapping = {str(k): k // 8 for k in range(8, 65, 8)}
    instr_name = instr.split(' ')[0]
    if len(instr_name) == 8:
        load_length = bytes_length_mapping[instr_name[1:3]]
    else:
        load_length = bytes_length_mapping[re.search(
            r"load([0-9]+)\_", instr_name).group(1)]

    val = lookup_symbolic_memory_data_section(
        state.symbolic_memory, data_section, addr, load_length)

    if val.size() != 8 * load_length:
        # we assume the memory are filled by 0 initially
        val = ZeroExt(8 * load_length - val.size(), val)

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
            val = simplify(
                SignExt(int(instr_name[1: 3]) - load_length * 8, val))
        else:
            val = simplify(
                ZeroExt(int(instr_name[1: 3]) - load_length * 8, val))

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
    bytes_length_mapping = {str(k): k // 8 for k in range(8, 65, 8)}
    instr_name = instr.split(' ')[0]
    if len(instr_name) == 9:
        if instr_name[0] == 'f':
            val = fpToIEEEBV(val)
        state.symbolic_memory = insert_symbolic_memory(
            state.symbolic_memory, addr, bytes_length_mapping[instr_name[1:3]], val)
    else:
        stored_length = bytes_length_mapping[re.search(
            r"store([0-9]+)", instr_name).group(1)]
        val = simplify(Extract(stored_length * 8 - 1, 0, val))
        state.symbolic_memory = insert_symbolic_memory(
            state.symbolic_memory, addr, stored_length, val)
