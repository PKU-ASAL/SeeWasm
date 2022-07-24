from eunomia.arch.wasm.configuration import Configuration
from graphviz import Digraph


def visualize(Graph, filename="wasm_ICFG.gv"):
    entry_func = Configuration.get_entry()
    entry_func_index_name = Graph.wasmVM.get_signature(entry_func)[0]
    entry_bb = Graph.func_to_bbs[entry_func_index_name][0]
    assert entry_bb.endswith('_0'), f"entry_bb ({entry_bb}) not ends with 0"

    g = Digraph(filename, filename=filename)
    g.attr(rankdir="TB")

    # we suppose the entry function's caller is 'start'
    # and the start consists of 'block_0_xx'
    # TODO, may change, need static analysis here
    for bbs in Graph.func_to_bbs.values():
        if bbs[0].split('_')[1] == '0':
            break
    caller_bbs = bbs

    # construct a set consisting of edges (nodeA, nodeB, edge_type)
    visited = set()
    # add these bbs to terminate the search
    visited.update(caller_bbs)
    edges_set = set()
    stack = list()
    stack.append(entry_bb)
    while stack:
        bb = stack.pop()
        visited.add(bb)
        if bb in Graph.bbs_graph:
            for edge_type, succ_bb in Graph.bbs_graph[bb].items():
                if succ_bb not in visited:
                    edges_set.add((bb, succ_bb, edge_type))
                    stack.append(succ_bb)
                elif (bb, succ_bb, edge_type) not in edges_set and succ_bb not in caller_bbs:
                    edges_set.add((bb, succ_bb, edge_type))

    with g.subgraph(name='global') as c:
        # construct the graph
        for edge in edges_set:
            node_from, node_to, _ = edge
            c.node(node_from)
            c.node(node_to)
            c.edge(node_from, node_to)

    g.render(filename, view=True)
