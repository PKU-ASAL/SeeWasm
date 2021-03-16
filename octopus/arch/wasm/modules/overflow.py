import re
from octopus.arch.wasm.format import format_sym_exe
from octopus.arch.wasm.report import Issue

visited_func = set()
load_action_data = {'read_action_data', 'action_data_size'}

def execute(wasmVM, sym_exe, index2state_and_memory):
    key_imports = {'send_inline', 'send_deferred', 'db_store_i64', 'db_update_i64', 'db_remove_i64'}
    _issues = []
    _issue = Issue('overflow', False, '')
    _issue_dict = dict()
    _issue_dict['module'] = _issue.module
    _issue_dict['is_vulnerable'] = False
    _issue_dict['constraints'] = _issue.constraints
    _issues.append(_issue_dict.copy())

     # init a call path
    nodes, edges = wasmVM.cfg.get_functions_call_edges()
    call_path = dict()
    for node in nodes:
        call_path[node] = set()
    for edge in edges:
        if edge.node_to != edge.node_from:
            call_path[edge.node_from].add(edge.node_to)
    try:
        indirect_target = [wasmVM.ana.func_prototypes[index][0] for index in
                           wasmVM.ana.elements[0].get('elems')]
    except IndexError:
        indirect_target = []
    
    # contract has no elem section
    if not indirect_target:
        for apply_internal_callee in call_path['apply']:
            if search_func(apply_internal_callee, edges, load_action_data):
               indirect_target.append(apply_internal_callee) 

    if not indirect_target:
        return _issues
    
    # we only concentrates on some function which modifys blockchain's status
    overflow_target = []
    for func_name in indirect_target:
        visited_func.clear()
        if search_func(func_name, edges, key_imports):
            overflow_target.append(func_name)

    if not overflow_target:
        return _issues

    for func_name in overflow_target:
        wasmVM.reset_wasmvm(1, quick=False, lasers=['overflow'])
        sym_exe, _ = wasmVM.emulate_functions(list_functions_name=[func_name])
        key_and_constraints = format_sym_exe(sym_exe)
        for item in key_and_constraints:
            keys, constraints = item[0], item[1]
            overflow_check_flag = False

            for key in keys:
                tmp_str = str(key)
                # if overflow_check_flag:
                #     continue
                if 'overflow_check_flag' in tmp_str and 'loc_0' not in tmp_str and 'ret' not in tmp_str:
                    # print('[key]', tmp_str)
                    overflow_check_flag = True

            if not overflow_check_flag:
                continue 

            # if constraints is not None, interger_overflow can bet satisfied
            if constraints:
                # simplify utilization conditions
                issue_constraints = set()
                for constraint in constraints:
                    tmp_str = str(constraint)
                    if 'If' in tmp_str:
                        continue
                    # print('[constraint]', tmp_str)
                    # loc_0 can't be manipulated 
                    if 'loc' in tmp_str and 'loc_0' not in tmp_str and 'ret' not in tmp_str:
                        issue_constraints.add(tmp_str)

                if issue_constraints:
                    _issues = []
                    _issue = Issue('overflow', True, issue_constraints)
                    _issue_dict = dict()
                    _issue_dict['module'] = _issue.module
                    _issue_dict['is_vulnerable'] = _issue.is_vulnerable
                    _issue_dict['constraints'] = _issue.constraints
                    _issues.append(_issue_dict.copy())
                    return _issues

    return _issues

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