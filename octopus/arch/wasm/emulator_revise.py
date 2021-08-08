import copy
import logging
from datetime import datetime

from z3 import *

import gvar
from octopus.arch.wasm.cfg import WasmCFG
from octopus.arch.wasm.vmstate import WasmVMstate
from octopus.engine.emulator import EmulatorEngine
from octopus.arch.wasm.helper_c import *
from .instructions import *
from octopus.arch.wasm.type2z3 import getConcreteBitVec

sys.setrecursionlimit(4096)

if gvar.logging_level_verbose:
    logging.basicConfig(level=logging.DEBUG)
else:
    logging.basicConfig(level=logging.INFO)
MAX = 42


# =======================================
# #         WASM Emulator               #
# =======================================

class WasmSSAEmulatorEngine(EmulatorEngine):

    def __init__(self, bytecode, timeout, func_index2func_name=None):
        self.cfg = WasmCFG(bytecode)
        self.ana = self.cfg.analyzer

        self.current_function = None
        self.reverse_instructions = dict()

        self.basicblock_per_instr = dict()
        self.current_basicblock = None

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

    def emulate_basic_block(self, state, has_ret, instructions):
        pre_instr = None
        states = [state]
        halt = False
        for instruction in instructions:
            next_states = []
            for state in states:
                state.instr = instruction
                state.pc += 1
                halt, ret = self.emulate_one_instruction(instruction, state, 0, has_ret, 0)
                if ret is not None:
                    next_states.extend(ret)
                else:
                    next_states.append(copy.deepcopy(state))
            states = next_states
        return halt, states


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
                halt = self.emulate_one_instruction(instr, state, depth, has_ret, call_depth, basicblock_path)
            else:
                halt = self.emulate_one_instruction(instr, state, depth, has_ret, call_depth)

    def emulate_one_instruction(self, instr, state, depth, has_ret, call_depth, basicblock_path=None):
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
            return instr_obj.emulate(state, has_ret, self.ana.func_prototypes, self.func_index2func_name, self.current_function.name, self.data_section)
        elif instr.group == 'Parametric':
            return self.emul_parametric_instr(instr, state, depth, has_ret, call_depth)
        else:
            instr_obj.emulate(state)
        return False, None

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
