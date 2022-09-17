# Implement an div zero detector

import logging
from copy import deepcopy

from eunomia.arch.wasm.configuration import Configuration, bcolors
from eunomia.arch.wasm.solver import SMTSolver
from z3 import sat

div_operations = {'bvsdiv', 'bvudic', 'bvsrem', 'bvurem', 'fp.div'}


class DivZeroLaser:
    def __init__(self):
        pass

    def _check(self, condition):
        s = SMTSolver(Configuration.get_solver())
        s.add(condition)
        if sat == s.check():
            return True
        return False

    def fire(self, expr, solver):
        # TODO revise for replace constraints as solver
        # two operands
        _, op2 = expr.arg(0), expr.arg(1)
        # copy the original_constraints
        new_cond = deepcopy(original_constraints)
        # indicate if div zero vulnerability
        divzeroed = False

        if expr.decl().name() in div_operations:
            # if the dividend is zero, it's vulnerable
            new_cond += [op2 == 0]
            if self._check(new_cond):
                logging.warning(
                    f"{bcolors.WARNING}The op2 ({op2}) may be zero, which may result in Div-Zero vulnerability!{bcolors.ENDC}")
                divzeroed = True
        if divzeroed:
            import datetime
            logging.info(f"Current Time: {datetime.datetime.now()}")
        return divzeroed
