import os
import sys
import time
from collections import defaultdict
from os import walk

import pytest
import sh

user_assigned_path = str(sys.argv[1])
assert user_assigned_path in {'e', 'b', 'o'}, f"you must enter the valid path"

helper_mapping = {
    "e": "emcc",
    "b": "emcc-binaryen",
    "o": "emcc-O3",
}

user_assigned_path = helper_mapping[user_assigned_path]
testcase_dir = f'./Wasm-samples/c_samples.nosync/{user_assigned_path}'
cmd_lists = []

candidates = []
for _, _, files in walk(testcase_dir):
    for file in files:
        if file.endswith('.wasm'):
            candidates.append(file[: -5])
# we remove this as it would consume lots time
candidates.remove('print_rhombic')

# we remove this as there is a small bug in graph.py
# candidates.remove('ln_ef_l2')

# jumpover these samples in `loop` category
candidates.remove('5n+1_lo_l1')
candidates.remove('7n+1_lo_l1')
candidates.remove('collaz_lo_l1')
candidates.remove('collaz_lo_l2')

# jumpover these samples in `cp` category
candidates.remove('file_cp_l1')
candidates.remove('div0_eh_cp')
candidates.remove('echo_cp_l1')
candidates.remove('echofile_cp_l1')
candidates.remove('file_eh_cp')

# jumpover these samples in `cf` category
candidates.remove('aes_cf')

# jumpover these samples in `svd` category
candidates.remove('cpu_svd')

# candidates.remove('pointers_sj_l1')

# jumpover these samples in `bo` category
candidates.remove('heap_bo_l1')  # dlfree problem
candidates.remove('stack_bo_l2')    # no BOMB_ENDING return value

# jumpover these samples in `sm` category
candidates.remove('stackarray_sm_ln')  # timeout
candidates.remove('list_sm')  # not support cpp
candidates.remove('vector_sm')  # not support cpp

# normal, just jump over
candidates.remove('addint_to_l1')
candidates.remove('atof_ef_l2')
candidates.remove('atoi_ef_l2')
candidates.remove('bubble_sort')
candidates.remove('buffer_overflow')
candidates.remove('df2cf_cp_l1')
candidates.remove('divzero')
candidates.remove('file_csv')
candidates.remove('float1_fp_l1')
candidates.remove('float2_fp_l1')
candidates.remove('float3_fp_l2')
candidates.remove('float4_fp_l2')
candidates.remove('float5_fp_l2')
candidates.remove('get_pid')
candidates.remove('heapoutofbound_sm_l2')
candidates.remove('hello')
candidates.remove('hello_array')
candidates.remove('if_check_manticore')
candidates.remove('intadd')

candidates.sort()

for case in candidates:
    case += '.wasm'
    file_path = os.path.join(testcase_dir, case)
    cmd_lists.append(['eunomia_entry', '-f', file_path, '-s',
                     '--onlyfunc', 'main', '--need_mapper'])

result = defaultdict(list)
python_cmd = sh.Command('/usr/bin/python3')
for i, cmd in enumerate(cmd_lists):
    try:
        print('Case: ', candidates[i])
        for _ in range(1):
            start = time.perf_counter()
            python_cmd(cmd)
            end = time.perf_counter()
            result[candidates[i]].append("{:.3f}".format(end - start))
    except sh.ErrorReturnCode as e:
        print(e)
        pytest.fail(e)

# print result
for k, v in result.items():
    print(f"{k},{','.join(v)}")

print('''
 _____
|   __|_ _ ___ ___ ___ ___ ___
|__   | | |  _|  _| -_|_ -|_ -|
|_____|___|___|___|___|___|___|
''')
