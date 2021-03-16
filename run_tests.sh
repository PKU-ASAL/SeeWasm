echo '[*] WebAssembly Disassembler [*]'
python3 -m unittest octopus/tests/WASM/test_disassembler.py
echo '[*] WebAssembly ControlFlowGraph & CallGraph analysis [*]'
python3 -m unittest octopus/tests/WASM/test_cfg.py