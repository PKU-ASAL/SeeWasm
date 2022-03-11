# emulate the bitwise related instructions

from .. exceptions import *
from z3 import *
import logging

helper_map = {
    'i32': 32,
    'i64': 64,
}


class BitwiseInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    # TODO overflow check in this function?
    def emulate(self, state):
        arg1, arg2 = state.symbolic_stack.pop(), state.symbolic_stack.pop()
        instr_type = self.instr_name[:3]

        # arg1 and arg2 could be BitVecRef, BitVecValRef and BoolRef
        if is_bool(arg1):
            arg1 = BitVec(str(arg1), helper_map[instr_type])
            logging.warning(
                "[!] In `BitwiseInstructions.py`, arg1 is BoolRef, translated to BitVec which may lead to some information loss")
        if is_bool(arg2):
            arg2 = BitVec(str(arg2), helper_map[instr_type])
            logging.warning(
                "[!] In `BitwiseInstructions.py`, arg2 is BoolRef, translated to BitVec which may lead to some information loss")

        assert arg1.size(
        ) == helper_map[instr_type], f'arg1 size is {arg1.size()} instead of {helper_map[instr_type]} in do_emulate_bitwise_instruction'
        assert arg2.size(
        ) == helper_map[instr_type], f'arg2 size is {arg2.size()} instead of {helper_map[instr_type]} in do_emulate_bitwise_instruction'

        if '.and' in self.instr_name:
            result = simplify(arg1 & arg2)
        elif '.or' in self.instr_name:
            result = simplify(arg1 | arg2)
        elif '.xor' in self.instr_name:
            result = simplify(arg1 ^ arg2)
        elif '.shr_s' in self.instr_name:
            result = simplify(arg2 >> arg1)
        elif '.shr_u' in self.instr_name:
            result = simplify(LShR(arg2, arg1))
        elif '.shl' in self.instr_name:
            result = simplify(arg2 << arg1)
        elif '.rotl' in self.instr_name:
            result = simplify(RotateLeft(arg2, arg1))
        elif '.rotr' in self.instr_name:
            result = simplify(RotateRight(arg2, arg1))
        else:
            raise UnsupportInstructionError

        if is_bool(result):
            if is_true(result):
                result = BitVecVal(1, 32)
            elif is_false(result):
                result = BitVecVal(0, 32)

        assert is_bv(result) or is_bool(
            result), f"in bitwise instruction, the value to be pushed is {type(result)} instead of BitVec or Bool"

        state.symbolic_stack.append(result)

        return False
