# This file defines the `state` that will be passed within Wasm-SE

from octopus.engine.engine import VMstate

from collections import defaultdict


class WasmVMstate(VMstate):
    def __init__(self):
        # data structure:
        self.symbolic_stack = []
        self.symbolic_memory = {}
        self.local_var = {}
        self.globals = {}
        self.constraints = []

        # instruction
        self.instr = None
        # current function name
        self.current_func_name = None
        # lasers, vulnerability detector
        self.lasers = 0
        # keep the operator and its speculated sign
        self.sign_mapping = defaultdict(bool)

    def __str__(self):
        return f'''Current Func:\t{self.current_func_name}
Stack:\t\t{self.symbolic_stack}
Local Var:\t{self.local_var}
Global Var:\t{self.globals}
Memory:\t\t{self.symbolic_memory}
Constraints:\t{self.constraints}\n'''

    def details(self):
        raise NotImplementedError
