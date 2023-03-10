#!/bin/bash

export PATH=/Users/xuxiaowei/Desktop/intern/wasi-sdk-14.0/bin:$PATH
clang test.c -o test.wasm
cd ..
python ./launcher.py -f ./bfs_test/test.wasm -s --sym_args 1 -v info
# cp test.wasm ../test/
# echo copy finished
# cd ..
# python ./test.py