# Wasm-SE
A native symbolic execution engine for WebAssembly

## 依赖安装
```shell
python3.6 -m pip install -r requirements.txt
```

## 测试

```shell
python3.6 octopus_wasm -f './test_contract/fairdicegame.wasm' --laser fake_eos --depth 2 --timeout 5
```

结果：

```shell
$ python3.6 octopus_wasm -f './test_contract/fairdicegame.wasm' --laser fake_eos --depth 2 --timeout 5
WARNING:root:=============================Function Name: apply=============================

[{"module": "fake_eos", "is_vulnerable": false, "constraints": []}]%
```

