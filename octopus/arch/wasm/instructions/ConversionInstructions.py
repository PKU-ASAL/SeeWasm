# emulate the conversion related instructions

from .. exceptions import *
from z3 import *


class ConversionInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    # TODO overflow check in this function?
    def emulate(self, state):
        arg0 = state.symbolic_stack.pop()

        if self.instr_name == 'i32.wrap/i64':
            assert arg0.size() == 64, 'i32.wrap/i64 has wrong arg type'
            divisor = BitVecVal(2 ** 32, 64)
            # mod
            result = simplify(Extract(31, 0, arg0 % divisor))
        elif self.instr_name == 'i64.extend_s/i32':
            assert arg0.size() == 32, 'i64.extend_s/i32 has wrong arg type'

            result = simplify(SignExt(32, arg0))
        elif self.instr_name == 'i64.extend_u/i32':
            assert arg0.size() == 32, 'i64.extend_u/i32 has wrong arg type'

            result = simplify(ZeroExt(32, arg0))
        elif self.instr_name == 'i32.trunc_s/f32':
            assert arg0.ebits() == 8, 'i32.trunc_s/f32 has wrong arg type'
            assert arg0.sbits() == 24, 'i32.trunc_s/f32 has wrong arg type'

            rm = RTZ()
            result = simplify(fpToSBV(rm, arg0, BitVecSort(32)))
            assert result.size() == 32, 'i32.trunc_s/f32 convert fail'
        elif self.instr_name == 'i32.trunc_s/f64':
            assert arg0.ebits() == 11, 'i32.trunc_s/f64 has wrong arg type'
            assert arg0.sbits() == 53, 'i32.trunc_s/f64 has wrong arg type'

            rm = RTZ()
            result = simplify(fpToSBV(rm, arg0, BitVecSort(32)))
            assert result.size() == 32, 'i32.trunc_s/f64 convert fail'
        elif self.instr_name == 'i64.trunc_s/f32':
            assert arg0.ebits() == 8, 'i64.trunc_s/f32 has wrong arg type'
            assert arg0.sbits() == 24, 'i64.trunc_s/f32 has wrong arg type'

            rm = RTZ()
            result = simplify(fpToSBV(rm, arg0, BitVecSort(64)))
            assert result.size() == 64, 'i64.trunc_s/f32 convert fail'
        elif self.instr_name == 'i64.trunc_s/f64':
            assert arg0.ebits() == 11, 'i64.trunc_s/f64 has wrong arg type'
            assert arg0.sbits() == 53, 'i64.trunc_s/f64 has wrong arg type'

            rm = RTZ()
            result = simplify(fpToSBV(rm, arg0, BitVecSort(64)))
            assert result.size() == 64, 'i64.trunc_s/f64 convert fail'
        elif self.instr_name == 'i32.trunc_u/f32':
            assert arg0.ebits() == 8, 'i32.trunc_u/f32 has wrong arg type'
            assert arg0.sbits() == 24, 'i32.trunc_u/f32 has wrong arg type'

            rm = RTZ()
            result = simplify(fpToUBV(rm, arg0, BitVecSort(32)))
            assert result.size() == 32, 'i32.trunc_u/f32 convert fail'
        elif self.instr_name == 'i32.trunc_u/f64':
            assert arg0.ebits() == 11, 'i32.trunc_u/f64 has wrong arg type'
            assert arg0.sbits() == 53, 'i32.trunc_u/f64 has wrong arg type'

            rm = RTZ()
            result = simplify(fpToUBV(rm, arg0, BitVecSort(32)))
            assert result.size() == 32, 'i32.trunc_u/f64 convert fail'
        elif self.instr_name == 'i64.trunc_u/f32':
            assert arg0.ebits() == 8, 'i64.trunc_u/f32 has wrong arg type'
            assert arg0.sbits() == 24, 'i64.trunc_u/f32 has wrong arg type'

            rm = RTZ()
            result = simplify(fpToUBV(rm, arg0, BitVecSort(64)))
            assert result.size() == 64, 'i64.trunc_u/f32 convert fail'
        elif self.instr_name == 'i64.trunc_u/f64':
            assert arg0.ebits() == 11, 'i64.trunc_u/f64 has wrong arg type'
            assert arg0.sbits() == 53, 'i64.trunc_u/f64 has wrong arg type'

            rm = RTZ()
            result = simplify(fpToUBV(rm, arg0, BitVecSort(64)))
            assert result.size() == 64, 'i64.trunc_u/f64 convert fail'
        elif self.instr_name == 'f32.demote/f64':
            assert arg0.ebits() == 11, 'f32.demote/f64 has wrong arg type'
            assert arg0.sbits() == 53, 'f32.demote/f64 has wrong arg type'

            rm = RNE()
            result = simplify(fpFPToFP(rm, arg0, Float32()))
            assert result.ebits() == 8, 'f32.demote/f64 conversion fail'
            assert result.sbits() == 24, 'f32.demote/f64 conversion fail'
        elif self.instr_name == 'f64.promote/f32':
            assert arg0.ebits() == 8, 'f64.promote/f32 has wrong arg type'
            assert arg0.sbits() == 24, 'f64.promote/f32 has wrong arg type'

            rm = RNE()
            result = simplify(fpFPToFP(rm, arg0, Float64()))
            assert result.ebits() == 11, 'f64.promote/f32 conversion fail'
            assert result.sbits() == 53, 'f64.promote/f32 conversion fail'
        elif self.instr_name == 'f32.convert_s/i32':
            assert arg0.size() == 32, 'f32.convert_s/i32 has wrong arg type'

            rm = RNE()
            result = simplify(fpSignedToFP(rm, arg0, Float32()))
            assert result.ebits() == 8, 'f32.convert_s/i32 conversion fail'
            assert result.sbits() == 24, 'f32.convert_s/i32 conversion fail'
        elif self.instr_name == 'f32.convert_s/i64':
            assert arg0.size() == 64, 'f32.convert_s/i64 has wrong arg type'

            rm = RNE()
            result = simplify(fpSignedToFP(rm, arg0, Float32()))
            assert result.ebits() == 8, 'f32.convert_s/i64 conversion fail'
            assert result.sbits() == 24, 'f32.convert_s/i64 conversion fail'
        elif self.instr_name == 'f64.convert_s/i32':
            assert arg0.size() == 32, 'f64.convert_s/i32 has wrong arg type'

            rm = RNE()
            result = simplify(fpSignedToFP(rm, arg0, Float64()))
            assert result.ebits() == 11, 'f64.convert_s/i32 conversion fail'
            assert result.sbits() == 53, 'f64.convert_s/i32 conversion fail'
        elif self.instr_name == 'f64.convert_s/i64':
            assert arg0.size() == 64, 'f64.convert_s/i64 has wrong arg type'

            rm = RNE()
            result = simplify(fpSignedToFP(rm, arg0, Float64()))
            assert result.ebits() == 11, 'f64.convert_s/i64 conversion fail'
            assert result.sbits() == 53, 'f64.convert_s/i64 conversion fail'
        elif self.instr_name == 'f32.convert_u/i32':
            assert arg0.size() == 32, 'f32.convert_u/i32 has wrong arg type'

            rm = RNE()
            result = simplify(fpUnsignedToFP(rm, arg0, Float32()))
            assert result.ebits() == 8, 'f32.convert_u/i32 conversion fail'
            assert result.sbits() == 24, 'f32.convert_u/i32 conversion fail'
        elif self.instr_name == 'f32.convert_u/i64':
            assert arg0.size() == 64, 'f32.convert_u/i64 has wrong arg type'

            rm = RNE()
            result = simplify(fpUnsignedToFP(rm, arg0, Float32()))
            assert result.ebits() == 8, 'f32.convert_u/i64 conversion fail'
            assert result.sbits() == 24, 'f32.convert_u/i64 conversion fail'
        elif self.instr_name == 'f64.convert_u/i32':
            assert arg0.size() == 32, 'f64.convert_u/i32 has wrong arg type'

            rm = RNE()
            result = simplify(fpUnsignedToFP(rm, arg0, Float64()))
            assert result.ebits() == 11, 'f64.convert_u/i32 conversion fail'
            assert result.sbits() == 53, 'f64.convert_u/i32 conversion fail'
        elif self.instr_name == 'f64.convert_u/i64':
            assert arg0.size() == 64, 'f64.convert_u/i64 has wrong arg type'

            rm = RNE()
            result = simplify(fpUnsignedToFP(rm, arg0, Float64()))
            assert result.ebits() == 11, 'f64.convert_u/i64 conversion fail'
            assert result.sbits() == 53, 'f64.convert_u/i64 conversion fail'
        elif self.instr_name == 'i32.reinterpret/f32':
            assert arg0.ebits() == 8, 'i32.reinterpret/f32 has wrong arg type'
            assert arg0.sbits() == 24, 'i32.reinterpret/f32 has wrong arg type'

            result = simplify(fpToIEEEBV(arg0))
            assert result.size() == 32, 'i32.reinterpret/f32 conversion fail'
        elif self.instr_name == 'i64.reinterpret/f64':
            assert arg0.ebits() == 11, 'i64.reinterpret/f64 has wrong arg type'
            assert arg0.sbits() == 53, 'i64.reinterpret/f64 has wrong arg type'

            result = simplify(fpToIEEEBV(arg0))
            assert result.size() == 64, 'i64.reinterpret/f64 conversion fail'
        elif self.instr_name == 'f32.reinterpret/i32':
            assert arg0.size() == 32, 'f32.reinterpret/i32 has wrong arg type'

            result = simplify(fpBVToFP(arg0, Float32()))
            assert result.ebits() == 8, 'f32.reinterpret/i32 conversion fail'
            assert result.sbits() == 24, 'f32.reinterpret/i32 conversion fail'
        elif self.instr_name == 'f64.reinterpret/i64':
            assert arg0.size() == 64, 'f64.reinterpret/i64 has wrong arg type'

            result = simplify(fpBVToFP(arg0, Float64()))
            assert result.ebits() == 11, 'f64.reinterpret/i64 conversion fail'
            assert result.sbits() == 53, 'f64.reinterpret/i64 conversion fail'
        else:
            raise UnsupportInstructionError

        state.symbolic_stack.append(result)

        return False
