class Issue():

    def __init__(self, module, is_vulnerable, constraints):
        # self.indirect_call_index = list(indirect_call_index)
        self.module = module
        self.is_vulnerable = is_vulnerable
        self.constraints = constraints
