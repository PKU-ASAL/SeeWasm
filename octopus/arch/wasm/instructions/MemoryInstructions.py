# emulate the memory related instructions

from .. exceptions import *
from z3 import *
from .. memory import load_instr, store_instr


class MemoryInstructions:
    def __init__(self, instr_name, instr_operand, instr_string):
        self.instr_name = instr_name
        self.instr_operand = instr_operand
        self.instr_str = instr_string
        self.mem_cnt = 2
        self.mem_step = 2

    # TODO overflow check in this function?
    def emulate(self, state, data_section):
        if self.instr_name == 'current_memory':
            state.symbolic_stack.append(BitVecVal(self.mem_cnt, 32))
        elif self.instr_name == 'grow_memory':
            self.mem_cnt += self.mem_step
            state.symbolic_stack.append(BitVecVal(1, 32))
        elif 'load' in self.instr_name:
            load_instr(self.instr_str, state, data_section)
        elif 'store' in self.instr_name:
            store_instr(self.instr_str, state)
        else:
            raise UnsupportInstructionError

        return False
