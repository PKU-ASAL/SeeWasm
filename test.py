import os
import sys
import time
from collections import defaultdict
from os import walk

import pytest
import sh

testcase_dir = './test/'
candidates = []
for _, _, files in walk(testcase_dir):
    for file in files:
        if file.endswith(".wasm"):
            candidates.append(file)

cmd_lists = []
for case in candidates:
    file_path = os.path.join(testcase_dir, case)
    if 'hello_world_go.wasm' == case:
        cmd_lists.append(['launcher.py', '-f', file_path,
                         '-s', '--entry', '_start', '-v', 'info'])
    else:
        cmd_lists.append(['launcher.py', '-f', file_path, '-s', '-v', 'info'])

result = defaultdict(list)
python_cmd = sh.Command(sys.executable)
for i, cmd in enumerate(cmd_lists):
    try:
        print(f'Running: {candidates[i]}')
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
    print(f"{k}, {','.join(v)}s")

print('''
 _____
|   __|_ _ ___ ___ ___ ___ ___
|__   | | |  _|  _| -_|_ -|_ -|
|_____|___|___|___|___|___|___|
''')
