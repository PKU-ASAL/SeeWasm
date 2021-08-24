# emulate the arithmetic related instructions

from octopus.arch.wasm.modules.DivZeroLaser import DivZeroLaser
from .. exceptions import *
from octopus.arch.wasm.utils import Enable_Lasers
from octopus.arch.wasm.modules.OverflowLaser import OverflowLaser

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

    def emulate(self, state):
        overflow_check_flag = False
        overflow_laser = None
        if state.lasers & Enable_Lasers.OVERFLOW.value:
            overflow_check_flag = True
            overflow_laser = OverflowLaser()

        div_zero_flag = False
        div_zero_laser = None
        if state.lasers & Enable_Lasers.DIVZERO.value:
            div_zero_flag = True
            div_zero_laser = DivZeroLaser()

        flags = [overflow_check_flag, div_zero_flag]
        laser_objs = [overflow_laser, div_zero_laser]

        def do_emulate_arithmetic_int_instruction(state, flags, laser_objs):
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
                    overflow_laser.fire(result, state.constraints)
                if div_zero_flag:
                    div_zero_laser.fire(result, state.constraints)
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
                    rm = RTN()
                    result = fpFPToFP(rm, arg1, float_helper_map[instr_type]())
                elif '.ceil' in self.instr_name:
                    # round toward positive
                    rm = RTP()
                    result = fpFPToFP(rm, arg1, float_helper_map[instr_type]())
                elif '.trunc' in self.instr_name:
                    # round toward zero
                    rm = RTZ()
                    result = fpFPToFP(rm, arg1, float_helper_map[instr_type]())
                elif '.nearest' in self.instr_name:
                    # round to integeral ties to even
                    rm = RNE()
                    result = fpFPToFP(rm, arg1, float_helper_map[instr_type]())
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
            do_emulate_arithmetic_int_instruction(state, flags, laser_objs)
        else:
            do_emulate_arithmetic_float_instruction(state, flags, laser_objs)


# ------------------------------------------------
# original code (for overflow check)
# after i32.sub:
# if self.lasers == ['overflow'] and ('loc' in str(arg1) or 'loc' in str(arg2)):
#     # print(self.instr_name, arg1, arg2, result)
#     if True:
#         state.constraints.append(
#             simplify(Extract(31, 30, arg2) ^ Extract(31, 30, arg2)) == 1)
#         state.constraints.append(
#             Extract(30, 0, arg2)+Extract(30, 0, arg1) > 2147483647)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)

# after i64.sub:
# if self.lasers == ['overflow'] and ('loc' in str(arg1) or 'loc' in str(arg2)):
#     # print(self.instr_name, arg1, arg2, result)
#     if True:
#         state.constraints.append(
#             simplify(Extract(63, 62, arg2) ^ Extract(63, 62, arg2)) == 1)
#         state.constraints.append(
#             Extract(62, 0, arg2)+Extract(62, 0, arg1) > 9223372036854775807)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)

# after i32.add
# if self.lasers == ['overflow'] and ('loc' in str(arg1) or 'loc' in str(arg2)):
#     # print(self.instr_name, arg1, arg2, result)
#     # if (is_bv_value(arg1) and str(arg2).startswith('load')) or (is_bv_value(arg2) and str(arg1).startswith('load')):
#     if is_bv_value(arg1) or is_bv_value(arg2):
#         pass
#     else:
#         state.constraints.append(
#             simplify(Extract(31, 30, arg2) ^ Extract(31, 30, arg2)) == 0)
#         state.constraints.append(
#             Extract(30, 0, arg2)+Extract(30, 0, arg1) > 2147483647)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)

# after i64.add:
# if self.lasers == ['overflow'] and ('loc' in str(arg1) or 'loc' in str(arg2)):
#     # print(self.instr_name, arg1, arg2, result)
#     # if (is_bv_value(arg1) and str(arg2).startswith('load')) or (is_bv_value(arg2) and str(arg1).startswith('load')):
#     if is_bv_value(arg1) or is_bv_value(arg2):
#         pass
#     else:
#         state.constraints.append(
#             simplify(Extract(63, 62, arg2) ^ Extract(63, 62, arg2)) == 0)
#         state.constraints.append(
#             Extract(62, 0, arg2)+Extract(62, 0, arg1) > 9223372036854775807)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)

# after i32.mul:
# if self.lasers == ['overflow'] and ('loc' in str(arg1) or 'loc' in str(arg2)):
#     # print(self.instr_name, arg1, arg2, result)
#     if is_bv_value(arg1) and not is_bv_value(arg2):
#         if 'load' in str(arg2):
#             state.constraints.append(arg2 > 0)
#         state.constraints.append(arg1.as_signed_long() > 0)
#         state.constraints.append(
#             simplify(Extract(31, 0, ZeroExt(32, arg2)*ZeroExt(32, arg1)) / arg1) != arg2)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)
#     elif is_bv_value(arg2) and not is_bv_value(arg1):
#         if 'load' in str(arg1):
#             state.constraints.append(arg1 > 0)
#         state.constraints.append(arg2.as_signed_long() > 0)
#         state.constraints.append(
#             simplify(Extract(31, 0, ZeroExt(32, arg2)*ZeroExt(32, arg1)) / arg2) != arg1)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)
#     else:
#         state.constraints.append(
#             simplify(Extract(31, 0, ZeroExt(32, arg2)*ZeroExt(32, arg1)) / arg2) != arg1)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)

# after i64.mul:
# if self.lasers == ['overflow'] and ('loc' in str(arg1) or 'loc' in str(arg2)):
#     # print(self.instr_name, arg1, arg2, result)
#     if is_bv_value(arg1) and not is_bv_value(arg2):
#         if 'load' in str(arg2):
#             state.constraints.append(arg2 > 0)
#         state.constraints.append(arg1.as_signed_long() > 0)
#         state.constraints.append(
#             simplify(Extract(63, 0, ZeroExt(64, arg2)*ZeroExt(64, arg1)) / arg1) != arg2)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)
#     elif is_bv_value(arg2) and not is_bv_value(arg1):
#         if 'load' in str(arg1):
#             state.constraints.append(arg1 > 0)
#         state.constraints.append(arg2.as_signed_long() > 0)
#         state.constraints.append(
#             simplify(Extract(63, 0, ZeroExt(64, arg2)*ZeroExt(64, arg1)) / arg2) != arg1)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)
#     else:
#         state.constraints.append(
#             simplify(Extract(63, 0, ZeroExt(63, arg2)*ZeroExt(64, arg1)) / arg2) != arg1)
#         overflow_check_flag = 'overflow_check_flag ' + \
#             str(result)
#         state.key_import_func_visited.append(
#             overflow_check_flag)


# ------------------------------------------------
# original code (for rollback check)
# after i32.rem_u:
# if self.quick['roll_back']:
#     state.symbolic_stack.append(result)
#     # calculating time is not what we need
#     if 'current_time' in str(arg2) and is_bv_value(arg1) and \
#             arg1.as_long() in [60, 3600, 86400]:
#         return False
#     elif is_bv_value(arg1) and is_bv_value(arg2):
#         return False

#     state.key_import_func_visited.append(result)
#     state_tmp_list = [None, None]
#     state_tmp_list[1] = copy.deepcopy(state)

#     current_result = copy.deepcopy(state_tmp_list)
#     self.result.append(current_result)

#     # remove 'roll_back' for quick finish
#     self.lasers.remove('roll_back')

#     return True

# after i64.rem_u:
# if self.quick['roll_back']:
#     state.symbolic_stack.append(result)
#     # calculating time is not what we need
#     if 'current_time' in str(arg2) and is_bv_value(arg1) and \
#             arg1.as_long() in [60, 3600, 86400]:
#         return False
#     elif is_bv_value(arg1) and is_bv_value(arg2):
#         return False

#     state.key_import_func_visited.append(result)
#     state_tmp_list = [None, None]
#     state_tmp_list[1] = copy.deepcopy(state)

#     current_result = copy.deepcopy(state_tmp_list)
#     self.result.append(current_result)

#     # remove 'roll_back' for quick finish
#     self.lasers.remove('roll_back')

#     return True
