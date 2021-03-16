from octopus.arch.wasm.format import format_sym_exe
from octopus.arch.wasm.report import Issue
import re

def execute(wasmVM, sym_exe, index2state):
    _issues = []
    action_data_size = set(['action_data_size'])
    candidate_func_set = search_const_func(wasmVM.cfg.functions)
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
        # one_path_result is combined by [key_import_funcs, constraints]
        key_import_funcs, constraints = one_path_result[0], one_path_result[1]
        if not key_import_funcs:
            continue

        transfer_flag = False
        code_detect_flag = False
        for constraint in constraints:
            tmp_str = str(constraint)

            if 'If' in tmp_str:
                continue
            # action == transfer
            if ('(action == transfer)' in tmp_str or '(transfer == action)' in tmp_str) and tmp_str.count('Not') % 2 == 1:
                transfer_flag = True
            if 'code' in tmp_str and 'receiver' not in tmp_str and tmp_str.count('Not') % 2 == 1:
                code_detect_flag = True

        if transfer_flag and not code_detect_flag:
            for key in key_import_funcs:
                tmp_str = str(key)

                if 'call_indirect_index=' in tmp_str:
                    index = int(tmp_str.split('=')[1])
                    index = index - wasmVM.ana.elements[0]['offset'][0].imm.value
                    mapped_index = wasmVM.ana.elements[0]['elems'][index]

                    import_func_count = len(wasmVM.ana.imports_func)
                    # because normal functions index follows the import functions
                    func_pos = mapped_index - import_func_count
                    func_name = wasmVM.cfg.functions[func_pos].name

                    if func_name in candidate_func_set or search_func(call_path, func_name, candidate_func_set):
                        # current constraint is enough to judge the fake EOS problem
                        # _issue = Issue('fake_eos', True, constraints)
                        # TODO we don't need constraints actually
                        _issue = Issue('fake_eos', True, '')
                        _issue_dict = {}
                        _issue_dict['module'] = _issue.module
                        _issue_dict['is_vulnerable'] = _issue.is_vulnerable
                        _issue_dict['constraints'] = _issue.constraints
                        _issues.append(_issue_dict.copy())

                if '$' in str(key) or '_Zn' in str(key):
                    if key in candidate_func_set or search_func(call_path, key, candidate_func_set):
                        # current constraint is enough to judge the fake EOS problem
                        # _issue = Issue('fake_eos', True, constraints)
                        # TODO we don't need constraints actually
                        _issue = Issue('fake_eos', True, '')
                        _issue_dict = {}
                        _issue_dict['module'] = _issue.module
                        _issue_dict['is_vulnerable'] = _issue.is_vulnerable
                        _issue_dict['constraints'] = _issue.constraints
                        _issues.append(_issue_dict.copy())

    if not _issues:
        _issue = Issue('fake_eos', False, '')
        _issue_dict = {}
        _issue_dict['module'] = _issue.module
        _issue_dict['is_vulnerable'] = _issue.is_vulnerable
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


def quick_check(keys, constraints):
    _issues = []
    transfer_flag = False
    code_detect_flag = False

    for constraint in constraints:
        # action == transfer
        if 'action == transfer' == constraint.__str__():
            transfer_flag = True
        if 'code' in constraint.__str__() and 'Not' not in constraint.__str__() and 'receiver' not in constraint.__str__():
            code_detect_flag = True

    if transfer_flag and not code_detect_flag:
        # current constraint is enough to judge the fake EOS problem
        # _issue = Issue('fake_eos', True, constraints)
        # TODO we don't need constraints actually
        _issue = Issue('fake_eos', True, '')
        _issue_dict = dict()
        # _issue_dict['indirect_call_index'] = _issue.indirect_call_index
        _issue_dict['module'] = _issue.module
        _issue_dict['is_vulnerable'] = True
        _issue_dict['constraints'] = _issue.constraints
        _issues.append(_issue_dict.copy())

        return _issues

# Whether upper_func calls targets
def search_func(call_path, entry, targets):
    if call_path[entry]:
        for callee in call_path[entry]:
            if callee in targets:
                return True
            else:
                # callee's callee.. in targets
                result = search_func(call_path, callee, targets)
                if result:
                    return True

# Whether func contains value check
def search_const_func(funcs):
    search_const_func_set = set()
    for func in funcs:
        for i in func.instructions:
            if not i.operand_interpretation:
                continue
            if '4611686018427387903' in i.operand_interpretation:
                search_const_func_set.add(func.name)
                break

    return search_const_func_set