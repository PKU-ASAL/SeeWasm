import copy
from collections import defaultdict, deque
from queue import PriorityQueue
from queue import Queue

from z3 import unsat

from seewasm.arch.wasm.configuration import Configuration
from seewasm.arch.wasm.exceptions import (ProcFailTermination,
                                          ProcSuccessTermination)
from seewasm.arch.wasm.instruction import WasmInstruction
from seewasm.arch.wasm.lib.utils import is_modeled
from seewasm.arch.wasm.utils import (query_cache, readable_internal_func_name,
                                     write_result)
from seewasm.core.basicblock import BasicBlock
from seewasm.core.edge import EDGE_FALLTHROUGH


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
    """
    _func_to_bbs = defaultdict(list)
    _bb_to_instructions = defaultdict(list)
    _aes_func = defaultdict(set)
    _bbs_graph = defaultdict(lambda: defaultdict(str))  # nested dict
    _rev_bbs_graph = defaultdict(lambda: defaultdict(str))

    _workers = 2
    _wasmVM = None

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
            initialize the bbs_graph
            """
            edges = cfg.edges
            # sort the edges, according to the edge.from and edge.to,
            # or the order of br_table branches will be random, the true_0 will not corrspond to the nearest block
            # TODO quite a huge overhead, try another way
            edges = sorted(edges, key=lambda x: (
                x.node_from, int(x.node_to.split('_')[2], 16)))

            type_ids = defaultdict(lambda: defaultdict(int))
            for edge in edges:
                node_from, node_to, edge_type = edge.node_from, edge.node_to, edge.type
                # we append a number after the edge type, because the br_table may have multiple conditional_true branches. See seewasm/arch/wasm/cfg.py
                if not edge_type[-1].isdigit():
                    # non-br_table case
                    numbered_edge_type = edge_type + '_' + \
                        str(type_ids[node_from][edge_type])
                else:
                    # br_table case
                    numbered_edge_type = edge_type
                cls.bbs_graph[node_from][numbered_edge_type] = node_to
                type_ids[node_from][edge_type] += 1

            # append single nodes into the bbs_graph
            for bb in cfg.basicblocks:
                bb_name = bb.name
                if bb_name not in cls.bbs_graph:
                    cls.bbs_graph[bb_name] = defaultdict(str)

        def init_bb_to_instr(cfg):
            """
            initialize the bb_to_instructions
            """
            bbs = cfg.basicblocks
            for bb in bbs:
                # Update the `cur_bb` fielf for each instruction
                for ins in bb.instructions:
                    ins.cur_bb = bb.name
                cls.bb_to_instructions[bb.name] = bb.instructions

        def init_aes_func():
            """
            initialize the aes_func
            """
            for bb_name, instructions in cls.bb_to_instructions.items():
                for instr in instructions:
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
                            cls.aes_func[bb_name].add(readable_name)

        def init_dummy_blocks():
            """
            Insert dummy exit after each function.
            Refer to: https://github.com/HNYuuu/Wasm-SE/issues/70

            Also update basicblocks in cfg, and class variables, e.g., bbs_graph and bb_to_instructions
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
                for zero_outdegree_bb in zero_outdegree:
                    # the bb's end_offset is its last instruction's offset_end
                    bb_end_offset = cls.bb_to_instructions[zero_outdegree_bb][
                        -1].offset_end
                    bb_end_instr_nature_offset = cls.bb_to_instructions[
                        zero_outdegree_bb][-1].nature_offset
                    dummy_end_block_offset = max(
                        dummy_end_block_offset, bb_end_offset + 1)
                    dummy_end_block_nature_offset = max(
                        dummy_end_block_nature_offset,
                        bb_end_instr_nature_offset + 1)
                dummy_end_block_offset_hex = str(
                    hex(dummy_end_block_offset)[2:])

                func_index = b.split('_')[1]
                # construct dummy end
                dummy_end = BasicBlock()
                dummy_end.name = f"block_{func_index}_{dummy_end_block_offset_hex}"

                end_ins = WasmInstruction(
                    1, 'nop', None, 0, b'\x0b', 0, 0, 'dummy end',
                    offset=dummy_end_block_offset,
                    nature_offset=dummy_end_block_nature_offset)
                end_ins.cur_bb = dummy_end.name

                dummy_end.start_offset = dummy_end_block_offset
                dummy_end.start_instr = end_ins
                dummy_end.instructions = [end_ins]
                dummy_end.end_instr = end_ins
                dummy_end.end_offset = end_ins.offset_end

                # insert dummy blocks
                cls.func_to_bbs[func_name].append(dummy_end.name)
                cls.bb_to_instructions[dummy_end.name] = dummy_end.instructions

                # construct edges from original exit points to the dummy end block
                # and update class variables
                for exit in zero_outdegree:
                    cls.bbs_graph[exit][f"{EDGE_FALLTHROUGH}_0"] = dummy_end.name
                cls.bbs_graph[dummy_end.name] = defaultdict(str)

        def _remove_original_edge(bb_names, keep_original_edge_bbs):
            """
            Extract the successive block of bb_name, and return it.
            Also, remove the edge in bbs_graph
            """
            bb_to_succ_bb_mapping = dict()

            # update bbs_graph
            for bb, edge_callee_mapping in cls.bbs_graph.items():
                if bb in bb_names:
                    assert len(edge_callee_mapping) == 1
                    # the succ bb is the first element of values
                    # keep the bb and succ_bb relation
                    bb_to_succ_bb_mapping[bb] = next(
                        iter(edge_callee_mapping.values()))

                    if bb in keep_original_edge_bbs:
                        continue
                    edge_callee_mapping["fallthrough_0"] = ""

            return bb_to_succ_bb_mapping

        def _find_max_fallthrough_edge_count(nested_dict, bb_name):
            edge_count = -1
            for e, callee in nested_dict[bb_name].items():
                if e.startswith('fall') and callee != "":
                    edge_count = max(edge_count, int(e.split('_')[1]))
            return edge_count + 1

        def _update_edges(bb_name, succ_bb_name, entry_name, dummy_end_name):
            """
            Insert two edges: bb_name to entry_name, dummy_end_name to callee_bb_name
            Update corresponding variables in bbs_graph
            """

            # update bbs_graph
            cls.bbs_graph[bb_name][
                f"fallthrough_{_find_max_fallthrough_edge_count(cls.bbs_graph, bb_name)}"] = entry_name
            cls.bbs_graph[dummy_end_name][
                f"fallthrough_{_find_max_fallthrough_edge_count(cls.bbs_graph, dummy_end_name)}"] = succ_bb_name

        def _update_xref(dummy_end_name, succ_bb_name, callee_op):
            """
            Append a tuple in the xref of the `nop` instruction who locates in dummy end.
            The tuple consists of: the next block's name, and its belonging function's name
            """
            dummy_end_bb_instrs = cls.bb_to_instructions[dummy_end_name]
            assert len(
                dummy_end_bb_instrs) == 1, f"{dummy_end_name} consists of more than 1 instructions: {dummy_end_bb_instrs}"
            dummy_end_bb_instrs[0].xref.append((succ_bb_name, callee_op))

        def link_dummy_blocks():
            """
            Remove edges after call, directly link it to the callee's dummy entry.
            Also link the dummy end to the next instruction of the call.
            Update edges in cfg and bbs_graph in class
            """
            # this list stores which block should be updated and the callee is its value
            # each ele consists of the current bb and its callee's op
            need_update_bb_info = list()
            # the edge that is directed from a bb in this set should be kept
            keep_original_edge_bbs = set()

            for bb_name, instructions in cls.bb_to_instructions.items():
                last_ins = instructions[-1]
                if last_ins.name == 'call':
                    # find the dummy blocks' name
                    # if the callee is imported in, do nothing and continue
                    callee_op = last_ins.operand_interpretation.split(' ')[1]
                    try:
                        callee_op = int(callee_op)
                    except ValueError:
                        callee_op = int(callee_op, 16)
                    callee_func_name = readable_internal_func_name(
                        Configuration.get_func_index_to_func_name(), f"$func{callee_op}")
                    if is_modeled(callee_func_name):
                        continue

                    need_update_bb_info.append([bb_name, callee_op])
                elif last_ins.name == 'call_indirect':
                    # find all possible callees
                    # refer to call_indirect in `ControlInstructions.py`
                    # store all dummy blocks in pair
                    # filter callee according to type
                    target_callee_type = int(
                        last_ins.operand_interpretation.split(' ')[1][:-1])
                    possible_callees = cls.wasmVM.ana.elements[0]['elems']
                    for possible_callee_op in possible_callees:
                        # extract the possible callee's type
                        possible_callee_type = cls.wasmVM.ana.func_types[possible_callee_op - len(
                            cls.wasmVM.ana.imports_func)]
                        if possible_callee_type != target_callee_type:
                            continue
                        possible_callee_func_name = readable_internal_func_name(
                            Configuration.get_func_index_to_func_name(), f"$func{possible_callee_op}")
                        if is_modeled(possible_callee_func_name):
                            keep_original_edge_bbs.add(bb_name)
                            continue

                        need_update_bb_info.append(
                            [bb_name, possible_callee_op])

            bb_names, _ = list(zip(*need_update_bb_info))
            # remove all bb's direct succ in bbs_graph
            # and return a dict, whose key is the bb, and the value is the succ bb
            bb_succ_bb_mapping = _remove_original_edge(
                set(bb_names), keep_original_edge_bbs)
            # update edges and xref
            for bb, callee_op in need_update_bb_info:
                # extract callee
                callee_bbs = cls.func_to_bbs[f"$func{callee_op}"]
                callee_entry, callee_dummy_end = callee_bbs[0], callee_bbs[-1]

                succ_bb = bb_succ_bb_mapping[bb]
                _update_edges(bb, succ_bb, callee_entry, callee_dummy_end)
                _update_xref(callee_dummy_end, succ_bb, callee_op)

        def init_rev_bbs_graph():
            for bb, edge_callee in cls.bbs_graph.items():
                for edge, callee in edge_callee.items():
                    if edge not in cls.rev_bbs_graph[callee]:
                        cls.rev_bbs_graph[callee][edge] = bb
                    else:
                        cls.rev_bbs_graph[callee][
                            f"fallthrough_{_find_max_fallthrough_edge_count(cls.rev_bbs_graph, callee)}"] = bb

            # for those zero indegree
            for bb in cls.bbs_graph.keys():
                if bb not in cls.rev_bbs_graph:
                    cls.rev_bbs_graph[bb] = defaultdict(str)

        cfg = cls.wasmVM.cfg
        init_func_to_bbs(cfg)
        init_bbs_graph(cfg)
        init_bb_to_instr(cfg)
        init_aes_func()
        init_dummy_blocks()
        link_dummy_blocks()
        init_rev_bbs_graph()

    def traverse(self):
        """
        This object can be initialized by a list of functions, each of them
        will be regarded as an entry function to perform symbolic execution
        """
        entry_func = self.entry
        self.final_states[entry_func] = self.traverse_one(entry_func)

    @ classmethod
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
            raise Exception(
                "There is no path searching algorithm you required.")

        return final_states

    @ classmethod
    def has_cycle(cls, u, g, nodes, vis):
        vis.add(u)
        for t in g[u]:
            if g[u][t] in nodes and (
                g[u][t] in vis or cls.has_cycle(g[u][t],
                                                g, nodes, vis)):
                return True
        vis.remove(u)
        return False

    @ classmethod
    def algo_interval(cls, entry, state, blks):
        """
        Traverse the CFG according to intervals.
        See our paper for more details
        """
        # rg, g, ninterval = cls.rev_bbs_graph, cls.bbs_graph, 0
        # while True:
        #     intervals = cls.intervals_gen(entry, blks, rg, g)
        #     if len(intervals) == ninterval:
        #         break
        #     ninterval = len(intervals)
        #     no_cycle_nodes = {}
        #     c = 0
        #     for h in intervals:
        #         if not cls.has_cycle(h, g, intervals[h], set()):
        #             for v in intervals[h]:
        #                 no_cycle_nodes[v] = {v}
        #         else:
        #             no_cycle_nodes[h] = intervals[h]
        #     heads = {v: head
        #              for head in no_cycle_nodes for v in no_cycle_nodes
        #              [head]}
        #     nrg, ng = defaultdict(
        #         lambda: defaultdict(str)), defaultdict(
        #         lambda: defaultdict(str))
        #     for v in g:
        #         if v in heads:
        #             for t in g[v]:
        #                 if g[v][t] in heads:
        #                     ng[heads[v]][t] = heads[g[v][t]]
        #     for v in rg:
        #         if v in heads:
        #             for t in rg[v]:
        #                 if rg[v][t] in heads:
        #                     nrg[heads[v]][t] = heads[rg[v][t]]
        #     rg, g = nrg, ng
        # print(ninterval)
        # a mapping from a node to its corresponding interval's head
        intervals = cls.intervals_gen(
            entry, blks, cls.rev_bbs_graph, cls.bbs_graph)
        heads = {v: head for head in intervals for v in intervals[head]}
        heads['return'] = 'return'

        final_states = cls.visit_interval([state], entry, heads, "return")
        return final_states["return"]

    @ classmethod
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
                    prevs = set(revg[v].values())
                    if prevs <= new_interval:
                        ext.add(v)
                new_interval |= ext
                if not ext:
                    break
            nodes = nodes - new_interval
            new_header = set()

            # modified version:
            for node in new_interval:
                for possible_header in g[node].values():
                    if possible_header in nodes:
                        new_header.add(possible_header)

            # original version:
            # for v in nodes:
            #     prevs = revg[v].values()
            #     if not new_interval.isdisjoint(prevs):
            #         new_header.add(v)

            que.extend(list(new_header))
            intervals[current_block] = new_interval
        return intervals

    @ classmethod
    def visit_interval(cls, states, blk, heads, prev=None):
        """
        Performing interval traversal, see our paper for more details

        Note: `blk` is the head of an interval
        """
        counter = 0

        def unique_idx():
            nonlocal counter
            counter += 1
            return counter-1
        default_cons_prior = defaultdict(int)
        default_cons_prior['prior'] = 65536
        default_cons_prior['cons'] = True
        default_cons_prior['checker_halt'] = False

        vis = deque([prev])
        que = PriorityQueue()  # takes minimum value at first
        lvar = {blk: default_cons_prior.copy()}
        que._put(
            (lvar[blk]['prior'],
             unique_idx(),
             (states, blk, blk, vis, lvar)))
        final_states = defaultdict(list)

        def producer():
            while not que.empty():
                yield que.get()

        # @wrap_non_picklable_objects
        def consumer(item):
            score, state_id, (state, current_block, cur_head, vis, lvar) = item
            # init cur_head if it is not in lvar
            if cur_head not in lvar:
                lvar[cur_head] = default_cons_prior.copy()
            succs_list = cls.bbs_graph[current_block].items()
            halt_flag = False
            """
            lis = []
            while not que.empty():
                lis.append(que.get())
            print([x[0] for x in lis]) 
            for x in lis:
                que.put(x)
            """
            # adopt DFS to traverse two intervals
            try:
                emul_states = cls.wasmVM.emulate_basic_block(
                    state, cls.bb_to_instructions[current_block], lvar[cur_head])
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
                valid_state = list(
                    filter(
                        lambda s: not cls.can_cut(
                            edge_type, next_block, s,
                            lvar[cur_head]),
                        emul_states))
                if len(valid_state) > 0:
                    avail_br[(edge_type, next_block)] = valid_state
            # reset the following three indicator, as they are used
            # in can_cut and should be re-init
            for valid_state in avail_br.values():
                for s in valid_state:
                    s.current_bb_name = ''
                    s.edge_type = ''
                    s.call_indirect_callee = ''

            for br in avail_br:
                (edge_type, next_block), valid_state = br, avail_br[br]
                new_head = heads[next_block]
                for valid_state_item in valid_state:
                    # try no deepcopy
                    local_new_lvar = lvar.copy()
                    local_new_lvar[cur_head] = cls.aes_run_local(
                        local_new_lvar[cur_head], next_block)
                    new_score = local_new_lvar[cur_head]['prior']
                    if new_head != cur_head:
                        # try no deepcopy
                        new_vis = vis.copy()
                        if new_head in vis:
                            while new_vis:
                                h = new_vis.pop()
                                if h == new_head:
                                    break
                                local_new_lvar.pop(h)
                        else:
                            new_vis.append(cur_head)
                        item = (new_score,
                                unique_idx(),
                                ([valid_state_item],
                                 next_block, new_head, new_vis,
                                 local_new_lvar))

                        que._put(item)
                    else:
                        que._put(
                            (new_score, unique_idx(),
                             ([valid_state_item],
                              next_block, cur_head, vis, local_new_lvar)))
            return halt_flag, []

        for item in producer():
            halt_flag, emul_states = consumer(item)

            for item in emul_states:
                # only the block that locates at the end of the entry function
                # can be regarded as end of path
                if readable_internal_func_name(
                        Configuration.get_func_index_to_func_name(),
                        item.current_func_name) == Configuration.get_entry():
                    write_result(item)

            final_states['return'].extend(emul_states)
            if halt_flag:
                break
        return final_states

    @ classmethod
    def sat_cut(cls, solver):
        # TODO need cached here
        return unsat == query_cache(solver)

    @ classmethod
    def can_cut(cls, edge_type, next_block, state, lvar):
        """
        The place in which users can determine if cut the branch or not (Default: according to SMT-solver).
        """
        if state.edge_type:
            not_same_edge = state.edge_type != edge_type
            return not_same_edge or cls.sat_cut(state.solver)

        if state.call_indirect_callee:
            if not is_modeled(state.call_indirect_callee):
                pass
            else:
                # if the callee is not modeled
                # check if the next block is the direct succ of current block
                current_instr_offset_end = state.instr.offset_end
                next_block_offset = int(next_block.split('_')[2], 16)
                not_direct_succ = (
                    current_instr_offset_end + 1 != next_block_offset)

                current_func = state.instr.cur_bb.split('_')[1]
                next_block_func = next_block.split('_')[1]
                not_same_func = current_func != next_block_func
                return not_direct_succ or not_same_func or cls.sat_cut(
                    state.solver)

        if state.current_bb_name == '':
            # normal situation, check the current_func_name
            cur_func = state.current_func_name
            for func, blks in cls.func_to_bbs.items():
                if next_block in blks:
                    break
            not_same_func = readable_internal_func_name(
                Configuration.get_func_index_to_func_name(),
                cur_func) != readable_internal_func_name(
                Configuration.get_func_index_to_func_name(),
                func)

            return not_same_func or cls.sat_cut(state.solver)
        else:
            # after restore_context, check the current_bb_name
            cur_bb = state.current_bb_name
            for _, blks in cls.func_to_bbs.items():
                try:
                    cur_bb_index = blks.index(cur_bb)
                except ValueError:
                    continue

                succ_block = blks[cur_bb_index + 1]
                break

            not_same_bb = succ_block != next_block
            return not_same_bb or cls.sat_cut(state.solver)

    @ classmethod
    def aes_run_local(cls, lvar, blk):
        new_lvar = copy.deepcopy(lvar)
        new_lvar['cons'] = True
        for name in cls.aes_func[blk]:
            _name, id = name.split('$')
            id = int(id)
            if id == 0:
                new_lvar['checker_halt'] = True
                new_lvar['prior'] = -1
            elif id == 1:
                new_lvar["cnt_i"] += 1
            elif id == 2:
                new_lvar['prior'] = abs(986 - new_lvar['cnt_i'])
            # if id == '1':
            #     new_lvar['checker_halt'] = True
            #     new_lvar['prior'] = -1
            # if id == '2':
            #     new_lvar['prior'] = abs(49 - new_lvar['cnt'])
            # if id == '0':
            #     new_lvar['cnt'] += 1
                # new_lvar['prior'] = 100 if not new_lvar['checker_halt'] else -1# has_one is shared
                # lvar['has_one'] = True
        return new_lvar
    
    @ classmethod
    def algo_dfs(cls, entry, state):
        que = Queue()
        que._put((entry, state))

        vis = {}

        while not que.empty():
            (current_bb, current_state) = que._get()
            succs_list = cls.bbs_graph[current_bb].items()
            try:
                emul_states = cls.wasmVM.emulate_basic_block(
                    state, cls.bb_to_instructions[current_bb], lvar[cur_head])
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
            
            for edge_type, next_block in succs_list:




