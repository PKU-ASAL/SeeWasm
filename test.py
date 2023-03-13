import sys
import pytest
from os import path
import sh

testcase_dir = './test/'
python_cmd = sh.Command(sys.executable)

@pytest.mark.parametrize('wasm_path, entry', [
    ('hello_world.wasm', ''),
    ('hello_world_go.wasm', '_start'),
    ('hello_world_rust.wasm', ''),
    ('test.wasm', ''),
])

def test_wasm_can_be_analyzed(wasm_path, entry):
    wasm_path = path.join(testcase_dir, wasm_path)
    cmd = ['launcher.py', '-f', wasm_path, '-s', '-v', 'info']
    if entry != "":
        cmd.extend(['--entry', entry])
    python_cmd(cmd)
