# emulate the arithmetic related instructions

from octopus.arch.wasm.modules.DivZeroLaser import DivZeroLaser
from .. exceptions import *
from octopus.arch.wasm.utils import Enable_Lasers, Configuration
from octopus.arch.wasm.modules.OverflowLaser import OverflowLaser
from octopus.arch.wasm.dawrf_parser import get_func_index_from_state, get_source_location
from octopus.arch.wasm.utils import bcolors

from z3 import *
import logging

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

    def emulate(self, state, analyzer):
        overflow_check_flag = False
        overflow_laser = None
        if Configuration.get_lasers() & Enable_Lasers.OVERFLOW.value:
            overflow_check_flag = True
            overflow_laser = OverflowLaser()

        div_zero_flag = False
        div_zero_laser = None
        if Configuration.get_lasers() & Enable_Lasers.DIVZERO.value:
            div_zero_flag = True
            div_zero_laser = DivZeroLaser()

        flags = [overflow_check_flag, div_zero_flag]
        laser_objs = [overflow_laser, div_zero_laser]

        def do_emulate_arithmetic_int_instruction(state, flags, laser_objs, analyzer):
            instr_type = self.instr_name[:3]

            if '.clz' in self.instr_name or '.ctz' in self.instr_name:
                # wasm documentation says:
                # This instruction is fully defined when all bits are zero; it returns the number of bits in the operand type.
                state.symbolic_stack.pop()
                state.symbolic_stack.append(
                    BitVecVal(helper_map[instr_type], helper_map[instr_type]))
            elif '.popcnt' in self.instr_name:
                # wasm documentation says:
                # This instruction is fully defined when all bits are zero; it returns 0.
                state.symbolic_stack.pop()
                state.symbolic_stack.append(
                    BitVecVal(0, helper_map[instr_type]))
            else:
                arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()

                # arg1 and arg2 could be BitVecRef, BitVecValRef and BoolRef
                if is_bool(arg1):
                    arg1 = BitVec(str(arg1), helper_map[instr_type])
                    logging.warning(
                        "[!] In `ArithmeticInstructions.py`, arg1 is BoolRef, translated to BitVec which may lead to some information loss")
                if is_bool(arg2):
                    arg2 = BitVec(str(arg2), helper_map[instr_type])
                    logging.warning(
                        "[!] In `ArithmeticInstructions.py`, arg2 is BoolRef, translated to BitVec which may lead to some information loss")

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

                overflow_check_flag, div_zero_flag = flags[0], flags[1]
                overflow_laser, div_zero_laser = laser_objs[0], laser_objs[1]
                if overflow_check_flag:
                    overflowed = overflow_laser.fire(
                        result, state.constraints, state.sign_mapping)
                    if overflowed:
                        func_ind = get_func_index_from_state(analyzer, state)
                        func_offset = state.instr.offset
                        original_file, line_no, col_no = get_source_location(
                            analyzer, func_ind, func_offset)
                        logging.warning(
                            f'{bcolors.WARNING}Overflowed! In file {original_file}, line no: {line_no}, col no: {col_no}{bcolors.ENDC}')
                if div_zero_flag:
                    divzeroed = div_zero_laser.fire(result, state.constraints)
                    if divzeroed:
                        func_ind = get_func_index_from_state(analyzer, state)
                        func_offset = state.instr.offset
                        original_file, line_no, col_no = get_source_location(
                            analyzer, func_ind, func_offset)
                        logging.warning(
                            f'{bcolors.WARNING}Div-zero! In file {original_file}, line no: {line_no}, col no: {col_no}{bcolors.ENDC}')
                result = simplify(result)
                state.symbolic_stack.append(result)

            return False

        def do_emulate_arithmetic_float_instruction(state, flags, laser_objs):
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

            overflow_check_flag, div_zero_flag = flags[0], flags[1]
            overflow_laser, div_zero_laser = laser_objs[0], laser_objs[1]
            if overflow_check_flag:
                overflow_laser.fire(result, state.constraints)
            if div_zero_flag:
                div_zero_laser.fire(result, state.constraints)

            result = simplify(result)
            state.symbolic_stack.append(result)

            return False

        op_type = self.instr_name[:1]
        if op_type == 'i':
            do_emulate_arithmetic_int_instruction(
                state, flags, laser_objs, analyzer)
        else:
            do_emulate_arithmetic_float_instruction(state, flags, laser_objs)
