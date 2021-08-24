from z3 import *
import logging
from copy import deepcopy

from octopus.arch.wasm.utils import bcolors

overflow_group = {'bvadd', 'bvmul'}


class OverflowLaser:
    def __init__(self):
        pass

    def _check(self, condition):
        s = Solver()
        s.add(condition)
        if sat == s.check():
            return True
        return False

    def fire(self, expr, original_constraints):
        # two operands
        op1, op2 = expr.arg(0), expr.arg(1)
        # copy the original_constraints
        new_cond = deepcopy(original_constraints)

        if expr.decl().name() in overflow_group:
            # unsigned
            new_cond += [Or(ULT(op1 + op2, op1), ULT(op1 + op2, op2))]
            if self._check(new_cond):
                logging.warning(
                    f'{bcolors.WARNING}The "{expr.decl().name()}" of op1 ({op1}) and op2 ({op2}) may overflow!{bcolors.ENDC}')
        elif expr.decl().name() == 'bvsub':
            new_cond += [op2 > op1]
            if self._check(new_cond):
                logging.warning(
                    f'{bcolors.WARNING}The "-" of op1 ({op1}) and op2 ({op2}) may underflow!{bcolors.ENDC}')
