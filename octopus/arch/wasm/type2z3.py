from z3 import *
from . exceptions import *


def getConcreteBitVec(type, name):
    if type == 'i32':
        return BitVec(name, 32)
    elif type == 'i64':
        return BitVec(name, 64)
    elif type == 'f32':
        return FP(name, Float32())
    elif type == 'f64':
        return FP(name, Float64())
    else:
        raise UnsupportZ3TypeError
