from octopus.arch.wasm.format import format_sym_exe
from octopus.arch.wasm.report import Issue
import re

searched_funcs = set()
target_funcs = set()


def execute(wasmVM, sym_exe, index2state):
    _issues = []
    receiver_func_set = set()
    key_imports = {'send_inline', 'send_deferred',
                   'db_store_i64', 'db_update_i64', 'db_remove_i64'}
    require_auth = set(['has_auth', 'require_auth', 'require_auth2'])
    key_and_constraints = format_sym_exe(sym_exe)
    nodes, edges = wasmVM.cfg.get_functions_call_edges()
    # call_path: {key: caller, val: [callee]}
    call_path = dict()
    for node in nodes:
        call_path[node] = set()
    for edge in edges:
        if edge.node_to != edge.node_from:
            call_path[edge.node_from].add(edge.node_to)

    for one_path_result in key_and_constraints:
        # one_path_result is combined by [key_import_funcs, constraints] in apply function
        key_import_funcs, constraints = one_path_result[0], one_path_result[1]
        if not key_import_funcs:
            continue

        action_name = None
        is_code_receiver = False
        halt = False
        for constraint in constraints:
            tmp_str = str(constraint)

            if 'If' in tmp_str or halt:
                continue
            # logical_ans_(Not(code == eosio.token)) == 0
            elif 'code' in tmp_str and 'receiver' not in tmp_str and tmp_str.count('Not') % 2 == 1:
                halt = True
                # print(tmp_str)
                continue
            # logical_ans_(Not(receiver == code)) == 0
            elif 'code' in tmp_str and 'receiver' in tmp_str and tmp_str.count('Not') % 2 == 1:
                is_code_receiver = True
                # print(tmp_str)
            # action_name to func_name
            elif '(action == ' in tmp_str and tmp_str.count('Not') % 2 == 1:
                if 'Extract' not in tmp_str:
                    action_name = tmp_str

        # need to check whether it has 'require_auth'
        if is_code_receiver and action_name and not halt:
            # print(action_name)
            for key in key_import_funcs:
                tmp_str = str(key)
                # call_indirect_index
                if 'call_indirect_index=' in tmp_str:
                    # print(tmp_str)
                    index = int(tmp_str.split('=')[1])
                    index = index - \
                        wasmVM.ana.elements[0]['offset'][0].imm.value
                    mapped_index = wasmVM.ana.elements[0]['elems'][index]

                    import_func_count = len(wasmVM.ana.imports_func)
                    # because normal functions index follows the import functions
                    func_pos = mapped_index - import_func_count
                    func_name = wasmVM.cfg.functions[func_pos].name
                    receiver_func_set.add((func_name, action_name))
        # print("======one=======")

    for func_info in receiver_func_set:
        func_name, action_name = func_info[0], func_info[1]

        searched_funcs.clear()
        target_funcs.clear()
        search_func(call_path, func_name, key_imports)

        if not target_funcs:
            continue

        searched_funcs.clear()
        target_funcs.clear()
        search_func(call_path, func_name, require_auth)

        if not target_funcs:
            # current constraint is not enough to judge the require_auth problem
            # because it will be vulnerable if it's not require_auth(get_local_0) / require_auth(receiver)
            # i.e. thedeosgames luckydraw require_auth(get_local_1) which is not receiver
            # however, it will be non-vulnerable if it's require_auth(get_local_x) and local_x == local_0
            _issue = Issue('auth_check', True, [func_name, action_name])
            _issue_dict = {}
            _issue_dict['module'] = _issue.module
            _issue_dict['is_vulnerable'] = True
            _issue_dict['constraints'] = _issue.constraints
            _issues.append(_issue_dict.copy())

            # if not _issue_dict:
            #     for key in key_import_funcs:
            #         tmp_str = str(key)
            #         # Not the case of elem
            #         if '$' in tmp_str or '_Zn' in tmp_str:
            #             if not search_func(call_path, tmp_str, require_auth):
            #                 # current constraint is not enough to judge the require_auth problem
            #                 # because it will be vulnerable if it's not require_auth(get_local_0) / require_auth(receiver)
            #                 # however, it will be non-vulnerable if it's require_auth(get_local_x) and local_x == local_0
            #                 _issue = Issue('auth_check', True, tmp_str)
            #                 _issue_dict = {}
            #                 _issue_dict['module'] = _issue.module
            #                 _issue_dict['constraints'] = _issue.constraints
            #                 _issues.append(_issue_dict.copy())

    if not _issues:
        _issue = Issue('auth_check', False, '')
        _issue_dict = {}
        _issue_dict['module'] = _issue.module
        _issue_dict['is_vulnerable'] = False
        _issue_dict['constraints'] = _issue.constraints
        _issues.append(_issue_dict.copy())

    return _issues
    # exit()

    # return double_check(_issues, index_set, wasmVM, index2state)


# # if apply does not check, maybe indirect call function would check it
# def double_check(_issues, index_set, wasmVM, index2state):
#     if not _issues and index_set:
#         for need_check_index in index_set:
#             for func_index, states in index2state.items():
#                 print(func_index, states)
#                 if need_check_index != func_index:
#                     continue
#                 for state in states:
#                     wasmVM.reset_wasmvm(2)
#                     sym_exe, _ = wasmVM.emulate_functions(list_functions_name=[func_index], state=state)

#                     # format the sym_exe
#                     key_and_constraints = format_sym_exe(sym_exe)

#                     for one_path_result in key_and_constraints:
#                         key_import_funcs, constraints = one_path_result[0], one_path_result[1]

#                         check_result = quick_check(constraints)
#                         if check_result:
#                             _issues.extend(check_result)
#     else:
#         # means there is no need to execute the indirect call, the apply is enough
#         pass

#     return _issues

# def quick_check(keys, constraints):
#     _issues = []
#     is_code_receiver = False

#     for constraint in constraints:
#         tmp_str = str(constraint)
#         if 'If' in tmp_str:
#                 continue
#         if 'code == receiver' not in tmp_str and tmp_str.count('Not') % 2 == 1:
#             is_code_receiver = True

#         return _issues

# Whether upper_func calls targets
def search_func(call_path, entry, targets):
    for callee in call_path[entry]:
        if callee not in searched_funcs:
            searched_funcs.add(callee)
            search_func(call_path, callee, targets)
            if {callee} & targets:
                target_funcs.add(entry)
