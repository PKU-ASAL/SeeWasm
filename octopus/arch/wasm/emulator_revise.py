import copy
import json
import logging
import re
from datetime import datetime
from functools import reduce

from z3 import *

import gvar
from octopus.arch.wasm.cfg import WasmCFG
from octopus.arch.wasm.vmstate import WasmVMstate
from octopus.engine.emulator import EmulatorEngine
from octopus.arch.wasm.helper_c import *
from .internal_functions import InternalFunction, PredefinedFunction
from .graph import Graph
from .instructions import *

sys.setrecursionlimit(4096)

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

class WasmSSAEmulatorEngine(EmulatorEngine):

    def __init__(self, bytecode, timeout, call_depth=MAX, lasers=None, quick=False, func_index2func_name=None):

        # retrive instructions, basicblocks & functions statically
        if lasers is None:
            lasers = []

        self.cfg = WasmCFG(bytecode)
        self.ana = self.cfg.analyzer

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
        self.key_import_functions = ['db_get_i64', 'db_find_i64', 'db_remove_i64', 'db_update_i64', 'db_idx64_remove',
                                     'db_idx64_store',
                                     'tapos_block_num', 'tapos_block_prefix', 'sha256', 'send_inline', 'send_deferred',
                                     'require_auth']
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

    def get_signature(self, func_name):
        # extract param and return str
        for func_info in self.ana.func_prototypes:
            if func_info[0] == func_name:
                param_str, return_str = func_info[1], func_info[2]
                break
        return param_str, return_str

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
                new_state.local_var[i] = getConcreteBitVec(local,
                                                           self.current_function.name + '_loc_' + str(i) + '_' + local)
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

    def emulate_basic_block(self, state, has_ret, instructions):
        pre_instr = None
        states = [state]
        for instruction in instructions:
            next_states = []
            for state in states:
                state.instr = instruction
                state.pc += 1
                _, ret = self.emulate_one_instruction(instruction, pre_instr, state, 0, has_ret, 0)
                if ret is not None:
                    next_states.extend(ret)
                else:
                    next_states.append(copy.deepcopy(state))
            states = next_states
        return states


    def emulate(self, state, depth=0, has_ret=[], call_depth=0, basicblock_path=None):
        halt = False
        instr = None

        while not halt:
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
                halt = self.emulate_one_instruction(instr, pre_instr, state, depth, has_ret, call_depth)

    def emulate_one_instruction(self, instr, pre_instr, state, depth, has_ret, call_depth, basicblock_path=None):
        instruction_map = {
            'Control': ControlInstructions,
            'Constant': ConstantInstructions,
            'Conversion': ConversionInstructions,
            'Memory': MemoryInstructions,
            'Parametric': ParametricInstructions,
            'Variable': VariableInstructions,
            'Logical_i32': LogicalInstructions,
            'Logical_i64': LogicalInstructions,
            'Logical_f32': LogicalInstructions,
            'Logical_f64': LogicalInstructions,
            'Arithmetic_i32': ArithmeticInstructions,
            'Arithmetic_i64': ArithmeticInstructions,
            'Arithmetic_f32': ArithmeticInstructions,
            'Arithmetic_f64': ArithmeticInstructions,
            'Bitwise_i32': BitwiseInstructions,
            'Bitwise_i64': BitwiseInstructions
        }
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

        instr_obj = instruction_map[instr.group](instr.name, instr.operand, instr.operand_interpretation)
        if instr.group == 'Memory':
            return instr_obj.emulate(state, self.data_section), None
        elif instr.group == 'Control':
            return self.emul_control_instr(instr, pre_instr, state, depth, has_ret, call_depth, basicblock_path)
        elif instr.group == 'Parametric':
            return self.emul_parametric_instr(instr, state, depth, has_ret, call_depth)
        else:
            instr_obj.emulate(state)
        return False, None

    def emul_unreachable(self):
        return True, None

    def emul_loop(self):
        return False, None

    def emul_else(self):
        return False, None

    def emul_if(self, state):
        op = state.symbolic_stack.pop()
        assert is_bv(op) or is_bool(
            op), f"the type of op popped from stack in `if` is {type(op)} instead of bv or bool"

        logging.debug('[IF] now the func is: %s' % self.current_function.name)
        states = {'conditional_true': copy.deepcopy(state), 'conditional_false': copy.deepcopy(state)}
        if is_bv(op):
            op = simplify(op != 0)
        states['conditional_true'].constraints.append(op)
        states['conditional_false'].constraints.append(simplify(Not(op)))
        return True, [states]

    def emul_end(self):
        return False, None

    def emul_br(self):
        return False, None

    def emul_br_if(self, instr, state, depth, has_ret, call_depth):
        op = state.symbolic_stack.pop()
        assert is_bv(op) or is_bool(op), f"the type of op popped from stack in `br_if` is {type(op)} instead of bv or bool"
        states = {'conditional_true': copy.deepcopy(state), 'conditional_false': copy.deepcopy(state)}
        if is_bv(op):
            op = simplify(op != 0)
        states['conditional_true'].constraints.append(op)
        states['conditional_false'].constraints.append(simplify(Not(op)))
        return True, [states]

    def emul_br_table(self, instr, state):
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

    def emul_call(self, instr, state, depth, call_depth, has_ret, basicblock_path):
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
        internal_function_name = self.cfg.functions[f_offset - import_func_count].name if f_offset > import_func_count else name
        # skip these functions
        func_is_not_from_system = (internal_function_name[0] == '_' and internal_function_name[1] == '_') or \
                                  internal_function_name in SKIP_FUNC_SET or (
                                          '_Zn' in internal_function_name and 'eos' not in internal_function_name) or \
                                  '_ZdaPv' in internal_function_name or 'printf' in internal_function_name
        new_states = []
        # if the function is the EOSIO library function
        if internal_function_name not in [x.name for x in self.cfg.functions]:
            if f_offset > len(self.ana.imports_func):
                raise Exception('function_name not in this module - available: %s', self.ana.func_prototypes)
            # import functions processed here
            args_num = len(param_str.split(' '))
            param_list = []
            if param_str:
                param_list = [state.symbolic_stack.pop() for _ in range(args_num)][::-1]
            func = InternalFunction(internal_function_name, param_list, return_str, state)
            halt = func.emul()
            return halt, [state]

        elif call_depth >= self.call_depth_limit or func_is_not_from_system:
            # (func_is_exports and not func_is_elems and func_is_not_from_system):
            # record the key funcs for the fake receipt detector
            state.key_import_func_visited.append(f_offset)

            if param_str:
                num_arg = len(param_str.split(' '))
                for _ in range(num_arg):
                    state.symbolic_stack.pop()
            if return_str:
                state.symbolic_stack.append(getConcreteBitVec(return_str,
                                                              internal_function_name + '_ret_' + return_str + '_' + self.current_function.name + '_' + str(
                                                                  state.pc)))
        elif name in C_LIBRARY_FUNCS:
            func = PredefinedFunction(name, self.current_function.name)
            func.emul(state, internal_function_name, param_str, return_str, self.data_section)
        else:
            new_state, new_has_ret = self.init_state_before_call(param_str, return_str, has_ret, state)
            self.visiting_function_name_list.append(self.current_function.name)
            # store the current function's constraints flag
            self.constraints_flag_stack.append(copy.deepcopy(self.current_function.constraint_flags))

            # fetch all possible result states for this call instruction
            # element in results is composed of return value and the result state, i.e., [return value, result state]
            possible_states = Graph.traverse_one(internal_function_name, new_state, has_ret)
            possible_call_results = []
            for pstate in possible_states:
                to_be_returned = None
                if has_ret and has_ret[-1]:
                    to_be_returned = pstate.symbolic_stack.pop()
                    if is_bool(to_be_returned):
                        if is_false(to_be_returned):
                            to_be_returned = BitVecVal(0, 32)
                        elif is_true(to_be_returned):
                            to_be_returned = BitVecVal(1, 32)
                        else:
                            raise NotDeterminedRetValError
                possible_call_results.append((to_be_returned, copy.deepcopy(pstate)))

            if not gvar.guided_emulation_mainline_function_flag:
                # restore the caller's constraints flag
                self.current_function.constraint_flags = self.constraints_flag_stack.pop()
                logging.debug(
                    '[+] restore the current function constraint flag: %s' % (
                        self.current_function.constraint_flags))
                logging.debug('')

            # for stack balance
            outer_need_ret = has_ret.pop()

            for i, return_constraint_tuple in enumerate(possible_call_results):
                new_state = copy.deepcopy(state)
                return_value, constraint, state_symbolic_memory, key_import_func_visited, current_globals = \
                    return_constraint_tuple[0], return_constraint_tuple[1].constraints, return_constraint_tuple[
                        1].symbolic_memory, return_constraint_tuple[1].key_import_func_visited, \
                    return_constraint_tuple[1].globals

                logging.debug('===================situation %s======================' % i)
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

                # the left-most branch
                if i == 0:
                    self.current_function.constraint_flags.append(1)
                # the right-most branch
                if i == len(possible_call_results) - 1:
                    self.current_function.constraint_flags[-1] = 0

                # if reach the right-most branch
                if self.current_function.constraint_flags[-1] == 0:
                    self.current_function.constraint_flags.pop()

                new_states.append(new_state)
        if len(new_states) == 0:
            new_states.append(state)
        return False, new_states

    def emul_return(self):
        return True, None

    def emul_control_instr(self, instr, pre_instr, state, depth, has_ret, call_depth, basicblock_path=None):
        halt = False
        if instr.name == 'unreachable':
            return self.emul_unreachable()
        elif instr.name == 'loop':
            return self.emul_loop()
        elif instr.name in ['nop', 'block']:
            return False, None
        elif instr.name == 'else':
            self.emul_else()
        elif instr.name == 'if':
            self.emul_if(instr, )
        elif instr.name == 'end':
            return self.emul_end()
        elif instr.name == 'br':
            return self.emul_br()
        elif instr.name == 'br_if':
            return self.emul_br_if(instr, state, depth, has_ret, call_depth)
        elif instr.name == 'br_table':
            self.emul_br_table(instr, state)
        elif instr.name == 'return':
            return self.emul_return()
        elif instr.name == 'call':
            return self.emul_call(instr, state, depth, call_depth, has_ret, basicblock_path)
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
            raise Exception('Instruction:', instr, 'not match in emul_control function')
        return halt

    def emul_parametric_instr(self, instr, state, depth, has_ret, call_depth):
        halt = False
        if instr.name == 'drop':
            state.symbolic_stack.pop()
            return False, None
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
