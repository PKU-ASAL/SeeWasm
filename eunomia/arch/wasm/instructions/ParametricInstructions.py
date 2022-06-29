import copy

from eunomia.arch.wasm.exceptions import UnsupportInstructionError
from z3 import BitVecNumRef, is_bool, is_bv, simplify


class ParametricInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    def emulate(self, state):
        if self.instr_name == 'drop':
            state.symbolic_stack.pop()
            return [state]
        elif self.instr_name == 'select':  # select instruction
            arg0, arg1, arg2 = state.symbolic_stack.pop(
            ), state.symbolic_stack.pop(), state.symbolic_stack.pop()
            assert is_bv(arg0) or is_bool(
                arg0), f"in select, arg0 type is {type(arg0)} instead of bv or bool"
            if isinstance(arg0, BitVecNumRef):
                arg0 = arg0.as_long()
                state.symbolic_stack.append(arg1 if arg0 == 0 else arg2)
                return [state]
            else:
                new_state = copy.deepcopy(state)
                new_state.constraints.append(simplify(arg0 != 0))
                new_state.symbolic_stack.append(arg1)

                state.constraints.append(simplify(arg0 == 0))
                state.symbolic_stack.append(arg2)
                return [state, new_state]
        else:
            raise UnsupportInstructionError
