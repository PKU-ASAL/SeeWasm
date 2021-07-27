# emulate the memory related instructions

from .. exceptions import *
from z3 import *
from .. helper import *

def do_emulate_memory_instruction(instr, state, data_section):
    if instr.name == 'current_memory':
        state.symbolic_stack.append(BitVec('current_memory_size', 32))
    elif instr.name == 'grow_memory':
        pass
    elif 'load' in instr.name:
        load_instr(instr, state, data_section)
    elif 'store' in instr.name:
        store_instr(instr, state)
    else:
        raise UnsupportInstructionError

    return False