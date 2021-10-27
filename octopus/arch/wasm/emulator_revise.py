# This file will initiate a Wasm Symbolic Execution Engine
# Also, it implements the Instruction Dispatcher

import copy
import logging
import re

from z3 import *

import gvar
from octopus.arch.wasm.cfg import WasmCFG
from octopus.arch.wasm.vmstate import WasmVMstate
from octopus.engine.emulator import EmulatorEngine
from octopus.arch.wasm.helper_c import *
from .instructions import *
from octopus.arch.wasm.utils import getConcreteBitVec
from octopus.arch.wasm.memory import insert_symbolic_memory

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

    def __init__(self, bytecode, func_index2func_name=None):
        self.cfg = WasmCFG(bytecode)
        self.ana = self.cfg.analyzer

        # all the exports function's name
        self.exported_func_names = [i["field_str"]
                                    for i in self.ana.exports if i["kind"] == 0]

        self.data_section = dict()
        # init memory section with data section
        for _, data_section_value in enumerate(self.ana.datas):
            data = data_section_value['data']
            offset = data_section_value['offset']
            size = data_section_value['size']
            # print(offset, size, data)
            if offset == '4':
                exit("The offset of data section is 4, please check")
                self.data_section[(offset, offset + size)] = BitVecVal(
                    int.from_bytes(data, byteorder='little'), size * 8)
            else:
                # the original implementation, but it will stuck when the data section is huge, so I comment this implementation
                # self.data_section[(offset, offset + size)] = BitVecVal(int.from_bytes(data, byteorder='big'), size * 8)
                self.data_section[(offset, offset + size)] = data
        # func index to func real name
        # like func 4 is $main function in C
        self.func_index2func_name = func_index2func_name

    def get_wasm_func_name(self, func_name):
        # translate the readable name to the internal name

        # if the func_name is the internal name
        for item in self.ana.func_prototypes:
            if item[0] == func_name:
                return func_name

        func_index = None
        for index, wat_func_name in self.func_index2func_name.items():
            if wat_func_name == func_name:
                func_index = index
                break
        return '$func' + str(func_index)

    def get_signature(self, func_name):
        # extract param and return str
        func_index = None
        if func_name[0] == '$':
            func_index = int(re.match(r'\$func(.*)', func_name).group(1))
        else:
            for index, wat_func_name in self.func_index2func_name.items():
                if wat_func_name == func_name:
                    func_index = index
                    break

        assert func_index, f"[!] Cannot find your entry function: {func_name}"
        func_info = self.ana.func_prototypes[func_index]
        param_str, return_str = func_info[1], func_info[2]

        return param_str, return_str

    def init_globals(self, state, is_exported):
        for i, item in enumerate(self.ana.globals):
            op_type = item[0]
            if op_type == 'i32':
                op_val = BitVecVal(item[1], 32) if is_exported else BitVec(
                    'global_' + str(i) + '_i32', 32)
            elif op_type == 'i64':
                op_val = BitVecVal(item[1], 64) if is_exported else BitVec(
                    'global_' + str(i) + '_i64', 64)
            else:
                raise UnsupportGlobalTypeError
            state.globals[i] = op_val

    def init_state(self, func_name, param_str, return_str, has_ret):
        state = WasmVMstate()
        if param_str != '':
            for i, local in enumerate(param_str.split(' ')):
                state.local_var[i] = getConcreteBitVec(
                    local, func_name + '_loc_' + str(i) + '_' + local)

        # deal with the globals
        # if the entry function is not exported, make them as symbols
        is_exported = func_name in self.exported_func_names
        # if the --concrete_globals is set, we ignore if the current function is exported
        # i.e., we can regard the current function is exported
        if Configuration.get_concrete_globals():
            is_exported = True
        self.init_globals(state, is_exported)

        if return_str:
            has_ret.append(True)
        else:
            has_ret.append(False)

        return state, has_ret

    def emulate_basic_block(self, states, has_ret, instructions):
        halt = False
        for instruction in instructions:
            next_states = []
            for state in states:  # TODO: embarassing parallel
                state.instr = instruction
                halt, ret = self.emulate_one_instruction(
                    instruction, state, 0, has_ret, 0)
                if ret is not None:
                    next_states.extend(ret)
                else:
                    next_states.append(copy.deepcopy(state))
            states = next_states
        return halt, states

    def emulate_one_instruction(self, instr, state, depth, has_ret, call_depth):
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

        logging.debug(
            f'\nInstruction:\t{instr.operand_interpretation}\nOffset:\t\t{instr.offset}\n' + str(state))

        for c in state.constraints:
            if type(c) != BoolRef:
                state.constraints.remove(c)
                # logging.warning(state.constraints)
                # exit()

        instr_obj = instruction_map[instr.group](
            instr.name, instr.operand, instr.operand_interpretation)
        if instr.group == 'Memory':
            return instr_obj.emulate(state, self.data_section), None
        elif instr.group == 'Control':
            return instr_obj.emulate(state, has_ret, self.ana.func_prototypes, self.func_index2func_name, self.data_section, self.ana)
        elif instr.group == 'Parametric':
            return instr_obj.emulate(state, depth, has_ret, call_depth)
        elif instr.group == 'Arithmetic_i32' or instr.group == 'Arithmetic_i64' or instr.group == 'Arithmetic_f32' or instr.group == 'Arithmetic_f64':
            instr_obj.emulate(state, self.ana)
            return False, None
        else:
            instr_obj.emulate(state)
            return False, None
