from octopus.engine.engine import VMstate


class WasmVMstate(VMstate):

    def __init__(self):
        self.symbolic_memory = {}
        self.constraints = []
        self.symbolic_stack = []
        self.local_var = []

        self.last_returned = []
        self.pc = 0
        self.instr = None

        self.instructions_visited = set()
        self.key_import_func_visited = list()
        # the element in self.globals is also a list, which is presented as [type, num]
        self.globals = list()
        # self.instructions_visited = dict()

    def details(self):
        return {'memory': self.symbolic_memory,
                'symbolic_stack': self.symbolic_stack,
                'last_returned': self.last_returned,
                'pc': self.pc}
