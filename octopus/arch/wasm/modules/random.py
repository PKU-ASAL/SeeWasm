import sys

import gvar
from octopus.arch.wasm.format import format_sym_exe
from octopus.arch.wasm.report import Issue

sys.setrecursionlimit(4096)
visited_func = set()
random_import_set = set(['tapos_block_num', 'tapos_block_prefix', 'current_time', 'transaction_size'])


def execute(wasmVM, sym_exe, index2state_and_memory):
    _issues = []
    random_func_set = set()
    nodes, edges = wasmVM.cfg.get_functions_call_edges()
    var_init(wasmVM)
    # all the suspect functions
    candidate_func_set = search_rem_func(wasmVM.cfg.functions)

    # call_path: {key: caller, val: [callee]}
    # reverse_call_path: {key: callee, val: [caller]}
    reverse_call_path = dict()
    call_path = dict()
    for node in nodes:
        call_path[node] = set()
        reverse_call_path[node] = set()
    for edge in edges:
        if edge.node_to != edge.node_from:
            call_path[edge.node_from].add(edge.node_to)
            reverse_call_path[edge.node_to].add(edge.node_from)

    # target_func_unsafe: {key: candidate, val: unsafe_func}
    target_func_unsafe = dict()
    for func in candidate_func_set:
        unsafe_func = search_func(call_path, func, gvar.unsafe_func.keys())
        if unsafe_func is not None:
            target_func_unsafe[func] = unsafe_func
    
    # build path [candidate to unsafe]
    for func in target_func_unsafe.keys():
        build_all_func_paths(reverse_call_path, func, target_func_unsafe[func], [target_func_unsafe[func]])
    func_import_path = dict()
    for path in gvar.all_func_paths:
        func_import_path[path[-1]] = path

    # build indirect_target
    try:
        indirect_target = [wasmVM.ana.func_prototypes[index][0] for index in
                           wasmVM.ana.elements[0].get('elems')]
    except IndexError:
        indirect_target = []

    # the func not in ABI, direct_call by apply
    # We should add the direct_call_func into indirect_target
    for to_be_scanned_func in target_func_unsafe.keys():
        to_be_scanned_funcs = {to_be_scanned_func}
        scanned_funcs = set()
        while len(to_be_scanned_funcs) > 0:
            cur_func = to_be_scanned_funcs.pop()
            for edge in edges:
                if edge.node_to == cur_func and cur_func not in scanned_funcs:
                    if 'apply' not in edge.node_from:
                        to_be_scanned_funcs.add(edge.node_from)
                    else:
                        indirect_target.append(cur_func)
            # to avoid call recursion
            scanned_funcs.add(cur_func)

    # build path [indirect_target to import]
    gvar.all_func_paths.clear()
    for target_name in target_func_unsafe.keys():
        build_all_func_paths(reverse_call_path, indirect_target, target_name, func_import_path[target_name])

    func_path2paths_constraints = dict()
    for func_path in gvar.all_func_paths:
        func2reasonable_paths = dict()
        func_path.reverse()
        # print(path)
        path_func_block = find_target_block(wasmVM, func_path)
        for fb in path_func_block:
            func_name, target_block = fb[0], fb[1]
            func2reasonable_paths.update(build_all_paths(wasmVM, func_name, target_block))

        # for test
        # print(func2reasonable_paths, '\n')
        paths_constraints = wasmVM.emulate_func_block_list(func_path, func2reasonable_paths)
        func_path2paths_constraints[tuple(func_path)] = paths_constraints

    # do quick check
    for func2constraints in func_path2paths_constraints.values():
        for paths_constraints in func2constraints.values():
            for constraints in paths_constraints:
                _issues.extend(quick_check(None, constraints))

    return _issues

def find_target_block(wasmVM, path):
    result = []

    for ind, func_name in enumerate(path):
        # end
        if func_name == path[-1]:
            break

        target_func = fetch_target_func(func_name, wasmVM.cfg.functions)
        callee = path[ind + 1]
        for ind, func_info in enumerate(wasmVM.ana.func_prototypes):
            if func_info[0] == callee:
                target_instr = 'call ' + str(ind)

        for basicblock in target_func.basicblocks:
            # We just use the first basicblock which contains target_instr
            if result and result[-1][0] == func_name:
                break
            for instr in basicblock.instructions:
                if instr.operand_interpretation == target_instr:
                    # append tuple(func_name, target_block)
                    result.append((func_name, basicblock))
                    break

    return result


def build_all_func_paths(reverse_call_path, entries, target, path):
    if reverse_call_path[target]:
        for caller in reverse_call_path[target]:
            new_path = path.copy()
            new_path.append(caller)
            if caller in entries:
                gvar.all_func_paths.append(new_path)
            else:
                build_all_func_paths(reverse_call_path, entries, caller, new_path)


def build_all_paths(wasmVM, func_name, target_basic_block=None):
    target_func = fetch_target_func(func_name, wasmVM.cfg.functions)
    # the second argument is the target basic blocks, I use the last one as an example
    if not target_basic_block:
        target_basic_block = target_func.basicblocks[-1]
    reasonable_paths = fetch_basic_blocks_path(target_func, target_basic_block, wasmVM.cfg.edges)

    return {func_name: reasonable_paths}


def fetch_target_func(target_func_name, cfg_functions):
    target_func = None

    # find target func according to func name
    for cfg_function in cfg_functions:
        if cfg_function.name == target_func_name:
            target_func = cfg_function
    assert target_func is not None, f"target_func_name: {target_func_name} is not found in cfg"

    return target_func


def fetch_basic_blocks_path(target_func, target_basic_block, edges):
    current_func_id = target_basic_block.name.split('_')[1]
    # target_func_edges is a dict, the key is the (from, to), the value is the edge info
    target_func_edges = dict()
    for edge in edges:
        if edge.node_from.split('_')[1] == current_func_id:
            # remove the loop back edge
            # and remove the jump from self to self
            if int(edge.node_from.split('_')[2], 16) >= int(edge.node_to.split('_')[2], 16):
                continue
            target_func_edges[(edge.node_from, edge.node_to)] = edge

    def is_condition(edge_info):
        if edge_info.type == 'conditional_true':
            return True
        elif edge_info.type == 'conditional_false':
            return True
        elif edge_info.type == 'unconditional':
            return True

        return False

    # pre-process
    # key is the to_node name, value is a list which contains the from_node name
    # ensure the edge is a jump, but if there is no jump, use fall through
    reverse_blocks = {target_func.basicblocks[0].name: []}
    # init the reverse_blocks
    for edge_pair in target_func_edges.keys():
        reverse_blocks[edge_pair[1]] = []

    for edge_pair, edge_info in target_func_edges.items():
        if is_condition(edge_info):
            reverse_blocks[edge_pair[1]].append(edge_pair[0])

    for to_node, from_nodes in reverse_blocks.items():
        # if there is no jump to to_node
        if not from_nodes:
            for edge_pair in target_func_edges.keys():
                if edge_pair[1] == to_node:
                    reverse_blocks[to_node].append(edge_pair[0])

    # build all the paths
    source_block, dest_block = target_basic_block.name, target_func.basicblocks[0].name
    visited = dict()
    for b in target_func.basicblocks:
        visited[b.name] = False
    path = []
    all_paths = []

    # use DFS to build path
    def grab_all_paths(source_block, dest_block, visited, path):
        visited[source_block] = True
        path.append(source_block)

        if source_block == dest_block:
            all_paths.append(path.copy())
        else:
            for temp_block in reverse_blocks[source_block]:
                if visited[temp_block] is False:
                    grab_all_paths(temp_block, dest_block, visited.copy(), path.copy())

    grab_all_paths(source_block, dest_block, visited, path)

    return all_paths

def var_init(wasmVM):
    gvar.elem_func_id = wasmVM.ana.elements[0]['elems']
    for id in gvar.elem_func_id:
        gvar.elem_func_name.add(wasmVM.ana.func_prototypes[id][0])
    for idx, func in enumerate(wasmVM.ana.func_prototypes):
        gvar.reverse_func_id[func[0]] = idx
    for basicblock in wasmVM.cfg.basicblocks:
        gvar.reverse_basicblock_func[basicblock.name] = int(str(basicblock.name).split('_')[1], 16) + len(wasmVM.ana.imports_func)
    for id, name in enumerate(wasmVM.ana.func_prototypes):
        for dub_name in gvar.unsafe_func:
            if dub_name in name:
                gvar.unsafe_func[dub_name] = id
                break
    pop_items = set()
    for name in gvar.unsafe_func:
        if gvar.unsafe_func[name] == -1:
            pop_items.add(name)
    for item in pop_items:
        gvar.unsafe_func.pop(item)
    for id, block in enumerate(wasmVM.cfg.basicblocks):
        gvar.reverse_basicblock_id[block.name] = id

# Find the blocks which call unsafe functions

# Whether func contains 'rem' instr
def search_rem_func(funcs):
    search_rem_func_set = set()
    for func in funcs:
        for i in func.instructions:
            if 'rem' in i.name:
                search_rem_func_set.add(func.name)
                break

    return search_rem_func_set

# Whether upper_func calls targets
def search_func(call_path, entry, targets):
    if call_path[entry]:
        for callee in call_path[entry]:
            if callee in targets:
                return callee
            else:
                # callee's callee.. in targets
                result = search_func(call_path, callee, targets)
                if result:
                    return result


def quick_check(keys, constraints):
    _issues = []

    for constraint in constraints:
        tmp_str = str(constraint)
        if 'If' not in tmp_str:
            print('[+] constraint: ', tmp_str)

        '''
        if 'ULE' in str(constraint):
            # Formula contains random_impact_factor
            if set([x in str(constraint) for x in random_import_set]) != set([False]):

                _issue = Issue('random', True, [constraint])
                _issue_dict = dict()
                _issue_dict['module'] = _issue.module
                _issue_dict['constraints'] = _issue.constraints

                _issues.append(_issue_dict.copy())
                break
            # 1. When the detected function is elems, the constraint should not contain loc
            # 2. When the detected function is not in elems, we need to execute the upper function to see
            # if the loc of the detected function is passed by elem_func_param, and then execute 1 logic.

            elif set([x + '_loc' in str(constraint) for x in gvar.elem_func_name]) != set([False]):
                _issue = Issue('random', True, [constraint])
                _issue_dict = dict()
                _issue_dict['module'] = _issue.module
                _issue_dict['is_vulnerable'] = True
                _issue_dict['constraints'] = _issue.constraints

                _issues.append(_issue_dict.copy())
                break
        '''

    return _issues