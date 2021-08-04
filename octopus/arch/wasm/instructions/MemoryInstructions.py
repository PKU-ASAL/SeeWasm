# emulate the memory related instructions

from .. exceptions import *
from z3 import *
from .. helper import *


class MemoryInstructions:
    def __init__(self, instr_name, instr_operand, instr_string):
        self.instr_name = instr_name
        self.instr_operand = instr_operand
        self.instr_str = instr_string

    # TODO overflow check in this function?
    def emulate(self, state, data_section):
        if self.instr_name == 'current_memory':
            state.symbolic_stack.append(BitVec('current_memory_size', 32))
        elif self.instr_name == 'grow_memory':
            pass
        elif 'load' in self.instr_name:
            load_instr(self.instr_str, state, data_section)
        elif 'store' in self.instr_name:
            store_instr(self.instr_str, state)
        else:
            raise UnsupportInstructionError

        return False