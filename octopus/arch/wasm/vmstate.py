from octopus.engine.engine import VMstate


class WasmVMstate(VMstate):
    def __init__(self):
        # data structure:
        self.symbolic_stack = []
        self.symbolic_memory = {}
        self.local_var = {}
        self.globals = {}

        # path constraints
        self.constraints = []

        # instruction
        self.pc = 0
        self.instr = None

        # TODO need remove the following two variables
        self.instructions_visited = set()
        self.key_import_func_visited = []

    def details(self):
        raise NotImplementedError
