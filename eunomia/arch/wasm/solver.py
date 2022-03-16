from z3 import *
# from lab_solver import *

class SMTSolver:
    def __new__(cls, designated_solver):
        if designated_solver == 'z3':
            return Solver()
        elif designated_solver == 'lab':
            import nufsolver
            return nufsolver.solver.Solver()
        else:
            raise Exception("No SMT backend found")
