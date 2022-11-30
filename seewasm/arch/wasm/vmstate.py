# This file defines the `state` that will be passed within Wasm-SE
from collections import defaultdict

from seewasm.arch.wasm.configuration import Configuration
from seewasm.arch.wasm.solver import SMTSolver
from seewasm.arch.wasm.utils import (init_file_for_file_sys,
                                     readable_internal_func_name)
from seewasm.engine.engine import VMstate
from z3 import BitVecVal


class WasmVMstate(VMstate):
    def __init__(self):
        # data structure:
        def local_default():
            return BitVecVal(0, 32)
        self.symbolic_stack = []
        self.symbolic_memory = {}
        self.local_var = defaultdict(local_default)
        self.globals = {}
        # instruction
        self.instr = "end"
        # current function name
        self.current_func_name = ''
        # current basic block's name, used in recursive process
        self.current_bb_name = ''
        # keep the operator and its speculated sign
        self.sign_mapping = defaultdict(bool)
        # context stack
        # whose element is 4-tuple: (func_name, stack, local, require_return)
        # TODO files buffer may need to maintained in context
        self.context_stack = []

        self.args = ""

        # all items should be initialized by init_file_for_file_sys in utils
        self.file_sys = {}
        for fd in range(0, 3):
            self.file_sys[fd] = init_file_for_file_sys()
        self.file_sys[0]["name"] = "stdin"
        self.file_sys[0]["status"] = True
        self.file_sys[0]["flag"] = "r"
        self.file_sys[1]["name"] = "stdout"
        self.file_sys[1]["status"] = True
        self.file_sys[1]["flag"] = "w"
        self.file_sys[2]["name"] = "stderr"
        self.file_sys[2]["status"] = True
        self.file_sys[2]["flag"] = "w"

        # used by br_if instruction
        self.edge_type = ''
        # the corresponding solver
        self.solver = SMTSolver(Configuration.get_solver())
        # the name of function that is called in call_indirect
        self.call_indirect_callee = ''

    def __str__(self):
        return f'''Current Func:\t{readable_internal_func_name(Configuration.get_func_index_to_func_name(), self.current_func_name)}
Stack:\t\t{self.symbolic_stack}
Local Var:\t{self.local_var}
Global Var:\t{self.globals}
Memory:\t\t{self.symbolic_memory}
Constraints:\t{self.solver.assertions()}\n'''

    def details(self):
        raise NotImplementedError

    def __lt__(self, other):
        return False

    def __getstate__(self):
        return self.__dict__.copy()
