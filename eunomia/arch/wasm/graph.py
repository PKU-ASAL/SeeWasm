import copy
import logging
from collections import defaultdict, deque
from queue import PriorityQueue

from eunomia.arch.wasm.configuration import Configuration, bcolors
from eunomia.arch.wasm.exceptions import (ProcFailTermination,
                                          ProcSuccessTermination)
from eunomia.arch.wasm.instruction import WasmInstruction
from eunomia.arch.wasm.instructions.ControlInstructions import C_LIBRARY_FUNCS
from eunomia.arch.wasm.solver import SMTSolver
from eunomia.arch.wasm.utils import (ask_user_input,
                                     readable_internal_func_name,
                                     state_choose_info, write_result)
from eunomia.core.basicblock import BasicBlock
from eunomia.core.edge import EDGE_FALLTHROUGH, Edge
from z3 import unsat

# if a state belongs to one of these functions, it means that
# the state is returned normally / unexpectedly.
# we should output these states to the 'result' folder
VALUABLE_FUNC_STATE_SET = {'main'}


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
    return defaultdict(lambda: 65536)


class Graph:
    """
    A Graph class, include several vital properties.
    Also, it is used to traverse the CFG according to the algorithm.

    Properties:
        _func_to_bbs: a mapping, from function's name to its included basic blocks (wrapped in a list);
        _bb_to_instructions: a mappming, from basic block's name to its included instruction objects (wrapped in a list);
        _aes_func: a mapping, not clear;
        _bbs_graph: a mapping, from basic block's name to a mapping, from edge type to its corresponding pointed to basic block's name;
        _rev_bbs_graph: same as above, but its reversed;
        _workers: reserved, for multi-processing;
        manual_guide: indicate if the path finding is guided by user manually;
    """
    _func_to_bbs = defaultdict(list)
    _bb_to_instructions = defaultdict(list)
    _aes_func = defaultdict(set)
    _bbs_graph = defaultdict(lambda: defaultdict(str))  # nested dict
    _rev_bbs_graph = defaultdict(lambda: defaultdict(str))

    _workers = 2
    _wasmVM = None
    manual_guide = False

    def __init__(self):
        self.entry = Configuration.get_entry()
        self.final_states = {self.entry: None}

    @classproperty
    def workers(cls):
        return cls._workers

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

    @classproperty
    def aes_func(cls):
        return cls._aes_func

    @classmethod
    def initialize(cls):
        """
        initialize these class properties
        """
        def init_func_to_bbs(cfg):
            """
            initialize the func_to_bbs structure
            """
            for func in cfg.functions:
                func_name, func_bbs = func.name, func.basicblocks
                cls.func_to_bbs[func_name] = [bb.name for bb in func_bbs]

        def init_bbs_graph(cfg):
            """
            initialize the bbs_graph and rev_bbs_graph structure
            """
            edges = cfg.edges
            # sort the edges, according to the edge.from and edge.to,
            # or the order of br_table branches will be random, the true_0 will not corrspond to the nearest block
            # TODO quite a huge overhead, try another way
            edges = sorted(edges, key=lambda x: (
                x.node_from, int(x.node_to.split('_')[2], 16)))

            type_ids = defaultdict(lambda: defaultdict(int))
            type_rev_ids = defaultdict(lambda: defaultdict(int))
            for edge in edges:
                node_from, node_to, edge_type = edge.node_from, edge.node_to, edge.type
                # we append a number after the edge type, because the br_table may have multiple conditional_true branches. See eunomia/arch/wasm/cfg.py
                if not edge_type[-1].isdigit():
                    # non-br_table case
                    numbered_edge_type = edge_type + '_' + \
                        str(type_ids[node_from][edge_type])
                    numbered_rev_edge_type = edge_type + '_' + \
                        str(type_rev_ids[node_to][edge_type])
                else:
                    # br_table case
                    numbered_edge_type = edge_type
                    numbered_rev_edge_type = edge_type
                cls.bbs_graph[node_from][numbered_edge_type] = node_to
                cls.rev_bbs_graph[node_to][numbered_rev_edge_type] = node_from
                type_ids[node_from][edge_type] += 1
                type_rev_ids[node_to][edge_type] += 1

            # append single nodes into the bbs_graph and rev_bbs_graph
            for bb in cfg.basicblocks:
                bb_name = bb.name
                if bb_name not in cls.bbs_graph:
                    cls.bbs_graph[bb_name] = defaultdict(str)
                if bb_name not in cls.rev_bbs_graph:
                    cls.rev_bbs_graph[bb_name] = defaultdict(str)

        def init_bb_to_instr(cfg):
            """
            initialize the bb_to_instructions
            """
            bbs = cfg.basicblocks
            for bb in bbs:
                cls.bb_to_instructions[bb.name] = bb.instructions

        def init_aes_func(cfg):
            """
            initialize the aes_func
            """
            bbs = cfg.basicblocks
            for bb in bbs:
                for instr in bb.instructions:
                    if instr.name == 'call':  # aes rules will be regarded as instrumented function calls
                        instr_operand = instr.operand_interpretation.split(' ')[
                            1]
                        try:
                            func_offset = int(instr_operand)
                        except ValueError:
                            func_offset = int(instr_operand, 16)
                        target_func = cls.wasmVM.ana.func_prototypes[func_offset]
                        func_name, _, _, _ = target_func
                        readable_name = readable_internal_func_name(
                            Configuration.get_func_index_to_func_name(), func_name)
                        # aes function's name is generated in "name$index" format.
                        if len(readable_name.split('$')) == 2:
                            cls.aes_func[bb.name].add(readable_name)

        def init_dummy_blocks(cfg):
            """
            Insert dummy entry and end before and aftr each function's cfg.
            Refer to: https://github.com/HNYuuu/Wasm-SE/issues/70

            Also update basicblocks in cfg, and class variables: bbs_graph, rev_bbs_graph and bb_to_instructions
            """
            # extract node with zero indegree and outdegree
            for func_name, bbs in cls.func_to_bbs.items():
                out_degree = {b: 0 for b in bbs}
                zero_outdegree = set()
                for b in bbs:
                    out_degree[b] += len(cls.bbs_graph[b])
                for b in bbs:
                    if out_degree[b] == 0:
                        zero_outdegree.add(b)

                assert zero_outdegree, "a function should have at least one exit point"

                dummy_end_block_offset = -1
                dummy_end_block_nature_offset = -1
                for bb in cfg.basicblocks:
                    if bb.name in zero_outdegree:
                        dummy_end_block_offset = max(
                            dummy_end_block_offset, bb.end_offset + 1)
                        dummy_end_block_nature_offset = max(
                            dummy_end_block_nature_offset, bb.end_instr.nature_offset + 1)
                dummy_end_block_offset_hex = str(
                    hex(dummy_end_block_offset)[2:])

                func_index = b.split('_')[1]
                # construct dummy end
                dummy_end = BasicBlock()
                end_ins = WasmInstruction(
                    1, 'nop', None, 0, b'\x0b', 0, 0, 'dummy end',
                    offset=dummy_end_block_offset,
                    nature_offset=dummy_end_block_nature_offset)
                dummy_end.instructions = [end_ins]
                dummy_end.start_offset = dummy_end_block_offset
                dummy_end.start_instr = end_ins
                dummy_end.name = f"block_{func_index}_{dummy_end_block_offset_hex}"
                dummy_end.end_instr = end_ins
                dummy_end.end_offset = end_ins.offset_end

                # insert dummy blocks into cfg
                for func in cfg.functions:
                    if func.name == func_name:
                        func.basicblocks += [dummy_end]
                        cls.func_to_bbs[func_name].append(dummy_end.name)
                        cls.bb_to_instructions[dummy_end.name] = dummy_end.instructions
                        break
                cfg.basicblocks += [dummy_end]

                # construct edges from original exit points to the dummy end block
                # and update class variables
                for i, exit in enumerate(zero_outdegree):
                    cfg.edges.append(
                        Edge(
                            exit, dummy_end.name,
                            EDGE_FALLTHROUGH))
                    cls.bbs_graph[exit][f"{EDGE_FALLTHROUGH}_{i}"] = dummy_end.name
                    cls.rev_bbs_graph[dummy_end.name][
                        f"{EDGE_FALLTHROUGH}_{i}"] = exit
                cls.bbs_graph[dummy_end.name] = defaultdict(str)

        def _update_edges(
                cfg, bb_name, succ_bb_name, entry_name, dummy_end_name):
            """
            Insert two edges: bb_name to entry_name, dummy_end_name to callee_bb_name
            Update corresponding variables in bbs_graph and rev_bbs_graph
            """
            # insert two edges into cfg.edges
            call_edge = Edge(
                bb_name, entry_name, EDGE_FALLTHROUGH)
            return_edge = Edge(
                dummy_end_name, succ_bb_name, EDGE_FALLTHROUGH)
            cfg.edges += [call_edge, return_edge]

            def find_max_fallthrough_edge_count(nested_dict, bb_name):
                edge_count = -1
                for e in nested_dict[bb_name].keys():
                    if e.startswith('fall'):
                        edge_count = max(edge_count, int(e.split('_')[1]))
                return edge_count + 1

            # update bbs_graph
            cls.bbs_graph[bb_name][
                f"fallthrough_{find_max_fallthrough_edge_count(cls.bbs_graph, bb_name)}"] = entry_name
            cls.bbs_graph[dummy_end_name][
                f"fallthrough_{find_max_fallthrough_edge_count(cls.bbs_graph, dummy_end_name)}"] = succ_bb_name
            # update rev_bbs_graph
            cls.rev_bbs_graph[entry_name][
                f"fallthrough_{find_max_fallthrough_edge_count(cls.rev_bbs_graph, entry_name)}"] = bb_name
            cls.rev_bbs_graph[succ_bb_name][
                f"fallthrough_{find_max_fallthrough_edge_count(cls.rev_bbs_graph, succ_bb_name)}"] = dummy_end_name

        def _remove_original_edge(cfg, bb_name):
            """
            Extract the successive block of bb_name, and return it.
            Also, remove the edge in edges, bbs_graph and rev_bbs_graph.
            """
            succ_bb_name = list(
                cls.bbs_graph[bb_name].values())[0]
            # remove the edge: (bb_name, callee_bb_name)
            cfg.edges = [e for e in cfg.edges if (
                e.node_from != bb_name or e.node_to != succ_bb_name)]
            # update the bbs_graph and rev_bbs_graph
            cls.bbs_graph = {bb: {e: callee_bb for e, callee_bb in cls.bbs_graph[bb].items(
            ) if (callee_bb != succ_bb_name or bb != bb_name)} for bb in cls.bbs_graph}
            cls.rev_bbs_graph = {callee_bb: {e: bb for e, bb in cls.rev_bbs_graph[callee_bb].items(
            ) if (bb != bb_name or callee_bb != succ_bb_name)} for callee_bb in cls.rev_bbs_graph}

            # convert these two as original data type
            cls.bbs_graph = defaultdict(
                lambda: defaultdict(str),
                cls.bbs_graph)
            cls.rev_bbs_graph = defaultdict(
                lambda: defaultdict(str),
                cls.rev_bbs_graph)

            return succ_bb_name

        def _update_xref(cfg, dummy_end_name, succ_bb_name, callee_op):
            """
            Append a tuple in the xref of the `nop` instruction who locates in dummy end.
            The tuple consists of: the next block's name, and its belonging function's name
            """
            for bb in cfg.basicblocks:
                if bb.name == dummy_end_name:
                    assert bb.end_instr.name == 'nop', f"{bb.name} does not end by 'nop'"
                    bb.end_instr.xref.append((succ_bb_name, callee_op))
                    break

        def link_dummy_blocks(cfg):
            """
            Remove edges after call, directly link it to the callee's dummy entry.
            Also link the dummy end to the next instruction of the call.
            Update edges in cfg, and bbs_graph and rev_bbs_graph in class
            """
            for bb in cfg.basicblocks:
                last_ins = bb.instructions[-1]
                bb_name = bb.name
                if last_ins.name == 'call':
                    # find the dummy blocks' name
                    # if the callee is imported in, do nothing and continue
                    callee_op = last_ins.operand_interpretation.split(' ')[1]
                    try:
                        callee_op = int(callee_op)
                    except ValueError:
                        callee_op = int(callee_op, 16)
                    # if the callee is the import function
                    if f"$func{callee_op}" not in cls.func_to_bbs.keys():
                        continue
                    # if the callee is emulated as C library funcs
                    if readable_internal_func_name(
                            Configuration.get_func_index_to_func_name(),
                            f"$func{callee_op}") in C_LIBRARY_FUNCS:
                        continue
                    entry_name = cls.func_to_bbs[f"$func{callee_op}"][0]
                    dummy_end_name = cls.func_to_bbs[f"$func{callee_op}"][-1]

                    succ_bb_name = _remove_original_edge(cfg, bb_name)
                    _update_edges(cfg, bb_name, succ_bb_name,
                                  entry_name, dummy_end_name)
                    _update_xref(cfg, dummy_end_name, succ_bb_name, callee_op)
                elif last_ins.name == 'call_indirect':
                    # find all possible callees
                    # refer to call_indirect in `ControlInstructions.py`
                    # store all dummy blocks in pair
                    dummy_blocks = []
                    possible_callees = cls.wasmVM.ana.elements[0]['elems']
                    for possible_callee in possible_callees:
                        # if the callee is the import function
                        if f"$func{possible_callee}" not in cls.func_to_bbs.keys():
                            continue
                        # if the callee is emulated as C library funcs
                        if readable_internal_func_name(
                                Configuration.get_func_index_to_func_name(),
                                f"$func{possible_callee}") in C_LIBRARY_FUNCS:
                            continue
                        entry_name = cls.func_to_bbs[f"$func{possible_callee}"][0]
                        dummy_end_name = cls.func_to_bbs[f"$func{possible_callee}"][-1]
                        dummy_blocks.append(
                            (entry_name, dummy_end_name, possible_callee))

                    callee_bb_name = _remove_original_edge(cfg, bb_name)
                    for entry_name, dummy_end_name, possible_callee in dummy_blocks:
                        _update_edges(
                            cfg, bb_name, callee_bb_name, entry_name,
                            dummy_end_name)
                        _update_xref(cfg, dummy_end_name,
                                     succ_bb_name, possible_callee)

        def update_instr_cur_bb(cfg):
            """
            Update the `cur_bb` fielf for each instruction in cfg.basicblocks
            """
            for bb in cfg.basicblocks:
                bb_name = bb.name
                for i in bb.instructions:
                    i.cur_bb = bb_name

        cfg = cls.wasmVM.cfg
        init_func_to_bbs(cfg)
        init_bbs_graph(cfg)
        init_bb_to_instr(cfg)
        init_aes_func(cfg)
        init_dummy_blocks(cfg)
        link_dummy_blocks(cfg)
        update_instr_cur_bb(cfg)

    def traverse(self):
        """
        This object can be initialized by a list of functions, each of them
        will be regarded as an entry function to perform symbolic execution
        """
        entry_func = self.entry
        self.final_states[entry_func] = self.traverse_one(entry_func)

    @classmethod
    def traverse_one(cls, func, state=None):
        """
        Symbolically executing the given function

        Args:
            func (str): The to be analyzed function's name
            state (VMstate, optional): From which the execution will begin. Defaults to None.

        Returns:
            list(VMstate): A list of states
        """
        # func_index_name is like $func16
        func_index_name, param_str, _, _ = cls.wasmVM.get_signature(func)
        if func not in cls.func_to_bbs:
            func = func_index_name

        if state is None:
            state = cls.wasmVM.init_state(func, param_str)

        # retrieve all the relevant basic blocks
        entry_func_bbs = cls.func_to_bbs[func]
        # filter out the entry basic block and corresponding instructions
        entry_bb = list(filter(lambda bb: bb[-2:] == '_0', entry_func_bbs))[0]
        blks = []
        for _, bbs in cls.func_to_bbs.items():
            blks += bbs

        if Configuration.get_algo() == 'interval':
            final_states = cls.algo_interval(entry_bb, state, blks)
        else:
            raise Exception("There is no traversing algorithm you required.")

        return final_states

    @classmethod
    def algo_interval(cls, entry, state, blks):
        """
        Traverse the CFG according to intervals.
        See our paper for more details
        """
        intervals = cls.intervals_gen(
            entry, blks, cls.rev_bbs_graph, cls.bbs_graph)
        # a mapping from a node to its corresponding interval's head
        heads = {v: head for head in intervals for v in intervals[head]}
        heads['return'] = 'return'

        final_states = cls.visit_interval(
            [state], entry, heads, cls.manual_guide, "return")
        return final_states["return"]

    @classmethod
    def intervals_gen(cls, blk, blk_lis, revg, g):
        """
        Generate intervals according to paper: Frances E Allen. 1970. Control flow analysis

        Return:
            intervals, a mapping, from each interval's head to the interval's composed nodes
        """
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
    def visit_interval(cls, states, blk, heads, guided=False, prev=None):
        """
        Performing interval traversal, see our paper for more details

        Note: `blk` is the head of an interval
        """
        vis = deque([prev])
        que = PriorityQueue()  # takes minimum value at first
        lvar = defaultdict(lambda: defaultdict(
            int, {'cons': True, 'prior': 65536}))
        que._put((lvar[blk]['prior'], (states, blk, blk, vis, lvar)))
        final_states = defaultdict(list)

        def producer():
            while not que.empty():
                yield que._get()

        # @wrap_non_picklable_objects
        def consumer(item):
            score, (state, current_block, cur_head, vis, lvar) = item
            succs_list = cls.bbs_graph[current_block].items()
            halt_flag = False
            # adopt DFS to traverse two intervals
            try:
                print(current_block)
                emul_states = cls.wasmVM.emulate_basic_block(
                    state, cls.bb_to_instructions[current_block])
            except ProcSuccessTermination:
                # end of path
                return False, state
            except ProcFailTermination:
                # trigger exit()
                write_result(state[0], exit=True)
                return False, state
            if len(succs_list) == 0:
                halt_flag = lvar[cur_head]['checker_halt']
                return halt_flag, emul_states

            avail_br = {}
            for edge_type, next_block in succs_list:
                valid_state = list(map(lambda s: s[edge_type] if isinstance(s, dict) else s, filter(
                    lambda s: not cls.can_cut(edge_type, next_block, s, lvar[cur_head]), emul_states)))
                if len(valid_state) > 0:
                    avail_br[(edge_type, next_block)] = valid_state
            # empty the current_bb_name, as it is only set in store_context and restore_context
            for valid_state in avail_br.values():
                for s in valid_state:
                    s.current_bb_name = ''

            if guided:
                # TODO: the data structure here, especially `avail_br` is different with function `visit` in dfs, thus the guided here need revise
                logging.warning(
                    f"\n[+] Currently, there are {len(avail_br)} possible branch(es) here: {bcolors.WARNING}{avail_br}{bcolors.ENDC}")
                if len(avail_br) == 1:
                    logging.warning(
                        f"[+] Enter {bcolors.WARNING}'i'{bcolors.ENDC} to show its information, or directly press {bcolors.WARNING}'enter'{bcolors.ENDC} to go ahead")
                    br_idx = ask_user_input(
                        emul_states, isbr=True, onlyone=True,
                        branches=avail_br)
                else:
                    logging.warning(
                        f"[+] Please choose one to continue the following emulation (T (conditional true), F (conditional false), f (fallthrough), current_block (unconditional))")
                    logging.warning(
                        f"[+] You can add an 'i' to illustrate information of your choice (e.g., 'T i' to show the basic block if you choose to go to the true branch)")
                    br_idx = ask_user_input(
                        emul_states, isbr=True, branches=avail_br)
                emul_states = avail_br[br_idx]

                emul_states = state_choose_info(emul_states)
                avail_br = {br_idx: emul_states}

            for br in avail_br:
                (edge_type, next_block), valid_state = br, avail_br[br]
                new_head = heads[next_block]
                for valid_state_item in valid_state:
                    local_new_lvar = copy.deepcopy(lvar)
                    local_new_lvar[cur_head] = cls.aes_run_local(
                        local_new_lvar[cur_head], next_block)
                    new_score = local_new_lvar[cur_head]['prior']
                    if new_head != cur_head:
                        new_vis = copy.deepcopy(vis)
                        if new_head in vis:
                            while new_vis:
                                h = new_vis.pop()
                                if h == new_head:
                                    break
                                local_new_lvar.pop(h)
                        else:
                            new_vis.append(cur_head)
                        que.put((new_score,
                                 ([valid_state_item],
                                  next_block, new_head, new_vis,
                                  local_new_lvar)))
                    else:
                        que.put(
                            (new_score, ([valid_state_item], next_block, cur_head, vis, local_new_lvar)))
            return halt_flag, []

        for item in producer():
            halt_flag, emul_states = consumer(item)

            # each item in emul_states indicates the end of path
            # solve the constraint and output to the log file
            for item in emul_states:
                if readable_internal_func_name(
                        Configuration.get_func_index_to_func_name(),
                        item.current_func_name) in VALUABLE_FUNC_STATE_SET:
                    # these functions correspond to end of path
                    pass
                elif readable_internal_func_name(
                        Configuration.get_func_index_to_func_name(),
                        item.current_func_name) != Configuration.get_entry():
                    continue
                write_result(item)

            final_states['return'].extend(emul_states)
            if halt_flag:
                break
        return final_states

    @ classmethod
    def sat_cut(cls, constraints):
        solver = SMTSolver(Configuration.get_solver())
        solver.add(*constraints)
        return unsat == solver.check()

    @ classmethod
    def can_cut(cls, edge_type, next_block, state, lvar):
        """
        The place in which users can determine if cut the branch or not (Default: according to SMT-solver).
        """
        if isinstance(state, dict):
            state = None if edge_type not in state else state[edge_type] if edge_type.startswith(
                'conditional_') else state

        if state.current_bb_name == '':
            # normal situation
            return cls.sat_cut(state.constraints)
        else:
            # after restore_context
            cur_bb = state.current_bb_name
            for _, blks in cls.func_to_bbs.items():
                try:
                    cur_bb_index = blks.index(cur_bb)
                except ValueError:
                    continue

                succ_block = blks[cur_bb_index + 1]
                break

            not_same_bb = succ_block != next_block
            return cls.sat_cut(state.constraints) or not_same_bb

    @ classmethod
    def aes_run_local(cls, lvar, blk):
        new_lvar = copy.deepcopy(lvar)
        new_lvar['cons'] = True
        for name in cls.aes_func[blk]:
            _name, id = name.split('$')
            if id == '1':
                new_lvar['checker_halt'] = True
                new_lvar['prior'] = -1
            if id == '2':
                new_lvar['prior'] = abs(49 - new_lvar['cnt'])
            if id == '0':
                new_lvar['cnt'] += 1
                # new_lvar['prior'] = 100 if not new_lvar['checker_halt'] else -1# has_one is shared
                # lvar['has_one'] = True
        return new_lvar
