class Graph:
    def __init__(self):
        self.func_to_bbs = dict()
        self.bbs_graph = dict()
        self.bb_to_instructions = dict()

    def extract_basic_blocks(self, wasmVM):
        cfg = wasmVM.cfg
        funcs = cfg.functions

        self.func_to_bbs = dict()
        for func in funcs:
            func_name, func_bbs = func.name, func.basicblocks
            # get the name of bb in func_bbs 
            func_bbs = [bb.name for bb in func_bbs]
            self.func_to_bbs[func_name] = func_bbs

        # adjacent graph for basic blocks, like:
        # {'block_3_0': ['block_3_6', 'block_3_9']}
        edges = cfg.edges
        for edge in edges:
            node_from, node_to = edge.node_from, edge.node_to
            if node_from not in self.bbs_graph:
                self.bbs_graph[node_from] = [node_to]
            else:
                self.bbs_graph[node_from].append(node_to)

        # goal 1: append those single node into the bbs_graph
        # goal 2: initialize bb_to_instructions
        bbs = cfg.basicblocks
        for bb in bbs:
            # goal 1
            bb_name = bb.name
            if bb_name not in self.bbs_graph:
                self.bbs_graph[bb_name] = []

            # goal 2
            self.bb_to_instructions[bb_name] = bb.instructions
    
    def traverse(self, wasmVM, entry_func_list):
        for entry_func in entry_func_list:
            # initialize a state
            param_str, return_str = wasmVM.get_signature(entry_func)
            state, has_ret = wasmVM.init_state(entry_func, param_str, return_str, [])

            # retrieve all the relevant basic blocks
            entry_func_bbs = self.func_to_bbs[entry_func]
            # filter out the entry basic block and corresponding instructions
            entry_bb = [bb for bb in entry_func_bbs if bb[-2:] == "_0"]
            instructions = self.bb_to_instructions[entry_bb]
            
            # cast entry_func into an object instead of a string
            # entry_func = wasmVM.cfg.get_function(entry_func)

            wasmVM.emulate_basic_block(state, has_ret, instructions)
