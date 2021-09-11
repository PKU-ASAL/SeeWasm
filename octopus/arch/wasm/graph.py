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
        final_states = cls.algo_interval(entry_bb, state, has_ret, blks)
        # restore the caller func
        state.current_func_name = caller_func_name
        return final_states

    @classmethod
    def algo_dfs(cls, entry, state, has_ret, blks=None):
        vis = defaultdict(int)
        circles = set()
        cls.pre(entry, vis, circles)
        vis = defaultdict(int)
        final_states = cls.visit([state], has_ret, entry, vis, circles, cls.manual_guide)
        return final_states

    @classmethod
    def algo_interval(cls, entry, state, has_ret, blks):
        intervals = cls.intervals_gen(entry, blks, cls.rev_bbs_graph, cls.bbs_graph)
        vis = defaultdict(int)
        heads = {v: head for head in intervals for v in intervals[head]}
        _, final_states = cls.test_visit([state], has_ret, entry, heads, vis, cls.manual_guide, entry)
        return final_states[entry]

    @classmethod
    def sat_cut(cls, state):
        solver = Solver()
        solver.add(*state.constraints)
        return sat != solver.check()

    @classmethod
    def can_cut(cls, type, state):
        if isinstance(state, dict):
            if type not in state:
                return True
            if type.startswith('conditional_'):
                if type in state:
                    return cls.sat_cut(state[type])
        elif type.startswith('conditional_'):
            return True
        return False

    @classmethod
    def pre(cls, blk, vis, circles):
        if vis[blk] == 1 and len(cls.bbs_graph[blk]) >= 2:  # br_if and has visited
            circles.add(blk)
            return
        vis[blk] = 1
        for ty in cls.bbs_graph[blk]:
            cls.pre(cls.bbs_graph[blk][ty], vis, circles)
        vis[blk] = 0

    @classmethod
    def visit(cls, states, has_ret, blk, vis, circles, guided, prev=None, branches=None):
        vis[prev] += 1
        instructions = cls.bb_to_instructions[blk]
        _, emul_states = cls.wasmVM.emulate_basic_block(states, has_ret, instructions)
        final_states = []
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

        if not branches:
            branches = cls.bbs_graph[blk]
        for state_item in emul_states:
            avail_br = []
            for type in branches:
                if not cls.can_cut(type, state_item):
                    avail_br.append(type)
            if guided:
                print(
                    f"\n[+] Currently, there are {len(avail_br)} possible branch(es) here: {bcolors.WARNING}{avail_br}{bcolors.ENDC}")
                if len(avail_br) == 1:
                    print(
                        f"[+] Enter {bcolors.WARNING}'i'{bcolors.ENDC} to show its information, or directly press {bcolors.WARNING}'enter'{bcolors.ENDC} to go ahead")
                    avail_br = [ask_user_input(
                        emul_states, isbr=True, onlyone=True, branches=branches, state_item=state_item)]
                else:
                    print(
                        f"[+] Please choose one to continue the following emulation (T (conditional true), F (conditional false), f (fallthrough), u (unconditional))")
                    print(
                        f"[+] You can add an 'i' to illustrate information of your choice (e.g., 'T i' to show the basic block if you choose to go to the true branch)")
                    avail_br = [ask_user_input(
                        emul_states, isbr=True, branches=branches, state_item=state_item)]

            for type in avail_br:
                nxt_blk = cls.bbs_graph[blk][type]
                state = state_item[type] if isinstance(state_item, dict) else state_item
                if not guided:
                    if vis[nxt_blk] > 0:
                        final_states.append(state)
                        continue
                    if nxt_blk in circles:
                        enter_states = [copy.deepcopy(state)]
                        for i in range(cls.loop_maximum_rounds):
                            exit_states = cls.visit(enter_states, has_ret, nxt_blk, vis, circles, guided, blk,
                                                    ['conditional_true_0'])
                            final_states.extend(exit_states)
                            enter_states = cls.visit(enter_states, has_ret, nxt_blk, vis, circles, guided, blk,
                                                     ['conditional_false_0'])
                        exit_states = cls.visit(enter_states, has_ret, nxt_blk, vis, circles, guided, blk, ['conditional_true_0'])
                        final_states.extend(exit_states)
                    else:
                        exit_states = cls.visit([copy.deepcopy(state)], has_ret, nxt_blk, vis, circles, guided, blk)
                        final_states.extend(exit_states)
                else:
                    final_states.extend(
                        cls.visit([copy.deepcopy(state)], has_ret, nxt_blk, vis, circles, guided, blk))
        vis[prev] -= 1
        return final_states if len(branches) > 0 else emul_states

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
        cnt, weights = defaultdict(int), defaultdict(int)
        que = deque([(states, blk)])
        final_states, response_to = defaultdict(list), defaultdict(set)
        while que:
            state, u = que.popleft()
            nlist = cls.bbs_graph[u].items()
            if len(nlist) >= 2: # this part should be encapsulated into a method
                for edge in nlist:
                    if weights[edge] == 0:
                        # put weights on edges, which could be move to preprocessing part
                        if edge[0] == 'conditional_true_0': # for true branch, one more execution, because the loop needs to jump out
                            weights[edge] = cls.loop_maximum_rounds + 1
                        else: # for false branch, do maximum rounds' execution
                            weights[edge] = cls.loop_maximum_rounds
            if blk != heads[u]:
                new_response_to, ret_states = cls.test_visit(state, has_ret, u, heads, vis, guided, blk)
                nlist = set().union(*[new_response_to[v] for v in new_response_to if heads[v] == blk])
                emul_states = defaultdict(list)
                emul_states.update({v: ret_states[v] for v in ret_states if heads[v] == blk})
                for v in ret_states:
                    if heads[v] != blk and vis[heads[v]]:
                        final_states[v].extend(ret_states[v])
                        response_to[v] |= new_response_to[v]
            else:
                _, emul_states = cls.wasmVM.emulate_basic_block(state, has_ret, cls.bb_to_instructions[u])
            nlist = set(filter(lambda p: (heads[p[1]] == blk or heads[u] == blk) and (weights[p] == 0 or cnt[p] < weights[p]), nlist))
            if len(nlist) == 0:
                emul_states = emul_states[blk] if isinstance(emul_states, dict) else emul_states
                final_states[prev].extend(emul_states)
                continue
            avail_br = {}
            for ty, v in nlist:
                emul_states = emul_states[v] if isinstance(emul_states, dict) else emul_states
                valid_state = list(map(lambda s: s[ty] if isinstance(s, dict) else s, filter(lambda s: not cls.can_cut(ty, s), emul_states)))
                if len(valid_state) > 0:
                    avail_br[(ty, v)] = valid_state
            if guided:
                print(
                    f"\n[+] Currently, there are {len(avail_br)} possible branch(es) here: {bcolors.WARNING}{avail_br}{bcolors.ENDC}")
                if len(avail_br) == 1:
                    print(
                        f"[+] Enter {bcolors.WARNING}'i'{bcolors.ENDC} to show its information, or directly press {bcolors.WARNING}'enter'{bcolors.ENDC} to go ahead")
                    br_idx = ask_user_input(emul_states, isbr=True, onlyone=True, branches=avail_br)
                else:
                    print(
                        f"[+] Please choose one to continue the following emulation (T (conditional true), F (conditional false), f (fallthrough), u (unconditional))")
                    print(
                        f"[+] You can add an 'i' to illustrate information of your choice (e.g., 'T i' to show the basic block if you choose to go to the true branch)")
                    br_idx = ask_user_input(emul_states, isbr=True, branches=avail_br)
                emul_states = avail_br[br_idx]
                print(
                    f"\n[+] Currently, there are {bcolors.WARNING}{len(emul_states)}{bcolors.ENDC} possible state(s) here")
                if len(emul_states) == 1:
                    print(
                        f"[+] Enter {bcolors.WARNING}'i'{bcolors.ENDC} to show its information, or directly press {bcolors.WARNING}'enter'{bcolors.ENDC} to go ahead")
                    state_index = ask_user_input(emul_states, isbr=False, onlyone=True)
                else:
                    print(
                        f"[+] Please choose one to continue the following emulation (1 -- {len(emul_states)})")
                    print(
                        f"[+] You can add an 'i' to illustrate information of the corresponding state (e.g., '1 i' to show the first state's information)")
                    state_index = ask_user_input(
                        emul_states, isbr=False)  # 0 for state, is a flag
                state_item = emul_states[state_index]
                avail_br = {br_idx: [state_item]}
            for br in avail_br:
                (ty, v), valid_state = br, avail_br[br]
                if vis[heads[v]]:
                    final_states[v].extend(valid_state)
                    response_to[v].add(br)
                else:
                    cnt[br] += 1
                    que.append((valid_state, v))
        vis[prev] = False
        return response_to, final_states
