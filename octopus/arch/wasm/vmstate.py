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
        return str(self.__dict__)

    def details(self):
        raise NotImplementedError
