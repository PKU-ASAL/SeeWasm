import os
import time

import pytest
import sh


testcase_dir = './c2wasm_samples/'
cmd_lists = []

case_lists = ['hello', 'simple_condition',
              'simple_rotate_array', 'intadd', 'bubble_sort', 'simple_loop', 'hello_array', 'divzero', 'overflow_but_check', 'overflow']

for case in case_lists:
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
        print('Case: ', case_lists[i], 'Duration: ', end - start)
    except sh.ErrorReturnCode as e:
        print(e)
        pytest.fail(e)
print('''
 _____                         
|   __|_ _ ___ ___ ___ ___ ___ 
|__   | | |  _|  _| -_|_ -|_ -|
|_____|___|___|___|___|___|___|
''')
