# emulate the variable related instructions

from .. exceptions import *
from z3 import *


class VariableInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    def emulate(self, state):
        # TODO
        # for go_samples.nosync/tinygo_main.wasm, the global.get operand would be prefixed by four \x80
        if self.instr_operand.startswith(b'\x80\x80\x80\x80'):
            self.instr_operand = self.instr_operand[4:]
        op = int.from_bytes(self.instr_operand, byteorder='big')

        if self.instr_name == 'get_local':
            if state.local_var.get(op, None) != None:
                state.symbolic_stack.append(state.local_var[op])
            else:
                state.symbolic_stack.append(state.local_var[op])
                # raise UninitializedLocalVariableError
        elif self.instr_name == 'set_local':
            var = state.symbolic_stack.pop()
            state.local_var[op] = var
        elif self.instr_name == 'get_global':
            global_index = op
            global_operand = state.globals[global_index]

            if isinstance(global_operand, str) or isinstance(global_operand, int):
                state.symbolic_stack.append(BitVecVal(global_operand, 32))
            elif is_bv(global_operand) or is_bv_value(global_operand):
                # the operand is a BitVecRef or BitVecNumRef
                state.symbolic_stack.append(global_operand)
            else:
                raise UnsupportGlobalTypeError
        elif self.instr_name is 'set_global':
            global_operand = state.symbolic_stack.pop()
            global_index = op

            state.globals[global_index] = global_operand
        elif self.instr_name == 'tee_local':
            var = state.symbolic_stack[-1]
            state.local_var[op] = var
        else:
            raise UnsupportInstructionError
        return False
