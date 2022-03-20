EDGE_UNCONDITIONAL = 'unconditional'
EDGE_CONDITIONAL_TRUE = 'conditional_true'
EDGE_CONDITIONAL_FALSE = 'conditional_false'
EDGE_FALLTHROUGH = 'fallthrough'
EDGE_CALL = 'call'


class Edge:
    """
    The edges in the CFG, connecting basic blocks
    """

    def __init__(self, node_from, node_to, edge_type=EDGE_UNCONDITIONAL,
                 condition=None):
        """
        Properties of edges in the CFG

        Properties:
            node_from: the 'name' of the basic block pointed from
            node_to: the 'name' of the basic block pointed to
            type: the type of the edge, including five types listed at the beginning of the current file

        Below are properties may be deprecated in the future
            condition: do not understand its actual meaning
        """

        self.node_from = node_from
        self.node_to = node_to
        self.type = edge_type

        self.condition = condition

    def __str__(self):
        return str(self.as_dict())

    def __eq__(self, other):
        return self.node_from == other.node_from and\
            self.node_to == other.node_to and\
            self.type == other.type and\
            self.condition == other.condition

    def __hash__(self):
        return hash(('from', self.node_from,
                     'to', self.node_to,
                     'type', self.type,
                     'condition', self.condition))

    def as_dict(self):
        return {'from': str(self.node_from), 'to': str(self.node_to),
                'type': self.type, 'condition': self.condition}
