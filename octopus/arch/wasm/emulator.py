import json
import logging
import re
from datetime import datetime
from functools import reduce
from random import sample

from z3 import *

import gvar
from octopus.arch.wasm.cfg import WasmCFG
from octopus.arch.wasm.helper import ImportFunction, can_jump_function, has_sidepath_call_keyimport, lookup_symbolic_memory, insert_symbolic_memory
from octopus.arch.wasm.security import fire_quick_check_by_module_name
from octopus.arch.wasm.vmstate import WasmVMstate
from octopus.engine.emulator import EmulatorEngine
from octopus.arch.wasm.helper_c import *

from . type2z3 import *
from . exceptions import *

from .instructions.VariableInstructions import *
from .instructions.MemoryInstructions import *
from .instructions.ConstantInstructions import *
from .instructions.LogicalInstructions import *
from .instructions.ConversionInstructions import *
from .instructions.BitwiseInstructions import *
from .instructions.ArithmeticInstructions import *

sys.setrecursionlimit(4096)

# you can comment below
# logging.basicConfig(filename='./logs/tmp.log',
# filemode='w',
# level=logging.INFO)
if gvar.logging_level_verbose:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)
MAX = 42

SKIP_FUNC_SET = ['malloc', 'free', 'strlen']
C_LIBRARY_FUNCS = ['$printf', '$scanf', '$strlen', '$swap']


# =======================================
# #         WASM Emulator               #
# =======================================


class WasmEmulatorEngine(EmulatorEngine):

    def __init__(self, bytecode):
        raise NotImplementedError


class WasmSSAEmulatorEngine(EmulatorEngine):

    def __init__(self, bytecode, random, timeout, call_depth=MAX, lasers=None, quick=False, func_index2func_name=None):

        # retrive instructions, basicblocks & functions statically
        if lasers is None:
            lasers = []

        self.cfg = WasmCFG(bytecode)
        self.ana = self.cfg.analyzer

        # random select from internal call branch
        self.random = random
        # call depth limit
        self.call_depth_limit = call_depth
        self.result = list()

        # timeout feature, x minutes
        self.timeout_min = timeout
        self.start_time = datetime.now()

        # roll_back
        self.func_path_start_time = None
        self.func_path_timeout_min = 4

        self.visiting_function_name_list = list()
        self.current_function = None
        self.current_f_instructions = None
        self.reverse_instructions = dict()
        self.current_f_basicblocks = None

        self.basicblock_per_instr = dict()
        self.current_basicblock = None
        # key: block.name, value: visited time
        self.visited_basicblock = dict()

        # only used in guided emulation
        self.pairs2jump_type = None
        self.mainline_function_state = None

        # constraint flag stack
        self.constraints_flag_stack = list()
        # key import function which are used for skipping function in sidepath
        self.sidepath_key_import_functions = [
            'tapos_block_num', 'tapos_block_prefix', 'send_inline', 'send_deferred']
        # key import function which are used in detector
        self.key_import_functions = ['db_get_i64', 'db_find_i64', 'db_remove_i64', 'db_update_i64', 'db_idx64_remove', 'db_idx64_store',
                                     'tapos_block_num', 'tapos_block_prefix', 'sha256', 'send_inline', 'send_deferred', 'require_auth']
        # quick means get result will fire laser immediately
        self.quick = {'fake_eos': False, 'fake_receipt': False,
                      'random': False, 'roll_back': False}
        if quick:
            assert len(
                lasers) == 1, "lasers name should always be with self.quick option"
            self.quick[lasers[0]] = True
            assert len(
                self.quick) == 4, f"there are only 4 detectors supported, do not add your own detector: {lasers[0]}"
        # lasers will fire
        self.lasers = lasers

        self.index2state = dict()

        self.data_section = dict()

        # init memory section with data section
        for _, data_section_value in enumerate(self.ana.datas):
            data = data_section_value['data']
            offset = data_section_value['offset']
            size = data_section_value['size']
            # print(offset, size, data)
            if offset == '4':
                exit("The offset of data section is 4, please check")
                self.data_section[(offset, offset + size)] = BitVecVal(int.from_bytes(data, byteorder='little'), size * 8)
            else:
                # the original implementation, but it will stuck when the data section is huge, so I comment this implementation
                # self.data_section[(offset, offset + size)] = BitVecVal(int.from_bytes(data, byteorder='big'), size * 8)
                self.data_section[(offset, offset + size)] = data
        # func index to func real name
        # like func 4 is $main function in C
        self.func_index2func_name = func_index2func_name

    def init_globals(self, state):
        for i, item in enumerate(self.ana.globals):
            op_type, op_val = item[0], BitVecVal(item[1], 32)
            state.globals[i] = op_val

    def init_state(self, func_name, param_str, return_str, has_ret):
        state = WasmVMstate()

        for i, local in enumerate(param_str.split(' ')):
            state.local_var[i] = getConcreteBitVec(local, func_name + '_loc_' + str(i) + '_' + local)

        # deal with the globals
        self.init_globals(state)

        if return_str:
            has_ret.append(True)
        else:
            has_ret.append(False)
        
        return state, has_ret

    def init_state_before_call(self, param_str, return_str, has_ret, state):
        num_arg = 0
        # this flag indicates whether the caller executes and returns properly
        # if the caller terminates in advance, which results in the imbalance of stack
        # we should use this flag to reallocate the arguments for callee
        need_to_reset = False

        if param_str:
            num_arg = len(param_str.split(' '))
            try:
                arg = [state.symbolic_stack.pop() for _ in range(num_arg)]
            except IndexError:
                need_to_reset = True

        if return_str:
            has_ret.append(True)
        else:
            has_ret.append(False)

        # init state of internal call
        new_state = copy.deepcopy(state)
        new_has_ret = has_ret

        if need_to_reset:
            for i, local in enumerate(param_str.split(' ')):
                new_state.local_var[i] = getConcreteBitVec(local, self.current_function.name + '_loc_' + str(i) + '_' + local)
        else:
            for x in range(num_arg):
                new_state.local_var[num_arg - 1 - x] = arg[x]
        
        # set the remaining local vars as None
        for x in range(num_arg, len(new_state.local_var)):
            new_state.local_var.pop(x)
        new_state.pc = 0

        return new_state, new_has_ret

    def reset_wasmvm(self, call_depth, random=None, quick=False, lasers=[]):
        # these options maybe changed by detectors
        self.call_depth_limit = call_depth
        self.random = random
        # if gvar.guided_emulation_flag:
        #     self.start_time = datetime.now()

        # the following two are combined
        self.quick = {'fake_eos': False, 'fake_receipt': False,
                      'random': False, 'roll_back': False}
        if quick:
            assert len(
                lasers) == 1, "lasers name should always be with self.quick option"
            self.quick[lasers[0]] = True
            assert len(
                self.quick) == 4, f"there are only 4 detectors supported, do not add your own detector: {lasers[0]}"
        self.lasers = lasers

        # reset these variables
        self.result = list()
        self.visiting_function_name_list = list()
        self.constraints_flag_stack = list()
        self.index2state = dict()

        # the others will not change or they will be re-initialized

    def set_from_function(self):
        # restore mainline function struct
        if gvar.guided_emulation_flag and not gvar.guided_emulation_mainline_function_flag and \
                len(self.visiting_function_name_list) == 1:

            self.visiting_function_name_list.pop()
            self.current_function = self.guided_emulation_mainline_function[0]
            self.current_f_instructions = self.guided_emulation_mainline_function[1]
            self.reverse_instructions = self.guided_emulation_mainline_function[2]
            self.current_f_basicblocks = self.guided_emulation_mainline_function[3]

            basicblock_path = self.guided_emulation_mainline_function[4]
            self.basicblock_per_instr.clear()
            for bb in self.current_f_basicblocks:
                for instr in bb.instructions:
                    if type(instr) is not str:
                        self.basicblock_per_instr[instr.offset] = bb
            self.current_basicblock = self.guided_emulation_mainline_function[5]

            gvar.guided_emulation_mainline_function_flag = True
            self.guided_emulation_mainline_function = None
            logging.debug(
                '[+] set from mainline function done, current function name: %s' % (self.current_function.name))
            logging.debug('')
        # restore last function struct
        elif len(self.visiting_function_name_list) > 0:
            last_visit_function_name = self.visiting_function_name_list.pop()
            self.current_function = self.cfg.get_function(
                last_visit_function_name)
            self.current_f_instructions = self.current_function.instructions
            self.reverse_instructions = {
                k: v for k, v in enumerate(self.current_f_instructions)}
            self.current_f_basicblocks = self.current_function.basicblocks

            for bb in self.current_f_basicblocks:
                for instr in bb.instructions:
                    self.basicblock_per_instr[instr.offset] = bb
            logging.debug('[+] set from function done, current function name: %s' %
                          (self.current_function.name))
            logging.debug('[+] now, the constraints flag is: %s' %
                          (self.current_function.constraint_flags))
            logging.debug('')
        else:
            logging.debug('[+] congratulations! reach the outermost function')

    def emulate_functions(self, depth, call_depth=0, list_functions_name=None, state=None):
        self.start_time = datetime.now()

        # reset key_import_func_visited
        if state is not None:
            state.key_import_func_visited = list()

        for func_name in list_functions_name:
            # retrieve func name according to the index
            if isinstance(func_name, int):
                func_name = func_name - self.ana.elements[0]['offset'][0].imm.value
                mapped_index = self.ana.elements[0]['elems'][func_name]
                import_func_count = len(self.ana.imports_func)
                # because normal functions index follows the import functions
                func_pos = mapped_index - import_func_count
                func_name = self.cfg.functions[func_pos].name

            # extract param and return str
            for func_info in self.ana.func_prototypes:
                if func_info[0] == func_name:
                    param_str, return_str = func_info[1], func_info[2]
                    break

            # the [] here is the `has_ret`
            # as here is the entry, thus it is empty
            state, has_ret = self.init_state(func_name, param_str, return_str, [])

            logging.info("=============================Function Name: %s=============================\n" % func_name)
            self.emulate_one_function(call_depth, function_name=func_name, state=state, depth=depth, has_ret=has_ret)
            
        return self.result, self.index2state

    def emulate_one_function(self, call_depth, function_name, depth, state=None, has_ret=[], basicblock_path=None):
        if function_name not in [x.name for x in self.cfg.functions]:
            raise Exception(
                'function_name not in this module - available: %s', self.ana.func_prototypes)

        self.current_function = self.cfg.get_function(function_name)
        # reset the return_value_and_state_list
        self.current_function.return_value_and_state_list = list()

        self.current_f_instructions = self.current_function.instructions
        # pc : instruction within a function
        self.reverse_instructions = {
            k: v for k, v in enumerate(self.current_f_instructions)}

        # basic blocks within a function
        self.current_f_basicblocks = self.current_function.basicblocks

        # create dict with:
        # * key = instruction offset
        # * value = basicblock reference
        # easy to get the corresponding basicblock per instr now
        for bb in self.current_f_basicblocks:
            for intr in bb.instructions:
                self.basicblock_per_instr[intr.offset] = bb

        if state is None: raise UninitializedStateError

        # launch emulation
        if gvar.guided_emulation_flag:
            self.emulate(state, depth, has_ret, call_depth, basicblock_path)
        else:
            self.emulate(state, depth, has_ret, call_depth)

        return copy.deepcopy(self.current_function.return_value_and_state_list)

    def construct_edges_with_condition(self, bb_path):
        self.pairs2jump_type = None
        pairs2jump_type = dict()

        pairs = set()
        for bb_index in range(len(bb_path) - 1):
            pairs.add((bb_path[bb_index], bb_path[bb_index + 1]))

        for edge in self.cfg.edges:
            pair = (edge.node_from, edge.node_to)
            if pair in pairs:
                pairs2jump_type[pair] = edge.type
        self.pairs2jump_type = pairs2jump_type.copy()

    def emulate_func_block_list(self, func_path, funcs_blocks_dict):
        self.func_path_start_time = datetime.now()
        gvar.guided_emulation_flag = True
        gvar.guided_emulation_mainline_function_flag = True

        state = WasmVMstate()
        # deal with the globals
        self.init_globals(state)

        # extract all params from self.ana.func_prototypes according to self.current_function.name
        for function_prototype in self.ana.func_prototypes:
            if function_prototype[0] == func_path[0]:
                target_func_locals = function_prototype[1]
                break

        # init state.local_var
        for i, local in enumerate(target_func_locals.split(' ')):
            state.local_var[i] = getConcreteBitVec(local, func_path[0] + '_loc_' + str(i) + '_' + local)

        def bb_index(basic_block_name):
            return int(basic_block_name.split('_')[-1], 16)

        def get_param(func_name):
            for func_prototype in self.ana.func_prototypes:
                if func_prototype[0] == func_name:
                    return func_prototype[1]
            exit('can not find func param')

        quick_checked_flag = False
        func2paths_constraints_and_keys = dict()
        for func_index, func in enumerate(func_path):
            # skip the remaining blocks if quick checked
            if quick_checked_flag:
                continue
            # logging.warning(f'entering func: %s' % func)
            has_set = False
            # use the current function as the initialized func
            initialized_state = copy.deepcopy(state)

            # func_path[-1] is import_func
            if func is func_path[-1]:
                break

            func2paths_constraints_and_keys[func] = list()

            # init some variables
            self.current_function = self.cfg.get_function(func)
            self.current_f_basicblocks = self.current_function.basicblocks
            for bb in self.current_f_basicblocks:
                for intr in bb.instructions:
                    self.basicblock_per_instr[intr.offset] = bb

            # a func may contain several basic blocks paths
            for basicblock_path in funcs_blocks_dict[func]:
                # if the running time exceeds the setting timeout minutes
                if (datetime.now() - self.func_path_start_time).total_seconds() > self.func_path_timeout_min * 60:
                    return func2paths_constraints_and_keys

                # logging.warning('entering basic blocks path: %s' % basicblock_path)
                instructions_sequence = list()

                basicblock_path.reverse()
                i, j = 0, 0
                while j < len(self.current_function.basicblocks) and i < len(basicblock_path):
                    if bb_index(basicblock_path[i]) == bb_index(self.current_function.basicblocks[j].name):
                        instructions_sequence.extend(
                            self.current_function.basicblocks[j].instructions)
                        # record current constraint, because in guidance emulation, there is no diverge
                        instructions_sequence.append('record')
                        i += 1
                        j += 1
                    elif bb_index(basicblock_path[i]) < bb_index(self.current_function.basicblocks[j].name):
                        i += 1
                    else:
                        j += 1

                # construct self.reverse_instruction
                self.reverse_instructions.clear()
                for i, instr in enumerate(instructions_sequence):
                    self.reverse_instructions[i] = instr

                # trim the reverse instructions if the next one is not a import func
                # e.g. [$func61, $func83, send_inline], the func61's instructions should be trimmed right before the
                # instruction `call 83`
                def trim_reverse_instructions(func, func_path):
                    current_func_index = func_path.index(func)

                    # make sure the next one is not the import func
                    next_func_id = None
                    if current_func_index + 1 < len(func_path) - 1:
                        next_func = func_path[current_func_index + 1]
                        for i, func_prototype in enumerate(self.ana.func_prototypes):
                            if next_func == func_prototype[0]:
                                next_func_id = i
                                break

                    if next_func_id:
                        i = len(self.reverse_instructions) - 1
                        while i > 0:
                            if type(self.reverse_instructions[i]) is str or self.reverse_instructions[
                                    i].name != 'call' or int(
                                    self.reverse_instructions[i].operand_interpretation.split(' ')[1]) != next_func_id:
                                del self.reverse_instructions[i]
                                i -= 1
                            else:
                                del self.reverse_instructions[i]
                                break

                trim_reverse_instructions(func, func_path)

                self.construct_edges_with_condition(basicblock_path)

                # if it is the first func
                if func_index == 0 or has_set:
                    state = copy.deepcopy(initialized_state)
                elif not has_set:
                    state.constraints.clear()
                    state, _ = self.init_state(func, get_param(func), "", [])
                    has_set = True
                    initialized_state = copy.deepcopy(state)

                # restore lasers for func_path from last path
                self.lasers = ['roll_back']
                self.emulate(state, depth=0, has_ret=[],
                             call_depth=0, basicblock_path=basicblock_path)
                # print(self.quick.items(), self.lasers)
                self.visited_basicblock.clear()
                if not self.lasers:
                    one_path_constraints_and_keys = (list(set(
                        self.result[-1][1].constraints)), list(set(self.result[-1][1].key_import_func_visited)))
                else:
                    one_path_constraints_and_keys = (
                        list(set(state.constraints)), list(set(state.key_import_func_visited)))
                func2paths_constraints_and_keys[func].append(
                    one_path_constraints_and_keys)

                # print('current basic block path constraints:', one_path_constraints)

                # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                if not quick_checked_flag:
                    for module_name, quick_checked in self.quick.items():
                        if quick_checked and module_name not in self.lasers:
                            quick_checked_flag = True

        return func2paths_constraints_and_keys

    def emulate(self, state, depth=0, has_ret=[], call_depth=0, basicblock_path=None):
        halt = False
        instr = None

        while not halt:
            # if the running time exceeds the setting timeout minutes
            if (datetime.now() - self.start_time).total_seconds() > self.timeout_min * 60:
                exit('["timeout!"]')

            pre_instr = instr
            # start instruction
            if state.pc < len(self.reverse_instructions):
                instr = self.reverse_instructions[state.pc]
            else:
                break

            # Save instruction and state
            state.instr = instr
            state.pc += 1

            self.current_basicblock = self.basicblock_per_instr[instr.offset]

            if gvar.guided_emulation_flag:
                halt = self.emulate_one_instruction(instr, pre_instr, state, depth, has_ret, call_depth, basicblock_path)
            else:
                halt = self.emulate_one_instruction(
                    instr, pre_instr, state, depth, has_ret, call_depth)

    def emulate_one_instruction(self, instr, pre_instr, state, depth, has_ret, call_depth, basicblock_path=None):
        if instr.operand_interpretation is None:
            instr.operand_interpretation = instr.name
        
        logging.debug(f'''
PC:\t\t{state.pc}
Current Func:\t{self.current_function.name}
Instruction:\t{instr.operand_interpretation}
Stack:\t\t{state.symbolic_stack}
Local Var:\t{state.local_var}
Global Var:\t{state.globals}
Memory:\t\t{state.symbolic_memory}\n''')

        for c in state.constraints:
            if type(c) != BoolRef:
                state.constraints.remove(c)
                # logging.warning(state.constraints)
                # exit()

        try:
            if instr.is_control:
                halt = self.emul_control_instr(instr, pre_instr, state, depth, has_ret, call_depth, basicblock_path)
            elif instr.is_parametric:
                halt = self.emul_parametric_instr(
                    instr, state, depth, has_ret, call_depth)
            elif instr.is_variable:
                halt = self.emul_variable_instr(instr, state)
            elif instr.is_memory:
                halt = self.emul_memory_instr(instr, state)
            elif instr.is_constant:
                halt = self.emul_constant_instr(instr, state)
            elif instr.is_logical_i32:
                halt = self.emul_logical_i32_instr(instr, state)
            elif instr.is_logical_i64:
                halt = self.emul_logical_i64_instr(instr, state)
            elif instr.is_logical_f32:
                halt = self.emul_logical_f32_instr(instr, state)
            elif instr.is_logical_f64:
                halt = self.emul_logical_f64_instr(instr, state)
            elif instr.is_arithmetic_i32:
                halt = self.emul_arithmetic_i32_instr(instr, state)
            elif instr.is_arithmetic_f32:
                halt = self.emul_arithmetic_f32_instr(instr, state)
            elif instr.is_arithmetic_f64:
                halt = self.emul_arithmetic_f64_instr(instr, state)
            elif instr.is_bitwise_i32:
                halt = self.emul_bitwise_i32_instr(instr, state)
            elif instr.is_bitwise_i64:
                halt = self.emul_bitwise_i64_instr(instr, state)
            elif instr.is_arithmetic_i64:
                halt = self.emul_arithmetic_i64_instr(instr, state)
            elif instr.is_conversion:
                halt = self.emul_conversion_instr(instr, state)
        except Exception:
            raise Exception('[!!] Error happened in instruction emulation')

        return halt

    def emul_control_instr(self, instr, pre_instr, state, depth, has_ret, call_depth, basicblock_path=None):

        halt = False
        if instr.name == 'unreachable':
            halt = True
        elif instr.name == 'loop':
            logging.debug('[LOOP]: %s' % (instr.offset))
            # remember which loop is traversed
            state.instructions_visited.add((self.current_function.name, instr.offset))
        elif instr.name in ['nop', 'block']:
            pass
        elif instr.name == 'else':
            # if in guided emulation
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                return False

            # if this else is jumped from a 'if' instruction, it can be continued
            if not pre_instr or pre_instr.name == 'if':
                pass
            else:
                # if the 'else' is not jumped from 'if', the control flow will jump to the 'else' xref
                jump_addr = instr.xref

                for idx in self.reverse_instructions:
                    if jump_addr[0] == self.reverse_instructions[idx].offset:
                        state.instr = self.reverse_instructions[idx]
                        state.pc = idx
                        break
        elif instr.name == 'if':
            op = state.symbolic_stack.pop()
            assert is_bv(op) or is_bool(
                op), f"the type of op popped from stack in `if` is {type(op)} instead of bv or bool"

            logging.debug('[IF] now the func is: %s' %
                          self.current_function.name)

            # if in guided emulation
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                print('IF')
                exit()

            # op situation:
            # 1. a zero BitVecVal, means False
            if is_bv_value(op) and op.as_long() == 0:
                jump_addr = instr.xref

                # should into new node but not
                for idx in self.reverse_instructions:
                    if jump_addr[0] == self.reverse_instructions[idx].offset:
                        state.instr = self.reverse_instructions[idx]
                        state.pc = idx
                        break

                logging.debug(
                    '[IF] This condition is always false, jump to the else branch')
                logging.debug('[IF] Current constraints can be solved and the flag is: %s, depth: %s' % (
                    self.current_function.constraint_flags, depth))
                logging.debug('')
                # after we 'jump' to the destination, change the current basic block
                self.current_basicblock = self.basicblock_per_instr[instr.offset]
            # op situation:
            # 1. a non-zero BitVecVal, means True
            # 2. some function's iterator
            elif (is_bv_value(op) and op.as_long() != 0) or op.__str__() in can_jump_function:
                logging.debug(
                    '[IF] This condition is always true, continue the following instructions')
                logging.debug('[IF] Current constraints can be solved and the flag is: %s, depth: %s' % (
                    self.current_function.constraint_flags, depth))
                logging.debug('')
            # op situation:
            # 1. is a BoolRef
            else:
                jump_addr = instr.xref
                new_state = copy.deepcopy(state)

                # if the op is a BitVecRef, try to convert it into BoolRef
                if is_bv(op):
                    op = simplify(op != 0)

                assert is_bool(
                    op), f"op type is {type(op)} instead of BoolRef in `if` instruction"
                # go to else branch firstly
                op = simplify(Not(op))
                new_state.constraints.append(simplify(op))
                # simplify the solver
                new_state.constraints = list(set(new_state.constraints))

                # left children
                # check if the left children's constraints can be satisfied
                s = Solver()
                s.add(*new_state.constraints)

                if gvar.guided_emulation_flag or sat == s.check():
                    # the constraints can be solved
                    self.current_function.constraint_flags.append(1)
                    logging.debug(
                        '[IF] Go to else branch. Current constraints can be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))
                    logging.debug(
                        '[x] Else branch path constraints can be satisfied:')
                    for c in new_state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('')

                    for idx in self.reverse_instructions:
                        if jump_addr[0] == self.reverse_instructions[idx].offset:
                            new_state.instr = self.reverse_instructions[idx]
                            new_state.pc = idx
                            break

                    # if in guided emulation, prune some branch
                    if gvar.guided_emulation_flag and not gvar.guided_emulation_mainline_function_flag:
                        self.current_basicblock = self.basicblock_per_instr[jump_addr[0]]
                        if self.current_basicblock.name not in self.visited_basicblock:
                            self.visited_basicblock[self.current_basicblock.name] = 1
                        else:
                            self.visited_basicblock[self.current_basicblock.name] += 1
                        # if self.visited_basicblock[self.current_basicblock.name] + 2*depth > 50:
                        #     return True

                    # go to the else branch
                    self.emulate(new_state, depth + 1, has_ret, call_depth)
                    # for test: we only need one_path_result in branched function
                    # if call_depth > 1:
                    #     return True
                    # if gvar.guided_emulation_flag:
                    #     return True

                    # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                    # TODO for HNYuuu, support multiple detector
                    for module_name, quick_checked in self.quick.items():
                        if quick_checked and module_name not in self.lasers:
                            return True
                    # restore the current basic block
                    self.current_basicblock = self.basicblock_per_instr[instr.offset]
                else:
                    # the constraints can not be solved
                    self.current_function.constraint_flags.append(-1)
                    logging.debug(
                        '[IF] Can not go to else branch. Current constraints can not be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))
                    logging.debug(
                        '[x] left children path constraints can not be satisfied:')
                    for c in new_state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('[x] current branch is pruned')
                    logging.debug('')

                # condition is True, go to the following instruction
                op = simplify(Not(op))
                state.constraints.append(op)
                # simplify the constraints
                state.constraints = list(set(state.constraints))

                # check if the constraints can be satisfied
                s = Solver()
                s.add(*state.constraints)

                if gvar.guided_emulation_flag or sat == s.check():
                    if not self.current_function.constraint_flags:
                        self.current_function.constraint_flags.append(0)
                    else:
                        self.current_function.constraint_flags[-1] = 0
                    logging.debug(
                        '[IF] Go to if branch. Current constraints can be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))
                    logging.debug(
                        '[x] If branch path constraints can be satisfied:')
                    for c in state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('')

                    self.emulate(state, depth + 1, has_ret, call_depth)
                    # for test: we only need one_path_result in branched function
                    # if call_depth > 1:
                    #     return True
                    # if gvar.guided_emulation_flag:
                    #     return True

                    # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                    for module_name, quick_checked in self.quick.items():
                        if quick_checked and module_name not in self.lasers:
                            return True
                    # restore
                    self.current_basicblock = self.basicblock_per_instr[instr.offset]
                    # if in guided emulation, prune some branch
                    if gvar.guided_emulation_flag and not gvar.guided_emulation_mainline_function_flag:
                        if self.current_basicblock.name not in self.visited_basicblock:
                            self.visited_basicblock[self.current_basicblock.name] = 1
                        else:
                            self.visited_basicblock[self.current_basicblock.name] += 1
                        # if self.visited_basicblock[self.current_basicblock.name] + 2*depth > 50:
                        #     return True

                    logging.debug(
                        '[IF] Current level both if and else branch were traversed, return to previous level')
                    self.current_function.constraint_flags.pop()
                else:
                    self.current_function.constraint_flags[-1] = -1
                    logging.debug(
                        '[IF] Can not go to if branch. Current constraints can not be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))
                    logging.debug(
                        '[x] right children path constraints can not be satisfied:')
                    for c in state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('[x] current branch is pruned')
                    logging.debug('')

                    logging.debug(
                        '[IF] Current level if branch can not be solved, so return to previous level')
                    self.current_function.constraint_flags.pop()

                # return the control flow
                halt = True
        elif instr.name == 'end':
            # if in guided emulation
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                return False

            # check if it's the last instructions of the function
            if instr.offset == self.current_f_instructions[-1].offset:
                halt = True

                # 1st is the return value, 2ed is the state
                state_tmp_list = [None, None]
                # the outer function needs to return a val
                if has_ret and has_ret[-1]:
                    to_be_returned = state.symbolic_stack.pop()
                    if is_bool(to_be_returned):
                        if is_false(to_be_returned):
                            to_be_returned = BitVecVal(0, 32)
                        elif is_true(to_be_returned):
                            to_be_returned = BitVecVal(1, 32)
                        else:
                            raise NotDeterminedRetValError

                    state_tmp_list[0] = to_be_returned

                state_tmp_list[1] = copy.deepcopy(state)

                self.current_function.return_value_and_state_list.append(
                    tuple(state_tmp_list))

                # 1. all branch with only True or False constraint, not symbolic execution result
                # 2. [0,0,0...,0] is the last node_path in one function
                logging.debug(
                    '[END] Reach the end which is located in the last line of function: %s, now constraint flag is: %s' % (
                        self.current_function.name, self.current_function.constraint_flags))
                logging.debug('[x] current constraint is:')
                for c in state.constraints:
                    logging.debug(' [x] %s' % c)
                logging.debug('')

                # reach the outermost function and has constraints
                if len(self.visiting_function_name_list) <= 0 and state_tmp_list[1].constraints:
                    current_result = copy.deepcopy(state_tmp_list)
                    # logging.warning("====one path end====")

                    if not reduce(lambda x, y: x or y, list(self.quick.values())):
                        self.result.append(current_result)
                    else:
                        for module_name, need_quick_check in self.quick.items():
                            if need_quick_check:
                                issue = fire_quick_check_by_module_name(current_result[1].key_import_func_visited,
                                                                        current_result[1].constraints, module_name)
                                # found a issue for specific laser A
                                issue = json.loads(issue)
                                if issue:
                                    # remove the laser A
                                    self.lasers = [
                                        l for l in self.lasers if l != module_name]
                                    # if this path result is vulnerable, add this path result to self.result and return to the emulate_functions
                                    self.result.append(current_result)
        elif instr.name == 'br':
            # if in guided emulation
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                return False

            jump_addr = instr.xref
            # if the destination is the loop which is visited
            # we should prune this branch
            if (self.current_function.name, jump_addr[0]) in state.instructions_visited:
                # state.instructions_visited.remove(jump_addr[0])
                return True

            for idx in self.reverse_instructions:
                if jump_addr[0] == self.reverse_instructions[idx].offset:
                    state.instr = self.reverse_instructions[idx]
                    state.pc = idx
                    break
            self.current_basicblock = self.basicblock_per_instr[instr.offset]
            # if in guided emulation, prune some branch
            if gvar.guided_emulation_flag and not gvar.guided_emulation_mainline_function_flag:
                if self.current_basicblock.name not in self.visited_basicblock:
                    self.visited_basicblock[self.current_basicblock.name] = 1
                else:
                    self.visited_basicblock[self.current_basicblock.name] += 1
                # if self.visited_basicblock[self.current_basicblock.name] + 2*depth > 50:
                #     return True
        elif instr.name == 'br_if':
            op = state.symbolic_stack.pop()
            assert is_bv(op) or is_bool(
                op), f"the type of op popped from stack in `br_if` is {type(op)} instead of bv or bool"

            # if in guided emulation
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:

                # # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                # for module_name, quick_checked in self.quick.items():
                #     if quick_checked and module_name not in self.lasers:
                #         return True

                current_bb = self.current_basicblock
                current_bb_index = basicblock_path.index(current_bb.name)

                # has following bb
                if current_bb_index + 1 < len(basicblock_path):
                    pair = (current_bb.name,
                            basicblock_path[current_bb_index + 1])
                else:
                    # this means reach the last basic block
                    # if the next function is `send inline`, can stop here and return the constraints
                    # if the next function is others, should follow the CFG and continue
                    return True

                jump_type = self.pairs2jump_type[pair]
                if jump_type == 'conditional_true':
                    if is_bv(op):
                        state.constraints.append(simplify(op != 0))
                    else:
                        state.constraints.append(op)
                elif jump_type == 'conditional_false':
                    if is_bv(op):
                        state.constraints.append(simplify(op == 0))
                    else:
                        state.constraints.append(Not(op))
                else:
                    print('BR_IF jump type is', jump_type)
                    exit()

                return False

            jump_addr = instr.xref

            logging.debug('[BRIF] now the func is: %s' %
                          (self.current_function.name))

            if (is_bv_value(op) and op.as_long() != 0) or op.__str__() in can_jump_function:
                for idx in self.reverse_instructions:
                    if jump_addr[0] == self.reverse_instructions[idx].offset:
                        state.instr = self.reverse_instructions[idx]
                        state.pc = idx
                        break

                logging.debug(
                    '[BRIF] This br_if condition is always true, so jump to the destination')
                logging.debug('[BRIF] Current constraints can be solved and the flag is: %s, depth: %s' % (
                    self.current_function.constraint_flags, depth))
                logging.debug('')

                # after we return from emul - restore current_basicblock
                self.current_basicblock = self.basicblock_per_instr[instr.offset]
            elif is_bv_value(op) and op.as_long() == 0:
                logging.debug(
                    '[BRIF] This br_if condition is always false, so follow the original instruction')
                logging.debug('[BRIF] Current constraints can be solved and the flag is: %s, depth: %s' % (
                    self.current_function.constraint_flags, depth))
                logging.debug('')
            # op is a BoolRef type
            else:
                # if the destination is the loop which is visited
                # do not go back, break out the loop
                if (self.current_function.name, jump_addr[0]) in state.instructions_visited:
                    # state.instructions_visited.remove(jump_addr[0])
                    return False

                # if in guided emulation, prune some branch
                if gvar.guided_emulation_flag and not gvar.guided_emulation_mainline_function_flag:
                    self.current_basicblock = self.basicblock_per_instr[jump_addr[0]]
                    if self.current_basicblock.name not in self.visited_basicblock:
                        self.visited_basicblock[self.current_basicblock.name] = 1
                    else:
                        self.visited_basicblock[self.current_basicblock.name] += 1
                    # if self.visited_basicblock[self.current_basicblock.name] + 2*depth > 50:
                    #     return True

                new_state = copy.deepcopy(state)

                # if the op is a BitVecRef, try to convert it into BoolRef
                if is_bv(op):
                    op = simplify(op != 0)

                assert is_bool(
                    op), f"op type is {type(op)} instead of BoolRef in `br_if` instruction and op is {op}"
                new_state.constraints.append(op)
                # simplify the solver
                new_state.constraints = list(set(new_state.constraints))

                # left children
                # check if the left children's constraints can be satisfied
                s = Solver()
                s.add(*new_state.constraints)

                if gvar.guided_emulation_flag or sat == s.check():
                    # the constraints can be solved
                    self.current_function.constraint_flags.append(1)
                    logging.info(
                        '[BRIF] Jump to the destination. Current constraints can be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))
                    logging.info(
                        '[x] Current path constraints can be satisfied:')
                    for c in new_state.constraints:
                        logging.info(' [x] %s' % c)
                    logging.info('')

                    # should into new node but not
                    for idx in self.reverse_instructions:
                        try:
                            if jump_addr[0] == self.reverse_instructions[idx].offset:
                                new_state.instr = self.reverse_instructions[idx]
                                new_state.pc = idx
                                break
                        except AttributeError:
                            return True

                    self.emulate(new_state, depth + 1, has_ret, call_depth)
                    # for test: we only need one_path_result in branched function
                    # if call_depth > 1:
                    #     return True
                    # if gvar.guided_emulation_flag:
                    #     return True

                    # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                    for module_name, quick_checked in self.quick.items():
                        if quick_checked and module_name not in self.lasers:
                            return True
                    self.current_basicblock = self.basicblock_per_instr[instr.offset]
                else:
                    self.current_function.constraint_flags.append(-1)
                    logging.debug(
                        '[BRIF] Can not jump to destination. Current constraints can not be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))
                    logging.debug(
                        '[BRIF] Current path constraints can not be satisfied:')
                    for c in new_state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('[BRIF] current branch is pruned')
                    logging.debug('')

                # right children
                # br_if False
                op = simplify(Not(op))
                state.constraints.append(op)

                # simplify the solver
                state.constraints = list(set(state.constraints))

                # check if the constraints can be satisfied
                s = Solver()
                s.add(*state.constraints)

                if gvar.guided_emulation_flag or sat == s.check():
                    if self.current_function.constraint_flags == []:
                        self.current_function.constraint_flags.append(0)
                    else:
                        self.current_function.constraint_flags[-1] = 0
                    logging.info(
                        '[BRIF] Follow the instructions. Current constraints can be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))
                    logging.info(
                        '[x] Right children path constraints can be satisfied:')
                    for c in state.constraints:
                        logging.info(' [x] %s' % c)
                    logging.info('')

                    self.emulate(state, depth + 1, has_ret, call_depth)
                    # for test: we only need one_path_result in branched function
                    # if call_depth > 1:
                    #     return True
                    # if gvar.guided_emulation_flag:
                    #     return True

                    # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                    for module_name, quick_checked in self.quick.items():
                        if quick_checked and module_name not in self.lasers:
                            return True
                    self.current_basicblock = self.basicblock_per_instr[instr.offset]
                    # if in guided emulation, prune some branch
                    if gvar.guided_emulation_flag and not gvar.guided_emulation_mainline_function_flag:
                        if self.current_basicblock.name not in self.visited_basicblock:
                            self.visited_basicblock[self.current_basicblock.name] = 1
                        else:
                            self.visited_basicblock[self.current_basicblock.name] += 1
                        # if self.visited_basicblock[self.current_basicblock.name] + 2*depth > 50:
                        #     return True

                    logging.debug('[BRIF] depth: %s' % depth)
                    logging.debug(
                        '[BRIF] current level both left and right node were traversed, return to previous level')
                    self.current_function.constraint_flags.pop()
                else:
                    self.current_function.constraint_flags[-1] = -1
                    logging.debug(
                        '[BRIF] Try to follow the instructions, but current constraints can not be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))
                    logging.debug(
                        '[x] Right children path constraints can not be satisfied:')
                    for c in state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('[BRIF] current branch is pruned')
                    logging.debug('')

                    logging.debug(
                        '[BRIF] Current level right node can not be solved, so return to previous level')
                    self.current_function.constraint_flags.pop()

                halt = True
        elif instr.name == 'br_table':
            op = state.symbolic_stack.pop()

            # if the branch operand is not a number, too much branches emulation may lead to path explosion
            # so we give up this situation's emulation
            if not is_bv_value(op):
                return True

            # if in guided emulation
            # because op currently is a concrete integer, and br_table add no constraint
            # therefore return False is enough here
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                return False

            branch = op.as_long()

            branches = list(instr.operand)
            # remove the first one
            branches.pop(0)

            try:
                index = branches.index(branch)
            except ValueError:
                index = -1

            jump_addr = instr.xref[index]

            for idx in self.reverse_instructions:
                if jump_addr == self.reverse_instructions[idx].offset:
                    state.instr = self.reverse_instructions[idx]
                    state.pc = idx
                    break

            self.current_basicblock = self.basicblock_per_instr[instr.offset]
            # if in guided emulation, prune some branch
            if gvar.guided_emulation_flag and not gvar.guided_emulation_mainline_function_flag:
                if self.current_basicblock.name not in self.visited_basicblock:
                    self.visited_basicblock[self.current_basicblock.name] = 1
                else:
                    self.visited_basicblock[self.current_basicblock.name] += 1

                # TODO for ruiyi
                # it's unreasonable
                # if self.visited_basicblock[self.current_basicblock.name] + 2*depth > 50:
                #     logging.warning('cut!')
                #     return True
        elif instr.name == 'return':
            # if in guided emulation
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                print('RETURN')
                exit()

            halt = True

            # 1st is the return value, 2ed is the state
            state_tmp_list = [None, None]
            if has_ret and has_ret[-1]:
                to_be_returned = state.symbolic_stack.pop()
                if is_bool(to_be_returned):
                    if is_false(to_be_returned):
                        to_be_returned = BitVecVal(0, 32)
                    elif is_true(to_be_returned):
                        to_be_returned = BitVecVal(1, 32)
                    else:
                        raise NotDeterminedRetValError

                state_tmp_list[0] = to_be_returned

            state_tmp_list[1] = copy.deepcopy(state)

            self.current_function.return_value_and_state_list.append(
                tuple(state_tmp_list))

            logging.debug(
                '[RET] reach the return which is located in the last line of function: %s, now constraint flag is: %s' % (
                    self.current_function.name, self.current_function.constraint_flags))
            logging.debug('[+] current constraint is:')
            for c in state.constraints:
                logging.debug(' [x] %s' % c)
            logging.debug('')

            if len(self.visiting_function_name_list) <= 0 and state_tmp_list[1].constraints:
                current_result = state_tmp_list

                if not reduce(lambda x, y: x or y, list(self.quick.values())):
                    self.result.append(current_result)
                else:
                    for module_name, need_quick_check in self.quick.items():
                        if need_quick_check:
                            issue = fire_quick_check_by_module_name(current_result[1].key_import_func_visited,
                                                                    current_result[1].constraints, module_name)
                            # found a issue for specific laser A
                            issue = json.loads(issue)
                            if issue:
                                # remove the laser A
                                self.lasers = [
                                    l for l in self.lasers if l != module_name]
                                # if this path result is vulnerable, add this path result to self.result and return to the emulate_functions
                                self.result.append(current_result)

        elif instr.name == 'call':
            try:
                f_offset = int(instr.operand_interpretation.split(' ')[1])
            except ValueError:
                # it's possible that the `call` operand is a hex
                f_offset = int(instr.operand_interpretation.split(' ')[1], 16)

            target_func = self.ana.func_prototypes[f_offset]
            name, param_str, return_str, _ = target_func
            # if the func_index2func_name is not None
            # change the function name to the more readable name
            if self.func_index2func_name is not None:
                name = self.func_index2func_name[int(re.search('(\d+)', name).group())]
            state.key_import_func_visited.append(name)

            # get callee function name
            import_func_count = len(self.ana.imports_func)
            if f_offset > import_func_count:
                # because normal functions index follows the import functions
                func_pos = f_offset - import_func_count
                internal_function_name = self.cfg.functions[func_pos].name
            else:
                internal_function_name = name

            # logging.warning(internal_function_name)

            # if in guided emulation
            if gvar.guided_emulation_flag and False:  # off

                # for stack balance
                if param_str:
                    args_num = len(param_str.split(' '))
                    for _ in range(args_num):
                        state.symbolic_stack.pop()
                if return_str:
                    if return_str == 'i32':
                        state.symbolic_stack.append(
                            BitVec(
                                internal_function_name + '_ret_i32' + '_' + self.current_function.name + '_' + str(
                                    state.pc), 32))
                    elif return_str == 'i64':
                        state.symbolic_stack.append(
                            BitVec(
                                internal_function_name + '_ret_i64' + '_' + self.current_function.name + '_' + str(
                                    state.pc), 64))
                    elif return_str == 'f32':
                        state.symbolic_stack.append(FP(
                            internal_function_name + '_ret_f32' + '_' + self.current_function.name + '_' + str(
                                state.pc), Float32()))
                    elif return_str == 'f64':
                        state.symbolic_stack.append(FP(
                            internal_function_name + '_ret_f32' + '_' + self.current_function.name + '_' + str(
                                state.pc), Float64()))
                return False

            func_is_exports = internal_function_name in [
                x['field_str'] for x in self.ana.exports]
            # some contract may not have elems
            if self.ana.elements:
                func_is_elems = f_offset in self.ana.elements[0]['elems']
            else:
                func_is_elems = False

            # skip these functions
            func_is_not_from_system = (internal_function_name[0] == '_' and internal_function_name[1] == '_') or \
                internal_function_name in SKIP_FUNC_SET or (
                '_Zn' in internal_function_name and 'eos' not in internal_function_name) or \
                '_ZdaPv' in internal_function_name or 'printf' in internal_function_name

            # if the function is the EOSIO library function
            if internal_function_name not in [x.name for x in self.cfg.functions]:
                if f_offset > len(self.ana.imports_func):
                    raise Exception(
                        'function_name not in this module - available: %s', self.ana.func_prototypes)
                else:
                    # import functions processed here
                    args_num = len(param_str.split(' '))
                    param_list = []
                    if param_str:
                        param_list = [state.symbolic_stack.pop()
                                      for _ in range(args_num)]
                        # reverse
                        param_list = param_list[::-1]

                    import_func = ImportFunction(
                        internal_function_name, param_list, return_str, state)

                    # if fake_receipt quick option is enabled
                    # or self.quick['roll_back']:
                    if self.quick['fake_receipt']:
                        if internal_function_name == 'send_inline':
                            state_tmp_list = [None, None]
                            state_tmp_list[1] = copy.deepcopy(state)

                            current_result = copy.deepcopy(state_tmp_list)
                            self.result.append(current_result)

                            return True

                    # append function's result into symbolic stack
                    if internal_function_name == 'eosio_assert':
                        if import_func.halt:
                            halt = import_func.get_halt()
                            logging.debug('[+] eosio_assert failed')
                            logging.debug('[x] current constraints:')
                            for c in import_func.get_constraint():
                                logging.debug(' [x] %s' % c)
                            logging.debug(
                                '[x] Therefore jump to the previous level')
                            logging.debug('')
                        elif import_func.constraint != None:
                            state.constraints = import_func.get_constraint()

                        if gvar.guided_emulation_flag:
                            halt = False
                    elif internal_function_name == 'eosio_assert_code':
                        if import_func.halt:
                            halt = import_func.get_halt()
                            logging.debug('[+] eosio_assert_code failed')
                            logging.debug('[x] current constraints:')
                            for c in import_func.get_constraint():
                                logging.debug(' [x] %s' % c)
                            logging.debug(
                                '[x] Therefore jump to the previous level')
                            logging.debug('')
                        elif import_func.constraint != None:
                            state.constraints = import_func.get_constraint()

                        if gvar.guided_emulation_flag:
                            halt = False
                    elif internal_function_name == 'memcpy':
                        # void* memcpy(void*dest, const void *src, size_t n)
                        # return is a pointer to dest
                        # but sometimes the `memcpy` may fail, so halt
                        if not import_func.get_halt():
                            state.symbolic_stack.append(
                                import_func.return_result())
                        else:
                            halt = True
                    elif internal_function_name == 'memmove':
                        if not import_func.get_halt():
                            state.symbolic_stack.append(
                                import_func.return_result())
                        else:
                            halt = True
                    elif internal_function_name == 'sha256':
                        if import_func.get_halt():
                            halt = True
                    elif internal_function_name == 'abort':
                        halt = True
                    elif internal_function_name == 'require_auth':
                        state.constraints = import_func.get_constraint()
                    elif internal_function_name == 'require_auth2':
                        state.constraints = import_func.get_constraint()
                    elif internal_function_name == 'memset':
                        state.symbolic_stack.append(
                            import_func.return_result())
                    elif internal_function_name == 'eosio_exit':
                        halt = True
                    elif internal_function_name == 'db_get_i64':
                        state.symbolic_stack.append(
                            import_func.return_result())
                    elif internal_function_name in self.key_import_functions:
                        state.key_import_func_visited.append(
                            import_func.format_key_import_func())
                        # print(import_func.format_key_import_func())

                        import_func_result = import_func.return_result()
                        if import_func_result is not None:
                            state.symbolic_stack.append(
                                import_func.return_result())

                        # TODO for ruiyi, what's the purpose
                        # if internal_function_name == 'db_find_64' or internal_function_name == 'db_store_i64':
                        #     halt = True
                    else:
                        import_func_result = import_func.return_result()
                        if import_func_result is not None:
                            # to distinguish between different function with same name
                            state.symbolic_stack.append(import_func_result)

            elif call_depth >= self.call_depth_limit or func_is_not_from_system:
                # (func_is_exports and not func_is_elems and func_is_not_from_system):
                # record the key funcs for the fake receipt detector
                state.key_import_func_visited.append(f_offset)

                if param_str:
                    num_arg = len(param_str.split(' '))
                    for _ in range(num_arg):
                        state.symbolic_stack.pop()
                if return_str:
                    state.symbolic_stack.append(getConcreteBitVec(return_str, internal_function_name + '_ret_' + return_str + '_' + self.current_function.name + '_' + str(state.pc)))

            # the function is the C library functions, here
            elif name in C_LIBRARY_FUNCS:
                # if the return value is dependent on the library function, we will manually contruct it
                # and jump over the process in which it append a symbol according to the signature of the function
                manually_constructed = False

                param_list = []
                if param_str:
                    num_arg = len(param_str.split(' '))
                    for _ in range(num_arg):
                        param_list.append(state.symbolic_stack.pop())

                if name == '$printf':
                    # has to use as_long()
                    mem_pointer, start_pointer = param_list[0].as_long(), param_list[1].as_long()
                    the_string = C_extract_string_by_start_pointer(start_pointer, mem_pointer, self.data_section, state.symbolic_memory)

                    if isinstance(the_string, str) and the_string.isspace():
                        the_string = f"'{ord(the_string)}'"
                    logging.warning("========================Print!=========================\n%s", the_string)
                elif name == '$scanf':
                    mem_pointer, start_pointer = param_list[0].as_long(), param_list[1].as_long()
                    the_string = C_extract_string_by_start_pointer(start_pointer, 0, self.data_section, state.symbolic_memory)

                    pattern_strs = the_string.split()
                    for i, pattern_str in enumerate(pattern_strs):
                        if pattern_str == '%d':
                            # as the basic unit in wasm is i32.load
                            target_mem_pointer = lookup_symbolic_memory(state.symbolic_memory, self.data_section, mem_pointer, 4).as_long()
                            # TODO recheck here
                            # move to the next position where the new variable should be inserted
                            mem_pointer += 4

                            state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, target_mem_pointer, 4, BitVec('variable'+str(i), 32))
                            logging.warning("================Initiated an scanf integer: %s!=================\n", '$scanf_variable'+str(i) + "_depth_" + str(depth))
                        elif pattern_str == '%s':
                            # as the basic unit in wasm is i32.load
                            target_mem_pointer = lookup_symbolic_memory(state.symbolic_memory, self.data_section, mem_pointer, 4).as_long()
                            # mem_pointer += 4

                            # insert an 'abc\x00', little endian: 6513249
                            # big endian: 1633837824
                            state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, target_mem_pointer, 4, BitVecVal(6513249, 32))
                            logging.warning("================Initiated an scanf string: abc=================\n")
                        else:
                            exit("$scanf error")
                elif name == '$strlen':
                    mem_pointer = param_list[0].as_long()
                    the_string = C_extract_string_by_mem_pointer(mem_pointer, self.data_section, state.symbolic_memory)
                    the_string = the_string.as_long()

                    string_length = len(the_string.to_bytes((the_string.bit_length() + 7) // 8, 'little'))
                    state.symbolic_stack.append(BitVecVal(string_length, 32))

                    manually_constructed = True
                    logging.warning("================$strlen! The length is: %s=================\n", string_length)
                elif name == '$swap':
                    the_one, the_other = param_list[0].as_long(), param_list[1].as_long()
                    the_one_mem = lookup_symbolic_memory(state.symbolic_memory, {}, the_one, 1)
                    the_other_mem = lookup_symbolic_memory(state.symbolic_memory, {}, the_other, 1)
                    state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, the_one, 1, the_other_mem)
                    state.symbolic_memory = insert_symbolic_memory(state.symbolic_memory, the_other, 1, the_one_mem)
                    logging.warning("================$swap! Swap the two: %s and %s=================\n", the_one_mem, the_other_mem)

                if not manually_constructed and return_str:
                    tmp_bitvec = getConcreteBitVec(return_str, internal_function_name + '_ret_' + return_str + '_' + self.current_function.name + '_' + str(state.pc))
                    state.symbolic_stack.append(tmp_bitvec)

            # normal function call is processed here
            else:
                # from mainline function
                if gvar.guided_emulation_mainline_function_flag:

                    # Whether internal_function_name calls a function in the sidepath_key_import_functions
                    gvar.visited_func.clear()
                    _, edges = self.cfg.get_functions_call_edges()
                    if not has_sidepath_call_keyimport(internal_function_name, edges, set(self.sidepath_key_import_functions)):  # and \
                        # not has_sidepath_call_keyimport(self.current_function.name, edges, set(self.sidepath_key_import_functions)):
                        if param_str:
                            num_arg = len(param_str.split(' '))
                            param = [state.symbolic_stack.pop()
                                     for _ in range(num_arg)]

                            # has sidepath_call key param
                            if True not in set([x in str(param) for x in ['tapos', 'loc_1', 'loc_2', 'loc_3', 'current_time']]):
                                if return_str:
                                    tmp_bitvec = getConcreteBitVec(return_str, internal_function_name + '_ret_' + return_str + '_' + self.current_function.name + '_' + str(state.pc))
                                    state.symbolic_stack.append(tmp_bitvec)
                                    
                                return False
                            else:
                                # print(param)
                                # recover stack balance
                                param.reverse()
                                [state.symbolic_stack.append(x) for x in param]

                    # restore mainline function when branched function exit
                    self.guided_emulation_mainline_function = (
                        self.current_function, self.current_f_instructions, self.reverse_instructions,
                        self.current_f_basicblocks, basicblock_path, self.current_basicblock)
                    gvar.guided_emulation_mainline_function_flag = False

                new_state, new_has_ret = self.init_state_before_call(
                    param_str, return_str, has_ret, state)

                self.visiting_function_name_list.append(
                    self.current_function.name)
                # store the current function's constraints flag
                self.constraints_flag_stack.append(
                    copy.deepcopy(self.current_function.constraint_flags))

                # fetch all possible result states for this call instruction
                # element in results is composed of return value and the result state, i.e., [return value, result state]
                possible_call_results = self.emulate_one_function(
                    call_depth + 1, internal_function_name, state=new_state, depth=depth, has_ret=has_ret,
                    basicblock_path=basicblock_path)

                self.set_from_function()
                # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                for module_name, quick_checked in self.quick.items():
                    if quick_checked and module_name not in self.lasers:
                        return True

                if not gvar.guided_emulation_mainline_function_flag:
                    # restore the caller's constraints flag
                    self.current_function.constraint_flags = self.constraints_flag_stack.pop()
                    logging.debug(
                        '[+] restore the current function constraint flag: %s' % (
                            self.current_function.constraint_flags))
                    logging.debug('')

                # for stack balance
                outer_need_ret = has_ret.pop()

                # sometimes branched function can't return value as expected
                if return_str and not possible_call_results:
                    tmp_bitvec = getConcreteBitVec(return_str, internal_function_name + '_ret_' + return_str + '_' + self.current_function.name + '_' + str(state.pc))
                    state.symbolic_stack.append(tmp_bitvec)

                    return False

                ran_num = self.random
                if ran_num and ran_num >= len(possible_call_results):
                    selected_branch = [i for i in range(
                        len(possible_call_results))]
                elif ran_num and ran_num < len(possible_call_results):
                    selected_branch = sample(
                        [i for i in range(len(possible_call_results))], ran_num)

                # iterate each possible result and continue the instruction after the 'call xxx'
                for i, return_constraint_tuple in enumerate(possible_call_results):
                    new_state = copy.deepcopy(state)
                    return_value, constraint, state_symbolic_memory, key_import_func_visited, current_globals = \
                        return_constraint_tuple[0], return_constraint_tuple[1].constraints, return_constraint_tuple[
                            1].symbolic_memory, return_constraint_tuple[1].key_import_func_visited, \
                        return_constraint_tuple[1].globals

                    # TODO for test
                    # we only need one_path_result in branched function
                    if gvar.guided_emulation_mainline_function_flag:
                        if outer_need_ret and return_value is not None:
                            state.symbolic_stack.append(return_value)
                            state.constraints = constraint
                            state.symbolic_memory = state_symbolic_memory
                            state.key_import_func_visited = key_import_func_visited
                            state.globals = current_globals
                        else:
                            state.constraints = constraint
                            state.symbolic_memory = state_symbolic_memory
                            state.key_import_func_visited = key_import_func_visited
                            state.globals = current_globals

                        return False

                    if ran_num and i in selected_branch:
                        pass
                    elif ran_num and i not in selected_branch:
                        continue

                    if not ran_num:
                        logging.debug(
                            '===================situation %s======================' % i)
                    else:
                        logging.debug(
                            '===============random situation %s===================' % i)

                    # if have outer_need_ret but no return_value, means the callee's this branch is failed
                    if outer_need_ret and return_value is None:
                        continue
                    elif outer_need_ret and return_value is not None:
                        new_state.symbolic_stack.append(return_value)
                        new_state.constraints = constraint
                        new_state.symbolic_memory = state_symbolic_memory
                        new_state.key_import_func_visited = key_import_func_visited
                        new_state.globals = current_globals
                    else:
                        new_state.constraints = constraint
                        new_state.symbolic_memory = state_symbolic_memory
                        new_state.key_import_func_visited = key_import_func_visited
                        new_state.globals = current_globals

                    if ran_num:
                        # left-most
                        if i == selected_branch[0]:
                            self.current_function.constraint_flags.append(1)
                        # right-most
                        if i == selected_branch[-1]:
                            self.current_function.constraint_flags[-1] = 0

                        # reach the right-most
                        if self.current_function.constraint_flags[-1] == 0:
                            self.current_function.constraint_flags.pop()
                    else:
                        # the left-most branch
                        if i == 0:
                            self.current_function.constraint_flags.append(1)
                        # the right-most branch
                        if i == len(possible_call_results) - 1:
                            self.current_function.constraint_flags[-1] = 0

                        # if reach the right-most branch
                        if self.current_function.constraint_flags[-1] == 0:
                            self.current_function.constraint_flags.pop()

                    self.emulate(new_state, depth, new_has_ret, call_depth)

                    # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                    for module_name, quick_checked in self.quick.items():
                        if quick_checked and module_name not in self.lasers:
                            return True

                if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                    return False
                else:
                    return True

        elif instr.name == 'call_indirect':
            index = state.symbolic_stack.pop()
            # if in guided emulation
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                print('CALL_INDIRECT')
                exit()

            if is_bv_value(index):
                index = index.as_long()
                if index > 200:
                    return True
                state.key_import_func_visited.append(
                    'call_indirect_index=' + str(index))

                if index not in self.index2state.keys():
                    self.index2state[index] = [copy.deepcopy(state)]
                else:
                    self.index2state[index].append(copy.deepcopy(state))
            else:
                halt = True
        else:
            raise Exception('Instruction:', instr,
                            'not match in emul_control function')

        return halt

    def emul_parametric_instr(self, instr, state, depth, has_ret, call_depth):
        halt = False

        if instr.name == 'drop':
            state.symbolic_stack.pop()
        elif instr.name == 'select':  # select instruction
            arg0, arg1, arg2 = state.symbolic_stack.pop(
            ), state.symbolic_stack.pop(), state.symbolic_stack.pop()

            assert is_bv(arg0) or is_bool(
                arg0), f"in select, arg0 type is {type(arg0)} instead of bv or bool"

            # if in guided emulation
            if gvar.guided_emulation_flag and gvar.guided_emulation_mainline_function_flag:
                if is_bool(arg0):
                    logical_result = BitVec(
                        'logical_ans_select_(' + str(arg0) + ')', 32)
                    state.constraints.append(
                        logical_result == If(arg0, arg2, arg1))
                    state.symbolic_stack.append(If(arg0, arg2, arg1))
                else:
                    # the logical_result type depends on the arg1 and arg2 type
                    # however, arg1 type and arg2's are always same
                    if is_bv(arg1):
                        if arg1.size() == 32:
                            logical_result = BitVec(
                                'logical_ans_select_(' + str(simplify(arg0 != 0)) + ')', 32)
                        elif arg1.size() == 64:
                            logical_result = BitVec(
                                'logical_ans_select_(' + str(simplify(arg0 != 0)) + ')', 64)
                        else:
                            raise Exception(
                                f"In guided emulation select instr, the arg1 size is {arg1.size()} instead of 32 or 64")
                    elif is_fp(arg1):
                        if arg1.sbits() == 24:
                            logical_result = FP(
                                'logical_ans_select_(' + str(simplify(arg0 != 0)) + ')', Float32())
                        elif arg1.sbits() == 53:
                            logical_result = FP(
                                'logical_ans_select_(' + str(simplify(arg0 != 0)) + ')', Float64())
                        else:
                            raise Exception(
                                f"In guided emulation select instr, the arg1 sbits is {arg1.sbits()} instead of 24 or 53")
                    else:
                        # if arg1 is other type, do it later, raise a Exception temporarily
                        raise Exception(
                            f"In guided emulation select instr, the arg1 type is {type(arg1)} instead of bv")

                    state.constraints.append(logical_result == If(
                        simplify(arg0 != 0), arg2, arg1))
                    state.symbolic_stack.append(
                        If(simplify(arg0 != 0), arg2, arg1))
                return False

            # arg0 is condition
            # arg2 is the value if condition is true
            # arg1 is the value if condition is false
            if (is_bv_value(arg0) and arg0.as_long() != 0) or arg0.__str__() in can_jump_function:
                state.symbolic_stack.append(arg2)
                logging.debug(
                    '[+] met a select instruction, go to the true branch')
                logging.debug('')
            elif is_bv_value(arg0) and arg0.as_long() == 0:
                state.symbolic_stack.append(arg1)
                logging.debug(
                    '[+] met a select instruction, go to the false branch')
                logging.debug('')
            else:
                new_state = copy.deepcopy(state)

                # if the condition type is a BitVecRef, try to convert it into BoolRef
                if is_bv(arg0):
                    arg0 = simplify(arg0 != 0)

                assert is_bool(
                    arg0), f"in select, the condition type is {type(arg0)} instead of bool"

                new_state.constraints.append(simplify(arg0))
                new_state.constraints = list(set(new_state.constraints))

                s = Solver()
                s.add(*new_state.constraints)
                if gvar.guided_emulation_flag or sat == s.check():
                    self.current_function.constraint_flags.append(1)
                    logging.info(
                        '[+] met a select instruction, assume the condition is true')
                    logging.info('[+] Current constraints can be solved and the flag is: %s, depth: %s' % (
                        self.current_function.constraint_flags, depth))

                    logging.info(
                        '[x] left children path constraints can be satisfied:')
                    for c in new_state.constraints:
                        logging.info(' [x] %s' % c)
                    logging.info('')

                    new_state.symbolic_stack.append(arg2)
                    self.emulate(new_state, depth + 1, has_ret, call_depth)
                    # for test: we only need one_path_result in branched function
                    # if call_depth > 1:
                    #     return True
                    # if gvar.guided_emulation_flag:
                    #     return True
                    # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                    for module_name, quick_checked in self.quick.items():
                        if quick_checked and module_name not in self.lasers:
                            return True
                    self.current_basicblock = self.basicblock_per_instr[instr.offset]
                else:
                    self.current_function.constraint_flags.append(-1)
                    logging.debug(
                        '[+] assume the select condition is true but current constraints can not be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))

                    logging.debug('[x] path constraints can not be satisfied:')
                    for c in new_state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('[x] current branch is pruned')
                    logging.debug('')

                arg0 = simplify(Not(arg0))
                state.constraints.append(arg0)
                state.constraints = list(set(state.constraints))

                s = Solver()
                s.add(*state.constraints)

                if gvar.guided_emulation_flag or sat == s.check():
                    if self.current_function.constraint_flags == []:
                        self.current_function.constraint_flags.append(0)
                    else:
                        self.current_function.constraint_flags[-1] = 0
                    logging.debug(
                        '[+] Assume the select condition is false. Current constraints can be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))

                    logging.debug('[x] path constraints can be satisfied:')
                    for c in state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('')

                    state.symbolic_stack.append(arg1)
                    self.emulate(state, depth + 1, has_ret, call_depth)
                    # for test: we only need one_path_result in branched function
                    # if call_depth > 1:
                    #     return True
                    # if gvar.guided_emulation_flag:
                    #     return True
                    # if self.quick is enabled and no lasers are in self.lasers, stop control immediately
                    for module_name, quick_checked in self.quick.items():
                        if quick_checked and module_name not in self.lasers:
                            return True
                    self.current_basicblock = self.basicblock_per_instr[instr.offset]

                    logging.debug('[+] depth: %s' % depth)
                    logging.debug(
                        '[+] current level both select condition were traversed, return to previous level')
                    self.current_function.constraint_flags.pop()
                else:
                    self.current_function.constraint_flags[-1] = -1
                    logging.debug(
                        '[+] assume select condition is false, but current constraints can not be solved and the flag is: %s, depth: %s' % (
                            self.current_function.constraint_flags, depth))

                    logging.debug(
                        '[x] path constraints can not be satisfied:')
                    for c in state.constraints:
                        logging.debug(' [x] %s' % c)
                    logging.debug('[x] current branch is pruned')
                    logging.debug('')

                    logging.debug(
                        '[+] select condition is false is impossible, so return to previous level')
                    self.current_function.constraint_flags.pop()

                halt = True
        else:
            raise Exception('Instruction:', instr,
                            'not match in emul_parametric function')

        return halt

    def emul_variable_instr(self, instr, state):
        return do_emulate_variable_instruction(instr, state)

    def emul_memory_instr(self, instr, state):
        # the data_section is used in the special cases
        # TODO decouple the data_section here
        return do_emulate_memory_instruction(instr, state, self.data_section)

    def emul_constant_instr(self, instr, state):
        return do_emulate_constant_instruction(instr, state)

    def emul_logical_i32_instr(self, instr, state):
        return do_emulate_logical_int_instruction(instr, state)

    def emul_logical_i64_instr(self, instr, state):
        return do_emulate_logical_int_instruction(instr, state)

    def emul_logical_f32_instr(self, instr, state):
        return do_emulate_logical_float_instruction(instr, state)

    def emul_logical_f64_instr(self, instr, state):
        return do_emulate_logical_float_instruction(instr, state)

    def emul_bitwise_i32_instr(self, instr, state):
        return do_emulate_bitwise_instruction(instr, state)
    
    def emul_bitwise_i64_instr(self, instr, state):
        return do_emulate_bitwise_instruction(instr, state)

    def emul_arithmetic_i32_instr(self, instr, state):
        return do_emulate_arithmetic_int_instruction(instr, state)

    def emul_arithmetic_i64_instr(self, instr, state):
        return do_emulate_arithmetic_int_instruction(instr, state)

    def emul_arithmetic_f32_instr(self, instr, state):
        return do_emulate_arithmetic_float_instruction(instr, state)

    def emul_arithmetic_f64_instr(self, instr, state):
        return do_emulate_arithmetic_float_instruction(instr, state)

    def emul_conversion_instr(self, instr, state):
        return do_emulate_conversion_instruction(instr, state)
