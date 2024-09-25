import copy
import logging
from collections import defaultdict

from z3 import (Not, Or, is_bool, is_bv, is_bv_value, is_false, is_true,
                simplify, unsat)

from seewasm.arch.wasm.configuration import Configuration
from seewasm.arch.wasm.exceptions import (ASSERT_FAIL, ProcFailTermination,
                                          ProcSuccessTermination,
                                          UnsupportInstructionError)
from seewasm.arch.wasm.lib.c_lib import CPredefinedFunction
from seewasm.arch.wasm.lib.go_lib import GoPredefinedFunction
from seewasm.arch.wasm.lib.utils import is_modeled
from seewasm.arch.wasm.lib.wasi import WASIImportFunction
from seewasm.arch.wasm.utils import (log_in_out, one_time_query_cache,
                                     readable_internal_func_name)

TERMINATED_FUNCS = {'__assert_fail', 'runtime.divideByZeroPanic'}


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
        concolic = state.type == 'concolic'
        # step 1
        num_arg = 0
        if param_str:
            num_arg = len(param_str.split(' '))
            arg = [state.symbolic_stack.pop() for _ in range(num_arg)]
            if concolic:
                arg_con = [state.concolic_stack.pop() for _ in range(num_arg)]
        # step 2
        if not concolic:
            state.context_stack.append((state.current_func_name,
                                        state.instr.cur_bb,
                                        [e for e in state.symbolic_stack],
                                        copy.copy(state.local_var),
                                        True if return_str else False))
        else:
            state.context_stack.append((state.current_func_name,
                                        state.instr.cur_bb,
                                        [e for e in state.symbolic_stack],
                                        [e for e in state.concolic_stack],
                                        copy.copy(state.local_var),
                                        copy.copy(state.local_var_concolic),
                                        True if return_str else False))
        # step 3
        for x in range(num_arg):
            state.local_var[num_arg - 1 - x] = arg[x]
            if concolic:
                state.local_var_concolic[num_arg - 1 - x] = arg_con[x]
        # set the remaining local vars as None
        for x in range(num_arg, len(state.local_var)):
            try:
                state.local_var.pop(x)
            except KeyError:
                # if some of the local var is unused during the caller
                # there is no need to pop it, thus continue the loop
                continue
        if concolic:
            for x in range(num_arg, len(state.local_var_concolic)):
                try:
                    state.local_var_concolic.pop(x)
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

        concolic = state.type == 'concolic'
        if len(state.context_stack) == 0:
            raise ProcSuccessTermination(0)
        if concolic:
            caller_func_name, cur_bb, stack,con_stack, local,con_local, require_return = state.context_stack.pop()
        else:
            caller_func_name, cur_bb, stack, local, require_return = state.context_stack.pop()
        
        logging.info(
            f"Return: {readable_internal_func_name(Configuration.get_func_index_to_func_name(), state.current_func_name)}")

        # step 1
        if require_return:
            return_val = state.symbolic_stack.pop()
            if concolic:
                return_val_con = state.concolic_stack.pop()

        # step 2
        state.current_func_name = caller_func_name
        state.current_bb_name = cur_bb
        state.symbolic_stack = stack
        state.local_var = local
        if concolic:
            state.concolic_stack = con_stack
            state.local_var_con = con_local
        # step 3
        if require_return:
            state.symbolic_stack.append(return_val)
            if concolic:
                state.concolic_stack.append(return_val_con)

    def deal_with_call(self, state, f_offset, data_section, analyzer, lvar):
        # get the callee's function signature
        target_func = analyzer.func_prototypes[f_offset]
        callee_func_name, param_str, return_str, _ = target_func

        readable_callee_func_name = readable_internal_func_name(
            Configuration.get_func_index_to_func_name(),
            callee_func_name)
        if Configuration.get_dsl_flag() and readable_callee_func_name.startswith("checker"):
            # if it is a instrumented function
            idx = int(readable_callee_func_name.split('$')[1])
            """
            if idx == -1:
                arg = _extract_params(param_str, state)[0]
                state.solver.add(arg > 0);
            elif idx == -2:
                arg = _extract_params(param_str, state)[0]
                state.solver.add(arg > 0);
            elif idx == 3:
                lvar['prior'] = abs(20 - lvar['rounds_i']) - 20
            elif idx == 4:
                lvar['prior'] = abs(3 - lvar['rounds_j'])
            """
            states = [state]
        elif Configuration.get_source_type() == 'c' and is_modeled(readable_callee_func_name, specify_lang='c'):
            func = CPredefinedFunction(
                readable_callee_func_name, state.current_func_name)
            states = log_in_out(
                readable_callee_func_name, "C Library")(
                func.emul)(
                state, param_str, return_str, data_section, analyzer)
        elif Configuration.get_source_type() == 'go' and is_modeled(readable_callee_func_name, specify_lang='go'):
            # TODO Go library func modeling is not tested
            func = GoPredefinedFunction(
                readable_callee_func_name, state.current_func_name)
            states = log_in_out(
                readable_callee_func_name, "Go Library")(
                func.emul)(
                state, param_str, return_str, data_section, analyzer)
        elif Configuration.get_source_type() == 'rust' and is_modeled(readable_callee_func_name, specify_lang='rust'):
            # TODO may model some rust library funcs
            pass
        # if the callee is imported (WASI)
        elif is_modeled(readable_callee_func_name, specify_lang='wasi'):
            func = WASIImportFunction(
                readable_callee_func_name, state.current_func_name)
            states = log_in_out(
                readable_callee_func_name, "import")(
                func.emul)(
                state, param_str, return_str, data_section)
        elif readable_callee_func_name in TERMINATED_FUNCS:
            logging.info(f"Termination: {readable_callee_func_name}")
            raise ProcFailTermination(ASSERT_FAIL)
        else:
            self.store_context(param_str, return_str, state,
                               readable_callee_func_name)
            states = [state]
        return states
    def find_solutions(solver):
        solutions = {}
        m = solver.model()
        # this check if there exist symbols with same name
        # which may lead to the result overwriting
        if len(set([k for k in m])) != len(m):
            logging.warning(
                f"the solving process found there exist symbols with identical name, please double check. ({[k for k in m]})")
        for k in m:
            # the decode is weird, we just want to convert unprintable characters
            # into printable chars
            # ref: https://stackoverflow.com/questions/13837848/converting-byte-stri98776ng-in-unicode-string
            solution_hex_str = hex(m[k].as_long())[2:]
            if len(solution_hex_str) % 2 == 1:
                solution_hex_str = "0" + solution_hex_str
            solution = []
            for i in range(0, len(solution_hex_str), 2):
                solution.append(chr(int(solution_hex_str[i: i + 2], 16)))
            solutions[str(k)] = "".join(solution[::-1])
        return solutions
    def emulate(self, state, data_section, analyzer, lvar):
        if self.instr_name in self.skip_command:
            return [state]
        if self.instr_name in self.term_command:
            return [state]

        if self.instr_name == 'nop':#illustrate get to the dummy end block
            if state.instr.xref:
                self.restore_context(state)#jump to callee function
            return [state]
        elif self.instr_name == 'br_if' or self.instr_name == 'if':
            if state.type == 'symbolic':
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
                    # these two flags are used to jump over unnecessary deepcopy
                    no_need_true, no_need_false = False, False
                    if unsat == one_time_query_cache(state.solver, op):
                        no_need_true = True
                    if unsat == one_time_query_cache(state.solver, Not(op)):
                        no_need_false = True

                    if no_need_true and no_need_false:
                        pass
                    elif not no_need_true and not no_need_false:
                        new_state = copy.deepcopy(state)
                        # conditional_true
                        state.edge_type = 'conditional_true_0'
                        state.solver.add(op)
                        # conditional_false
                        new_state.edge_type = 'conditional_false_0'
                        new_state.solver.add(Not(op))
                        # append
                        states.append(state)
                        states.append(new_state)
                    else:
                        if no_need_true:
                            state.edge_type = 'conditional_false_0'
                            state.solver.add(Not(op))
                            states.append(state)
                        else:
                            state.edge_type = 'conditional_true_0'
                            state.solver.add(op)
                            states.append(state)
                else:
                    exit(f"br_if/if instruction error. op is {op}")
                return states
            elif state.type == 'concolic':
                op = state.symbolic_stack.pop()
                op_var = state.concolic_stack.pop()
                assert is_bv_value(op) , f"the type of op popped from stack in `br_if`/`if` is {type(op)} instead of bv or bool"
                op = simplify(op != 0)
                states = []
                if is_true(op):
                    state.edge_type = 'conditional_true_0'
                    new_state= copy.deepcopy(state)
                    new_state.solver.add(simplify(op_var==0))
                    new_state.edge_type = 'conditional_false_0'
                    state.solver.add(simplify(op_var!=0))
                elif is_false(op):
                    state.edge_type = 'conditional_false_0'
                    new_state= copy.deepcopy(state)
                    new_state.solver.add(simplify(op_var!=0))
                    new_state.edge_type = 'conditional_true_0'
                    state.solver.add(simplify(op_var==0))
                states.append(state)
                states.append(new_state)
                return states   
            
            
        elif self.instr_name == 'call_indirect':
            # refer to: https://developer.mozilla.org/en-US/docs/WebAssembly/Understanding_the_text_format#webassembly_tables
            # this instruction will pop an element out of the stack, and use this as an index in the table, i.e., elem section in Wasm module, to dynamically determine which fucntion will be invoked
            elem_index_to_func = Configuration.get_elem_index_to_func()
            concolic = state.type == 'concolic'
            
            # target function index
            op = state.symbolic_stack.pop()
            if not concolic:
                op_con = state.concolic_stack.pop()
            assert is_bv_value(
                op), f"in call_indirect, op is a symbol ({op}), not support yet"
            op = op.as_long()
            elem_size= next((i for i, v in enumerate(elem_index_to_func[::-1]) if v != -1), None)
            assert op >=0 and op < elem_size
            
            callee_func_offset = elem_index_to_func[op]
            assert isinstance(callee_func_offset,int),f"error data type"
            assert callee_func_offset<=len(analyzer.elements),f"callee_func_offset:{callee_func_offset} is out of range"
            
            callee_func_name =  Configuration.get_func_index_to_func_name()[callee_func_offset]
            
            state.call_indirect_callee = callee_func_name
            
            if callee_func_offset == -1:
                exit("no valid callee in call_indirect")
            else:
                return self.deal_with_call(
                    state, callee_func_offset, data_section, analyzer, lvar)
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
            #2 1 0 3 
            # construct possible state
            states = []
            states.append(state)
            if state.type == 'concolic':
                op_sym = state.concolic_stack.pop()
                op = op.as_long()
                if(op>=n_br or op<0):
                    state.edge_type = "conditional_false_0"
                    state.solver.add(simplify(Or(op_sym >= n_br, op_sym < 0)))
                    states.append(state)
                
                for target, index_list in target_branch2index.items():
                    if op in index_list:
                        new_state= copy.deepcopy(state)
                        new_state.edge_type = f"conditional_false_0"
                        new_state.solver.add(simplify(Or(op_sym >= n_br, op_sym < 0)))
                        states.append(new_state)
                        
                        state.edge_type = f"conditional_true_{target}"
                        index_list = [simplify(op_sym == i) for i in index_list]
                        state.solver.add(simplify(Or(index_list)))

                        
                    else:
                        new_state= copy.deepcopy(state)
                        new_state.edge_type = f"conditional_true_{target}"
                        index_list = [simplify(op_sym == i) for i in index_list]
                        new_state.solver.add(simplify(Or(index_list)))
                        states.append(new_state)
                
            else:
                for target, index_list in target_branch2index.items():
                    index_list = [simplify(op == i) for i in index_list]#可能有多个index指向同一个target
                    cond = simplify(Or(index_list))
                    if is_false(cond):
                        continue
                    elif is_true(cond):
                        # we can omit the "True" apppended into the constraint
                        new_state = copy.deepcopy(state)
                        new_state.edge_type = f"conditional_true_{target}"
                        states.append(new_state)
                    else:
                        # we have to query z3
                        new_state = copy.deepcopy(state)
                        new_state.solver.add(cond)
                        new_state.edge_type = f"conditional_true_{target}"
                        states.append(new_state)

                # determine if we need the default branch
                cond = simplify(Or(op >= n_br, op < 0))
                if is_false(cond):
                    # we don't need it
                    pass
                elif is_true(cond):
                    state.edge_type = "conditional_false_0"
                    states.append(state)
                else:
                    state.solver.add(cond)
                    state.edge_type = "conditional_false_0"
                    states.append(state)

            assert len(states) != 0, f"in br_table, no branch is selected"
            return states
        elif self.instr_name == 'call':
            self.instr_operand = self.instr_string.split(' ')[1]
            # get the callee's function signature
            try:
                f_offset = int(self.instr_operand)
            except ValueError:
                # it's possible that the `call` operand is a hex
                f_offset = int(self.instr_operand, 16)
            return self.deal_with_call(
                state, f_offset, data_section, analyzer, lvar)
        else:
            raise UnsupportInstructionError
