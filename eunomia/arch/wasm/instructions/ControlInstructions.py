import copy
import logging
from collections import defaultdict

from eunomia.arch.wasm.configuration import Configuration
from eunomia.arch.wasm.exceptions import (ProcSuccessTermination,
                                          UnsupportInstructionError)
from eunomia.arch.wasm.lib.c_lib import CPredefinedFunction
from eunomia.arch.wasm.lib.go_lib import GoPredefinedFunction
from eunomia.arch.wasm.lib.wasi import WASIImportFunction
from eunomia.arch.wasm.solver import SMTSolver
from eunomia.arch.wasm.utils import readable_internal_func_name
from z3 import Not, Or, is_bool, is_bv, is_false, is_true, simplify, unsat

C_LIBRARY_FUNCS = {
    '__small_printf', 'abs', 'atof', 'atoi', 'exp', 'getchar', 'iprintf',
    'printf', 'putchar', 'puts', 'scanf', 'swap', 'system',
    'emscripten_resize_heap', 'fopen', 'vfprintf', 'open', 'exit', 'setlocale'}
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
PANIC_FUNCTIONS = {'runtime.nilPanic': 'nil pointer dereference',
                   'runtime.lookupPanic': 'index out of range',
                   'runtime.slicePanic': 'slice out of range',
                   'runtime.sliceToArrayPointerPanic': 'slice smaller than array',
                   'runtime.divideByZeroPanic': 'divide by zero',
                   'runtime.unsafeSlicePanic': 'unsafe.Slice: len out of range',
                   'runtime.chanMakePanic': 'new channel is too big',
                   'runtime.negativeShiftPanic': 'negative shift',
                   'runtime.blockingPanic': 'trying to do blocking operation in exported function'}

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
        self.skip_command = {'loop', 'end', 'br', 'else', 'block'}
        self.term_command = {'unreachable', 'return'}

    def store_context(self, param_str, return_str, state, callee_func_name):
        """
        Store the context of current stack and local.
        The sequence is:
        1. pop specific number of elements from stack, which will be used by callee
        2. store the current context, including (current_func, current_block, stack, local, require_return)
        3. assign popped elements in step 1 in local, change the current_func_name
        """
        logging.info(
            f"Call: {readable_internal_func_name(Configuration.get_func_index_to_func_name(), state.current_func_name)} -> {callee_func_name}")

        # step 1
        num_arg = 0
        if param_str:
            num_arg = len(param_str.split(' '))
            arg = [state.symbolic_stack.pop() for _ in range(num_arg)]

        # step 2
        state.context_stack.append((state.current_func_name,
                                    state.instr.cur_bb,
                                    [e for e in state.symbolic_stack],
                                    copy.copy(state.local_var),
                                    True if return_str else False))

        # step 3
        for x in range(num_arg):
            state.local_var[num_arg - 1 - x] = arg[x]
        # set the remaining local vars as None
        for x in range(num_arg, len(state.local_var)):
            try:
                state.local_var.pop(x)
            except KeyError:
                # if some of the local var is unused during the caller
                # there is no need to pop it, thus continue the loop
                continue

        state.current_func_name = callee_func_name

    def restore_context(self, state):
        """
        Restore context.

        1. pop an element from stack if require return
        2. restore the context
        3. push the element in step 1 into stack
        """
        if len(state.context_stack) == 0:
            raise ProcSuccessTermination(0)

        caller_func_name, cur_bb, stack, local, require_return = state.context_stack.pop()

        logging.info(
            f"Return: {readable_internal_func_name(Configuration.get_func_index_to_func_name(), state.current_func_name)}")

        # step 1
        if require_return:
            return_val = state.symbolic_stack.pop()

        # step 2
        state.current_func_name = caller_func_name
        state.current_bb_name = cur_bb
        state.symbolic_stack = stack
        state.local_var = local

        # step 3
        if require_return:
            state.symbolic_stack.append(return_val)

    def deal_with_call(self, state, f_offset, data_section, analyzer):
        # get the callee's function signature
        target_func = analyzer.func_prototypes[f_offset]
        callee_func_name, param_str, return_str, _ = target_func

        readable_callee_func_name = readable_internal_func_name(
            Configuration.get_func_index_to_func_name(),
            callee_func_name)

        # if the callee is a C library function
        if Configuration.get_source_type() == 'c' and IS_C_LIBRARY_FUNCS(
                readable_callee_func_name) and readable_callee_func_name not in NEED_STEP_IN_C:
            # exit("Currently, we don't allow external function's model")
            logging.info(
                f"Call: {readable_callee_func_name} (C library)")
            func = CPredefinedFunction(
                readable_callee_func_name, state.current_func_name)
            func.emul(state, param_str, return_str, data_section, analyzer)
            logging.info(f"Return: {readable_callee_func_name} (C library)")
        elif Configuration.get_source_type() == 'go' and IS_GO_LIBRARY_FUNCS(
                readable_callee_func_name) and readable_callee_func_name not in NEED_STEP_IN_GO:
            logging.info(
                f"Call: {readable_callee_func_name} (Go library)")
            func = GoPredefinedFunction(
                readable_callee_func_name, state.current_func_name)
            func.emul(state, param_str, return_str, data_section, analyzer)
            logging.info(f"Return: {readable_callee_func_name} (Go library)")
            # terminate panic related functions. eg: runtime.divideByZeroPanic
            if readable_callee_func_name in TERMINATED_FUNCS:
                logging.info(
                    f"Termination:: {readable_callee_func_name} (Go library)")
                # TODO terminate state, but normally there will be `unreachable` instruction after the call
        # if the callee is the imported
        elif readable_callee_func_name in [i[1] for i in analyzer.imports_func]:
            func = WASIImportFunction(
                readable_callee_func_name, state.current_func_name)
            logging.info(
                f"Call: {readable_callee_func_name} (import)")
            func.emul(state, param_str, return_str, data_section)
            logging.info(f"Return: {readable_callee_func_name} (import)")
        elif readable_callee_func_name in TERMINATED_FUNCS:
            logging.info(
                f"Termination: {readable_callee_func_name}")
        else:
            self.store_context(param_str, return_str, state,
                               readable_callee_func_name)

        return [state]

    def emulate(self, state, data_section, analyzer):
        if self.instr_name in self.skip_command:
            return [state]
        if self.instr_name in self.term_command:
            return [state]

        if self.instr_name == 'nop':
            if state.instr.xref:
                self.restore_context(state)
            return [state]
        elif self.instr_name == 'br_if' or self.instr_name == 'if':
            op = state.symbolic_stack.pop()
            assert is_bv(op) or is_bool(
                op), f"the type of op popped from stack in `br_if`/`if` is {type(op)} instead of bv or bool"
            states = []
            if is_bv(op):
                op = simplify(op != 0)

            # | op      | branch              |
            # | ------- | ------------------- |
            # | False   | conditional_false_0 |
            # | True    | conditional_true_0  |
            # | BoolRef | both                |

            if is_true(op):
                state.edge_type = 'conditional_true_0'
                states.append(state)
            elif is_false(op):
                state.edge_type = 'conditional_false_0'
                states.append(state)
            elif not is_true(op) and not is_false(op):
                new_state = copy.deepcopy(state)
                # conditional_true
                state.edge_type = 'conditional_true_0'
                state.constraints.append(op)
                # conditional_false
                new_state.edge_type = 'conditional_false_0'
                new_state.constraints.append(simplify(Not(op)))
                # append
                states.append(state)
                states.append(new_state)
            else:
                exit(f"br_if/if instruction error. op is {op}")

            return states
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

            state_func_offset_tuples = []
            solver = SMTSolver(Configuration.get_solver())
            for i, possible_func_offset in enumerate(possible_callee):
                # if the type is not suitable, just jump over
                if analyzer.func_types[possible_func_offset - import_funcs_num] != call_indirect_func_type:
                    continue

                i = i + offset
                solver.reset()
                solver.add(simplify(op == i))
                if unsat == solver.check():
                    continue

                state_func_offset_tuples.append(
                    (copy.deepcopy(state), possible_func_offset))

            if not state_func_offset_tuples:
                exit("no valid callee in call_direct")
            elif len(state_func_offset_tuples) > 1:
                exit("multiple possible callees in call_indirect")
            else:
                state, func_offset = state_func_offset_tuples[0]
                return self.deal_with_call(
                    state, func_offset, data_section, analyzer)
        elif self.instr_name == 'br_table':
            # state.instr.xref indicates the destination instruction's offset
            # TODO examine br_table
            op = state.symbolic_stack.pop()

            # operands of br_table instruction
            ops = [i for i in self.instr_operand]
            n_br, br_lis = ops[0], ops[1:-1]

            # construct a dict to minimize the possible states
            target_branch2index = defaultdict(list)
            for index, target in enumerate(br_lis):
                target_branch2index[target].append(index)

            # construct possible state
            states = []
            for target, index_list in target_branch2index.items():
                index_list = [simplify(op == i) for i in index_list]
                cond = simplify(Or(index_list))
                if is_false(cond):
                    continue
                new_state = copy.deepcopy(state)
                new_state.constraints.append(cond)
                new_state.edge_type = f"conditional_true_{target}"
                states.append(new_state)

            cond = simplify(op >= n_br)
            if is_false(cond):
                return states
            else:
                state.constraints.append(cond)
                state.edge_type = "conditional_false_0"
                states.append(state)

                return states
        elif self.instr_name == 'call':
            self.instr_operand = self.instr_string.split(' ')[1]
            # get the callee's function signature
            try:
                f_offset = int(self.instr_operand)
            except ValueError:
                # it's possible that the `call` operand is a hex
                f_offset = int(self.instr_operand, 16)
            return self.deal_with_call(state, f_offset, data_section, analyzer)
        else:
            raise UnsupportInstructionError
