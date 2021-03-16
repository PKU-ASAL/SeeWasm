import logging
import re

from octopus.arch.wasm.format import format_sym_exe
from octopus.arch.wasm.report import Issue

fake_receipt = {'send_inline', 'db_store_i64', 'db_update_i64'}
target_funcs = set()
searched_funcs = set()


def execute(wasmVM, sym_exe, index2state):
    # try to find the index_set manually
    functions = wasmVM.cfg.functions
    index_set = set()

    # init a call path
    nodes, edges = wasmVM.cfg.get_functions_call_edges()
    call_path = dict()
    for node in nodes:
        call_path[node] = set()
    for edge in edges:
        if edge.node_to != edge.node_from:
            call_path[edge.node_from].add(edge.node_to)

    funcs_apply = list()
    for func in functions:
        if 'apply' in func.name:
            funcs_apply.append(func)
    assert funcs_apply != [], "cannot find apply in this contract"

    for func_apply in funcs_apply:
        # because the transfer may be followed by a eq or ne instruction
        eq_set, ne_set = set(), set()
        found_transfer = False

        basic_blocks_apply = func_apply.basicblocks
        # 1. grab the basic blocks which contain the transfer const
        # 2. initialize a dict, the key is the first instruction's offset and the value is the basic block
        offset2basicblocks = dict()
        for basic_block in basic_blocks_apply:
            # init the dict
            first_instr_offset = basic_block.instructions[0].offset
            offset2basicblocks[first_instr_offset] = basic_block
            # try to find the blocks containing transfer
            for instr in basic_block.instructions:
                if '-3617168760277827584' in str(instr):
                    found_transfer = True
                    continue
                if found_transfer:
                    found_transfer = False
                    if 'eq' in str(instr):
                        eq_set.add(basic_block)
                    elif 'ne' in str(instr):
                        ne_set.add(basic_block)
                    else:
                        # other instructions follows
                        # do nothing
                        pass

        if not eq_set and not ne_set:
            continue

        # grab the target basic block by the last instruction's xref for eq_set
        target_basic_blocks = set()
        for basic_block in eq_set:
            if basic_block.instructions[-1].xref:
                last_instr_xref = basic_block.instructions[-1].xref[0]
            else:
                continue
            target_basic_blocks.add(offset2basicblocks[last_instr_xref])

        # grab the target basic block by the last instruction's offset for ne_set
        for basic_block in ne_set:
            last_instr_offset = basic_block.instructions[-1].offset_end
            target_basic_blocks.add(offset2basicblocks[last_instr_offset + 1])

        # fetch the 2nd const from each of target basic blocks
        found_const = False
        for target_basic_block in target_basic_blocks:
            for instr in target_basic_block.instructions:
                if 'i32.const 0' in str(instr) and not found_const:
                    found_const = True
                    continue
                elif 'i32.const' in str(instr) and found_const:
                    found_const = False
                    index_set.add(int.from_bytes(
                        instr.operand, byteorder='big'))
                    break

    # remove the obviously wrong index from index_set
    index_set_dup = set()
    for index in index_set:
        # means no elements section in this module
        if not wasmVM.ana.elements:
            break

        if (index - wasmVM.ana.elements[0]['offset'][0].imm.value) >= len(wasmVM.ana.elements[0]['elems']):
            continue
        index_set_dup.add(index)
    index_set = index_set_dup

    # if the index_set is empty, try to check whether the check is performed in apply
    if index_set:
        logging.info(f"the index_set found by static analyze is {index_set}")
        return double_check(call_path, index_set, index2state, wasmVM)
    else:
        transfer_inline_flag = False
        # find `transfer` in data section
        for data in wasmVM.ana.datas:
            if b'transfer' in data['data']:
                transfer_inline_flag = True
                break

        # try to run all the paths in `apply`
        if transfer_inline_flag:
            sym_exe, _ = wasmVM.emulate_functions(
                list_functions_name=['apply'])

            # find the key funcs which may contain `transfer`
            may_contain_transfer_funcs = set()

            key_and_constraints = format_sym_exe(sym_exe)
            for item in key_and_constraints:
                keys, constraints = item[0], item[1]
                for constraint in constraints:
                    if '(action == transfer)' in constraint and constraint.count(
                            'Not') % 2 == 1 and 'If' not in constraint:
                        for key in keys:
                            may_contain_transfer_funcs.add(key)
                        break

            # check which func may be the `transfer`
            for suspect_func in may_contain_transfer_funcs:
                # print('suspect:', suspect_func)
                if type(suspect_func) == str:
                    continue
                suspect_func = index2func_name(wasmVM, suspect_func)
                search_func(call_path, suspect_func, fake_receipt)

            _issues = []
            for target_func in target_funcs:
                _issues.extend(generate_issues(wasmVM, target_func, _issues))

            return _issues
        else:
            _issues = []
            _issue = Issue('fake_receipt', False, [])
            _issue_dict = dict()
            _issue_dict['module'] = _issue.module
            _issue_dict['is_vulnerable'] = False
            _issue_dict['constraints'] = _issue.constraints
            _issues.append(_issue_dict.copy())
            return _issues


def index2func_name(wasmVM, index):
    import_funcs_count = len(wasmVM.ana.imports_func)
    index -= import_funcs_count
    return wasmVM.cfg.functions[index].name


def double_check(call_path, index_set, index2state, wasmVM):
    print("within double_check()")
    _issues = []
    if index_set:
        for need_exec_index in index_set:
            try:
                # eliminate the elem index offset
                need_exec_index = need_exec_index - \
                    wasmVM.ana.elements[0]['offset'][0].imm.value
                mapped_index = wasmVM.ana.elements[0]['elems'][need_exec_index]

                import_func_count = len(wasmVM.ana.imports_func)
                # because normal functions index follows the import functions
                func_pos = mapped_index - import_func_count
                func_name = wasmVM.cfg.functions[func_pos].name
            except Exception:
                logging.info(
                    f"the index found {need_exec_index} in not a valid pos")
                continue
            else:
                search_func(call_path, func_name, fake_receipt)
                if not target_funcs:
                    continue

                _issues.extend(generate_issues(wasmVM, func_name, _issues))

    return _issues


def generate_issues(wasmVM, func_name, _issues):
    # quick option seems cannot be used here
    # because of the whitelist rules
    wasmVM.reset_wasmvm(1, quick=True, lasers=['fake_receipt'])
    # no nested indirect call execution here, thus drop the second return value
    sym_exe, _ = wasmVM.emulate_functions(list_functions_name=[func_name])

    # format the sym_exe
    key_and_constraints = format_sym_exe(sym_exe)

    if key_and_constraints:
        last_path_result = key_and_constraints[-1]
        keys, constraints = last_path_result[0], last_path_result[1]
    else:
        keys, constraints = [], []
    _issues = quick_check(keys, constraints)
    print("after quick_check():", _issues)
    if _issues and _issues[-1]['is_vulnerable'] is False:
        return _issues
    else:
        _issues = []
        _issue = Issue('fake_receipt', True, constraints)
        _issue_dict = dict()
        _issue_dict['module'] = _issue.module
        _issue_dict['is_vulnerable'] = True
        _issue_dict['constraints'] = _issue.constraints
        _issues.append(_issue_dict.copy())
        print("within the else branch", _issues)

    return _issues


def quick_check(keys, constraints):
    offset_to = None
    protect_flag = True
    _issues = []
    _issue = Issue('fake_receipt', False, [])
    _issue_dict = dict()
    _issue_dict['module'] = _issue.module
    _issue_dict['is_vulnerable'] = False
    _issue_dict['constraints'] = _issue.constraints
    _issues.append(_issue_dict.copy())

    for ind, constraint in enumerate(constraints):
        tmp_str = str(constraint)

        if 'If' in tmp_str:
            continue
        elif '4611686018427387903' in tmp_str and 'load_i64*' in tmp_str and not offset_to:
            value = re.search(
                r'ULE\(4611686018427387903[ \n+]*Extract\(62,[ \n]*0,[ \n]*load_i64\*\(([0-9]*)\)\),[ \n]*9223372036854775806\)\)',
                tmp_str)
            if not value:
                value = re.search(
                    r'ULE\(9223372036854775807,[ \n]*4611686018427387903[ \n]*\+[ \n]*load_i64\*\(([0-9]*)\)',
                    tmp_str)
            try:
                offset_to = int(value.group(1)) - 8
            except ValueError:
                pass
            except AttributeError:
                pass
        # $func53_loc_2_i64 == load_i64*($func53_loc_0_i32)
        # load_i64*($func55_loc_0_i32) == load_i64*($func55_loc_2_i32)
        elif 'load_i64*' in tmp_str and '_loc_0_i32' in tmp_str and '_loc_2_i' in tmp_str:
            if tmp_str.count('Not') % 2 == 1:
                for key in keys:
                    if 'db' in str(key) or 'send' in str(key):
                        return _issues
            # when self != to, the transfer func exit() quickly
            else:
                for key in keys:
                    if 'db' in str(key) or 'send' in str(key):
                        protect_flag = False
                if protect_flag:
                    return _issues
                protect_flag = True

        elif re.search(r'Not\(logical_ans_\([$A-Za-z0-9_]*_loc_2_i64[ \n]*==[ \n]*[0-9]*\)[ \n]*==[ \n]*0\)', tmp_str):
            if tmp_str.count('Not') % 2 == 1:
                for key in keys:
                    if 'db' in str(key) or 'send' in str(key):
                        return _issues
            # when self != to, the transfer func exit() quickly
            else:
                for key in keys:
                    if 'db' in str(key) or 'send' in str(key):
                        protect_flag = False
                if protect_flag:
                    return _issues
                protect_flag = True

    if offset_to:
        to_str = 'load_i64*(' + str(offset_to)
        for constraint in constraints:
            tmp_str = str(constraint)
            # logical_ans_(load_i64*($func49_loc_0_i32) == load_i64*(29432)) when value is load_i64*(29440)
            if 'load_i64*(' in tmp_str and to_str in tmp_str and '_loc_0_i32' in tmp_str:
                if tmp_str.count('Not') % 2 == 1:
                    for key in keys:
                        if 'db' in str(key) or 'send' in str(key):
                            return _issues
                # when self != to, the transfer func exit() quickly
                else:
                    for key in keys:
                        if 'db' in str(key) or 'send' in str(key):
                            protect_flag = False
                    if protect_flag:
                        return _issues
                    protect_flag = True

    return []


# Whether upper_func calls targets
def search_change_func(call_path, entry, targets):
    if call_path[entry]:
        for callee in call_path[entry]:
            if callee in targets:
                return True
            else:
                # callee's callee.. in targets
                result = search_change_func(call_path, callee, targets)
                if result:
                    return True


def search_func(call_path, entry, targets):
    for callee in call_path[entry]:
        if callee not in searched_funcs:
            searched_funcs.add(callee)
            search_func(call_path, callee, targets)
            if {callee} & targets:
                target_funcs.add(entry)
