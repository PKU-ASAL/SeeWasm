class BasicBlock(object):
    """
    The basic block in the CFG, consisting of instructions
    """

    def __init__(self, start_offset=0x00, start_instr=None,
                 name='block_default_name'):
        """
        The properties of basic blocks

        Properties:
            start_offset: the offset of the first instruction on function level
            start_instr: the first instruction of the current basic block
            name: the name of the basic block, whose naming style is "block_[func_index]_[start_offset]"
            end_offset: the offset_ned of the last instruction
            end_instr: the last instruction

        Below are properties may be deprecated in the future
            states: not clear
            function_name: its corresponding function's name
            dsl: the user given constraints written in DSL (this is corresponding to the previous version's DSL)
        """
        self.start_offset = start_offset
        self.start_instr = start_instr
        self.name = name
        self.end_offset = None
        self.end_instr = None
        self.instructions = list()

        # may be deprecated in the future
        self.states = []
        self.function_name = "unknown"
        self.dsl = []

    @property
    def size(self):
        return self.end_offset - self.start_offset

    def __str__(self):
        out = ''
        line = ''
        line = str(self.start_offset) + ': ' + str(self.name) + '\n'
        line += 'start_instr = ' + str(self.start_instr.name) + '\n'
        line += 'size = ' + str(self.size) + '\n'
        line += 'end_offset = ' + str(self.end_offset) + '\n'
        line += 'end_instr = ' + str(self.end_instr.name) + '\n'
        line += 'function_name = ' + str(self.function_name) + '\n'
        line += 'dsl = ' + str(self.dsl) + '\n'
        out += line + '\n\n'
        return out

    def instructions_details(self, format='hex'):
        out = ''
        line = ''
        for i in self.instructions:
            line = '%x: ' % i.offset
            if i.operand is not None and not i.xref:
                line += '%s' % str(i)
            elif isinstance(i.xref, list) and i.xref:
                line += '%s %s' % (i.name, i.xref)
            elif isinstance(i.xref, int) and i.xref:
                line += '%s %x' % (i.name, i.xref)
            elif i.operand_interpretation:
                line += i.operand_interpretation
            else:
                line += i.name + ' '

            out += line + '\n'
        return out

    def instructions_ssa(self, format='hex'):
        out = ''
        line = ''
        for i in self.instructions:
            line = '%x: ' % i.offset
            if i.ssa:
                line += '' + i.ssa.format()
            else:
                line += '[NO_SSA] ' + i.name
            out += line + '\n'
        return out
