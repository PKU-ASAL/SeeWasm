# This file gives some practical functions that will be adopted by other files

import json
import logging
import re
import struct
from codecs import decode
from datetime import datetime
from os import makedirs, path

from eunomia.arch.wasm.configuration import Configuration, bcolors
from eunomia.arch.wasm.exceptions import (INVALIDMEMORY, ProcFailTermination,
                                          UnsupportZ3TypeError)
from eunomia.arch.wasm.solver import SMTSolver
from z3 import (FP, BitVec, BitVecRef, Float32, Float64, is_bv, is_bv_value,
                sat, unsat)

# this is the opened files base addr
FILE_BASE_ADDR = 100000000


# this is a mapping, which maps the data type to the corresponding BitVec
def getConcreteBitVec(type, name):
    if type == 'i32':
        return BitVec(name, 32)
    elif type == 'i64':
        return BitVec(name, 64)
    elif type == 'f32':
        return FP(name, Float32())
    elif type == 'f64':
        return FP(name, Float64())
    else:
        raise UnsupportZ3TypeError


def readable_internal_func_name(func_index_to_func_name, internal_func_name):
    """
    Convert the internal name to a more readable one with the help of func_index_to_func_name
    """
    if func_index_to_func_name is None:
        return internal_func_name

    if not internal_func_name.startswith('$'):
        return internal_func_name

    readable_name = None
    try:
        readable_name = func_index_to_func_name[int(
            re.search('(\d+)', internal_func_name).group())]
    except (AttributeError, KeyError) as _:
        # if the internal_function_name is the readable name already
        readable_name = internal_func_name
    assert readable_name is not None, f"the internal funciton {internal_func_name} cannot find its corresponding readable name"
    return readable_name


def show_state_info(state_index, states):
    state = states[state_index]
    state_infos = state.items() if isinstance(
        state, dict) else [('fallthrough', state)]
    for _, info in state_infos:
        print(f'''
Current Func:\t{info.current_func_name}
Stack:\t\t{info.symbolic_stack}
Local Var:\t{info.local_var}
Global Var:\t{info.globals}
Memory:\t\t{info.symbolic_memory}\n''', flush=True)


def show_branch_info(branch, branches, state):
    bb_name = branches[branch]
    if branch in ['conditional_true', 'conditional_false']:
        logging.warning(
            f"[!] The constraint: {bcolors.WARNING}'{state[branch].solver.assertions()[-1]}'{bcolors.ENDC} will be appended")
    logging.warning(
        f"[!] You choose to go to basic block: {bcolors.WARNING}{bb_name}{bcolors.ENDC}")
    # commented, TODO, need revise, uncomment if neccessary
    # print(f'[!] Its instruction begins at offset {cls.bb_to_instructions[bb_name][0].offset}')
    # print(f'[!] The leading instructions are showed as follows:')
    # instructions = cls.bb_to_instructions[bb_name]
    # for i, instr in enumerate(instructions):
    #     if i >= 10:
    #         break
    #     print(f'\t{instr.operand_interpretation}')


def state_choose_info(emul_states):
    logging.warning(
        f"\n[+] Currently, there are {bcolors.WARNING}{len(emul_states)}{bcolors.ENDC} possible state(s) here")
    if len(emul_states) == 1:
        logging.warning(
            f"[+] Enter {bcolors.WARNING}'i'{bcolors.ENDC} to show its information, or directly press {bcolors.WARNING}'enter'{bcolors.ENDC} to go ahead")
        state_index = ask_user_input(
            emul_states, isbr=False, onlyone=True)
    else:
        logging.warning(
            f"[+] Please choose one to continue the following emulation (1 -- {len(emul_states)})")
        logging.warning(
            f"[+] You can add an 'i' to illustrate information of the corresponding state (e.g., '1 i' to show the first state's information)")
        state_index = ask_user_input(
            emul_states, isbr=False)  # 0 for state, is a flag
    state_item = emul_states[state_index]
    emul_states = [state_item]
    return emul_states


def ask_user_input(
        emul_states, isbr, onlyone=False, branches=None, state_item=None):
    # `concerned_variable` is state_index or branch, depends on the flag value
    branch_mapping = {
        'T': 'conditional_true',
        'F': 'conditional_false',
        'f': 'fallthrough',
        'u': 'unconditional',
        'conditional_true': 'T',
        'conditional_false': 'F',
        'fallthrough': 'f',
        'unconditional': 'u',
    }

    while True:
        user_input = input("[!] Please input the command: ")
        try:
            ask_for_info = False

            # if there is only one possible state
            if onlyone and not isbr:
                user_input = ("1 " + user_input) if user_input == 'i' else "1"
            elif onlyone and isbr:  # if there is only one possible branch
                branch_symbol = branch_mapping[list(branches.keys())[0]]
                user_input = branch_symbol + " " + \
                    user_input if user_input == 'i' else branch_symbol

            if ' ' in user_input:
                concerned_variable, ask_for_info = user_input.split(' ')
                assert ask_for_info == 'i'
                ask_for_info = True
            else:
                concerned_variable = user_input

            concerned_variable = branch_mapping[concerned_variable] if isbr else int(
                concerned_variable) - 1
            if not ask_for_info:
                break
            if isbr:
                show_branch_info(concerned_variable, branches, state_item)
            else:
                show_state_info(concerned_variable, emul_states)
        except Exception:
            logging.warning(
                f"{bcolors.FAIL}[!] Invalid input, please try again{bcolors.ENDC}")

    return concerned_variable


def bin_to_float(b):
    """ Convert binary string to a float. """
    bf = int_to_bytes(int(b, 2), 8)  # 8 bytes needed for IEEE 754 binary64.
    return struct.unpack('>d', bf)[0]


def int_to_bytes(n, length):  # Helper function
    """ Int/long to byte string.

        Python 3.2+ has a built-in int.to_bytes() method that could be used
        instead, but the following works in earlier versions including 2.x.
    """
    return decode('%%0%dx' % (length << 1) % n, 'hex')[-length:]


# the patterns used in C printf, and their corresponding length of to be loaded memory
C_TYPE_TO_LENGTH = {'s': 4, 'c': 4, 'd': 4, 'u': 4, 'x': 4, 'f': 8}


def calc_memory_align(parsed_pattern):
    """
    Used for calculate memory align in printf
    """
    offset = []
    for i, item in enumerate(parsed_pattern):
        cur_type = item[-1][-1]
        offset.append(C_TYPE_TO_LENGTH[cur_type])

        # decide if we should align the memory
        if cur_type == 'f':
            previous_sum = sum(offset[:i])
            if previous_sum % 8 != 0:
                offset[i - 1] += 4

    return offset


def parse_printf_formatting(lines):
    cfmt = '''\
(                                  # start of capture group 1
%                                  # literal "%"
(?:                                # first option
(?:[-+0 #]{0,5})                   # optional flags
(?:\d+|\*)?                        # width
(?:\.(?:\d+|\*))?                  # precision
(?:h|l|ll|w|I|I32|I64)?            # size
[cCdiouxXeEfgGaAnpsSZ]             # type
) |                                # OR
%%)                                # literal "%%"
'''

    # tuple list, in which each element consisting of line number, begin position and pattern
    result = []
    for line_num, line in enumerate(lines.splitlines()):
        for m in re.finditer(cfmt, line, flags=re.X):
            result.append([line_num, m.start(1), m.group(1)])
    return result


def _extract_outermost_int(num):
    """
    This function is used to extract the outermost int for a symbol.
    For example, if num is: a + 87, the function will return 87.
    If num is: a + b, the function will return None.
    """
    the_int = None
    if is_bv(num):
        for i in range(num.num_args()):
            if is_bv_value(num.arg(i)):
                the_int = num.arg(i).as_long()
                break
    elif isinstance(num, int):
        the_int = num
    else:
        exit(f"the type of num is {type(num)}, cannot extract the int args")

    return the_int


def str_to_little_endian_int(string):
    """
    Convert the given string to an integer, little endian
    For example, "abc" is 6513249
    """
    return int.from_bytes(str.encode(string), "little")


def write_result(state, exit=False):
    """
    Write result in ./log/result folder in json format
    """
    # if it is existed, and the stderr has no output
    # it means that it is raised by ProcFailTermination
    # do not write anything and just return
    if exit and not state.file_sys[2]['content']:
        return

    file_name = f"./log/result/{Configuration.get_file_name()}_{Configuration.get_start_time()}/state_{datetime.timestamp(datetime.now()):.3f}.json"
    makedirs(path.dirname(file_name), exist_ok=True)
    state_result = {}
    with open(file_name, 'w') as fp:
        if exit:
            if state.symbolic_stack:
                state_result["Status"] = f"Exit with status code {state.symbolic_stack[-1]}"
            else:
                state_result["Status"] = f"Exit"
        else:
            # return value
            if state.symbolic_stack:
                state_result["Return"] = str(state.symbolic_stack[-1])
            else:
                state_result["Return"] = None

        # solution of constraints
        state_result["Solution"] = {}
        state.solver.check()
        m = state.solver.model()
        # this check if there exist symbols with same name
        # which may lead to the result overwriting
        if len(set([k for k in m])) != len(m):
            logging.warning(
                f"the solving process found there exist symbols with identical name, please double check. ({[k for k in m]})")
        for k in m:
            # the decode is weird, we just want to convert unprintable characters
            # into printable chars
            # ref: https://stackoverflow.com/questions/13837848/converting-byte-string-in-unicode-string
            solution_hex_str = hex(m[k].as_long())[2:]
            if len(solution_hex_str) % 2 == 1:
                solution_hex_str = "0" + solution_hex_str
            solution = []
            for i in range(0, len(solution_hex_str), 2):
                solution.append(chr(int(solution_hex_str[i: i + 2], 16)))
            state_result["Solution"][str(k)] = "".join(solution[::-1])

        candidate_fds = []
        # filter out all output buffer
        for fd, file_info in state.file_sys.items():
            if "w" in file_info["flag"]:
                if isinstance(fd, int) or fd[0] == "-":
                    candidate_fds.append(fd)

        state_result["Output"] = []
        # stdout and stderr buffer
        for fd in candidate_fds:
            assert all(isinstance(x, (int, BitVecRef))
                       for x in state.file_sys[fd]["content"]), f"buffer is: {state.file_sys[fd]['content']}, not all int and bitvec"
            tmp_dict = {"name": None, "output": None}
            # output_buffer = []
            output_solve_buffer = []
            for el in state.file_sys[fd]["content"]:
                if isinstance(el, int):
                    # output_buffer.append(chr(el).encode())
                    output_solve_buffer.append(chr(el))
                elif isinstance(el, BitVecRef):
                    assert el.size() == 8, f"{el} size is not 8"
                    # output_buffer.append(str(el).encode())
                    # if can solve a concrete number
                    solve_char = m.evaluate(el)
                    if is_bv_value(solve_char):
                        output_solve_buffer.append(
                            chr(solve_char.as_long()))
                    elif is_bv(solve_char):
                        output_solve_buffer.append(b"`@`")
                    else:
                        exit(
                            f"result of solving {el} is {solve_char} and type is {type(solve_char)}")

            tmp_dict["name"] = state.file_sys[fd]["name"]
            # tmp_dict["output"] = f'{b"".join(output_buffer)}'
            tmp_dict["output"] = "".join(output_solve_buffer)
            state_result["Output"].append(tmp_dict)

        json.dump(state_result, fp, indent=4)


def init_file_for_file_sys():
    """
    The item for file_sys of state should be initialized here.
    """
    return {"name": "", "status": False, "flag": "", "content": []}


def log_in_out(func_name, directory):
    """
    A decorator to log before entering and after exiting call emulation
    """
    def decorator(f):
        def wrapper(*args, **kw):
            logging.info(f"Call: {func_name} ({directory})")
            states = f(*args, **kw)
            logging.info(f"Return: {func_name} ({directory})")
            return states
        return wrapper
    return decorator


def query_cache(solver):
    """
    Check is assertions in solver are cached.
    If they are, return directly, or update the cache and return
    """
    cons_hash_set = {hash(c) for c in solver.assertions()}
    cons_hash_list = list(cons_hash_set)
    cons_hash_list.sort()
    cons_hash_tuple = tuple(cons_hash_list)

    if cons_hash_tuple not in Configuration._z3_cache_dict:
        solver_check_result = solver.check()

        # try to terminate invalid-memory in advance
        if solver_check_result == sat:
            m = solver.model()
            for k in m:
                if str(k) == 'invalid-memory':
                    Configuration._z3_cache_dict[cons_hash_tuple] = unsat
                    raise ProcFailTermination(INVALIDMEMORY)

        Configuration._z3_cache_dict[cons_hash_tuple] = solver_check_result
    else:
        solver_check_result = Configuration._z3_cache_dict[cons_hash_tuple]

    return solver_check_result


def one_time_query_cache(solver, con):
    """
    the *args are received constraints, they will not be inserted into the solver.
    It is an one-time query
    """
    solver.push()
    solver.add(con)
    solver_check_result = query_cache(solver)
    solver.pop()

    return solver_check_result


def one_time_query_cache_without_solver(con):
    cons_hash_set = set([hash(c) for c in [con]])
    cons_hash_list = list(cons_hash_set)
    cons_hash_list.sort()
    cons_hash_tuple = tuple(cons_hash_list)
    if cons_hash_tuple not in Configuration._z3_cache_dict:
        s = SMTSolver(Configuration.get_solver())
        s.add(con)
        solver_check_result = s.check()
        Configuration._z3_cache_dict[cons_hash_tuple] = solver_check_result
    else:
        solver_check_result = Configuration._z3_cache_dict[cons_hash_tuple]

    return solver_check_result
