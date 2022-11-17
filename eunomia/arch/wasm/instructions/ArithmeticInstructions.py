# emulate the arithmetic related instructions

import logging

from eunomia.arch.wasm.exceptions import UnsupportInstructionError
from z3 import (RNE, RTN, RTP, RTZ, BitVec, BitVecVal, Float32, Float64, SRem,
                UDiv, URem, fpAbs, fpAdd, fpDiv, fpMax, fpMin, fpMul, fpNeg,
                fpRoundToIntegral, fpSqrt, fpSub, is_bool, simplify)

helper_map = {
    'i32': 32,
    'i64': 64,
    'f32': [8, 24],
    'f64': [11, 53]
}

float_helper_map = {
    'f32': Float32,
    'f64': Float64
}


class ArithmeticInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    def emulate(self, state):
        def do_emulate_arithmetic_int_instruction(state):
            instr_type = self.instr_name[:3]

            if '.clz' in self.instr_name or '.ctz' in self.instr_name:
                # wasm documentation says:
                # This instruction is fully defined when all bits are zero;
                # it returns the number of bits in the operand type.
                state.symbolic_stack.pop()
                state.symbolic_stack.append(
                    BitVecVal(helper_map[instr_type], helper_map[instr_type]))
            elif '.popcnt' in self.instr_name:
                # wasm documentation says:
                # This instruction is fully defined when all bits are zero;
                # it returns 0.
                state.symbolic_stack.pop()
                state.symbolic_stack.append(
                    BitVecVal(0, helper_map[instr_type]))
            else:
                arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()

                # arg1 and arg2 could be BitVecRef, BitVecValRef and BoolRef
                if is_bool(arg1):
                    arg1 = BitVec(str(arg1), helper_map[instr_type])
                    logging.warning(
                        f"[!] In `ArithmeticInstructions.py`, arg1 is BoolRef, translated to BitVec which may lead to some information loss")
                if is_bool(arg2):
                    arg2 = BitVec(str(arg2), helper_map[instr_type])
                    logging.warning(
                        f"[!] In `ArithmeticInstructions.py`, arg2 is BoolRef, translated to BitVec which may lead to some information loss")

                assert arg1.size(
                ) == helper_map[instr_type], f"in arithmetic instruction, arg1 size is {arg1.size()} instead of {helper_map[instr_type]}"
                assert arg2.size(
                ) == helper_map[instr_type], f"in arithmetic instruction, arg2 size is {arg2.size()} instead of {helper_map[instr_type]}"

                if '.sub' in self.instr_name:
                    result = arg2 - arg1
                elif '.add' in self.instr_name:
                    result = arg2 + arg1
                elif '.mul' in self.instr_name:
                    result = arg2 * arg1
                elif '.div_s' in self.instr_name:
                    result = arg2 / arg1
                elif '.div_u' in self.instr_name:
                    result = UDiv(arg2, arg1)
                elif '.rem_s' in self.instr_name:
                    result = SRem(arg2, arg1)
                elif '.rem_u' in self.instr_name:
                    result = URem(arg2, arg1)
                else:
                    raise UnsupportInstructionError

                result = simplify(result)
                state.symbolic_stack.append(result)

            return [state]

        def do_emulate_arithmetic_float_instruction(state):
            # TODO need to be clarified
            # wasm default rounding rules
            rm = RNE()

            instr_type = self.instr_name[:3]

            two_arguments_instrs = ['add', 'sub',
                                    'mul', 'div', 'min', 'max', 'copysign']
            one_argument_instrs = ['sqrt', 'floor',
                                   'ceil', 'trunc', 'nearest', 'abs', 'neg']

            # add instr_type before each instr
            two_arguments_instrs = [str(instr_type + '.' + i)
                                    for i in two_arguments_instrs]
            one_argument_instrs = [str(instr_type + '.' + i)
                                   for i in one_argument_instrs]

            # pop two elements
            if self.instr_name in two_arguments_instrs:
                arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()

                assert arg1.ebits() == helper_map[instr_type][0] and arg1.sbits(
                ) == helper_map[instr_type][1], 'In do_emulate_arithmetic_float_instruction, arg1 type mismatch'
                assert arg2.ebits() == helper_map[instr_type][0] and arg2.sbits(
                ) == helper_map[instr_type][1], 'In do_emulate_arithmetic_float_instruction, arg2 type mismatch'

                if '.add' in self.instr_name:
                    result = fpAdd(rm, arg2, arg1)
                elif '.sub' in self.instr_name:
                    result = fpSub(rm, arg2, arg1)
                elif '.mul' in self.instr_name:
                    result = fpMul(rm, arg2, arg1)
                elif '.div' in self.instr_name:
                    result = fpDiv(rm, arg2, arg1)
                elif '.min' in self.instr_name:
                    result = fpMin(arg2, arg1)
                elif '.max' in self.instr_name:
                    result = fpMax(arg2, arg1)
                elif '.copysign' in self.instr_name == 'f32.copysign':
                    # extract arg2's sign to overwrite arg1's sign
                    if arg2.isPositive() ^ arg1.isPositive():
                        result = fpNeg(arg1)
            # pop one element
            elif self.instr_name in one_argument_instrs:
                arg1 = state.symbolic_stack.pop()

                assert arg1.ebits() == helper_map[instr_type][0] and arg1.sbits(
                ) == helper_map[instr_type][1], 'In do_emulate_arithmetic_float_instruction, arg1 type mismatch'

                if '.sqrt' in self.instr_name:
                    result = fpSqrt(rm, arg1)
                elif '.floor' in self.instr_name:
                    # round toward negative
                    result = fpRoundToIntegral(RTN(), arg1)
                elif '.ceil' in self.instr_name:
                    # round toward positive
                    result = fpRoundToIntegral(RTP(), arg1)
                elif '.trunc' in self.instr_name:
                    # round toward zero
                    result = fpRoundToIntegral(RTZ(), arg1)
                elif '.nearest' in self.instr_name:
                    # round to integeral ties to even
                    result = fpRoundToIntegral(RNE(), arg1)
                elif '.abs' in self.instr_name:
                    result = fpAbs(arg1)
                elif '.neg' in self.instr_name:
                    result = fpNeg(arg1)
            else:
                raise UnsupportInstructionError

            result = simplify(result)
            state.symbolic_stack.append(result)

            return [state]

        op_type = self.instr_name[:1]
        if op_type == 'i':
            return do_emulate_arithmetic_int_instruction(state)
        else:
            return do_emulate_arithmetic_float_instruction(state)
