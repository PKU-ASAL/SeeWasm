(module
  (type (;0;) (func (param i32 i32) (result i32)))
  (type (;1;) (func))
  (import "env" "__isoc99_scanf" (func $__isoc99_scanf (type 0)))
  (import "env" "printf" (func $printf (type 0)))
  (func $__wasm_call_ctors (type 1))
  (func $main (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    local.set 2
    i32.const 48
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set 0
    i32.const 0
    local.set 5
    local.get 4
    local.get 5
    i32.store offset=44
    local.get 4
    local.get 0
    i32.store offset=40
    local.get 4
    local.get 1
    i32.store offset=36
    i32.const 32
    local.set 6
    local.get 4
    local.get 6
    i32.add
    local.set 7
    local.get 4
    local.get 7
    i32.store offset=16
    i32.const 1024
    local.set 8
    i32.const 16
    local.set 9
    local.get 4
    local.get 9
    i32.add
    local.set 10
    local.get 8
    local.get 10
    call $__isoc99_scanf
    drop
    i32.const 0
    local.set 11
    local.get 4
    local.get 11
    i32.store offset=28
    block  ;; label = @1
      loop  ;; label = @2
        local.get 4
        i32.load offset=32
        local.set 12
        i32.const -1
        local.set 13
        local.get 12
        local.get 13
        i32.add
        local.set 14
        local.get 4
        local.get 14
        i32.store offset=32
        local.get 12
        i32.eqz
        br_if 1 (;@1;)
        local.get 4
        i32.load offset=28
        local.set 15
        i32.const 1
        local.set 16
        local.get 15
        local.get 16
        i32.add
        local.set 17
        local.get 4
        local.get 17
        i32.store offset=28
        br 0 (;@2;)
      end
      unreachable
    end
    local.get 4
    i32.load offset=28
    local.set 18
    local.get 4
    local.get 18
    i32.store
    i32.const 1027
    local.set 19
    local.get 19
    local.get 4
    call $printf
    drop
    local.get 4
    i32.load offset=44
    local.set 20
    i32.const 48
    local.set 21
    local.get 4
    local.get 21
    i32.add
    local.set 22
    local.get 22
    global.set 0
    local.get 20
    return)
  (table (;0;) 1 1 funcref)
  (memory (;0;) 256 256)
  (global (;0;) (mut i32) (i32.const 5243920))
  (export "memory" (memory 0))
  (export "__wasm_call_ctors" (func $__wasm_call_ctors))
  (export "main" (func $main))
  (export "__indirect_function_table" (table 0))
  (data (;0;) (i32.const 1024) "%d\00%d\0a\00"))
