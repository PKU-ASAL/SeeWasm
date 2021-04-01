# 该脚本用于抽取 C 通过 -g3 等级编译得到的 wat 文件中的对应的 function index 和 function 名称之间的关系
# This script will maintain a *map* structure, consisting of the function index and the corresponding 
# function name that obtained from the compiler from C to Wasm with -g3 debuggability

import re

def extract_mapping(file_path):
    with open(file_path) as fp:
        text = fp.read()

    # index to func name
    mapper = {}
    matches = re.findall(r'func (.*) \(type', text)
    for i, func_name in enumerate(matches):
        mapper[i] = func_name

    return mapper

def main():
    extract_mapping('/Users/ningyu/Documents/GitHub/Wasm-SE/c2wasm_samples/hello_g3.wat')


if __name__ == "__main__":
    main()
