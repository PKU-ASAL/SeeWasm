class Function(object):
    """
    The function object of the given Wasm module
    """

    def __init__(self, start_offset, start_instr=None,
                 name='func_default_name', prefered_name=None):
        """
        The properties of the functions of the given Wasm module

        Properties:
            start_offset: the start offset of the first instruction
            start_instr: the first instruction of the function
            name: the function's name, represented in '$funcX' or readable name (TODO will make them all to readable name in the future)
            prefered_name: the signature of the function, including type of arguments and return value
            size: the size of the function, the sum of all its composed basic blocks
            end_offset: the end_offset of its last basic block
            end_instr: the last instruction of the function
            basicblocks: the list of all composed basic blocks
            instructions: the list of all composed instructions
        """
        self.start_offset = start_offset
        self.start_instr = start_instr
        self.name = name
        self.prefered_name = prefered_name if prefered_name else name
        self.size = 0
        self.end_offset = None
        self.end_instr = None
        self.basicblocks = list()
        self.instructions = list()

    def __str__(self):
        line = ('%x' % self.start_offset) + ': ' + str(self.name) + '\n'
        line += 'prefered_name: %s\n' % self.prefered_name
        line += 'start_offset = %x\n' % self.start_offset
        line += 'start_instr = ' + str(self.start_instr.name) + '\n'
        if self.size:
            line += 'size = ' + str(self.size) + '\n'
        if self.end_offset:
            line += 'end_offset = ' + str(self.end_offset) + '\n'
        if self.end_instr:
            line += 'end_instr = ' + str(self.end_instr.name) + '\n'
        line += 'lenght basicblocks: %s\n' % len(self.basicblocks)
        line += 'lenght instructions: %s\n' % len(self.instructions)
        line += '\n\n'
        return line
