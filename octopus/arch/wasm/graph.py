from z3 import *

class ClassPropertyDescriptor:
    def __init__(self, fget, fset=None):
        self.fget = fget
        self.fset = fset

    def __get__(self, obj, klass=None):
        if klass is None:
            klass = type(obj)
        return self.fget.__get__(obj, klass)()

    def __set__(self, obj, value):
        if not self.fset:
            raise AttributeError
        type_ = type(obj)
        return self.fset.__get__(obj, type_)(value)

    def setter(self, func):
        if not isinstance(func, (classmethod, staticmethod)):
            func = classmethod(func)
        self.fset = func
        return self

def classproperty(func):
    if not isinstance(func, (classmethod, staticmethod)):
        func = classmethod(func)
    return ClassPropertyDescriptor(func)

class Graph:
    _func_to_bbs = {}
    _bb_to_instructions = {}
    _bbs_graph = {}
    _wasmVM = None

    def __init__(self, funcs):
        self.entries = funcs
        self.final_states = {func: [] for func in self.entries}

    @classproperty
    def func_to_bbs(cls):
        return cls._func_to_bbs

    @classproperty
    def bbs_graph(cls):
        return cls._bbs_graph

    @classproperty
    def bb_to_instructions(cls):
        return cls._bb_to_instructions

    @classproperty
    def wasmVM(cls):
        return cls._wasmVM

    @wasmVM.setter
    def wasmVM(cls, val):
        cls.wasmVM = val

    @classmethod
    def extract_basic_blocks(cls):
        cfg = cls.wasmVM.cfg
        funcs = cfg.functions
        cls.func_to_bbs = dict()
        for func in funcs:
            func_name, func_bbs = func.name, func.basicblocks
            # get the name of bb in func_bbs 
            func_bbs = [bb.name for bb in func_bbs]
            cls.func_to_bbs[func_name] = func_bbs

        # adjacent graph for basic blocks, like:
        # {'block_3_0': ['block_3_6', 'block_3_9']}
        edges = cfg.edges
        for edge in edges:
            node_from, node_to, edge_type = edge.node_from, edge.node_to, edge.type
            if node_from not in cls.bbs_graph:
                cls.bbs_graph[node_from] = {edge_type: node_to}
            else:
                cls.bbs_graph[node_from][edge_type] = node_to

        # goal 1: append those single node into the bbs_graph
        # goal 2: initialize bb_to_instructions
        bbs = cfg.basicblocks
        for bb in bbs:
            # goal 1
            bb_name = bb.name
            if bb_name not in cls.bbs_graph:
                cls.bbs_graph[bb_name] = []
            # goal 2
            cls.bb_to_instructions[bb_name] = bb.instructions

    def traverse(self):
        for entry_func in self.entries:
            self.traverse_one(entry_func)

    def traverse_one(self, func, state=None, has_ret=None):
        param_str, return_str = self.wasmVM.get_signature(func)
        if state is None:
            state, has_ret = self.wasmVM.init_state(func, param_str, return_str, [])
        self.wasmVM.current_function = self.wasmVM.cfg.get_function(func)
        # retrieve all the relevant basic blocks
        entry_func_bbs = self.func_to_bbs[func]
        # filter out the entry basic block and corresponding instructions
        entry_bb = list(filter(lambda bb: bb[-2:] == '_0', entry_func_bbs))[0]

        self.visit(state, has_ret, entry_bb, self.final_states[func])
        print(self.final_states[func])

    def visit(self, state, has_ret, blk, final_states):
        instructions = self.bb_to_instructions[blk]
        emul_states = self.wasmVM.emulate_basic_block(state, has_ret, instructions)
        if len(self.bbs_graph[blk]) == 0:
            final_states.append(emul_states)
        for type in self.bbs_graph[blk]:
            if isinstance(emul_states, dict) and type in emul_states:
                state = emul_states[type]
                solver = Solver()
                solver.add(*state.constraints)
                if sat == solver.check():
                    self.visit(state, has_ret, self.bbs_graph[blk][type], final_states)
            else:
                self.visit(state, has_ret, self.bbs_graph[blk][type], final_states)
        return state

