#!/usr/bin/env bash
# build-rs: compile and demangle Wasm for Rust source programs

error() {
  command printf '\033[1;31mError\033[0m: %s\n\n' "$1" 1>&2
}

usage() {
    cat >&2 <<END_USAGE
build-rs: compile and demangle Wasm for Rust source programs

USAGE:
    build-rs [FLAGS] [PATH]

FLAGS:
    -h, --help                  Prints help information
    -f, --file                  Build Wasm for specific Rust source file
    -d, --dir, --directory      Build Wasm for all Rust source files in dir [DEPTH=1]

PREREQUISITES:
1. To compile Rust to Wasm, the WASI-enabled Rust toolchain must be enabled:
   \`rustup target add wasm32-wasi\`. If you don't have \`rustup\`, follow https://rustup.rs .
2. This script uses \`wasm-tools\` to demangle.
   Install with \`cargo install wasm-tools\`. Confirm by \`wasm-tools --version\`.
   Details can be found at https://github.com/bytecodealliance/wasm-tools.

END_USAGE
}

build() {
  if [ ! -f "$1" ]; then
    error "File $1 not exists."
    exit 1
  fi
  local dir_name=$(dirname "$1")
  local file_name=$(basename "$1")
  
  if ! rustc "$1" -g --target wasm32-wasi --out-dir "$dir_name"
  then
    error "Failed to compile $file_name to wasm."
    exit 1
  fi

  local wasm_name="${file_name%.*}.wasm"
  local wat_name="${file_name%.*}.wat"
  
  if ! wasm-tools demangle "$dir_name/$wasm_name" -o "$dir_name/$wasm_name"
  then
    error "Failed to demangle "$dir_name/$wasm_name"."
    exit 1
  fi
  
  # To convert `wasm` to human-readable text form `wat`, install `wasm2wat` from
  # https://github.com/WebAssembly/wabt then unquote the following command.
  #
  # wasm2wat "$dir_name/$wasm_name" -o "$dir_name/$wat_name"
}

traverse() {
  if [ ! -d "$1" ]; then
    error "Directory $1 not exists."
    exit 1
  fi
  local d="$1/*"
  for f in $d
  do
    if [ ${f##*.} = "rs" ]; then
      # echo $f
      build $f
    fi
  done
}

if [ $# -eq 0 ]; then
  usage
  exit 0
fi

# parse command line options
while [ $# -gt 0 ]
do
  arg="$1"

  case "$arg" in
    -h|--help)
      usage
      exit 0
      ;;
    -f|--file)
      shift # shift off the argument
      build "$1"
      shift # shift off the path
      ;;
    -d|--dir|--directory)
      shift # shift off the argument
      traverse "$1"
      shift # shift off the path
      ;;
    *)
      error "Unknown option: '$arg'"
      usage
      exit 1
      ;;
  esac
done

