import json
import glob
import os
import pytest
import subprocess
import sys

testcase_dir = './test/'

@pytest.mark.parametrize('wasm_path, entry', [
    ('hello_world.wasm', ''),
    ('hello_world_go.wasm', '_start'),
    ('hello_world_wasip1.wasm', '_start'),
    ('hello_world_rust.wasm', ''),
    ('test.wasm', ''),
    ('password.wasm', '')
])

def test_wasm_can_be_analyzed(wasm_path, entry):
    wasm_path = os.path.join(testcase_dir, wasm_path)
    cmd = [sys.executable, 'launcher.py', '-f', wasm_path, '-s', '-v', 'info']
    if entry != "":
        cmd.extend(['--entry', entry])
    subprocess.run(cmd, timeout=60, check=True)

def test_return_simulation():
    wasm_path = './test/test_return.wasm'
    cmd = [sys.executable, 'launcher.py', '-f', wasm_path, '-s', '-v', 'info']
    subprocess.run(cmd, timeout=60, check=True)

    result_dir = glob.glob('./output/result/test_return_*')
    result_dir.sort()
    result_dir = result_dir[-1]
    state_path = glob.glob(f'{result_dir}/state*.json')
    assert len(state_path) == 1, 'should have only one state returning `1`'

    with open(state_path[0], 'r') as f:
        state = json.load(f)
    assert state['Return'] == "1", f'should return 1, got {state["Return"]}'

def test_unreachable_simulation():
    wasm_path = './test/test_unreachable.wasm'
    cmd = [sys.executable, 'launcher.py', '-f', wasm_path, '-s', '-v', 'info']
    subprocess.run(cmd, timeout=60, check=True)

    result_dir = glob.glob('./output/result/test_unreachable_*')
    result_dir.sort()
    result_dir = result_dir[-1]
    state_path = glob.glob(f'{result_dir}/state*.json')
    assert len(state_path) == 1, 'should have only one state output `null`'
    with open(state_path[0], 'r') as f:
        state = json.load(f)
    assert state['Solution'] == {}, f'should have no solution, got {state["Solution"]}'

def test_c_sym_args():
    wasm_path = './test/sym_c.wasm'
    cmd = [sys.executable, 'launcher.py', '-f', wasm_path, '-s', '--sym_args', '1', '--source_type', 'c', '--entry', '__main_void', '-v', 'info']
    subprocess.run(cmd, timeout=60, check=True)

    result_dir = glob.glob('./output/result/sym_c*')
    result_dir.sort()
    result_dir = result_dir[-1]
    state_path = glob.glob(f'{result_dir}/state*.json')
    assert len(state_path) == 3, 'should have three states output'
    for state in state_path:
        with open(state, 'r') as f:
            state = json.load(f)
        assert 'Solution' in state and 'sym_arg_1' in state['Solution'], f'no sym_arg_1 solution found in {state}'
        assert 'Return' in state, f'no Return found in {state}'
        assert 'Output' in state and len(state['Output']) == 2, f'no Output found in {state}'
        inp = state['Solution']["sym_arg_1"]
        analyzed_return = state['Return']
        analyzed_stdout = state['Output'][0]['output']
        expected_return_to_stdout = {"0": "a", "1": "b", "2": "c"}
        assert analyzed_return in expected_return_to_stdout, f'analyzed return value {analyzed_return} not found in expected_return_to_stdout'
        assert analyzed_stdout == expected_return_to_stdout[analyzed_return], f'output mismatched, got {analyzed_stdout}, expected {expected_return_to_stdout[analyzed_return]}'

def test_password_sym_args():
    wasm_path = './test/password.wasm'
    cmd = [sys.executable, 'launcher.py', '-f', wasm_path, '-s', '--sym_args', '10', '--source_type', 'c', '--entry', '_start', '-v', 'info']
    subprocess.run(cmd, timeout=60, check=True)

    result_dir = glob.glob('./output/result/password*')
    result_dir.sort()
    result_dir = result_dir[-1]
    state_path = glob.glob(f'{result_dir}/state*.json')
    assert len(state_path) == 6, 'should have six states output'
    for state in state_path:
        with open(state, 'r') as f:
            state = json.load(f)
        assert 'Solution' in state and 'sym_arg_1' in state['Solution'], f'no sym_arg_1 solution found in {state}'
        assert 'Output' in state and len(state['Output']) == 2, f'no Output found in {state}'
        inp = state['Solution']["sym_arg_1"]
        analyzed_stdout = state['Output'][0]['output']
        if 'Return' in state:
            assert state['Return'] == "0", f'should return 0, got {state["Return"]}'
            assert inp == "hello", f'solved input mismatched, got {inp}'
            assert analyzed_stdout == "Password found!\n", f'output mismatched, got {analyzed_stdout}'
        else:
            assert 'Status' in state, f'no Status found in {state}'
            assert state['Status'] == "Exit with status code 1", f'should exit with status code 1, got {state["Status"]}'
