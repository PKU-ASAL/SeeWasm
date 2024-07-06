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

def test_hello_c_to_wasm():
    source_path = "./test/c/src/hello.c"
    cmd = ["clang", "-g", source_path, "-o", "hello_c.wasm"]
    subprocess.run(cmd, timeout=60, check=True)
    assert os.path.exists("hello_c.wasm"), "hello_c.wasm not found. Compilation failed."
    cmd = [sys.executable, 'launcher.py', '-f', "hello_c.wasm", '-s', '-v', 'info', '--source_type', 'c', '--entry', '__main_void']
    subprocess.run(cmd, timeout=60, check=True)
    os.remove("hello_c.wasm")
    os.remove("hello_c.wat")

    result_dir = glob.glob('./output/result/hello_c*')
    result_dir.sort()
    result_dir = result_dir[-1]
    state_path = glob.glob(f'{result_dir}/state*.json')
    assert len(state_path) == 1, 'should have only one state output'
    with open(state_path[0], 'r') as f:
        state = json.load(f)
    assert state['Output'][0] == {
        "name": "stdout",
        "output": "Hello, world!\n"
    }, f'output mismatched, got {state["Output"]}'

def test_sym_c_to_wasm():
    source_path = "./test/c/src/sym.c"
    cmd = ["clang", "-g", source_path, "-o", "sym_c.wasm"]
    subprocess.run(cmd, timeout=60, check=True)
    assert os.path.exists("sym_c.wasm"), "sym_c.wasm not found. Compilation failed."
    cmd = [sys.executable, 'launcher.py', '-f', "sym_c.wasm", '-s', '--sym_args', '1', '-v', 'info', '--source_type', 'c', '--entry', '__main_void']
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
        analyzed_return = int(state['Return'])
        analyzed_stdout = state['Output'][0]['output']
        if state['Return'] != 1: # only test the printable input, should be a char in a~z
            continue
        # call wasmtime with inp
        cmd = ["wasmtime", "sym_c.wasm", inp]
        p = subprocess.run(cmd, timeout=60, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        # compare results
        assert p.returncode == analyzed_return, f'analyzed return code {analyzed_return}, wasmtime returned {p.returncode}, input {inp}, wasmtime stderr {p.stderr.decode("utf-8")}'
        assert p.stdout.decode('utf-8') == analyzed_stdout, f'output mismatched, analyzed {analyzed_stdout}, wasmtime returned {p.stdout.decode("utf-8")}'

    os.remove("sym_c.wasm")
    os.remove("sym_c.wat")

def test_hello_rust_to_wasm():
    source_dir = "./test/rust/hello"
    expected_wasm_path = "./test/rust/hello/target/wasm32-wasi/debug/hello_rust.wasm"
    cmd = ["cargo", "build", "--target", "wasm32-wasi"]
    subprocess.run(cmd, cwd=source_dir, timeout=60, check=True)
    assert os.path.exists(expected_wasm_path), "hello_rust.wasm not found. Compilation failed."
    cmd = [sys.executable, 'launcher.py', '-f', expected_wasm_path, '-s', '-v', 'info', '--source_type', 'rust', '--entry', '__main_void']
    subprocess.run(cmd, timeout=60, check=True)
    cmd = ["rm", "-rf", "./test/rust/hello/target"]
    subprocess.run(cmd, timeout=60, check=True)

    result_dir = glob.glob('./output/result/hello_rust*')
    result_dir.sort()
    result_dir = result_dir[-1]
    state_path = glob.glob(f'{result_dir}/state*.json')
    assert len(state_path) == 1, 'should have only one state output'
    with open(state_path[0], 'r') as f:
        state = json.load(f)
    assert state['Output'][0] == {
        "name": "stdout",
        "output": "Hello, world!\n"
    }, f'output mismatched, got {state["Output"]}'