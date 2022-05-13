import copy
import logging
from collections import defaultdict

from eunomia.arch.wasm.configuration import Configuration
from eunomia.arch.wasm.exceptions import (NotDeterminedRetValError,
                                          UnsupportInstructionError)
from eunomia.arch.wasm.graph import Graph
from eunomia.arch.wasm.internalFunctions import (PANIC_FUNCTIONS,
                                                 CPredefinedFunction,
                                                 GoPredefinedFunction)
from eunomia.arch.wasm.lib.wasi import WASIImportFunction
from eunomia.arch.wasm.solver import SMTSolver
from eunomia.arch.wasm.utils import (getConcreteBitVec,
                                     readable_internal_func_name)
from z3 import (BitVecVal, Not, Or, is_bool, is_bv, is_false, is_true,
                simplify, unsat)

# TODO ensure the correctness of malloc, realloc, and free
C_LIBRARY_FUNCS = {
    '__small_printf', 'abs', 'atof', 'atoi', 'ceil', 'exp', 'floor', 'getchar',
    'iprintf', 'printf', 'putchar', 'puts', 'scanf', 'sqrt', 'swap',
    'system'}
# 'runtime.alloc' temporary disabled for some bug
GO_LIBRARY_FUNCS = {'fmt.Scanf', 'fmt.Printf'}
TERMINATED_FUNCS = {'__assert_fail', 'runtime.divideByZeroPanic'}
# below functions are not regarded as library function, need step in
NEED_STEP_IN_GO = {
    'fmt.Println', '_*fmt.pp_.printArg', '_*fmt.buffer_.writeByte',
    '_*fmt.pp_.fmtInteger', '_*os.File_.Write', '_*fmt.fmt_.fmtInteger',
    'memmove', '_*fmt.pp_.fmtString', '_*fmt.fmt_.truncateString',
    '_*fmt.fmt_.padString', '_*fmt.buffer_.writeString',
    '_syscall/js.Value_.Get', '_syscall/js.Value_.Type',
    '_syscall/js.Value_.isNumber', 'syscall/js.makeValue', '_*sync.Pool_.Get',
    'runtime.sliceAppend', '_os.stdioFileHandle_.Write'}
NEED_STEP_IN_C = {}

# we heuristically define that if a func is start with the pre-defined substring, it is a library function


def IS_GO_LIBRARY_FUNCS(x):
    return x.startswith(tuple(GO_LIBRARY_FUNCS)) or x in PANIC_FUNCTIONS


def IS_C_LIBRARY_FUNCS(x):
    return x in C_LIBRARY_FUNCS


class ControlInstructions:
    def __init__(self, instr_name, instr_operand, instr_string):
        self.instr_name = instr_name
        self.instr_operand = instr_operand
        self.instr_string = instr_string
        self.skip_command = {'loop', 'end', 'br', 'else', 'nop', 'block'}
        self.term_command = {'unreachable', 'return'}

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
        new_has_ret = copy.deepcopy(has_ret)

        if need_to_reset:
            for i, local in enumerate(param_str.split(' ')):
                new_state.local_var[i] = getConcreteBitVec(
                    local, state.current_func_name + '_loc_' + str(i) + '_' + local)
        else:
            for x in range(num_arg):
                new_state.local_var[num_arg - 1 - x] = arg[x]

        # set the remaining local vars as None
        for x in range(num_arg, len(new_state.local_var)):
            try:
                new_state.local_var.pop(x)
            except KeyError:
                # if some of the local var is unused during the caller
                # there is no need to pop it, thus continue the loop
                continue

        return new_state, new_has_ret

    def deal_with_call(self, state, f_offset, has_ret, data_section, analyzer):
        # get the callee's function signature
        target_func = analyzer.func_prototypes[f_offset]
        internal_function_name, param_str, return_str, _ = target_func

        readable_name = readable_internal_func_name(
            Configuration.get_func_index_to_func_name(),
            internal_function_name)

        new_states = []
        # if the callee is imported by WASI
        if readable_name in [i[1] for i in analyzer.imports_func]:
            func = WASIImportFunction(readable_name, state.current_func_name)
            logging.warning(
                f"Invoked a WASI import function: {readable_name}")
            func.emul(state, param_str, return_str, data_section)
            logging.warning(f'End of a import function: {readable_name}')
        # if the callee is a C library function
        elif Configuration.get_source_type() == 'c' and IS_C_LIBRARY_FUNCS(
                readable_name) and readable_name not in NEED_STEP_IN_C:
            logging.warning(
                f"Invoked a C library function: {readable_name}")
            func = CPredefinedFunction(
                readable_name, state.current_func_name)
            func.emul(state, param_str, return_str, data_section, analyzer)
            logging.warning(f'End of a C library function: {readable_name}')
        elif Configuration.get_source_type() == 'go' and IS_GO_LIBRARY_FUNCS(
                readable_name) and readable_name not in NEED_STEP_IN_GO:
            logging.warning(
                f"Invoked a Go library function: {readable_name}")
            func = GoPredefinedFunction(
                readable_name, state.current_func_name)
            func.emul(state, param_str, return_str, data_section, analyzer)
            logging.warning(f'End of a Go library function: {readable_name}')
            # terminate panic related functions. eg: runtime.divideByZeroPanic
            if readable_name in TERMINATED_FUNCS:
                logging.warning(
                    f"Terminated function invoked (Golang): {readable_name} ")
                # TODO terminate state, but normally there will be `unreachable` instruction after the call
        elif readable_name in TERMINATED_FUNCS:
            logging.warning(
                f"Terminated function invoked: {readable_name} ")
            return [state]
        else:
            # if the callee takes NO symbols as input:
            # 1. the param_str is empty [Doing]
            # 2. the params are all non-symbol [TODO]
            # logging.warning(f'invoke: {readable_name} with {internal_function_name}')
            logging.warning(
                f"From: {readable_internal_func_name(Configuration.get_func_index_to_func_name(), state.current_func_name)}, invoke: {readable_name}")
            new_state, new_has_ret = self.init_state_before_call(
                param_str, return_str, has_ret, state)
            possible_states = Graph.traverse_one(
                internal_function_name, new_state, new_has_ret)
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
                possible_call_results.append(
                    (to_be_returned, copy.deepcopy(pstate)))

            # for stack balance
            outer_need_ret = has_ret.pop()

            for i, return_constraint_tuple in enumerate(possible_call_results):
                new_state = copy.deepcopy(state)
                return_value, constraint, state_symbolic_memory, current_globals = return_constraint_tuple[0], \
                    return_constraint_tuple[
                    1].constraints, \
                    return_constraint_tuple[
                    1].symbolic_memory, \
                    return_constraint_tuple[1].globals

                # if have outer_need_ret but no return_value, means the callee's this branch is failed
                if outer_need_ret and return_value is None:
                    continue
                elif outer_need_ret and return_value is not None:
                    new_state.symbolic_stack.append(return_value)
                    new_state.constraints = constraint
                    new_state.symbolic_memory = state_symbolic_memory
                    new_state.globals = current_globals
                    new_state.stdin_buffer = return_constraint_tuple[1].stdin_buffer
                else:
                    new_state.constraints = constraint
                    new_state.symbolic_memory = state_symbolic_memory
                    new_state.globals = current_globals
                    new_state.stdin_buffer = return_constraint_tuple[1].stdin_buffer

                new_states.append(new_state)
            logging.warning(f'End of function: {readable_name}')
        if len(new_states) == 0:
            new_states.append(state)
        return new_states

    def emulate(
            self, state, has_ret, data_section, analyzer):
        if self.instr_name in self.skip_command:
            return None
        if self.instr_name in self.term_command:
            return None

        if self.instr_name == 'br_if':
            op = state.symbolic_stack.pop()
            assert is_bv(op) or is_bool(
                op), f"the type of op popped from stack in `br_if` is {type(op)} instead of bv or bool"
            states = {'conditional_true_0': copy.deepcopy(
                state), 'conditional_false_0': copy.deepcopy(state)}
            if is_bv(op):
                op = simplify(op != 0)

            if not is_true(op):
                # op is False, or a BoolRef that cannot be determined
                states['conditional_true_0'].constraints.append(op)
            if not is_false(op):
                # op is True, or a BoolRef that cannot be determined
                states['conditional_false_0'].constraints.append(
                    simplify(Not(op)))

            return [states]
        elif self.instr_name == 'if':
            op = state.symbolic_stack.pop()
            assert is_bv(op) or is_bool(
                op), f"the type of op popped from stack in `if` is {type(op)} instead of bv or bool"
            states = {'conditional_true_0': copy.deepcopy(
                state), 'conditional_false_0': copy.deepcopy(state)}
            if is_bv(op):
                cond = simplify(op != 0)

            # similar as br_if
            if not is_true(cond):
                states['conditional_true_0'].constraints.append(cond)
            if not is_false(cond):
                states['conditional_false_0'].constraints.append(
                    simplify(Not(cond)))

            return [states]
        elif self.instr_name == 'call_indirect':
            # refer to: https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format#webassembly_tables
            # this instruction will pop an element out of the stack, and use this as an index in the table, i.e., elem section in Wasm module, to dynamically determine which fucntion will be invoked

            # target function index
            op = state.symbolic_stack.pop()

            # traverse the elem section
            possible_callee = analyzer.elements[0]['elems']
            offset = analyzer.elements[0]['offset']
            call_indirect_func_type = int(self.instr_string.split(' ')[1][:-1])
            import_funcs_num = len(analyzer.imports_func)

            states = []
            solver = SMTSolver(Configuration.get_solver())
            for i, possible_func_offset in enumerate(possible_callee):
                # if the type is not suitable, just jump over
                if analyzer.func_types[possible_func_offset - import_funcs_num] != call_indirect_func_type:
                    continue

                i = i + offset
                new_state = copy.deepcopy(state)
                solver.reset()
                solver.add(simplify(op == i))
                if unsat == solver.check():
                    continue
                after_calls = self.deal_with_call(
                    new_state, possible_func_offset, has_ret, data_section, analyzer)
                states.extend(after_calls)
                # try each of them, like what you do after line 167
            if len(states) == 0:
                print(op)
                print(possible_callee)
                print(offset)
                print(state)
                exit("call indirect error")
            return states
        elif self.instr_name == 'br_table':
            # state.instr.xref indicates the destination instruction's offset
            op = state.symbolic_stack.pop()

            # operands of br_table instruction
            ops = [i for i in self.instr_operand]
            n_br, br_lis = ops[0], ops[1:-1]

            # construct a dict to minimize the possible states
            target_branch2index = defaultdict(list)
            for index, target in enumerate(br_lis):
                target_branch2index[target].append(index)
            states = {}
            for target, index_list in target_branch2index.items():
                new_state = copy.deepcopy(state)
                index_list = [simplify(op == i) for i in index_list]
                cond = simplify(Or(index_list))
                if not is_true(cond):
                    new_state.constraints.append(cond)
                states['conditional_true_' + str(target)] = new_state
            false_state = copy.deepcopy(state)
            cond = simplify(op >= n_br)
            if not is_true(cond):
                false_state.constraints.append(cond)
            states['conditional_false_0'] = false_state

            return [states]
        elif self.instr_name == 'call':
            self.instr_operand = self.instr_string.split(' ')[1]
            # get the callee's function signature
            try:
                f_offset = int(self.instr_operand)
            except ValueError:
                # it's possible that the `call` operand is a hex
                f_offset = int(self.instr_operand, 16)
            return self.deal_with_call(
                state, f_offset, has_ret, data_section, analyzer)
        else:
            print(self.instr_name)
            raise UnsupportInstructionError
