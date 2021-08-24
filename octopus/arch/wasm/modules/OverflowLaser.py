from z3 import *
import logging

from octopus.arch.wasm.utils import bcolors


class OverflowLaser:
    def __init__(self):
        pass

    def _check(self, condition):
        s = Solver()
        s.add(condition)
        if sat == s.check():
            return True
        return False

    def fire(self, expr):
        # two operands
        op1, op2 = expr.arg(0), expr.arg(1)

        if expr.decl().name() == 'bvadd':
            cond = Or(op1 + op2 < op1, op1 + op2 < op2)
            if self._check(cond):
                logging.warning(
                    f'{bcolors.WARNING}The "+" of op1 ({op1}) and op2 ({op2}) may overflow!{bcolors.ENDC}')
        elif expr.decl().name() == 'bvsub':
            cond = op2 > op1
            if self._check(cond):
                logging.warning(
                    f'{bcolors.WARNING}The "-" of op1 ({op1}) and op2 ({op2}) may underflow!{bcolors.ENDC}')
