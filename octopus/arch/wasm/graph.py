import copy
import logging
import re
from collections import defaultdict, deque
from functools import partial, partialmethod
from queue import LifoQueue, PriorityQueue, SimpleQueue

from joblib import Parallel, delayed
from loky import wrap_non_picklable_objects
from octopus.arch.wasm.exceptions import DSLParseError
from octopus.arch.wasm.utils import Configuration, ask_user_input, bcolors
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


def default_cnt():
    return defaultdict(lambda :65536)


class Graph:
    _func_to_bbs = {}
    _bb_to_instructions = {}
    _bbs_graph = defaultdict(lambda: defaultdict(str))  # nested dict
    _rev_bbs_graph = defaultdict(lambda: defaultdict(str))
    _loop_maximum_rounds = 50
    _workers = 2
    _wasmVM = None
    manual_guide = False
    _user_dsl = None

    def __init__(self, funcs):
        self.entries = funcs
        self.final_states = {func: None for func in funcs}

    @classproperty
    def workers(cls):
        return cls._workers

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
            cls.func_to_bbs[func_name] = [bb.name for bb in func_bbs]

        # adjacent graph for basic blocks, like:
        # {'block_3_0': ['block_3_6', 'block_3_9']}
        edges = cfg.edges
        # sort the edges, according to the edge.from and edge.to
        # or the order of br_table branches will be random, the true_0 will not corrspond to the nearest block
        # TODO quite a huge overhead, try another way
        edges = sorted(edges, key=lambda x: (
            x.node_from, int(x.node_to[x.node_to.rfind('_')+1:], 16)))
        type_ids = defaultdict(lambda: defaultdict(int))
        type_rev_ids = defaultdict(lambda: defaultdict(int))
        for edge in edges:
            # there are four types of edges:
            # ['unconditional', 'fallthrough', 'conditional_true', 'conditional_false']
            node_from, node_to, edge_type = edge.node_from, edge.node_to, edge.type
            # we append a number after the edge type as the br_table may have multiple conditional_true branches
            if not edge_type[-1].isdigit():
                numbered_edge_type = edge_type + '_' + \
                    str(type_ids[node_from][edge_type])
            else:
                numbered_edge_type = edge_type
            cls.bbs_graph[node_from][numbered_edge_type] = node_to
            numbered_rev_edge_type = edge_type + '_' + \
                str(type_rev_ids[node_to][edge_type])
            cls.rev_bbs_graph[node_to][numbered_rev_edge_type] = node_from
            type_ids[node_from][edge_type] += 1
            type_rev_ids[node_to][edge_type] += 1

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

    @classmethod
    def parse_dsl(cls, user_dsl):
        """
        This function is used to parse user-given dsl:
        step 1: extract relevant blocks and insert into a json file;
        step 2: insert the DSL into corresponding block
        """

        def _extract_blocks_by_funcname(target_func_name):
            target_blocks = cls.func_to_bbs.get(target_func_name, None)
            if not target_blocks:
                # if it cannot be accessed by name directly
                for func_offset, func_name in cls.wasmVM.func_index2func_name.items():
                    if target_func_name == func_name:
                        # if func_name is target_func_name, extract the blocks
                        target_blocks = cls.func_to_bbs["$func" +
                                                        str(func_offset)]
                        break
            return target_blocks

        def all_descendant(node):
            visited = set()
            q = deque()
            q.append(node)
            while q:
                tmp = q.popleft()
                if tmp not in visited:
                    visited.add(tmp)
                else:
                    continue
                for edge_type, direct_descendant in cls.bbs_graph[tmp].items():
                    if edge_type == "unconditional_0" and direct_descendant not in visited:
                        visited.add(direct_descendant)
                        continue
                    q.append(direct_descendant)
            return visited

        def nearest_common(node1, node2):
            node1_descendant = all_descendant(node1)
            node2_descendant = all_descendant(node2)
            intersected = node1_descendant.intersection(node2_descendant)
            if not intersected:
                return None
            else:
                # sort
                intersected = list(intersected)
                intersected = [int(i[i.rfind('_')+1:], 16)
                               for i in intersected]
                intersected.sort()
                intersected = [hex(i)[2:] for i in intersected]
                return intersected[0]

        def _analyze_nesting(head, depth):
            if len(counter) < depth:
                counter.append(0)
            q = deque()
            q.append(head)
            while q:
                tmp = q.popleft()
                if tmp in main_branch:
                    return
                main_branch.add(tmp)
                if len(cls.bbs_graph[tmp]) == 0:
                    return
                elif len(cls.bbs_graph[tmp]) == 1:
                    q.append(list(cls.bbs_graph[tmp].values())[0])
                elif len(cls.bbs_graph[tmp]) == 2:
                    false_node, true_node = cls.bbs_graph[tmp][
                        'conditional_false_0'], cls.bbs_graph[tmp]['conditional_true_0']
                    nc = nearest_common(false_node, true_node)
                    if nc:  # if then structure
                        nc = head[:head.rfind('_')] + '_' + nc
                        result[false_node] = '_'.join(
                            [str(i) for i in counter])
                        counter[depth-1] += 1
                        result[true_node] = '_'.join([str(i) for i in counter])
                        counter[depth-1] += 1
                        q.append(nc)
                        need_run.append(false_node)
                        need_run.append(true_node)
                    else:  # loop structure
                        result[false_node] = '_'.join(
                            [str(i) for i in counter])
                        counter[depth-1] += 1
                        q.append(true_node)
                        need_run.append(false_node)
                else:
                    raise DSLParseError

        # step 1
        for dsl_item in user_dsl:
            dsl_item["blocks"] = list()
            # if user use regex
            scope_is_regex = dsl_item.get('regex', False)
            if scope_is_regex:
                target_func_name_re = dsl_item["scope"]
                r = re.compile(target_func_name_re)
                target_func_names = list(
                    filter(r.match, cls.wasmVM.func_index2func_name.values()))
            else:
                target_func_names = [dsl_item["scope"]]

            for target_func_name in target_func_names:
                target_blocks = _extract_blocks_by_funcname(
                    target_func_name)
                if target_blocks:
                    if "nesting" in dsl_item.keys():
                        # initialize for each function
                        counter = []  # depth indicator
                        result = dict()
                        main_branch = set()  # used to terminate recursive _analyze_nesting
                        need_run = deque()

                        # we need run the current func's first block
                        need_run.append(target_blocks[0])
                        while need_run:
                            tmp = need_run.popleft()
                            if tmp in result:
                                counter = [int(i)
                                           for i in result[tmp].split('_')]
                            _analyze_nesting(tmp, len(counter)+1)

                        # parse the result
                        concerned_dsl = '_'.join(
                            [str(i) for i in dsl_item["nesting"]])
                        for tmp_block, extracted_dsl in result.items():
                            if extracted_dsl == concerned_dsl:
                                dsl_item["blocks"].append([tmp_block])
                                break
                    else:
                        dsl_item["blocks"].append(target_blocks)

        cls.wasmVM.user_dsl = user_dsl

        # step 2
        for dsl_item in user_dsl:
            # if there is regex, there may be more than one matched funcs
            # i.e., more than one set of blocks
            for func_blocks in dsl_item['blocks']:
                # we insert the dsl to the first block
                target_block = func_blocks[0]
                # iterate the cfg to find the target block and insert the dsl
                for cfg_block in cls.wasmVM.cfg.basicblocks:
                    if cfg_block.name == target_block:
                        tmp_dsl_item = copy.deepcopy(dsl_item)
                        # remove 'blocks' field
                        tmp_dsl_item.pop('blocks')
                        cfg_block.dsl.append(tmp_dsl_item)
                        break

    def traverse(self):
        for entry_func in self.entries:
            self.final_states[entry_func] = self.traverse_one(entry_func)
            # final states of all feasible paths for the given program
            print(
                f'There are total {len(self.final_states[entry_func])} state(s):')
            for i, final_state in enumerate(self.final_states[entry_func]):
                s = Solver()
                s.add(final_state.constraints)
                if sat == s.check():
                    print(
                        f'For state{i}, return with {final_state.symbolic_stack}, a set of possible input: {s.model()}', end='\n', flush=True)
                else:
                    print(
                        f'For state{i}, return with {final_state.symbolic_stack}, which is unsat', end='\n', flush=True)

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
        if Configuration.get_algo() == 'dfs':
            final_states = cls.algo_dfs(entry_bb, state, has_ret, blks)
        elif Configuration.get_algo() == 'interval':
            final_states = cls.algo_interval(entry_bb, state, has_ret, blks)
        # restore the caller func
        state.current_func_name = caller_func_name
        return final_states

    @classmethod
    def algo_dfs(cls, entry, state, has_ret, blks=None):
        vis = defaultdict(int)
        circles = set()
        cls.calc_circle(entry, vis, circles)
        vis = defaultdict(int)
        final_states = cls.visit(
            [state], has_ret, entry, vis, circles, cls.manual_guide)
        return final_states

    @classmethod
    def extract_edges(cls, entry):
        edges = set()
        que = deque([entry])
        while que:
            u = que.popleft()
            for br in cls.bbs_graph[u]:
                v = cls.bbs_graph[u][br]
                if (u, v) not in edges:
                    edges.add((u, v))
                    que.append(v)
        nds = set()
        for edge in edges:
            print(edge[0], edge[1])
            nds.add(edge[0])
            nds.add(edge[1])
        for nd in nds:
            print(nd+':', end='')
            for inst in cls.bb_to_instructions[nd]:
                print(inst, end=' ')
            print()

    @classmethod
    def algo_interval(cls, entry, state, has_ret, blks):
        intervals = cls.intervals_gen(
            entry, blks, cls.rev_bbs_graph, cls.bbs_graph)
        heads = {v: head for head in intervals for v in intervals[head]}
        scores = defaultdict(int)
        score_func = partial(cls.priority_score, scores=scores)
        heads['return'] = 'return'
        final_states = cls.visit_interval(
            [state], has_ret, entry, heads, score_func, cls.manual_guide, "return")
        return final_states["return"]

    @classmethod
    def sat_cut(cls, state):
        state.constraints = list(set(state.constraints))
        solver = Solver()
        solver.add(*state.constraints)
        return unsat == solver.check()

    @classmethod
    def can_cut(cls, type, state):
        if isinstance(state, dict):
            if type not in state:
                return True
            if type.startswith('conditional_'):
                if type in state:
                    return cls.sat_cut(state[type])
        elif cls.sat_cut(state):
            return True
        return False

    @classmethod
    def calc_circle(cls, blk, vis, circles):
        '''determine if there is a circle in CFG, add the circle's entry block into the `circles`'''
        if vis[blk] == 1 and len(cls.bbs_graph[blk]) >= 2:  # br_if and has visited
            circles.add(blk)
            return
        vis[blk] = 1
        for edge_type in cls.bbs_graph[blk]:
            cls.calc_circle(cls.bbs_graph[blk][edge_type], vis, circles)
        vis[blk] = 0

    @classmethod
    def visit(cls, states, has_ret, blk, vis, circles, guided, prev=None, branches=None):
        vis[prev] += 1
        instructions = cls.bb_to_instructions[blk]
        _, emul_states = cls.wasmVM.emulate_basic_block(
            states, has_ret, instructions)
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

        specify = branches is not None
        adj_bb = cls.bbs_graph[blk]
        if branches:
            branches = [br for br in adj_bb if br.startswith(branches[0])]
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
                        f"[+] Please choose one to continue the following emulation (T (conditional true), F (conditional false), f (fallthrough), current_block (unconditional))")
                    print(
                        f"[+] You can add an 'i' to illustrate information of your choice (e.g., 'T i' to show the basic block if you choose to go to the true branch)")
                    avail_br = [ask_user_input(
                        emul_states, isbr=True, branches=branches, state_item=state_item)]

            for type in avail_br:
                nxt_blk = cls.bbs_graph[blk][type]
                state = state_item[type] if isinstance(
                    state_item, dict) else state_item
                if not guided:
                    if vis[nxt_blk] > 0:
                        final_states.append(state)
                        continue
                    if nxt_blk in circles:
                        enter_states = [copy.deepcopy(state)]
                        for i in range(cls.loop_maximum_rounds):
                            exit_states = cls.visit(enter_states, has_ret, nxt_blk, vis, circles, guided, blk,
                                                    ['conditional_true'])
                            print(exit_states[0])
                            final_states.extend(exit_states)
                            enter_states = cls.visit(enter_states, has_ret, nxt_blk, vis, circles, guided, blk,
                                                     ['conditional_false'])
                        exit_states = cls.visit(
                            enter_states, has_ret, nxt_blk, vis, circles, guided, blk, ['conditional_true'])
                        final_states.extend(exit_states)
                    else:
                        exit_states = cls.visit(
                            [copy.deepcopy(state)], has_ret, nxt_blk, vis, circles, guided, blk)
                        final_states.extend(exit_states)
                else:
                    final_states.extend(
                        cls.visit([copy.deepcopy(state)], has_ret, nxt_blk, vis, circles, guided, blk))
        vis[prev] -= 1
        # TODO: Fix the Bug : may return a dict state, which is illegal.
        return final_states if specify else emul_states

    @classmethod
    def intervals_gen(cls, blk, blk_lis, revg, g):
        intervals = {}
        nodes = set(blk_lis)
        que = deque([blk])
        while que:
            current_block = que.popleft()
            new_interval = {current_block}
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
            intervals[current_block] = new_interval
        return intervals

    @classmethod
    def priority_score(cls, data_item, scores):
        states, blk, heads, cnt, weight = data_item
        br = ('conditional_false_0', 'block_1_7b')
        head = heads['block_1_7b']
        return weight[head][br] - cnt[head][br]

    @classmethod
    def visit_interval(cls, states, has_ret, blk, heads, score_func, guided=False, prev=None):
        '''`blk` is the head of an interval'''
        # `cnt` is the traversed times
        # `weights` is the upper bound of how many times the edge can be traversed
        vis = deque([prev])
        cnt, weights = defaultdict(lambda :defaultdict(int)), defaultdict(default_cnt)
        que = PriorityQueue()
        # que = SimpleQueue()
        # TODO:parallel sync_que = Queue()
        score = score_func((states, blk, heads, cnt, weights))
        que.put((score, (states, blk, blk, vis, cnt, weights)))
        final_states = defaultdict(list)

        def producer():
            """
            TODO:parallel
            while not que.empty():
                score, (state, current_block, cur_head, vis, cnt, weights) = que.get()
                sync_que.put((score, (state, current_block, cur_head, vis, cnt, weights)))
            """
            while not que.empty():
                yield que.get()

        @wrap_non_picklable_objects
        def consumer(item):
            score, (state, current_block, cur_head, vis, cnt, weights) = item
            succs_list = cls.bbs_graph[current_block].items()
            flag = False
            if len(succs_list) >= 2:  # this part should be encapsulated into a method
                for br_dest_pair in succs_list:
                    if weights[cur_head][br_dest_pair] == 65536 and br_dest_pair[0] == 'conditional_false_0':
                        # put weights on edges, which could be move to preprocessing part
                        # for true branch, one more execution, because the loop needs to jump out
                        weights[cur_head][br_dest_pair] = cls.loop_maximum_rounds
            # two intervals, use DFS to traverse between intervals
            if cur_head != heads[current_block]:
                new_vis = copy.deepcopy(vis)
                new_vis.append(cur_head)
                # que.append((score, (state, current_block, current_block, vis, cnt, weights)))
                que.put(
                    (score, (state, current_block, current_block, new_vis, cnt, weights)))
                return flag, []
            # current block is still in the same interval, emulate it directly
            else:
                _, emul_states = cls.wasmVM.emulate_basic_block(
                    state, has_ret, cls.bb_to_instructions[current_block])
            if len(succs_list) == 0:
                emul_states = emul_states[cur_head] if isinstance(
                    emul_states, dict) else emul_states
                rets = [s.symbolic_stack[0].as_long() for s in emul_states]
                flag = rets[0] == 3
                return flag, emul_states
            succs_list = set(filter(lambda p: (heads[p[1]] == cur_head or heads[current_block] == cur_head) and
                                              (cnt[cur_head][p] < weights[cur_head][p]), succs_list))
            avail_br = {}
            for edge_type, next_block in succs_list:
                emul_states = emul_states[next_block] if isinstance(
                    emul_states, dict) else emul_states
                # TODO give a description here
                valid_state = list(map(lambda s: s[edge_type] if isinstance(
                    s, dict) else s, filter(lambda s: not cls.can_cut(edge_type, s), emul_states)))
                if len(valid_state) > 0:
                    avail_br[(edge_type, next_block)] = copy.deepcopy(valid_state)
            if guided:
                print(
                    f"\n[+] Currently, there are {len(avail_br)} possible branch(es) here: {bcolors.WARNING}{avail_br}{bcolors.ENDC}")
                if len(avail_br) == 1:
                    print(
                        f"[+] Enter {bcolors.WARNING}'i'{bcolors.ENDC} to show its information, or directly press {bcolors.WARNING}'enter'{bcolors.ENDC} to go ahead")
                    br_idx = ask_user_input(
                        emul_states, isbr=True, onlyone=True, branches=avail_br)
                else:
                    print(
                        f"[+] Please choose one to continue the following emulation (T (conditional true), F (conditional false), f (fallthrough), current_block (unconditional))")
                    print(
                        f"[+] You can add an 'i' to illustrate information of your choice (e.g., 'T i' to show the basic block if you choose to go to the true branch)")
                    br_idx = ask_user_input(
                        emul_states, isbr=True, branches=avail_br)
                emul_states = avail_br[br_idx]
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
                avail_br = {br_idx: [state_item]}

            for br in avail_br:
                (edge_type, next_block), valid_state = br, avail_br[br]
                new_w = copy.deepcopy(weights)
                new_cnt = copy.deepcopy(cnt)
                new_cnt[cur_head][br] += 1
                new_score = score_func((valid_state, next_block, heads, new_cnt, new_w))
                if heads[next_block] in vis:
                    new_vis = copy.deepcopy(vis)
                    while new_vis:
                        h = new_vis.pop()
                        if h == heads[next_block]:
                            break
                        new_cnt.pop(h)
                        new_w.pop(h)
                    que.put((new_score, (valid_state, next_block,
                            heads[next_block], new_vis, new_cnt, new_w)))
                else:
                    que.put((new_score, (valid_state, next_block,
                            cur_head, vis, new_cnt, new_w)))
            return flag, []
        for item in producer():
            f, l = consumer(item)
            final_states['return'].extend(l)
            if f:
                break
        """TODO: parallel
        with Parallel(n_jobs=cls.workers, verbose=100) as parallel:
            finals = []
            while not que.empty():
                res = parallel(delayed(consumer)(item) for item in producer())
                finals.extend([item for r in res for item in r])
            final_states['return'].extend(finals)
        """
        return final_states
