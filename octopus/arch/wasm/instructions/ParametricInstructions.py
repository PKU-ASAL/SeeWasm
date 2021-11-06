import copy
from octopus.arch.wasm.exceptions import UnsupportInstructionError
from z3 import *


class ParametricInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    # TODO overflow check in this function?
    def emulate(self, state, depth, has_ret, call_depth):
        if self.instr_name == 'drop':
            state.symbolic_stack.pop()
            return False, None
        elif self.instr_name == 'select':  # select instruction
            arg0, arg1, arg2 = state.symbolic_stack.pop(
            ), state.symbolic_stack.pop(), state.symbolic_stack.pop()
            assert is_bv(arg0) or is_bool(
                arg0), f"in select, arg0 type is {type(arg0)} instead of bv or bool"
            if isinstance(arg0, BitVecNumRef):
                arg0 = arg0.as_long()
                state.symbolic_stack.append(arg1 if arg0 == 0 else arg2)
                return False, [state]
            else:
                state1 = copy.deepcopy(state)
                state1.constraints.append(simplify(arg0 != 0))
                state1.symbolic_stack.append(arg1)
                state1.constraints = list(set(state1.constraints))
                state2 = copy.deepcopy(state)
                state2.constraints.append(simplify(arg0 == 0))
                state2.symbolic_stack.append(arg2)
                state2.constraints = list(set(state2.constraints))
                return False, [state1, state2]
        else:
            raise Exception('Instruction:', self.instr_name,
                            'not match in emul_parametric function')
