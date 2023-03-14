# This file will initiate a Wasm Symbolic Execution Engine
# Also, it implements the Instruction Dispatcher
import logging
import re
import sys
from collections import defaultdict
from queue import Queue

from z3 import BitVec, BitVecVal

from seewasm.arch.wasm.analyzer import WasmModuleAnalyzer
from seewasm.arch.wasm.cfg import WasmCFG
from seewasm.arch.wasm.configuration import Configuration
from seewasm.arch.wasm.exceptions import (ASSERT_FAIL, ProcFailTermination,
                                          UnsupportInstructionError)
from seewasm.arch.wasm.instructions import (ArithmeticInstructions,
                                            BitwiseInstructions,
                                            ConstantInstructions,
                                            ControlInstructions,
                                            ConversionInstructions,
                                            LogicalInstructions,
                                            MemoryInstructions,
                                            ParametricInstructions,
                                            VariableInstructions)
from seewasm.arch.wasm.lib.utils import is_modeled
from seewasm.arch.wasm.utils import (getConcreteBitVec, init_file_for_file_sys,
                                     readable_internal_func_name)
from seewasm.arch.wasm.vmstate import WasmVMstate
from seewasm.core.basicblock import BasicBlock
from seewasm.core.edge import EDGE_FALLTHROUGH, Edge
from seewasm.engine.emulator import EmulatorEngine

sys.setrecursionlimit(4096)

# config the logger
logging_config = {
    'filename': f'./log/log/{Configuration.get_file_name()}_{Configuration.get_start_time()}.log',
    'filemode': 'w+',
    'format': '%(asctime)s | %(levelname)s | %(message)s',
}
if 'debug' == Configuration.get_verbose_flag():
    logging_config['level'] = logging.DEBUG
elif 'info' == Configuration.get_verbose_flag():
    logging_config['level'] = logging.INFO
else:
    logging_config['level'] = logging.WARNING
logging.basicConfig(**logging_config)


# =======================================
# #         WASM Emulator               #
# =======================================

class WasmSSAEmulatorEngine(EmulatorEngine):

    def __init__(self, bytecode):
        self.cfg = WasmCFG(bytecode)
        self.ana = WasmModuleAnalyzer(self.cfg.module_bytecode)
        # set the func index to func name mapping
        Configuration.set_func_index_to_func_name(
            self.ana.names, self.ana.func_prototypes)

        if Configuration.get_entry() not in Configuration.get_func_index_to_func_name().values():
            exit(
                f"Your designated entry: {Configuration.get_entry()} does not exist.\nPlease assign another by '--entry'")

        # build call graph
        self.cfg.build_call_graph(self.ana)

        # remove functions has no relationship with entry
        self.remove_unrelated_funcs()

        # split basic blocks by call and call_indirect instrucitons
        # for generating ICFG
        self.split_bbs()

        # all the exports function's name
        self.exported_func_names = [i["field_str"]
                                    for i in self.ana.exports if i["kind"] == 0]

        self.data_section = dict()
        # init memory section with data section
        for _, data_section_value in enumerate(self.ana.datas):
            data = data_section_value['data']
            offset = data_section_value['offset']
            size = data_section_value['size']

            # the original implementation, but it will stuck when the data section is huge, so I comment this implementation
            # self.data_section[(offset, offset + size)] = BitVecVal(int.from_bytes(data, byteorder='big'), size * 8)
            self.data_section[(offset, offset + size)] = data

    def remove_unrelated_funcs(self):
        """
        Remove such functions that cannot be regarded as callees from entry
        """
        # extract functions that can be regarded as callee of call_indirect
        try:
            elem_callees = self.ana.elements[0]['elems']
            elem_funcs = set()
            for elem_callee_op in elem_callees:
                elem_funcs.add(
                    readable_internal_func_name(
                        Configuration.get_func_index_to_func_name(),
                        f"$func{elem_callee_op}"))
        except IndexError:
            # there is no elem section in the to-be-analyzed program
            elem_funcs = set()

        # init entry as entry_func and all elem functions
        entry_callees = set()
        visited = set()
        stack = list()

        entry_func = Configuration.get_entry()
        entry_callees.add(entry_func)
        entry_callees.update(elem_funcs)

        # traverse from all entries to extract all possible callees
        stack.append(entry_func)
        stack += list(elem_funcs)
        while stack:
            item_func = stack.pop()
            visited.add(item_func)
            item_func_callees = self.cfg.call_graph.get(item_func, [])
            for item_func_callee in item_func_callees:
                if item_func_callee not in visited:
                    # if the func is emulated, jump over
                    if is_modeled(item_func_callee):
                        continue
                    elif item_func_callee not in entry_callees:
                        entry_callees.add(item_func_callee)
                        stack.append(item_func_callee)

        # remove unrelated functions from self.cfg.functions
        i = 0
        count = 0
        all_func = len(self.cfg.functions)
        while i < len(self.cfg.functions):
            func_name = readable_internal_func_name(
                Configuration.get_func_index_to_func_name(),
                self.cfg.functions[i].name)
            if func_name not in entry_callees:
                # remove this
                count += 1
                self.cfg.functions.pop(i)
            else:
                i += 1
        logging.warning(
            f"Totally remove {count} unrelated functions, around {count*100/all_func:<.3f}% of all functions")

    def split_bbs(self):
        """
        Split basic blocks by call and call_indirect instructions
        """
        # reinit
        self.cfg.basicblocks = []
        # add external keys (node_from) refer to each edge object
        tmp_edge_map = defaultdict(list)
        for e in self.cfg.edges:
            tmp_edge_map[e.node_from].append(e)

        for func in self.cfg.functions:
            func_basic_blocks = func.basicblocks

            i = 0
            while i < len(func_basic_blocks):
                bb = func_basic_blocks[i]

                _, func_index, _ = bb.name.split('_')
                for ins_i, instruction in enumerate(bb.instructions):
                    # we should split the basic block after these two instructions, if they are not the last instruction
                    if (instruction.name == 'call' or instruction.name == 'call_indirect') and ins_i != len(bb.instructions) - 1:
                        # if the callee is imported, don't need to split the bb
                        if instruction.name == 'call':
                            callee_index = int(
                                instruction.operand_interpretation.split(" ")[1], 0)
                            if self.ana.func_prototypes[callee_index][3] == 'import':
                                continue

                        first_part_ins, second_part_ins = bb.instructions[
                            : ins_i + 1], bb.instructions[ins_i + 1:]
                        next_ins = bb.instructions[ins_i + 1]

                        # change the current basic block
                        bb.end_offset = instruction.offset_end
                        bb.end_instr = instruction
                        bb.instructions = first_part_ins

                        # init a new basic block
                        new_bb = BasicBlock()
                        new_bb.instructions = second_part_ins
                        new_bb.start_offset = next_ins.offset
                        new_bb.start_instr = next_ins
                        new_bb.name = f"block_{func_index}_{hex(new_bb.start_offset)[2:]}"
                        new_bb.end_instr = second_part_ins[-1]
                        new_bb.end_offset = new_bb.end_instr.offset_end

                        # record the relationship between bb and new_bb
                        # if there are edges start from bb, make them start from new_bb
                        if bb.name not in tmp_edge_map:
                            pass
                        else:
                            # update the tmp_edge_map
                            while tmp_edge_map[bb.name]:
                                e = tmp_edge_map[bb.name].pop()
                                e.node_from = new_bb.name
                                tmp_edge_map[new_bb.name].append(e)

                        # append the new basic block, add a new edge
                        func_basic_blocks.append(new_bb)
                        new_edge = Edge(bb.name, new_bb.name, EDGE_FALLTHROUGH)
                        self.cfg.edges.append(new_edge)
                        # update the tmp_edge_map
                        tmp_edge_map[bb.name].append(new_edge)

                        break

                i += 1

            # assert there are no dup blocks, and sort them by both func index and bb index
            block_len = len(func_basic_blocks)
            assert len({bb.name for bb in func_basic_blocks}
                       ) == block_len, "dup block exist"
            func_basic_blocks = list(
                sorted(
                    func_basic_blocks,
                    key=lambda x: int(x.name.split('_')[2], 16)))

            # write back
            func.basicblocks = func_basic_blocks
            self.cfg.basicblocks += func_basic_blocks

    def count_instrs(self):
        """
        Statically count instructions followed by the entry function
        """
        # only consider the first given func
        func = readable_internal_func_name(
            Configuration.get_func_index_to_func_name(),
            Configuration.get_entry())
        queue = Queue()
        visited = set()

        # put the entry func
        queue.put(func)
        # put all elem funcs
        for elem in self.ana.elements[0]["elems"]:
            queue.put(
                readable_internal_func_name(
                    Configuration.get_func_index_to_func_name(),
                    "$func" + str(elem)))

        while not queue.empty():
            caller = queue.get()
            visited.add(caller)

            callees = self.cfg.call_graph.get(caller, {})
            for callee in callees:
                if callee not in visited:
                    queue.put(callee)

        # add the instruction number
        for f in self.cfg.functions:
            concerned_func = readable_internal_func_name(
                Configuration.get_func_index_to_func_name(), f.name)
            if concerned_func in visited:
                self.total_instructions += len(f.instructions)
                self.concerned_funcs[concerned_func] = len(f.instructions)

        logging.info(f"total instructions: {self.total_instructions}")

    def get_signature(self, func_name):
        """
        Obtain function's signature from func_prototypes
        """
        # extract param and return str
        func_index = None
        if func_name[0] == '$':
            func_index = int(re.match('\$func(.*)', func_name).group(1))
        else:
            for index, wat_func_name in Configuration.get_func_index_to_func_name().items():
                if wat_func_name == func_name:
                    func_index = index
                    break

        assert func_index is not None, f"[!] Cannot find your entry function: {func_name}"
        func_info = self.ana.func_prototypes[func_index]
        func_index_name, param_str, return_str, func_type = *func_info,

        return func_index_name, param_str, return_str, func_type

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

    def init_state(self, func_name, param_str):
        state = WasmVMstate()

        # update file sys
        state.file_sys[0]["content"] = Configuration.get_stdin()
        sym_file_limit, _ = Configuration.get_sym_file_limits()
        for i in range(sym_file_limit):
            state.file_sys[i + 3] = init_file_for_file_sys()

        args = Configuration.get_args()
        state.args = args

        if param_str != '':
            for i, local in enumerate(param_str.split(' ')):
                state.local_var[i] = getConcreteBitVec(
                    local, func_name + '_loc_' + str(i) + '_' + local)

        state.current_func_name = func_name

        # deal with the globals
        # if the entry function is not exported, make them as symbols
        is_exported = func_name in self.exported_func_names
        # if the --symbol_globals is not set, we treat the globals as concrete values
        # i.e., the targeted function is exported
        if not Configuration.get_symbol_globals():
            is_exported = True
        self.init_globals(state, is_exported)

        return state

    def emulate_basic_block(self, states, instructions, lvar=None):
        """
        Symbolically execute the instructions from each of state in states

        Args:
            states (list(VMstate)): From which the symbolic execution begin;
            instructions (list(Instruction)): A list of instruction objects
        """
        for instruction in instructions:
            if instruction.name == "return":
                logging.debug("got 'return' instruction, now return")
                break
            if instruction.name == "unreachable":
                logging.debug("got 'unreachable' instruction, now terminate")
                raise ProcFailTermination(ASSERT_FAIL)
            next_states = []
            for state in states:  # TODO: embarassing parallel
                state.instr = instruction
                next_states.extend(self.emulate_one_instruction(
                    instruction, state, lvar))
            states = next_states
        return states

    def emulate_one_instruction(self, instr, state, lvar=None):
        instruction_map = {
            'Arithmetic_i32': ArithmeticInstructions,
            'Arithmetic_i64': ArithmeticInstructions,
            'Arithmetic_f32': ArithmeticInstructions,
            'Arithmetic_f64': ArithmeticInstructions,
            'Bitwise_i32': BitwiseInstructions,
            'Bitwise_i64': BitwiseInstructions,
            'Constant': ConstantInstructions,
            'Control': ControlInstructions,
            'Conversion': ConversionInstructions,
            'Logical_i32': LogicalInstructions,
            'Logical_i64': LogicalInstructions,
            'Logical_f32': LogicalInstructions,
            'Logical_f64': LogicalInstructions,
            'Memory': MemoryInstructions,
            'Parametric': ParametricInstructions,
            'Variable': VariableInstructions,
        }
        if instr.operand_interpretation is None:
            instr.operand_interpretation = instr.name

        # logging.debug(
        #     f"\nState:\t{id(state)}\nInstruction:\t{instr.operand_interpretation}\nOffset:\t\t{instr.nature_offset}\n{state.__str__()}")

        instr_obj = instruction_map[instr.group](
            instr.name, instr.operand, instr.operand_interpretation)
        if instr.group == 'Memory':
            ret_states = instr_obj.emulate(state, self.data_section)
        elif instr.group == 'Control':
            ret_states = instr_obj.emulate(
                state, self.data_section, self.ana, lvar)
        else:
            ret_states = instr_obj.emulate(state)
        return ret_states
