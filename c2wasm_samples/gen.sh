#!/bin/bash

emcc "$1.c" -g3 -s WASM=1 -o "$1.html"

rm -f "$1.js"
rm -f "$1.html"

wasm2wat "$1.wasm" > "$1.wat"

mv "$1.wasm" "$1_g3.wasm"
mv "$1.wat" "$1_g3.wat"

echo "Done!"