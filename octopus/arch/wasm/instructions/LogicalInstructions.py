# emulate the logical related instructions

from .. exceptions import *
from z3 import *

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

                result = simplify(arg0 == 0)
                if is_bool(result):
                    if is_true(result):
                        result = BitVecVal(1, 32)
                    elif is_false(result):
                        result = BitVecVal(0, 32)
            else:
                arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()
                # [call 4] [tee_local 5] [i32.const 0] [i32.lt_s] [br_if]
                # if arg2.__str__() == 'db_find_i64_i32' and arg1.__str__() == '0':
                #     state.symbolic_stack.append(BitVecVal(0, 32))
                #     return False

                assert is_bv(arg1) and is_bv(
                    arg2), f"in `logical` instruction, arg1 or arg2 type is wrong instead of BitVec"

                if 'eq' in self.instr_name:
                    result = simplify(arg1 == arg2)
                elif 'ne' in self.instr_name:
                    result = simplify(arg1 != arg2)
                elif 'lt_s' in self.instr_name:
                    result = simplify(arg2 < arg1)
                elif 'lt_u' in self.instr_name:
                    result = simplify(ULT(arg2, arg1))
                elif 'gt_s' in self.instr_name:
                    result = simplify(arg2 > arg1)
                elif 'gt_u' in self.instr_name:
                    result = simplify(UGT(arg2, arg1))
                elif 'le_s' in self.instr_name:
                    result = simplify(arg2 <= arg1)
                elif 'le_u' in self.instr_name:
                    result = simplify(ULE(arg2, arg1))
                elif 'ge_s' in self.instr_name:
                    result = simplify(arg2 >= arg1)
                elif 'ge_u' in self.instr_name:
                    result = simplify(UGE(arg2, arg1))
                else:
                    raise UnsupportInstructionError

                if is_bool(result):
                    if is_true(result):
                        result = BitVecVal(1, 32)
                    elif is_false(result):
                        result = BitVecVal(0, 32)

            # check the result type
            if is_bv_value(result):
                state.symbolic_stack.append(result)
            else:
                logical_result = BitVec(
                    'logical_ans_(' + str(result) + ')', 32)
                state.constraints.append(logical_result == If(
                    result, BitVecVal(1, 32), BitVecVal(0, 32)))
                state.symbolic_stack.append(logical_result)

            return False

        def do_emulate_logical_float_instruction(state):
            arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()
            instr_type = self.instr_name[:3]

            assert arg1.ebits() == helper_map[instr_type][0] and arg1.sbits(
            ) == helper_map[instr_type][1], 'emul_logical_f_instr arg1 type mismatch'
            assert arg2.ebits() == helper_map[instr_type][0] and arg2.sbits(
            ) == helper_map[instr_type][0], 'emul_logical_f_instr arg2 type mismatch'

            if 'eq' in self.instr_name:
                result = simplify(fpEQ(arg1, arg2))
            elif 'ne' in self.instr_name:
                result = simplify(fpNEQ(arg1, arg2))
            elif 'lt' in self.instr_name:
                result = simplify(fpLT(arg2, arg1))
            elif 'le' in self.instr_name:
                result = simplify(fpLEQ(arg2, arg1))
            elif 'gt' in self.instr_name:
                result = simplify(fpGT(arg2, arg1))
            elif 'ge' in self.instr_name:
                result = simplify(fpGEQ(arg2, arg1))
            else:
                raise UnsupportInstructionError

            if is_bool(result):
                if is_true(result):
                    result = BitVecVal(1, 32)
                elif is_false(result):
                    result = BitVecVal(0, 32)

            # check the result type
            if is_bv_value(result):
                state.symbolic_stack.append(result)
            else:
                logical_result = BitVec(
                    'logical_ans_(' + str(result) + ')', 32)
                state.constraints.append(logical_result == If(
                    result, BitVecVal(1, 32), BitVecVal(0, 32)))
                state.symbolic_stack.append(logical_result)

            return False

        op_type = self.instr_name[:1]
        if op_type == 'i':
            do_emulate_logical_int_instruction(state)
        else:
            do_emulate_logical_float_instruction(state)
