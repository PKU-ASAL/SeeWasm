# SeeWasm [![Test](https://github.com/HNYuuu/SeeWasm/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/HNYuuu/SeeWasm)
![SeeWasm-logo](./images/logo.png)


WebAssembly (Wasm), a low-level language, offers several advantages and can be translated from high-level mainstream programming languages such as C, C++, Go, and Rust.

In this project, we have implemented a **symbolic execution engine** for Wasm binaries, SeeWasm. Our goal is to build a toolchain that takes source code files (written in other programming languages) as input, performs symbolic execution, and outputs feasible paths with their solutions for further analysis (e.g., vulnerability detection).

##  Prerequisites 
To run SeeWasm, ensure you have Python 3.7 or a later version installed. Then, install the required Python libraries by executing the following command:

```shell
python3 -m pip install -r requirements.txt
```

If you encounter issues building the wheel for leb128, update pip and wheel, then reinstall leb128:

```shell
pip install --upgrade pip wheel
pip install --force-reinstall leb128==1.0.4
```

If you need to visualize the graph (`--visualize`), make sure you have installed `graphviz` on your system. You can use `sudo apt install graphviz` to install.

To verify everything is set up correctly, run the following command:

```shell
pytest test.py -m basic
```

This command traverses the `./test` folder and performs symbolic execution on all Wasm binaries.
If successful, a success message will be displayed, typically **after several seconds**.

Sample Wasm binaries, including "Hello World" in C, Go, and Rust, are provided in the folder. 
These can be compiled from their respective source languages; the compilation processes are detailed in [WASI tutorial](https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md#compiling-to-wasi) (C and Rust), and [WASI "Hello World" example](https://wasmbyexample.dev/examples/wasi-hello-world/wasi-hello-world.go.en-us.html) (Go).

## Analyze
This section demonstrates how to use SeeWasm to analyze a generated WebAssembly file.

### Options
All valid options are shown in below:

```shell
SeeWasm, a symbolic execution engine for Wasm binaries

Optional arguments:
  -h, --help            show this help message and exit

Input arguments:
  -f WASMMODULE, --file WASMMODULE
                        binary file (.wasm)
  --stdin STDIN         stream of stdin
  --sym_stdin SYM_STDIN
                        stream of stdin in N bytes symbols
  --args ARGS           command line
  --sym_args SYM_ARGS [SYM_ARGS ...]
                        command line in symbols, each of them is N bytes at most
  --sym_files SYM_FILES SYM_FILES
                        Create N symbolic files, each of them has M symbolic bytes
  --source_type [{c,go,rust}]
                        type of source file

Features:
  --entry ENTRY         set entry point as the specilized function
  --visualize           visualize the ICFG on basic blocks level
  --incremental         enable incremental solving
  -v [{warning,info,debug}], --verbose [{warning,info,debug}]
                        set the logging level

Analyze:
  -s, --symbolic        perform the symbolic execution
```

We will detail these options according to their functionalities.

### Input Arguments
According to values given to input arguments, SeeWasm can deassemble the target binary and construct valid inputs.

Specifically, `-f` is not an optional option, following which the path of to be analyzed Wasm binary should be given.
`--stdin STRING` and `--sym_stdin N` can pass concrete or symbolic bytes through the stdin stream.
The difference between them is that a concrete string has to be passed through `--stdin`, and a string consisting of `N` symbolic characters need to be passed through `--sym_stdin`.
For example, `--sym_stdin 5` will input 5 symbolic bytes if some functions need to read input from stdin.

Similarly, `--args STRING1, STRING2, ...` and `--sym_args N1, N2, ...` pass concrete and symbolic arguments to the Wasm binary.
For instance, if `main` requires three arguments where each of them should be two bytes, `--sym_args 2 2 2` is enough.

Some programs will interact with files and conduct reading and writing.
SeeWasm can also simulate this by a *symbolic file system*.
Users have to apply `--sym_files N M` to create `N` symbolic files, where each of them has (or can hold) `M` bytes at most.

Finally, as several high-level programming languages can be compiled to Wasm binaries. We have achieved some specific optimizations, but users have to indicate the source language by `--source_types`.

### Features
`--entry` can tell SeeWasm which function is the entry, from which the symbolic execution performs.
Note that the `__original_main` is the default entry for all Wasm binaries following WASI standard.
The toolchain we mentioned in the [previous section](README.md#prerequisites) can generate Wasm binaries following WASI standard.

As we mentioned in our paper, the given Wasm will be parsed into ICFG.
Sometimes visualizing the ICFG is necessary for debugging.
Thus `--visualize` can achieve this goal.

During symbolic execution, constraints solving is a bottleneck for the performance.
We have implemented a set of optimizations on the solving process.
The `--incremental` refers to *incremental solving*, which may not always introduce positive optimizations during the analysis. Therefore, we set a flag to allow users to decidie if enable the incremental solving.

The `-v` is an optional option.
Accoding to different values, different levels of logging can be generated, which may help the debugging.

### Analyze
The `-s` is a mandatory option.
It will enable the symbolic execution analysis on the given Wasm binary.

## Output
The output of SeeWasm, including logs and results, is stored in the `log` folder, with each file named according to the pattern `NAME_TIMESTAMP`.

The log file follows a specific format, which illustrates the call trace of the anaylzed program:

```log
2024-07-01 07:50:36,191 | WARNING | Totally remove 27 unrelated functions, around 50.000% of all functions
2024-07-01 07:50:36,205 | INFO | Call: __original_main -> __main_void
2024-07-01 07:50:36,218 | INFO | Call: __main_void -> __wasi_args_sizes_get
2024-07-01 07:50:36,219 | INFO | Call: args_sizes_get (import)
2024-07-01 07:50:36,219 | INFO | 	args_sizes_get, argc_addr: 70792, arg_buf_size_addr: 70796
2024-07-01 07:50:36,219 | INFO | Return: args_sizes_get (import)
2024-07-01 07:50:36,219 | INFO | Return: __wasi_args_sizes_get
...
```

The result is a JSON file containing feasible paths with their solutions, formatted as follows:

```json
{
    "Status": xxx,
    "Solution": {xxx},
    "Output": [
        {
            "name": "stdout",
            "output": "xxx"
        },
        {
            "name": "stderr",
            "output": "xxx"
        }
    ]
}
```

## Example
If we want to execute a program which does not requrie any extra arguments and input, the command should be:

```shell
python3 launcher.py -f PATH_TO_WASM_BINARY -s
```

If compilicated arguments are required, for example, a `base64` program whose `main` is like:

```c
// main of base64
int main(int argc, char **argv)
{
  // environment setting
  ...

  while ((opt = getopt_long(argc, argv, "diw:", long_options, NULL)) != -1)
    switch (opt) {
      // call functions according to passed arguments
      ...
    }

  // encode or decode
}
```
We can see that the `base64` not only requires a two bytes arguments, but also needs a string of input to encode or decode. Also, the encoded or decoded results will go to a file.
Thus, the command to analyze the `base64` is like:

```shell
python3 launcher.py -f PATH_TO_BASE64 -s --sym_args 2 --sym_stdin 5 --sym_files 1 10 -v info
```

## Citations

If you use our tool or dataset in your research for publication, please kindly cite the following paper:

```
@inproceedings{he2023eunomia,
  author = {He, Ningyu and Zhao, Zhehao and Wang, Jikai and Hu, Yubin and Guo, Shengjian and Wang, Haoyu and Liang, Guangtai and Li, Ding and Chen, Xiangqun and Guo, Yao},
  title = {Eunomia: Enabling User-Specified Fine-Grained Search in Symbolically Executing WebAssembly Binaries},
  year = {2023},
  isbn = {9798400702211},
  publisher = {Association for Computing Machinery},
  address = {New York, NY, USA},
  url = {https://doi.org/10.1145/3597926.3598064},
  doi = {10.1145/3597926.3598064},
  booktitle = {Proceedings of the 32nd ACM SIGSOFT International Symposium on Software Testing and Analysis},
  pages = {385–397},
  numpages = {13},
  keywords = {WebAssembly, Symbolic Execution, Domain Specific Language, Path Explosion},
  location = {Seattle, WA, USA},
  series = {ISSTA 2023}
}

```

## Feedback

If you have any questions or need further clarification, please post on the [Issues](https://github.com/HNYuuu/SeeWasm/issues) page.

## Acknowledgements

We would like to thank the anonymous reviewers for their valuable feedback and suggestions.
