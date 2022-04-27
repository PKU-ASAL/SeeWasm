# Wasm-SE
![Wasm-SE-logo](./images/wasm-se-logo.png)
WebAssembly (Wasm), as a low-level language, has several advantages. Moreover, Wasm can be translated from other mainstream programming languages, e.g., C, C++, Go, Rust and so on.

In this project, we have implemented a **symbolic execution engine** for Wasm files. Our goal is to build a set of toolchain, which can take source code file (written in other programming languages) as input, symbolically execute it, and generate the path constraints for further analysis (e.g., vulnerability detection).

Currently, we have supported some of standard C library functions, and we are going to support Go in the following stage.

|          |     C      |     Go     | EWasm | EOSIO | Rust  |
| :------: | :--------: | :--------: | :---: | :---: | :---: |
| Progress | Working on | Working on | TODO  | Done  | TODO  |

##  Prerequisites 
To run the samples (some simple Wasm files compiled from C), you have to install some python libraries as follows:

```shell
python3 -m pip install -r requirements.txt
```

You can test if all of them are installed successfully by:

```shell
python3 test.py e
```

This command will traverse the `Wasm-samples/c_samples.nosync/emcc` folder and extract the Wasm files. If all of them can be symbolically executed without any exceptions, the success info would shown in your terminal **after several minutes**. However, *during the developing stage, some exceptions may happen, please raise the issue for us*.

## Toolchain

To analyze the files written in other programming languages, you have to generate the corresponding Wasm file in your local environment. In this section, we would briefly give the instruction about how to compile C / Go file into Wasm.

### C -> Wasm

#### One-Shot Solution

Write your own `[file_name].c` file, and put it in the `Wasm-samples/c_samples.nosync/source` folder. Then, `cd` to the `Wasm-samples/c_samples.nosync` folder, and run:

```shell
./gen.sh -e [file_name]
```

In this way, the corresponding files would be generated in `Wasm-samples/c_samples.nosync/emcc` folder (`-e` indicates only emcc is invoked). However, users can change the `-e` to `-b` or `-o`, which corresponds to binaryen optimization ([wasm-opt](https://github.com/WebAssembly/binaryen) is required) and emcc O3 optimization, respectively.

Our experiments result shows that, both of binaryen and emcc O3 optimization can lead to a significant acceleration for the following analysis. Therefore, **we strongly recommend users adopt `-b` or `-o` to accelerate the analysis.**

#### Manual Generation

To generate Wasm file from C, we recommend the tool: [Emscripten](https://emscripten.org/index.html). You can follow its [official instruction](https://emscripten.org/docs/getting_started/downloads.html) to install it in your local environment. To verify if emcc is installed successfully, run `emcc --check` in your terminal to see if any error happens.

After emcc is installed, use the command:
```shell
emcc [file_name].c -g -s WASM=1 -o [file_name].html
```

Here, `-g` means the generated Wasm file would keep the debug information, which would be used in the following stage.
The above command would generate three files: `[file_name].html`, `[file_name].js` and `[file_name].wasm`. The first two files provide the hosting environment for the Wasm file. Thus, we can only focus on the `[file_name].wasm`, in which all the logic in C is transferred to Wasm instructions.

Moreover, our tool requires a *WebAssembly Text* file with the same name of the Wasm file. You have to install the official tool [wasm2wat](https://github.com/WebAssembly/wabt) and use the command:

```shell
wasm2wat [file_name].wasm -o [file_name].wat
```

To run the generated Wasm file, please refer to [this part](#analyze-specific-functions).

### Go -> Wasm

There are two ways to translate Go code into Wasm code: original Go and TinyGo. **We strongly recommend use the latter one, i.e., TinyGo.**

#### Original Go
To compile Go code to Wasm file, you have to firstly make sure the Go environment is properly installed on your device.
You can test it in your terminal by:
```shell
go version
```

Then, you can use the following command to compile a `[file_name].go` into `[file_name].wasm`, and convert it into a Wat file.
```shell
GOOS=js GOARCH=wasm go build -o [file_name].wasm
wasm2wat [file_name].wasm -o [file_name].wat
```

Note that the Wat file is larger than 60M, because it contains all the necessary functions that are used to interact with the hosting environment (JavaScript here as we assigned).
The `main` function in Go file is named as `main.main` in the Wat file.

#### TinyGo
[TinyGo](https://tinygo.org/getting-started/install/) requires Go version greater than 1.15. You should install it and check it by:
```shell
tinygo
```

If it is successfully installed on your computer, you can modify go source files and run `make` command in Wasm-samples folder to generate corresponding files.

For manual generation, you can use command below to generate Wasm and Wat files.
```shell
tinygo build -wasm-abi=generic -target=wasi -opt=0 -scheduler=none -o main.wasm ./main.go
wasm2wat main.wasm -o main.wat
```

We provided several examples in the repo Wasm-samples. The command to run the symbolic execution engine is: (You can change the path of wasm file to other examples to run it)
```shell
python3 eunomia_entry -f './Wasm-samples/go_samples.nosync/hello_world/main.wasm' -s --onlyfunc main.main --concrete_globals --source_type go
```

## Analyze

In this section, we would show how to use Wasm-SE to analyze the generated Wasm file.

### Analyze Specific Function(s)

To specify which functions would be analyzed, i.e., as the entry point during the symbolic execution, we should use the following command:

```shell
python3 eunomia_entry -f [path_to_file].wasm -s --onlyfunc [entry_func] -v
```

Here, in the `[entry_func]`, users are allowed to specify the entry functions. For Wasm file compiled from C, we typically set this field as `main`.
Also, you can use `-v` to output each Wasm instruction's behavior.

Note that, if the Wasm file are generated by Go source code, you should also append `--source_type go`, which enables a different set of library function emulation that specifies to Go.

### Enable Vulnerability Detector

The goal of Wasm-SE is to automatically identify vulnerabilities in scanned files. Currently, we are working on the implementation of detectors, and some of them have been achieved.
The details are shown in below:

| Vulnerability Type | Integer  Overflow / Underflow | Div Zero | Buffer Overflow |
| :----------------: | :---------------------------: | :------: | :-------------: |
| **Progress on C**  |             Done              |   Done   |      Done       |
| **Progress on Go** |             Doing             |  Doing   |      Doing      |

Users can input `--overflow`, `--divzero` or `--buffer` to enable the corresponding detectors.

### Enable Coverage Calculation

The option `--coverage` can output the coverage information under the `log` director.
