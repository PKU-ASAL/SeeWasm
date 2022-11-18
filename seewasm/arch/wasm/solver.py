from z3 import Solver

# from lab_solver import *


class SMTSolver:
    def __new__(cls, designated_solver):
        if designated_solver == 'z3':
            return Solver()
        else:
            raise Exception("No SMT backend found")
