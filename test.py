import os
import time
from os import walk, path

import pytest
import sh


testcase_dir = './c2wasm_samples/'
cmd_lists = []

candidates = []
for _, _, files in walk('./c2wasm_samples'):
    for file in files:
        if file.endswith('.c'):
            candidates.append(file[:-2])
candidates.remove('print_rhombic')

for case in candidates:
    case_file = case + '_g3.wasm'
    file_path = os.path.join(testcase_dir, case_file)
    cmd_lists.append(['octopus_wasm', '-f', file_path, '-s',
                     '--onlyfunc', 'main', '--need_mapper'])

python_cmd = sh.Command('python3.6')
for i, cmd in enumerate(cmd_lists):
    try:
        start = time.perf_counter()
        python_cmd(cmd)
        end = time.perf_counter()
        print('Case: ', candidates[i], 'Duration: ', end - start)
    except sh.ErrorReturnCode as e:
        print(e)
        pytest.fail(e)
print('''
 _____                         
|   __|_ _ ___ ___ ___ ___ ___ 
|__   | | |  _|  _| -_|_ -|_ -|
|_____|___|___|___|___|___|___|
''')
