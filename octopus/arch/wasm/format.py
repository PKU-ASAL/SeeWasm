# This file is written by Octopus
# It is for formatting

import re

from octopus.arch.wasm.constant import LANG_TYPE


def format_func_name(name, param_str, return_str):
    result = '{} '.format(return_str) if return_str else ''
    return ('{}{}({})'.format(result, name, param_str))


def format_bb_name(function_id, offset):
    return ('block_%x_%x' % (function_id, offset))


def format_kind_function(f_type):
    return f_type


def format_kind_table(element_type, flags, initial, maximum):
    return {'element_type': LANG_TYPE.get(element_type),
            'limits_flags': flags,
            'limits_initial': initial,
            'limits_maximum': maximum}


def format_kind_memory(flags, initial, maximum):
    return {'limits_flags': flags,
            'limits_initial': initial,
            'limits_maximum': maximum}


def format_kind_global(mutability, content_type, current_instruction):
    # leave mutability temporarily
    return [content_type, current_instruction]


def format_scan_result(result):
    def name_to_string(val=13949526960272233840):
        charmap = ".12345abcdefghijklmnopqrstuvwxyz"
        result = ['.'] * 13
        for i in range(12 + 1):
            c = charmap[val & (0x0f if i == 0 else 0x1f)]
            result[12 - i] = c
            val >>= (4 if i == 0 else 5)
        result = ''.join(result).rstrip('.')
        return result

    def decode(matchobj):
        original = int(matchobj.group(0))
        result = name_to_string(original)
        return result

    new_result = list()

    for key_functions, constraints in result:
        new_key_functions = key_functions
        new_constraints = list()
        for constraint in constraints:
            constraint = str(constraint)
            if 'action ==' in constraint or 'code ==' in constraint:
                constraint = re.sub(r'[0-9]{10,}', decode, constraint)
            new_constraints.append(constraint)
        new_result.append([new_key_functions.copy(), new_constraints.copy()])

    return new_result


def format_sym_exe(sym_exe):
    key_and_constraints = []

    for _, tmp_tuple in enumerate(sym_exe):
        path_state = tmp_tuple[1]
        constraints = path_state.constraints
        key_and_constraints.append([key_import_funcs, constraints])

    # substitute long number to human readable name
    key_and_constraints = format_scan_result(key_and_constraints)

    return key_and_constraints
