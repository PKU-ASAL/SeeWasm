# SeeWasm
![SeeWasm-logo](./images/logo.png)

WebAssembly (Wasm), as a low-level language, has several advantages. Moreover, Wasm can be translated from high-level mainstream programming languages, e.g., C, C++, Go, Rust and so on.

In this project, we have implemented a **symbolic execution engine** for Wasm binaries, SeeWasm. Our goal is to build a set of toolchain, which can take source code file (written in other programming languages) as input, symbolically execute it, and output feasible paths with their solutions for further analysis (e.g., vulnerability detection).

##  Prerequisites 
First, you have to make sure Python3.7+ is installed.

Then, some libraries shoule be installed as follows:

```shell
python -m pip install -r requirements.txt
```

You can test if all of them are installed successfully by:

```shell
python test.py
```

This command will traverse the `./test` folder and extract all Wasm binaries.
If all of them can be symbolically executed without any exceptions, the success info would shown in your terminal **after several seconds**.

Some representative samples exist in the folder, e.g., hello world programs written in C and Rust.
These two Wasm binaries can be compiled from C and Rust, and the compiling processes are illustrated in [here](https://github.com/bytecodealliance/wasmtime/blob/main/docs/WASI-tutorial.md#compiling-to-wasi).
We will not repeat how to compile programs into Wasm binaries in this readme.

## Analyze

In this section, we would show how to use SeeWasm to analyze the generated Wasm file.

### Options
All valid options are shown in below:
```shell
SeeWasm, a symbolic execution engine for Wasm module

optional arguments:
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

## Example
If we want to execute a program which does not requrie any extra arguments and input, the command should be:

```shell
python launcher.py -f PATH_TO_WASM_BINARY -s
```

The corresponding logging and results of feasible paths will be generated in `./log` folder.

If compilicated arguments are required. For example, a `base64` program whose `main` is like:

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
python launcher.py -f PATH_TO_BASE64 -s --sym_args 2 --sym_stdin 5 --sym_files 1 10 -v info
```