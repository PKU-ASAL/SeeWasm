elem_func_id = set()
elem_func_name = set()

reverse_func_id = dict()
reverse_basicblock_func = dict()
reverse_basicblock_id = dict()

all_func_paths = list()
unsafe_func = dict(db_store_i64=-1, db_update_i64=-1, send_inline=-1, send_deferred=-1,
                   tapos_block_num=-1, transaction_size=-1, tapos_block_prefix=-1)
# unsafe_func = dict(db_store_i64 = -1, db_update_i64 = -1, send_inline = -1, send_deferred = -1)
edge_dict = dict()
visited_func = set()

guided_emulation_flag = False
guided_emulation_mainline_function_flag = False

logging_level_verbose = False
