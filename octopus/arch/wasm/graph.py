from z3 import *
from collections import defaultdict

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
    _bbs_graph = defaultdict(dict) # nested dict
    _loop_maximum_rounds = 30
    _wasmVM = None

    def __init__(self, funcs):
        self.entries = funcs
        self.final_states = {func: None for func in funcs}

    @classproperty
    def loop_maximum_rounds(cls):
        return cls._loop_maximum_rounds

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
            # there are four types of edges:
            # ['unconditional', 'fallthrough', 'conditional_true', 'conditional_false']
            node_from, node_to, edge_type = edge.node_from, edge.node_to, edge.type
            cls.bbs_graph[node_from][edge_type] = node_to

        # goal 1: append those single node into the bbs_graph
        # goal 2: initialize bb_to_instructions
        bbs = cfg.basicblocks
        for bb in bbs:
            # goal 1
            bb_name = bb.name
            if bb_name not in cls.bbs_graph:
                cls.bbs_graph[bb_name] = dict()
            # goal 2
            cls.bb_to_instructions[bb_name] = bb.instructions

    def traverse(self):
        for entry_func in self.entries:
            self.final_states[entry_func] = self.traverse_one(entry_func)

    @classmethod
    def traverse_one(cls, func, state=None, has_ret=None):
        param_str, return_str = cls.wasmVM.get_signature(func)
        if state is None:
            state, has_ret = cls.wasmVM.init_state(func, param_str, return_str, [])
        # store the caller func
        caller_func_name = state.current_func_name
        # set the callee func
        state.current_func_name = cls.wasmVM.cfg.get_function(func).name

        # retrieve all the relevant basic blocks
        entry_func_bbs = cls.func_to_bbs[func]
        # filter out the entry basic block and corresponding instructions
        entry_bb = list(filter(lambda bb: bb[-2:] == '_0', entry_func_bbs))[0]
        final_states = []
        vis = defaultdict(int)
        cls.visit(state, has_ret, entry_bb, final_states, vis)
        
        # recover the caller func obj
        state.current_func_name = caller_func_name
        return final_states

    @classmethod
    def visit(cls, state, has_ret, blk, final_states, vis):
        if vis[blk] >= cls.loop_maximum_rounds:
            return
        vis[blk] += 1
        instructions = cls.bb_to_instructions[blk]
        halt, emul_states = cls.wasmVM.emulate_basic_block(state, has_ret, instructions)
        if halt or len(cls.bbs_graph[blk]) == 0:
            final_states.extend(emul_states)
        for state_item in emul_states:
            for type in cls.bbs_graph[blk]:
                if isinstance(state_item, dict) and type in state_item:
                    state = state_item[type]
                    solver = Solver()
                    solver.add(*state.constraints)
                    if sat == solver.check():
                        cls.visit(state, has_ret, cls.bbs_graph[blk][type], final_states, vis)
                else:
                    cls.visit(state_item, has_ret, cls.bbs_graph[blk][type], final_states, vis)


