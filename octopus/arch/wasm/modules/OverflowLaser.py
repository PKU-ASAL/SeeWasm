from z3 import *
import logging

from octopus.arch.wasm.utils import bcolors


class OverflowLaser:
    def __init__(self):
        pass

    def fire(self, expr):
        if expr.decl().name() == 'bvadd':
            op1, op2 = expr.arg(0), expr.arg(1)

            # init a solver
            s = Solver()
            s.add(Or(op1 + op2 < op1, op1 + op2 < op2))
            if sat == s.check():
                logging.warning(
                    f'{bcolors.WARNING}The sum of op1 ({op1}) and op2 ({op2}) may overflow!{bcolors.ENDC}')
