import os
import time
from os import walk, path

import pytest
import sh
from collections import defaultdict


testcase_dir = './c2wasm_samples/emcc-binaryen'
cmd_lists = []

candidates = []
for _, _, files in walk(testcase_dir):
    for file in files:
        if file.endswith('.wasm'):
            candidates.append(file[: -5])
candidates.remove('print_rhombic')
candidates.remove('collatz_manticore')
candidates.remove('simple_rotate_array')

candidates.sort()

for case in candidates:
    case += '.wasm'
    file_path = os.path.join(testcase_dir, case)
    cmd_lists.append(['octopus_wasm', '-f', file_path, '-s',
                     '--onlyfunc', 'main', '--need_mapper'])

result = defaultdict(list)
python_cmd = sh.Command('python3.6')
for i, cmd in enumerate(cmd_lists):
    try:
        print('Case: ', candidates[i])
        for _ in range(5):
            start = time.perf_counter()
            python_cmd(cmd)
            end = time.perf_counter()
            result[candidates[i]].append("{:.3f}".format(end-start))
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
