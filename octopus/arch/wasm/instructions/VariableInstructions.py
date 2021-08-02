# emulate the variable related instructions

from .. exceptions import *
from z3 import *

def do_emulate_variable_instruction(instr, state):
    op = int.from_bytes(instr.operand, byteorder='big')

    if instr.name == 'get_local':
        if state.local_var.get(op, None) != None:
            state.symbolic_stack.append(state.local_var[op])
        else:
            raise UninitializedLocalVariableError
    elif instr.name == 'set_local':
        var = state.symbolic_stack.pop()
        state.local_var[op] = var
    elif instr.name == 'get_global':
        global_index = op
        global_operand = state.globals[global_index]

        if isinstance(global_operand, str) or isinstance(global_operand, int):
            state.symbolic_stack.append(BitVecVal(global_operand, 32))
        elif is_bv(global_operand) or is_bv_value(global_operand):
            # the operand is a BitVecRef or BitVecNumRef
            state.symbolic_stack.append(global_operand)
        else:
            raise UnsupportGlobalTypeError
    elif instr.name is 'set_global':
        global_operand = state.symbolic_stack.pop()
        global_index = op

        state.globals[global_index] = global_operand
    elif instr.name == 'tee_local':
        var = state.symbolic_stack[-1]
        state.local_var[op] = var
    else:
        raise UnsupportInstructionError
    return False