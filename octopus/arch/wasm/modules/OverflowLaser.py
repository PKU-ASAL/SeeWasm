# Implement an integer overflow detector

from z3 import *
import logging
from copy import deepcopy
from collections import defaultdict

from octopus.arch.wasm.utils import bcolors

overflow_group = {'bvadd', 'bvmul', 'bvsub'}


class OverflowLaser:
    def __init__(self):
        pass

    def _check(self, constraint):
        s = Solver()
        s.add(constraint)
        if sat == s.check():
            # print(s.model())
            return True
        return False

    def fire(self, expr, original_constraints, sign_mapping):
        # two operands
        op1, op2 = expr.arg(0), expr.arg(1)
        # copy the original_constraints
        new_cond = deepcopy(original_constraints)
        # indicate if it is overflowed
        overflowed = False

        # we only consider the instructions in `overflow_group`
        if expr.decl().name() not in overflow_group:
            return

        # step 1:
        # if two BitVecNumRef, return directly
        # as only the symbol can be manipulated
        if isinstance(op1, BitVecNumRef) and isinstance(op2, BitVecNumRef):
            return

        def contain_op(cons, op):
            for sub_cons in cons.children():
                if sub_cons.get_id() == op.get_id():
                    return True
                return contain_op(sub_cons, op)

        # step 2:
        # if both of op1 and op2 are free, overflow may happen
        free_variable = True
        op2con = defaultdict(list)
        for op in [op1, op2]:
            for constraint in new_cond:
                if contain_op(constraint, op):
                    free_variable = False
                    op2con[(op, op.get_id())].append(constraint)
            if not free_variable:
                break
        if free_variable:
            logging.warning(
                f'{bcolors.WARNING}op1 ({op1}) or op2 ({op2}) is free, which may result in overflow!{bcolors.ENDC}')
            overflowed = True

        # step 3:
        # infer the data type according to its passed instruction

        # speculate the sign, default is signed
        is_signed = sign_mapping.get(
            op1.hash(), True) & sign_mapping.get(op2.hash(), True)
        op_name = expr.decl().name()
        if op_name == 'bvadd':
            new_cond += [Not(BVAddNoOverflow(op1, op2, is_signed))]
            if self._check(new_cond):
                if is_signed:
                    logging.warning(
                        f'{bcolors.WARNING}The bvadd of op1 ({op1}) and op2 ({op2}) may overflow (signed){bcolors.ENDC}')
                else:
                    logging.warning(
                        f'{bcolors.WARNING}The bvadd of op1 ({op1}) and op2 ({op2}) may overflow (unsigned){bcolors.ENDC}')
                overflowed = True
        elif op_name == 'bvsub':
            new_cond += [Not(BVSubNoUnderflow(op1, op2, is_signed))]
            if self._check(new_cond):
                if is_signed:
                    logging.warning(
                        f'{bcolors.WARNING}The bvsub of op1 ({op1}) and op2 ({op2}) may underflow (signed){bcolors.ENDC}')
                else:
                    logging.warning(
                        f'{bcolors.WARNING}The bvsub of op1 ({op1}) and op2 ({op2}) may underflow (unsigned){bcolors.ENDC}')
                overflowed = True
        elif op_name == 'bvmul':
            new_cond += [Not(BVMulNoOverflow(op1, op2, is_signed))]
            if self._check(new_cond):
                if is_signed:
                    logging.warning(
                        f'{bcolors.WARNING}The bvmul of op1 ({op1}) and op2 ({op2}) may overflow (signed){bcolors.ENDC}')
                else:
                    logging.warning(
                        f'{bcolors.WARNING}The bvmul of op1 ({op1}) and op2 ({op2}) may overflow (unsigned){bcolors.ENDC}')
                overflowed = True
        return overflowed
