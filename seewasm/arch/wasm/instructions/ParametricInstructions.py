from copy import deepcopy

from seewasm.arch.wasm.exceptions import UnsupportInstructionError
from seewasm.arch.wasm.utils import one_time_query_cache
from z3 import Not, is_bool, is_bv, is_false, is_true, simplify, unsat,If


class ParametricInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    def emulate(self, state):
        if self.instr_name == 'drop':
            state.symbolic_stack.pop()
            if state.type == 'concolic':
                state.concolic_stack.pop()
            return [state]
        elif self.instr_name == 'select' and state.type =='symbolic':  # select instruction
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
                if unsat == one_time_query_cache(state.solver, op):
                    no_need_true = True
                if unsat == one_time_query_cache(state.solver, Not(op)):
                    no_need_false = True

                if no_need_true and no_need_false:
                    pass
                elif not no_need_true and not no_need_false:
                    new_state = deepcopy(state)

                    state.solver.add(op)
                    state.symbolic_stack.append(arg1)

                    new_state.solver.add(Not(op))
                    new_state.symbolic_stack.append(arg2)

                    return [state, new_state]
                else:
                    if no_need_true:
                        state.solver.add(Not(op))
                        state.symbolic_stack.append(arg2)
                    else:
                        state.solver.add(op)
                        state.symbolic_stack.append(arg1)
                    return [state]
            else:
                exit(f"select instruction error. op is {op}")
        elif self.instr_name == 'select' and self.type =='concolic':  # select instruction
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
                exit(f"select instruction error. op is {op}")


            arg0, arg1, arg2 = state.concolic_stack.pop(
            ), state.concolic_stack.pop(), state.concolic_stack.pop()
            assert is_bv(arg0) or is_bool(
                arg0), f"in select, arg0 type is {type(arg0)} instead of bv or bool"
            # mimic the br_if
            if is_bv(arg0):
                # NOTE: if arg0 is zero, return arg1, or arg2
                # ref: https://developer.mozilla.org/en-US/docs/WebAssembly/Reference/Control_flow/Select
                op = simplify(arg0 == 0)

            if is_true(op):
                state.concolic_stack.append(arg1)
                return [state]
            elif is_false(op):
                state.concolic_stack.append(arg2)
                return [state]
            elif not is_true(op) and not is_false(op):
                # these two flags are used to jump over unnecessary deepcopy
                no_need_true, no_need_false = False, False
                if unsat == one_time_query_cache(state.solver, op):
                    no_need_true = True
                if unsat == one_time_query_cache(state.solver, Not(op)):
                    no_need_false = True

                if no_need_true and no_need_false:
                    pass
                elif not no_need_true and not no_need_false:

                    state.concolic_stack.append(If(op, arg1, arg2))

                    return [state]
                else:
                    if no_need_true:
                        state.solver.add(Not(op))
                        state.concolic_stack.append(arg2)
                    else:
                        state.solver.add(op)
                        state.concolic_stack.append(arg1)
                    return [state]
            else:
                exit(f"select instruction error. op is {op}")
        else:
            raise UnsupportInstructionError
