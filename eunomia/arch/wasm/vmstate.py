# This file defines the `state` that will be passed within Wasm-SE
import copy
from collections import defaultdict

from eunomia.arch.wasm.configuration import Configuration
from eunomia.arch.wasm.utils import readable_internal_func_name
from eunomia.engine.engine import VMstate
from z3 import BitVecVal


class WasmVMstate(VMstate):
    def __init__(self, stdin_buffer=b'', args=''):
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
        self.current_func_name = 'none'
        # keep the operator and its speculated sign
        self.sign_mapping = defaultdict(bool)

        self.stdin_buffer = stdin_buffer
        self.args = args
        self.stdout_buffer = []
        self.stderr_buffer = []
        self.fd = {'stdin': 0, 'stdout': 1, 'stderr': 2}
        self.files_buffer = dict()

    def translate(self, ctx):
        state = WasmVMstate()
        for v in self.symbolic_stack:
            state.symbolic_stack.append(copy.deepcopy(v).translate(ctx))
        for k, v in self.symbolic_memory.items():
            state.symbolic_memory[k] = copy.deepcopy(v).translate(ctx)
        for k, v in self.local_var.items():
            state.local_var[k] = copy.deepcopy(v).translate(ctx)
        for k, v in self.globals.items():
            state.globals[k] = copy.deepcopy(v).translate(ctx)
        for c in self.constraints:
            state.constraints.append(copy.deepcopy(c).translate(ctx))

    def __str__(self):
        return f'''Current Func:\t{readable_internal_func_name(Configuration.get_func_index_to_func_name(), self.current_func_name)}
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
