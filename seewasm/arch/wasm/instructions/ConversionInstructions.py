# emulate the conversion related instructions

from seewasm.arch.wasm.exceptions import UnsupportInstructionError
from z3 import (If, RNE, RTZ, BitVecSort, BitVecVal, Extract, Float32,
                Float64, SignExt, ZeroExt, fpBVToFP, fpFPToFP, fpGEQ, fpGT,
                fpIsNaN, fpLEQ, fpLT, fpSignedToFP, fpToIEEEBV, fpToSBV,
                fpToUBV, fpUnsignedToFP, simplify)


class ConversionInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    def emulate(self, state):
        arg0 = state.symbolic_stack.pop()

        def saturating_trunc(arg, signed, bits):
            if arg.ebits() == 8:
                float_sort = Float32()
            else:
                float_sort = Float64()

            zero = BitVecVal(0, bits)
            if signed:
                min_val = -(2 ** (bits - 1))
                max_val = 2 ** (bits - 1) - 1
                min_bv = BitVecVal((1 << bits) + min_val, bits)
                max_bv = BitVecVal(max_val, bits)
                min_fp = fpSignedToFP(RNE(), min_bv, float_sort)
                max_fp = fpSignedToFP(RNE(), max_bv, float_sort)
                trunc_val = fpToSBV(RTZ(), arg, BitVecSort(bits))
                return simplify(
                    If(fpIsNaN(arg), zero,
                       If(fpLT(arg, min_fp), min_bv,
                          If(fpGT(arg, max_fp), max_bv, trunc_val))))

            max_val = 2 ** bits - 1
            max_bv = BitVecVal(max_val, bits)
            max_fp = fpUnsignedToFP(RNE(), max_bv, float_sort)
            trunc_val = fpToUBV(RTZ(), arg, BitVecSort(bits))
            return simplify(
                If(fpIsNaN(arg), zero,
                   If(fpLEQ(arg, fpUnsignedToFP(RNE(), zero, float_sort)), zero,
                      If(fpGEQ(arg, max_fp), max_bv, trunc_val))))

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
        elif self.instr_name == 'i32.trunc_sat_f32_s':
            assert arg0.ebits() == 8, 'i32.trunc_sat_f32_s has wrong arg type'
            assert arg0.sbits() == 24, 'i32.trunc_sat_f32_s has wrong arg type'

            result = saturating_trunc(arg0, signed=True, bits=32)
        elif self.instr_name == 'i32.trunc_sat_f32_u':
            assert arg0.ebits() == 8, 'i32.trunc_sat_f32_u has wrong arg type'
            assert arg0.sbits() == 24, 'i32.trunc_sat_f32_u has wrong arg type'

            result = saturating_trunc(arg0, signed=False, bits=32)
        elif self.instr_name == 'i32.trunc_sat_f64_s':
            assert arg0.ebits() == 11, 'i32.trunc_sat_f64_s has wrong arg type'
            assert arg0.sbits() == 53, 'i32.trunc_sat_f64_s has wrong arg type'

            result = saturating_trunc(arg0, signed=True, bits=32)
        elif self.instr_name == 'i32.trunc_sat_f64_u':
            assert arg0.ebits() == 11, 'i32.trunc_sat_f64_u has wrong arg type'
            assert arg0.sbits() == 53, 'i32.trunc_sat_f64_u has wrong arg type'

            result = saturating_trunc(arg0, signed=False, bits=32)
        elif self.instr_name == 'i64.trunc_sat_f32_s':
            assert arg0.ebits() == 8, 'i64.trunc_sat_f32_s has wrong arg type'
            assert arg0.sbits() == 24, 'i64.trunc_sat_f32_s has wrong arg type'

            result = saturating_trunc(arg0, signed=True, bits=64)
        elif self.instr_name == 'i64.trunc_sat_f32_u':
            assert arg0.ebits() == 8, 'i64.trunc_sat_f32_u has wrong arg type'
            assert arg0.sbits() == 24, 'i64.trunc_sat_f32_u has wrong arg type'

            result = saturating_trunc(arg0, signed=False, bits=64)
        elif self.instr_name == 'i64.trunc_sat_f64_s':
            assert arg0.ebits() == 11, 'i64.trunc_sat_f64_s has wrong arg type'
            assert arg0.sbits() == 53, 'i64.trunc_sat_f64_s has wrong arg type'

            result = saturating_trunc(arg0, signed=True, bits=64)
        elif self.instr_name == 'i64.trunc_sat_f64_u':
            assert arg0.ebits() == 11, 'i64.trunc_sat_f64_u has wrong arg type'
            assert arg0.sbits() == 53, 'i64.trunc_sat_f64_u has wrong arg type'

            result = saturating_trunc(arg0, signed=False, bits=64)
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
        elif self.instr_name == 'i32.extend_s/i8':
            assert arg0.size() == 8, 'i32.extend_s/i8 has wrong arg type'

            result = simplify(SignExt(24, arg0))
        elif self.instr_name == 'i32.extend_s/i16':
            assert arg0.size() == 16, 'i32.extend_s/i16 has wrong arg type'

            result = simplify(SignExt(16, arg0))
        elif self.instr_name == 'i64.extend_s/i8':
            assert arg0.size() == 8, 'i64.extend_s/i8 has wrong arg type'

            result = simplify(SignExt(56, arg0))
        elif self.instr_name == 'i64.extend_s/i16':
            assert arg0.size() == 16, 'i64.extend_s/i16 has wrong arg type'

            result = simplify(SignExt(48, arg0))
        elif self.instr_name == 'i64.extend_s/i32':
            assert arg0.size() == 32, 'i64.extend_s/i32 has wrong arg type'

            result = simplify(SignExt(32, arg0))
        else:
            print('\nErr:\nUnsupported instruction: %s\n' % self.instr_name)
            raise UnsupportInstructionError

        state.symbolic_stack.append(result)

        return [state]
