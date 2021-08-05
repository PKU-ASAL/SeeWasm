class ControlInstructions:
    def __init__(self, instr_name, instr_operand, _):
        self.instr_name = instr_name
        self.instr_operand = instr_operand
        self.skip = lambda : False, None
        self.terminate = lambda : True, None
        self.skip_command = ['loop', 'return', 'end', 'br', 'else']
        self.term_command = ['unreachable']

    # TODO overflow check in this function?
    def emulate(self, state):
        if self.instr_name in self.skip_command:
            return False, None
        if self.instr_name in self.term_command:
            return True, None