# emulate the variable related instructions

from .. exceptions import *
from z3 import *

def do_emulate_variable_instruction(instr, state):
    op = int.from_bytes(instr.operand, byteorder='big')

    if instr.name == 'get_local':
        if state.local_var[op] is not None:
            state.symbolic_stack.append(state.local_var[op])
        else:
            raise UninitializedLocalVariableError
    elif instr.name == 'set_local':
        var = state.symbolic_stack.pop()

        # dynamic increase the length of array of local variables
        if op >= len(state.local_var):
            state.local_var += [None] * (op - len(state.local_var) + 1)
        # set the local variable
        state.local_var[op] = var
    elif instr.name == 'get_global':
        global_index = op
        global_type = state.globals[global_index][0]
        global_operand = state.globals[global_index][1]

        assert global_type == 'i32', 'the type of operand of get_global is not i32, please check'
        if isinstance(global_operand, str) or isinstance(global_operand, int):
            state.symbolic_stack.append(BitVecVal(global_operand, 32))
        elif global_operand.is_bv() or global_operand.is_bv_value():
            # the operand is a BitVecRef or BitVecNumRef
            state.symbolic_stack.append(global_operand)
        else:
            raise UnsupportGlobalTypeError
    elif instr.name is 'set_global':
        global_operand = state.symbolic_stack.pop()
        global_index = op
        global_type = state.globals[global_index][0]

        assert global_type == 'i32', 'the type of operand of set_global is not i32, please check'
        state.globals[global_index][1] = global_operand
    elif instr.name == 'tee_local':
        var = state.symbolic_stack[-1]
        state.local_var[op] = var
    else:
        raise UnsupportInstructionError
    return False