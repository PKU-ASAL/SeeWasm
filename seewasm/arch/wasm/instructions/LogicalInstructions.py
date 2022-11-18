# emulate the logical related instructions

from seewasm.arch.wasm.exceptions import UnsupportInstructionError
from z3 import (UGE, UGT, ULE, ULT, BitVecVal, If, fpEQ, fpGEQ, fpGT, fpLEQ,
                fpLT, fpNEQ, is_bv, is_false, is_true, simplify)

helper_map = {
    'i32': 32,
    'i64': 64,
    'f32': [8, 24],
    'f64': [11, 53]
}


class LogicalInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    # TODO overflow check in this function?
    def emulate(self, state):
        def do_emulate_logical_int_instruction(state):
            instr_type = self.instr_name[:3]
            if 'eqz' in self.instr_name:
                arg0 = state.symbolic_stack.pop()

                assert arg0.size(
                ) == helper_map[instr_type], f"in `eqz` the argument popped size is {arg0.size()} instead of {helper_map[instr_type]}"

                result = arg0 == 0
            else:
                arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()

                assert is_bv(arg1) and is_bv(
                    arg2), f"in `logical` instruction, arg1 or arg2 type is wrong instead of BitVec"

                if 'eq' in self.instr_name:
                    result = arg1 == arg2
                elif 'ne' in self.instr_name:
                    result = arg1 != arg2
                elif 'lt_s' in self.instr_name:
                    result = arg2 < arg1
                elif 'lt_u' in self.instr_name:
                    result = ULT(arg2, arg1)
                elif 'gt_s' in self.instr_name:
                    result = arg2 > arg1
                elif 'gt_u' in self.instr_name:
                    result = UGT(arg2, arg1)
                elif 'le_s' in self.instr_name:
                    result = arg2 <= arg1
                elif 'le_u' in self.instr_name:
                    result = ULE(arg2, arg1)
                elif 'ge_s' in self.instr_name:
                    result = arg2 >= arg1
                elif 'ge_u' in self.instr_name:
                    result = UGE(arg2, arg1)
                else:
                    raise UnsupportInstructionError

            # try to simplify result and insert 1 or 0 directly, instead of an ite statement
            result = simplify(result)
            if is_true(result):
                state.symbolic_stack.append(BitVecVal(1, 32))
            elif is_false(result):
                state.symbolic_stack.append(BitVecVal(0, 32))
            else:
                state.symbolic_stack.append(
                    If(result, BitVecVal(1, 32), BitVecVal(0, 32)))

            return [state]

        def do_emulate_logical_float_instruction(state):
            arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()
            instr_type = self.instr_name[:3]

            assert arg1.ebits() == helper_map[instr_type][0] and arg1.sbits(
            ) == helper_map[instr_type][1], 'emul_logical_f_instr arg1 type mismatch'
            assert arg2.ebits() == helper_map[instr_type][0] and arg2.sbits(
            ) == helper_map[instr_type][1], 'emul_logical_f_instr arg2 type mismatch'

            if 'eq' in self.instr_name:
                result = fpEQ(arg1, arg2)
            elif 'ne' in self.instr_name:
                result = fpNEQ(arg1, arg2)
            elif 'lt' in self.instr_name:
                result = fpLT(arg2, arg1)
            elif 'le' in self.instr_name:
                result = fpLEQ(arg2, arg1)
            elif 'gt' in self.instr_name:
                result = fpGT(arg2, arg1)
            elif 'ge' in self.instr_name:
                result = fpGEQ(arg2, arg1)
            else:
                raise UnsupportInstructionError

            # try to simplify result and insert 1 or 0 directly, instead of an ite statement
            result = simplify(result)
            if is_true(result):
                state.symbolic_stack.append(BitVecVal(1, 32))
            elif is_false(result):
                state.symbolic_stack.append(BitVecVal(0, 32))
            else:
                state.symbolic_stack.append(
                    If(result, BitVecVal(1, 32), BitVecVal(0, 32)))

            return [state]

        op_type = self.instr_name[:1]
        if op_type == 'i':
            return do_emulate_logical_int_instruction(state)
        else:
            return do_emulate_logical_float_instruction(state)
