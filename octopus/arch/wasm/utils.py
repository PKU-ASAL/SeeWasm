from z3 import *
from . exceptions import *


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



def show_state_info(state_index, states):
    state = states[state_index]
    state_infos = state.items() if isinstance(state, dict) else [('fallthrough', state)]
    for edge_type, info in state_infos:
        print(f'''
PC:\t\t{info.pc}
Current Func:\t{info.current_func_name}
Stack:\t\t{info.symbolic_stack}
Local Var:\t{info.local_var}
Global Var:\t{info.globals}
Memory:\t\t{info.symbolic_memory}
Constraints:\t{info.constraints[:-1]}\n''')

def show_branch_info(branch, branches, state):
    bb_name = branches[branch]
    if branch in ['conditional_true', 'conditional_false']:
        print(f'[!] The constraint: "{state[branch].constraints[-1]}" will be appended')
    print(f'[!] You choose to go to basic block: {bb_name}')
    # commented, TODO, need revise, uncomment if neccessary
    # print(f'[!] Its instruction begins at offset {cls.bb_to_instructions[bb_name][0].offset}')
    # print(f'[!] The leading instructions are showed as follows:')
    # instructions = cls.bb_to_instructions[bb_name]
    # for i, instr in enumerate(instructions):
    #     if i >= 10:
    #         break
    #     print(f'\t{instr.operand_interpretation}')

def ask_user_input(emul_states, isbr, branches=None, state_item=None):
    # the flag can be 0 or 1,
    # 0 means state, 1 means branch
    # `concerned_variable` is state_index or branch, depends on the flag value
    branch_mapping = {
        'T': 'conditional_true',
        'F': 'conditional_false',
        'f': 'fallthrough',
        'u': 'unconditional',
    }

    while True:
        user_input = input("[!] Please input the command: ")
        try:
            ask_for_info = False
            if ' ' in user_input:
                concerned_variable, ask_for_info = user_input.split(' ')
                assert ask_for_info == 'i'
                ask_for_info = True
            else:
                concerned_variable = user_input

            concerned_variable = branch_mapping[user_input] if isbr else int(concerned_variable) - 1
            if not ask_for_info:
                break
            if isbr:
                show_branch_info(concerned_variable, branches, state_item)
            else:
                show_state_info(concerned_variable, emul_states)
            print('')
        except:
            raise("[!] Valid input is needed")
    return concerned_variable
