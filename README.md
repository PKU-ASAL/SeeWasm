# Wasm-SE
A native symbolic execution engine for WebAssembly

## 依赖安装
```shell
python3.6 -m pip install -r requirements.txt
```

## 测试

### 分析 C 语言指定函数
如果我们要测试例如 C 语言中的 `main` 函数，那么我们可以使用如下语句：
```shell
python3.6 octopus_wasm -f './c2wasm_samples/hello_g3.wasm' -s --onlyfunc main --need_mapper -v
```
**注意，`need_mapper` 参数在 `-g3` 编译选项下为必选，否则无法正确跳过 `printf` 等 C 语言库函数**

目前，所有位于 `c2wasm_samples` 文件夹下的脚本均可以被正常分析，可以使用如下指令来测试（可能需要安装必要的库）：
```shell
python3 test.py
```
上述测试脚本约耗时五分钟。

### EOSIO 漏洞扫描器
**Note: 请暂时先使用 C 语言样例做测试**

输入：
```shell
python3.6 octopus_wasm -f './test_contract/fairdicegame.wasm' --laser fake_eos
```

结果：
```shell
$ python3.6 octopus_wasm -f './test_contract/fairdicegame.wasm' --laser fake_eos
WARNING:root:=============================Function Name: apply=============================

[{"module": "fake_eos", "is_vulnerable": false, "constraints": []}]%
```

# Compile WASM from C

## Tools

1. [customized clang](https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md#from-c): this is a c2wasm compiler provided by the [WASI](https://wasi.dev/) team, which will compile c to wasm code runnable in [wasmtime](https://wasmtime.dev/) or [wasmer](https://wasmer.io/), both of which are WASM runtime (without browser required). However, some APIs in c (like `syscall()`) are not supported.
2. [Emscripten](https://emscripten.org/): this is a complete compiler toolchain to WebAssembly. It can compile c to wasm code running in browser (with a `-o xx.html` target) or in the aforementioned WASM runtime (with a `-o xx.wasm` target).

# Generate CFG

```bash
python3.6 octopus_wasm -g -f /path/to/xx.wasm --onlyfunc main
```

Example:

```
python3.6 octopus_wasm -g -f c2wasm_samples/simple_condition_g3.wasm --onlyfunc main
```

Results:

Shown as `cfg/simple_conditon.cfg.gv.pdf`.

Note:

- For wasm code compiled from c, it is recommended to use Emscripten with a `-g3` option provided. 
- Make sure the function name is correctly exported when using `--onlyfunc` option. (use [wasm2wat](https://github.com/WebAssembly/wabt) to check)