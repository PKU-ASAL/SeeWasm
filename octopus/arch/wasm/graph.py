import copy

from z3 import *
from collections import defaultdict, deque
from octopus.arch.wasm.utils import ask_user_input, bcolors


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
    _bbs_graph = defaultdict(lambda: defaultdict(str))  # nested dict
    _rev_bbs_graph = defaultdict(lambda : defaultdict(str))
    _loop_maximum_rounds = 5
    _wasmVM = None
    manual_guide = False

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
    def rev_bbs_graph(cls):
        return cls._rev_bbs_graph

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
        # sort the edges, according to the edge.from and edge.to
        # or the order of br_table branches will be random, the true_0 will not corrspond to the nearest block
        # TODO quite a huge overhead, try another way
        edges = sorted(edges, key=lambda x: (x.node_from, x.node_to))
        type_ids = defaultdict(lambda: defaultdict(int))
        for edge in edges:
            # there are four types of edges:
            # ['unconditional', 'fallthrough', 'conditional_true', 'conditional_false']
            node_from, node_to, edge_type = edge.node_from, edge.node_to, edge.type
            # we have to make the value as a list as the br_table may have multiple conditional_true branches
            ty = edge_type + '_' + str(type_ids[node_from][edge_type])
            cls.bbs_graph[node_from][ty] = node_to
            cls.rev_bbs_graph[node_to][ty] = node_from
            type_ids[node_from][edge_type] += 1

        # goal 1: append those single node into the bbs_graph
        # goal 2: initialize bb_to_instructions
        bbs = cfg.basicblocks
        for bb in bbs:
            # goal 1
            bb_name = bb.name
            if bb_name not in cls.bbs_graph:
                cls.bbs_graph[bb_name] = defaultdict(str)
            # goal 2
            cls.bb_to_instructions[bb_name] = bb.instructions

    # entry to analyze a file
    def traverse(self):
        for entry_func in self.entries:
            self.final_states[entry_func] = self.traverse_one(entry_func)

    @classmethod
    def traverse_one(cls, func, state=None, has_ret=None):
        func = cls.wasmVM.get_wasm_func_name(func)
        param_str, return_str = cls.wasmVM.get_signature(func)
        if state is None:
            state, has_ret = cls.wasmVM.init_state(
                func, param_str, return_str, [])

        # switch the state from caller to callee
        caller_func_name = state.current_func_name
        state.current_func_name = cls.wasmVM.cfg.get_function(func).name
        # retrieve all the relevant basic blocks
        entry_func_bbs = cls.func_to_bbs[func]
        # filter out the entry basic block and corresponding instructions
        entry_bb = list(filter(lambda bb: bb[-2:] == '_0', entry_func_bbs))[0]

        blks = entry_func_bbs
        intervals = cls.intervals_gen(entry_bb, blks, cls.rev_bbs_graph, cls.bbs_graph)
        vis = defaultdict(int)
        heads = {v: head for head in intervals for v in intervals[head]}
        _, final_states = cls.test_visit([state], has_ret, entry_bb, heads, vis)
        # restore the caller func
        state.current_func_name = caller_func_name
        return final_states

    @classmethod
    def can_cut(cls, type, state):
        if isinstance(state, dict):
            if type.startswith('conditional_'):
                if type in state:
                    state = state[type]
                    solver = Solver()
                    solver.add(*state.constraints)
                    if sat != solver.check():
                        return True
        return False

    @classmethod
    def intervals_gen(cls, blk, blk_lis, revg, g):
        intervals = {}
        nodes = set(blk_lis)
        que = deque([blk])
        while que:
            u = que.popleft()
            new_interval = {u}
            while True:
                succs = set([g[v][t] for v in new_interval for t in g[v]])
                succs = succs - new_interval
                ext = set()
                for v in succs:
                    prevs = set([revg[v][t] for t in revg[v]])
                    if prevs <= new_interval:
                        ext.add(v)
                new_interval |= ext
                if not ext:
                    break
            nodes = nodes - new_interval
            new_header = set()
            for v in nodes:
                prevs = set([revg[v][t] for t in revg[v]])
                if not prevs.isdisjoint(new_interval):
                    new_header.add(v)
            que.extend(list(new_header))
            intervals[u] = new_interval
        return intervals

    @classmethod
    def test_visit(cls, states, has_ret, blk, heads, vis, guided=False, prev=None):
        vis[prev] = True
        cnt = defaultdict(int) # could be replaced with weights
        que = deque([(states, has_ret, blk)])
        final_states = []
        response_to = set()
        while que:
            state, has_ret, u = que.popleft()
            nlist = cls.bbs_graph[u]
            if blk != heads[u]:
                new_response_to, emul_states = cls.test_visit(state, has_ret, u, heads, vis, guided, blk)
                nlist = {p[0]: p[1] for p in new_response_to if heads[p[1]] == blk}
                new_response_to -= {(p, nlist[p]) for p in nlist}
                response_to = response_to | new_response_to
            else:
                _, emul_states = cls.wasmVM.emulate_basic_block(state, has_ret, cls.bb_to_instructions[u])
            if guided:
                # show how many possible states here, and ask the user to choose one
                print(
                    f"\n[+] Currently, there are {bcolors.WARNING}{len(emul_states)}{bcolors.ENDC} possible state(s) here")
                if len(emul_states) == 1:
                    print(
                        f"[+] Enter {bcolors.WARNING}'i'{bcolors.ENDC} to show its information, or directly press {bcolors.WARNING}'enter'{bcolors.ENDC} to go ahead")
                    state_index = ask_user_input(
                        emul_states, isbr=False, onlyone=True)
                else:
                    print(
                        f"[+] Please choose one to continue the following emulation (1 -- {len(emul_states)})")
                    print(
                        f"[+] You can add an 'i' to illustrate information of the corresponding state (e.g., '1 i' to show the first state's information)")
                    state_index = ask_user_input(
                        emul_states, isbr=False)  # 0 for state, is a flag
                state_item = emul_states[state_index]
                emul_states = [state_item]

            response_to |= {(ty, heads[nlist[ty]]) for ty in nlist if vis[heads[nlist[ty]]]}
            for state_item in emul_states:
                avail_br = list(filter(lambda ty: not cls.can_cut(ty, state_item), nlist))
                if guided:
                    print(
                        f"\n[+] Currently, there are {len(avail_br)} possible branch(es) here: {bcolors.WARNING}{avail_br}{bcolors.ENDC}")
                    if len(avail_br) == 1:
                        print(
                            f"[+] Enter {bcolors.WARNING}'i'{bcolors.ENDC} to show its information, or directly press {bcolors.WARNING}'enter'{bcolors.ENDC} to go ahead")
                        avail_br = [ask_user_input(
                            emul_states, isbr=True, onlyone=True, branches=avail_br, state_item=state_item)]
                    else:
                        print(
                            f"[+] Please choose one to continue the following emulation (T (conditional true), F (conditional false), f (fallthrough), u (unconditional))")
                        print(
                            f"[+] You can add an 'i' to illustrate information of your choice (e.g., 'T i' to show the basic block if you choose to go to the true branch)")
                        avail_br = [ask_user_input(
                            emul_states, isbr=True, branches=avail_br, state_item=state_item)]
                flag = True
                for ty in avail_br:
                    v = nlist[ty]
                    state = state_item[ty] if isinstance(state_item, dict) else state_item
                    if (heads[v] == heads[blk] or heads[u] == heads[blk]) and (cnt[v] < cls._loop_maximum_rounds and not vis[heads[v]]):
                        cnt[v] += 1
                        que.append(([copy.deepcopy(state)], has_ret, v))
                        flag = False
                if flag:
                    final_states.append(copy.deepcopy(state_item['conditional_false_0'] if isinstance(state_item, dict) else state_item))
        vis[prev] = False
        return response_to, final_states