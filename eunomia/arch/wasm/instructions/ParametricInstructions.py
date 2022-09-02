from copy import deepcopy

from eunomia.arch.wasm.exceptions import UnsupportInstructionError
from eunomia.arch.wasm.utils import cached_sat_or_unsat
from z3 import Not, is_bool, is_bv, is_false, is_true, simplify, unsat


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
            # mimic the br_if
            if is_bv(arg0):
                # NOTE: if arg0 is zero, return arg1, or arg2
                # ref: https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Control_flow/Select
                op = simplify(arg0 == 0)

            if is_true(op):
                state.symbolic_stack.append(arg1)
                return [state]
            elif is_false(op):
                state.symbolic_stack.append(arg2)
                return [state]
            elif not is_true(op) and not is_false(op):
                # these two flags are used to jump over unnecessary deepcopy
                no_need_true, no_need_false = False, False
                if unsat == cached_sat_or_unsat(state.constraints + [op]):
                    no_need_true = True
                if unsat == cached_sat_or_unsat(state.constraints + [Not(op)]):
                    no_need_false = True

                if no_need_true and no_need_false:
                    pass
                elif not no_need_true and not no_need_false:
                    new_state = deepcopy(state)

                    state.constraints.append(op)
                    state.symbolic_stack.append(arg1)

                    new_state.constraints.append(Not(op))
                    new_state.symbolic_stack.append(arg2)

                    return [state, new_state]
                else:
                    if no_need_true:
                        state.constraints.append(Not(op))
                        state.symbolic_stack.append(arg2)
                    else:
                        state.constraints.append(op)
                        state.symbolic_stack.append(arg1)
                    return [state]
            else:
                exit(f"select instruction error. op is {op}")
        else:
            raise UnsupportInstructionError
