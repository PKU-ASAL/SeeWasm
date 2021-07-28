# emulate the arithmetic related instructions

from .. exceptions import *
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

# TODO overflow check in this function?
def do_emulate_arithmetic_int_instruction(instr, state):
    instr_type = instr.name[:3]
    
    if '.clz' in instr.name or '.ctz' in instr.name:
        # wasm documentation says:
        # This instruction is fully defined when all bits are zero; it returns the number of bits in the operand type.
        state.symbolic_stack.pop()
        state.symbolic_stack.append(BitVecVal(helper_map[instr_type], helper_map[instr_type]))
    elif '.popcnt' in instr.name:
        # wasm documentation says:
        # This instruction is fully defined when all bits are zero; it returns 0.
        state.symbolic_stack.pop()
        state.symbolic_stack.append(BitVecVal(0, helper_map[instr_type]))
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

        if '.sub' in instr.name:
            result = simplify(arg2 - arg1)
        elif '.add' in instr.name:
            result = simplify(arg2 + arg1)
        elif '.mul' in instr.name:
            result = simplify(arg2 * arg1)
        elif '.div_s' in instr.name:
            result = simplify(arg2 / arg1)
        elif '.div_u' in instr.name:
            result = simplify(UDiv(arg2, arg1))
        elif '.rem_s' in instr.name:
            result = simplify(SRem(arg2, arg1))
        elif '.rem_u' in instr.name:
            result = simplify(URem(arg2, arg1))
        else:
            raise UnsupportInstructionError

        state.symbolic_stack.append(result)

    return False

def do_emulate_arithmetic_float_instruction(instr, state):
    # TODO need to be clarified
    # wasm default rounding rules
    rm = RNE()

    instr_type = instr.name[:3]

    two_arguments_instrs = ['add', 'sub', 'mul', 'div', 'min', 'max', 'copysign']
    one_argument_instrs = ['sqrt', 'floor', 'ceil', 'trunc', 'nearest', 'abs', 'neg']

    # add instr_type before each instr
    two_arguments_instrs = [str(instr_type + '.' + i) for i in two_arguments_instrs]
    one_argument_instrs = [str(instr_type + '.' + i) for i in one_argument_instrs]

    # pop two elements
    if instr.name in two_arguments_instrs:
        arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()

        assert arg1.ebits() == helper_map[instr_type][0] and arg1.sbits(
        ) == helper_map[instr_type][1], 'In do_emulate_arithmetic_float_instruction, arg1 type mismatch'
        assert arg2.ebits() == helper_map[instr_type][0] and arg2.sbits(
        ) == helper_map[instr_type][1], 'In do_emulate_arithmetic_float_instruction, arg2 type mismatch'

        if '.add' in instr.name:
            result = simplify(fpAdd(rm, arg2, arg1))
        elif '.sub' in instr.name:
            result = simplify(fpSub(rm, arg2, arg1))
        elif '.mul' in instr.name:
            result = simplify(fpMul(rm, arg2, arg1))
        elif '.div' in instr.name:
            result = simplify(fpDiv(rm, arg2, arg1))
        elif '.min' in instr.name:
            result = simplify(fpMin(arg2, arg1))
        elif '.max' in instr.name:
            result = simplify(fpMax(arg2, arg1))
        elif '.copysign' in instr.name == 'f32.copysign':
            # extract arg2's sign to overwrite arg1's sign
            if arg2.isPositive() ^ arg1.isPositive():
                result = simplify(fpNeg(arg1))

        state.symbolic_stack.append(result)
    # pop one element
    elif instr.name in one_argument_instrs:
        arg1 = state.symbolic_stack.pop()

        assert arg1.ebits() == helper_map[instr_type][0] and arg1.sbits(
        ) == helper_map[instr_type][1], 'In do_emulate_arithmetic_float_instruction, arg1 type mismatch'

        if '.sqrt' in instr.name:
            result = simplify(fpSqrt(rm, arg1))
        elif '.floor' in instr.name:
            # round toward negative
            rm = RTN()
            result = simplify(fpFPToFP(rm, arg1, float_helper_map[instr_type]()))
        elif '.ceil' in instr.name:
            # round toward positive
            rm = RTP()
            result = simplify(fpFPToFP(rm, arg1, float_helper_map[instr_type]()))
        elif '.trunc' in instr.name:
            # round toward zero
            rm = RTZ()
            result = simplify(fpFPToFP(rm, arg1, float_helper_map[instr_type]()))
        elif '.nearest' in instr.name:
            # round to integeral ties to even
            rm = RNE()
            result = simplify(fpFPToFP(rm, arg1, float_helper_map[instr_type]()))
        elif '.abs' in instr.name:
            result = simplify(fpAbs(arg1))
        elif '.neg' in instr.name:
            result = simplify(fpNeg(arg1))

        state.symbolic_stack.append(result)
    else:
        raise UnsupportInstructionError

    return False


# ------------------------------------------------
# original code (for overflow check)
# after i32.sub:
# if self.lasers == ['overflow'] and ('loc' in str(arg1) or 'loc' in str(arg2)):
#     # print(instr.name, arg1, arg2, result)
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
#     # print(instr.name, arg1, arg2, result)
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
#     # print(instr.name, arg1, arg2, result)
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
#     # print(instr.name, arg1, arg2, result)
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
#     # print(instr.name, arg1, arg2, result)
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
#     # print(instr.name, arg1, arg2, result)
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