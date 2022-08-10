# This file defines the `state` that will be passed within Wasm-SE
from collections import defaultdict

from eunomia.arch.wasm.configuration import Configuration
from eunomia.arch.wasm.utils import readable_internal_func_name
from eunomia.engine.engine import VMstate
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
        self.constraints = []
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

        self.file_sys = {
            0: {"name": "stdin", "status": True, "flag": "r", "content": []},
            1: {"name": "stdout", "status": True, "flag": "w", "content": []},
            2: {"name": "stderr", "status": True, "flag": "w", "content": []}}

        # used by br_if instruction
        self.edge_type = ''

    def __str__(self):
        return f'''\b
Current Func:\t{readable_internal_func_name(Configuration.get_func_index_to_func_name(), self.current_func_name)}
Stack:\t\t{self.symbolic_stack}
Local Var:\t{self.local_var}
Global Var:\t{self.globals}
Memory:\t\t{self.symbolic_memory}
Constraints:\t{self.constraints}\n'''

    def details(self):
        raise NotImplementedError

    def __lt__(self, other):
        return False

    def __getstate__(self):
        return self.__dict__.copy()
