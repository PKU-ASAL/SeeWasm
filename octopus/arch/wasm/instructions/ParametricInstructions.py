from octopus.arch.wasm.exceptions import UnsupportInstructionError


class ParametricInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand

    # TODO overflow check in this function?
    def emulate(self, state, depth, has_ret, call_depth):
        if self.instr_name == 'drop':
            state.symbolic_stack.pop()
            return False, None
        elif self.instr_name == 'select':  # select instruction
            raise UnsupportInstructionError
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
