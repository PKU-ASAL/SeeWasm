import os
import pytest
import sh


testcase_dir = './c2wasm_samples/'
cmd_lists = []

case_lists = ['hello', 'print_rhombic', 'simple_condition',
              'simple_rotate_array', 'intadd', 'bubble_sort', 'simple_loop', 'hello_array']

for case in case_lists:
    case_file = case + '_g3.wasm'
    file_path = os.path.join(testcase_dir, case_file)
    cmd_lists.append(['octopus_wasm', '-f', file_path, '-s',
                     '--onlyfunc', 'main', '--need_mapper'])

python_cmd = sh.Command('python3.6')
for cmd in cmd_lists:
    try:
        python_cmd(cmd)
    except sh.ErrorReturnCode as e:
        print(e)
        pytest.fail(e)
print('''
 _____                         
|   __|_ _ ___ ___ ___ ___ ___ 
|__   | | |  _|  _| -_|_ -|_ -|
|_____|___|___|___|___|___|___|
''')
