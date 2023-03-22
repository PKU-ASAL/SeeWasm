import sys
import pytest
from os import path
import subprocess
import glob

testcase_dir = './test/'

@pytest.mark.parametrize('wasm_path, entry', [
    ('hello_world.wasm', ''),
    ('hello_world_go.wasm', '_start'),
    ('hello_world_rust.wasm', ''),
    ('hello_world_rust_demangled.wasm', ''),
    ('test.wasm', ''),
])

def test_wasm_can_be_analyzed(wasm_path, entry):
    wasm_path = path.join(testcase_dir, wasm_path)
    cmd = [sys.executable, 'launcher.py', '-f', wasm_path, '-s', '-v', 'info']
    if entry != "":
        cmd.extend(['--entry', entry])
    subprocess.run(cmd, timeout=900, check=True)

def test_return_simulation():
    wasm_path = './test/test_return.wasm'
    cmd = [sys.executable, 'launcher.py', '-f', wasm_path, '-s', '-v', 'info', '--source_type', 'rust']
    subprocess.run(cmd, timeout=900, check=True)

    result_dir = glob.glob('./log/result/test_return_*')
    assert len(result_dir) == 1, 'more than one matching results, do you have multiple `test_return*` cases?'
    result_dir = result_dir[0]
    state_path = glob.glob(f'{result_dir}/state*.json')
    assert len(state_path) == 1, 'should have only one state output `Exit 0`'

    proc = subprocess.run(['jq', '.Solution.proc_exit', state_path[0]], capture_output=True, check=True)
    out = proc.stdout.decode('utf-8').strip()
    expect = '"\\u0000"'
    assert out == expect, f'expect {expect}, got {out}'

def test_unreachable_simulation():
    wasm_path = './test/test_unreachable.wasm'
    cmd = [sys.executable, 'launcher.py', '-f', wasm_path, '-s', '-v', 'info', '--source_type', 'rust']
    subprocess.run(cmd, timeout=900, check=True)

    result_dir = glob.glob('./log/result/test_unreachable_*')
    assert len(result_dir) == 1, 'more than one matching results, do you have multiple `test_unreachable*` cases?'
    result_dir = result_dir[0]
    state_path = glob.glob(f'{result_dir}/state*.json')
    assert len(state_path) == 1, 'should have only one state output `null`'

    proc = subprocess.run(['jq', '.Solution.proc_exit', state_path[0]], capture_output=True, check=True)
    out = proc.stdout.decode('utf-8').strip()
    expect = 'null'
    assert out == expect, f'expect {expect}, got {out}'
