# Wasm-SE
A native symbolic execution engine for WebAssembly

## 依赖安装
```shell
python3.6 -m pip install -r requirements.txt
```

## 测试

```shell
python3.6 octopus_wasm -f './test_contract/fairdicegame.wasm' --laser fake_eos
```

结果：

```shell
$ python3.6 octopus_wasm -f './test_contract/fairdicegame.wasm' --laser fake_eos
WARNING:root:=============================Function Name: apply=============================

[{"module": "fake_eos", "is_vulnerable": false, "constraints": []}]%
```

## 分析 C 语言指定函数
如果我们要测试例如 C 语言中的 `main` 函数，那么我们可以使用如下语句：
```shell
python3.6 octopus_wasm -f './c2wasm_samples/hello_g3.wasm' -s --onlyfunc main --need_mapper
```
**注意，`need_mapper` 参数在 `-g3` 编译选项下为必选，否则无法正确跳过 `printf` 等 C 语言库函数**