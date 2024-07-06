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

To verify everything is set up correctly, run the following command:

```shell
python3 -m pytest test.py -vv
```

This command traverses the `./test` folder and performs symbolic execution on all Wasm binaries.
If successful, a success message will be displayed, typically **after several seconds**.

Sample Wasm binaries, including "Hello World" in C, Go, and Rust, are provided in the folder. 
These can be compiled from their respective source languages; the compilation processes are detailed in [WASI tutorial](https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md#compiling-to-wasi) (C and Rust), and [WASI "Hello World" example](https://wasmbyexample.dev/examples/wasi-hello-world/wasi-hello-world.go.en-us.html) (Go).

For Rust and C++ project, you can use `wasm-tools` to demangle symbol names in the `name` section. Install with `cargo install wasm-tools`. Confirm by `wasm-tools --version`. Details can be found at [Wasm Tools](https://github.com/bytecodealliance/wasm-tools).

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
SeeWasm can deassemble the target binary and construct valid inputs based on the values of the input arguments.

Specifically, `-f` option is mandatory, and it must be followed by the path of the Wasm binary to be analyzed. The `--stdin STRING` and `--sym_stdin N` options allow users to pass concrete and symbolic bytes through the stdin stream, respectively. A concrete string must be passed using `--stdin`, while a string consisting of `N` symbolic characters must be passed using `--sym_stdin`. For example, `--sym_stdin 5` inputs 5 symbolic bytes for functions that read from stdin.

Similarly, `--args STRING1, STRING2, ...` and `--sym_args N1, N2, ...` options pass concrete and symbolic arguments to the Wasm binary. For instance, if `main` requires three arguments, each two bytes long, `--sym_args 2 2 2` is enough.

Some programs interact with files. SeeWasm simulates this using a *symbolic file system*. Users can create `N` symbolic files, each with up to `M` bytes, using the `--sym_files N M` option.

As multiple high-level programming languages can be compiled to Wasm binaries, we have implemented specific optimizations. To take advantage of these optimizations, users must indicate the source language using the `--source_type` option.

### Features
`--entry` specifies the entry function from which symbolic execution begins. By default, the entry function is `__original_main`. Users must specify a proper entry function to ensure the symbolic execution is performed correctly.

The input Wasm is parsed into an Interprocedural Control Flow Graph (ICFG), which can be visualized for debugging purposes using the `--visualize` option (requires `graphviz`, installable via `sudo apt install graphviz` on Ubuntu).

The constraint solving process is a bottleneck for symbolic execution performance; however, we have implemented some optimizations to mitigate this issue. The `--incremental` flag enables *incremental solving*. Note that it may not always yield positive results during analysis, and is therefore optional.

The `-v` option controls the logging level, allowing users to adjust the verbosity of logging output to aid in debugging.

### Analyze
The `-s` is a mandatory option. It enables symbolic execution analysis on the given Wasm binary.

## Output
The output of SeeWasm, including logs and results, is stored in the `output` folder, with each file named according to the pattern `NAME_TIMESTAMP`.

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
    "Status": "xxx",
    "Solution": {"xxx"},
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

You can use `./clean.sh -f` to remove all files in the `output` folder.

## Example
To execute a program that takes no extra arguments or input, use the following command:

```shell
python3 launcher.py -f PATH_TO_WASM_BINARY -s
```

If compilicated arguments are required, for example, a `base64` program with a `main` function like:

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

The `base64` program expects two-byte arguments and a string input to encode or decode, producing output that is written to a file.
Thus, the command to analyze `base64` is like:

```shell
python3 launcher.py -f PATH_TO_BASE64 -s --sym_args 2 --sym_stdin 5 --sym_files 1 10
```

## Feedback

If you have any questions or need further clarification, please post on the [Issues](https://github.com/HNYuuu/SeeWasm/issues) page.
