import re
import gvar
from octopus.arch.wasm.report import Issue

visited_func = set()
random_import_set = set(['tapos_block_num', 'tapos_block_prefix', 'current_time', 'transaction_size'])


def execute(wasmVM, sym_exe, index2state_and_memory):
    _issues = []
    _issue = Issue('roll_back', False, [])
    _issue_dict = dict()
    _issue_dict['module'] = _issue.module
    _issue_dict['is_vulnerable'] = False
    _issue_dict['constraints'] = _issue.constraints
    _issues.append(_issue_dict.copy())

    var_init(wasmVM)
    nodes, edges = wasmVM.cfg.get_functions_call_edges()
    try:
        indirect_target = [wasmVM.ana.func_prototypes[index][0] for index in
                           wasmVM.ana.elements[0].get('elems')]
    except IndexError:
        indirect_target = []

    # the roll_back_func not in ABI, direct_call by apply
    # We should add the direct_call_func into indirect_target
    to_be_scanned_funcs = {'send_inline'}
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
    if not indirect_target:
        return _issues

    # {key: callee, val: [caller]}
    reverse_call_path = dict()
    for node in nodes:
        reverse_call_path[node] = set()
    for edge in edges:
        if edge.node_to != edge.node_from:
            reverse_call_path[edge.node_to].add(edge.node_from)

    if reverse_call_path.get('send_inline') is None:
        return _issues

    # assign all_func_paths [callee, caller, caller_caller, ..., indirect_target]
    target_name = 'send_inline'
    build_all_func_paths(reverse_call_path, indirect_target, target_name, ['send_inline'])

    # func_path2paths_constraints_and_keys = dict()
    for func_path in gvar.all_func_paths:
        # # TODO for test
        # if func_path != ['send_inline', '$func146', '$func137', '$func131', '$func94', '$func77']:
        #     continue
        func2reasonable_paths = dict()
        func_path.reverse()
        path_func_block = find_target_block(wasmVM, func_path)
        for fb in path_func_block:
            func_name, target_block = fb[0], fb[1]
            func2reasonable_paths.update(build_all_paths(wasmVM, func_name, target_block))

        func2reasonable_paths = drop_useless_paths(func2reasonable_paths)

        wasmVM.reset_wasmvm(2, quick=True, lasers=['roll_back'])
        paths_constraints_and_keys = wasmVM.emulate_func_block_list(func_path, func2reasonable_paths)
        for func in paths_constraints_and_keys.keys():
            for constraints_and_keys in paths_constraints_and_keys[func]:
                constraints, keys = constraints_and_keys[0], constraints_and_keys[1]
                issues = quick_check(keys, constraints)
                if issues is not None:
                    return issues
                # print("====================one path end====================")
        # func_path2paths_constraints_and_keys[tuple(func_path)] = paths_constraints_and_keys

    # do quick check
    # for func2constraints_and_keys in func_path2paths_constraints_and_keys.values():
    #     for paths_constraints_and_keys in func2constraints_and_keys.values():
    #         for constraints_and_keys in paths_constraints_and_keys:
    #             constraints, keys = constraints_and_keys[0], constraints_and_keys[1]
    #             issues = quick_check(keys, constraints)
    #             if issues is not None:
    #                 return issues
    #             print("====================one path end====================")

    return _issues


def quick_check(keys, constraints):
    transfer_amount = None
    reveal_amount = None
    _issues = []

    for constraint in constraints:
        tmp_str = str(constraint)

        if 'If' in tmp_str:
            continue
        elif '4611686018427387903' in tmp_str:
            value = re.search(r'ULE\(4611686018427387903[ \n]*\+[ \n]*Extract\(62,[ \n]*0,[ \n]*([a-zA-Z0-9_\*\+\(\) \n]*),[ \n]*9223372036854775806',
                              tmp_str)
            if not value:
                value = re.search(r'ULE\(9223372036854775807,[ \n]*4611686018427387903[ \n]*\+[ \n]*\(([a-zA-Z0-9\(\)\*\+_, \n]*)',
                              tmp_str)
            if value:
                if not transfer_amount:
                    transfer_amount = value.group(1)
                elif transfer_amount != value.group(1):
                     reveal_amount = value.group(1)
        elif 'rem' in tmp_str:
            # remove current_time in constraints-check
            if 'tapos' in tmp_str or 'transaction_id' in tmp_str:
                _issue = Issue('roll_back', True, ['changeable-result'])
                _issue_dict = dict()
                _issue_dict['module'] = _issue.module
                _issue_dict['is_vulnerable'] = True
                _issue_dict['constraints'] = _issue.constraints
                _issues.append(_issue_dict.copy())
                return _issues
            elif 'loc' in tmp_str:
                _issue = Issue('roll_back', 'need_comfirmed', ['result-manipulated-by-params'])
                _issue_dict = dict()
                _issue_dict['module'] = _issue.module
                _issue_dict['is_vulnerable'] = _issue.is_vulnerable
                _issue_dict['constraints'] = _issue.constraints
                _issues.append(_issue_dict.copy())
                return _issues
            # bvurem_i(Concat(Extract(55, 0, load_i64*(8114)), 0) |
            elif re.search(r'load_i64*([0-9])',tmp_str) or re.search(r'load_i32*([0-9])',tmp_str):
                # action_data store in apply function
                _issue = Issue('roll_back', 'need_comfirmed', ['result-manipulated-by-params'])
                _issue_dict = dict()
                _issue_dict['module'] = _issue.module
                _issue_dict['is_vulnerable'] = _issue.is_vulnerable
                _issue_dict['constraints'] = _issue.constraints
                _issues.append(_issue_dict.copy())
                return _issues
        else:
            pass
            # print(tmp_str)
        

    # print('transfer_amount: ', transfer_amount)
    # print('reveal_amount: ', reveal_amount)
    # print('====================constraint key====================')
    # if reveal_amount:
    for key in keys:
        tmp_str = str(key)
        # if 'db' in tmp_str:
        #     print(tmp_str)
        if 'rem' in tmp_str:
            if 'tapos' in tmp_str or 'current_time' in tmp_str or 'transaction_id' in tmp_str:
                _issue = Issue('roll_back', True, ['changeable-result'])
                _issue_dict = dict()
                _issue_dict['module'] = _issue.module
                _issue_dict['is_vulnerable'] = True
                _issue_dict['constraints'] = _issue.constraints
                _issues.append(_issue_dict.copy())
                return _issues
            elif 'loc' in tmp_str:
                _issue = Issue('roll_back', 'need_comfirmed', ['result-manipulated-by-params'])
                _issue_dict = dict()
                _issue_dict['module'] = _issue.module
                _issue_dict['is_vulnerable'] = _issue.is_vulnerable
                _issue_dict['constraints'] = _issue.constraints
                _issues.append(_issue_dict.copy())
                return _issues
            # bvurem_i(Concat(Extract(55, 0, load_i64*(8114)), 0) |
            elif re.search(r'load_i64*([0-9])',tmp_str) or re.search(r'load_i32*([0-9])',tmp_str):
                # action_data store in apply function
                _issue = Issue('roll_back', 'need_comfirmed', ['result-manipulated-by-params'])
                _issue_dict = dict()
                _issue_dict['module'] = _issue.module
                _issue_dict['is_vulnerable'] = _issue.is_vulnerable
                _issue_dict['constraints'] = _issue.constraints
                _issues.append(_issue_dict.copy())
                return _issues

    return None


def drop_useless_paths(funcs_blocks_dict):
    def sort_basicblocks(path):
        path = list(path)
        path.sort(key=lambda x: int(x.split('_')[2], 16), reverse=True)
        return path

    for func, paths in funcs_blocks_dict.items():
        # trans each path in paths to set
        paths_set = []
        for path in paths:
            paths_set.append(set(path))

        # sort paths_set by length desc
        paths_set.sort(key=len, reverse=True)

        # if path_A contains all block in path_B, remove path_B
        i = 0
        while i < len(paths_set) - 1:
            j = i + 1
            while j < len(paths_set):
                if paths_set[i] > paths_set[j]:
                    # print(paths_set[i], paths_set[j])
                    del paths_set[j]
                    continue
                else:
                    j += 1
            i += 1

        # reset the paths
        funcs_blocks_dict[func] = [sort_basicblocks(path) for path in paths_set]

    return funcs_blocks_dict


def var_init(wasmVM):
    try:
        gvar.elem_func_id = wasmVM.ana.elements[0]['elems']
    except IndexError:
        gvar.elem_func_id = []

    for id in gvar.elem_func_id:
        gvar.elem_func_name.add(wasmVM.ana.func_prototypes[id][0])
    for idx, func in enumerate(wasmVM.ana.func_prototypes):
        gvar.reverse_func_id[func[0]] = idx
    for basicblock in wasmVM.cfg.basicblocks:
        gvar.reverse_basicblock_func[basicblock.name] = int(str(basicblock.name).split('_')[1], 16) + len(
            wasmVM.ana.imports_func)
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


# fetch function according to the function name
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
        # if edge_info.type == 'conditional_false':
        #     return True
        # elif edge_info.type == 'conditional_true':
        #     return True
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
    reach_limit = [False]

    # use DFS to build path
    def grab_all_paths(source_block, dest_block, visited, path):
        visited[source_block] = True
        path.append(source_block)

        if source_block == dest_block:
            all_paths.append(path.copy())
            # the up limit
            if len(all_paths) > 9999:
                reach_limit[0] = True
        else:
            for temp_block in reverse_blocks[source_block]:
                if visited[temp_block] is False:
                    if grab_all_paths(temp_block, dest_block, visited.copy(), path.copy()):
                        return True

            if reach_limit[0]:
                return True

    grab_all_paths(source_block, dest_block, visited, path)

    return all_paths


# Whether func contains 'i64.const rem' instr
def search_rem_func(funcs):
    search_rem_func_set = set()
    for func in funcs:
        for i in func.instructions:
            if 'rem' in i.name:
                search_rem_func_set.add(func.name)
                break

    return search_rem_func_set


# Whether func_name calls a function in the collection
def search_func(func_name, edges, target_set):
    upper_function_set = set()
    for edge in edges:
        # edge.node_to in {'send_inline'}
        if edge.node_to in target_set:
            if edge.node_from != func_name:
                if edge.node_from not in visited_func:
                    # if edge.node_from != func_name:
                    upper_function_set.add(edge.node_from)
                    visited_func.add(edge.node_from)
                else:
                    continue
            else:
                return True
        else:
            continue

    if upper_function_set:
        return search_func(func_name, edges, upper_function_set)
    else:
        return False


# Whether func_name calls a function in the collection and the hit number
def _search_func(func_name, edges, tmp_set, hit_number=0):
    upper_function_set = set()
    for edge in edges:
        if edge.node_to not in tmp_set:
            continue
        else:
            if edge.node_from != func_name:
                upper_function_set.add(edge.node_from)
            else:
                hit_number += 1

    # print(hit_number,upper_function_set)
    if upper_function_set:
        hit_number = _search_func(func_name, edges, upper_function_set, hit_number=hit_number)
        return hit_number
    else:
        return hit_number
