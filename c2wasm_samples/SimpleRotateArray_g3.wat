(module
  (type (;0;) (func (param i32 i32) (result i32)))
  (type (;1;) (func))
  (type (;2;) (func (param i32 i32)))
  (type (;3;) (func (param i32) (result i32)))
  (import "env" "printf" (func $printf (type 0)))
  (import "env" "__isoc99_scanf" (func $__isoc99_scanf (type 0)))
  (import "env" "strlen" (func $strlen (type 3)))
  (func $__wasm_call_ctors (type 1))
  (func $swap (type 2) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    local.set 2
    i32.const 16
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    local.get 0
    i32.store offset=12
    local.get 4
    local.get 1
    i32.store offset=8
    local.get 4
    i32.load offset=12
    local.set 5
    local.get 5
    i32.load8_u
    local.set 6
    local.get 4
    local.get 6
    i32.store8 offset=7
    local.get 4
    i32.load offset=8
    local.set 7
    local.get 7
    i32.load8_u
    local.set 8
    local.get 4
    i32.load offset=12
    local.set 9
    local.get 9
    local.get 8
    i32.store8
    local.get 4
    i32.load8_u offset=7
    local.set 10
    local.get 4
    i32.load offset=8
    local.set 11
    local.get 11
    local.get 10
    i32.store8
    return)
  (func $RotateArray (type 1)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    local.set 0
    i32.const 144
    local.set 1
    local.get 0
    local.get 1
    i32.sub
    local.set 2
    local.get 2
    global.set 0
    i32.const 1024
    local.set 3
    i32.const 0
    local.set 4
    local.get 3
    local.get 4
    call $printf
    drop
    i32.const 32
    local.set 5
    local.get 2
    local.get 5
    i32.add
    local.set 6
    local.get 6
    local.set 7
    local.get 2
    local.get 7
    i32.store offset=16
    i32.const 1055
    local.set 8
    i32.const 16
    local.set 9
    local.get 2
    local.get 9
    i32.add
    local.set 10
    local.get 8
    local.get 10
    call $__isoc99_scanf
    drop
    i32.const 0
    local.set 11
    local.get 2
    local.get 11
    i32.store offset=28
    i32.const 32
    local.set 12
    local.get 2
    local.get 12
    i32.add
    local.set 13
    local.get 13
    local.set 14
    local.get 14
    call $strlen
    local.set 15
    i32.const 1
    local.set 16
    local.get 15
    local.get 16
    i32.sub
    local.set 17
    local.get 2
    local.get 17
    i32.store offset=24
    block  ;; label = @1
      loop  ;; label = @2
        local.get 2
        i32.load offset=28
        local.set 18
        local.get 2
        i32.load offset=24
        local.set 19
        local.get 18
        local.set 20
        local.get 19
        local.set 21
        local.get 20
        local.get 21
        i32.lt_s
        local.set 22
        i32.const 1
        local.set 23
        local.get 22
        local.get 23
        i32.and
        local.set 24
        local.get 24
        i32.eqz
        br_if 1 (;@1;)
        i32.const 32
        local.set 25
        local.get 2
        local.get 25
        i32.add
        local.set 26
        local.get 26
        local.set 27
        local.get 2
        i32.load offset=28
        local.set 28
        local.get 27
        local.get 28
        i32.add
        local.set 29
        i32.const 32
        local.set 30
        local.get 2
        local.get 30
        i32.add
        local.set 31
        local.get 31
        local.set 32
        local.get 2
        i32.load offset=24
        local.set 33
        local.get 32
        local.get 33
        i32.add
        local.set 34
        local.get 29
        local.get 34
        call $swap
        local.get 2
        i32.load offset=28
        local.set 35
        i32.const 1
        local.set 36
        local.get 35
        local.get 36
        i32.add
        local.set 37
        local.get 2
        local.get 37
        i32.store offset=28
        local.get 2
        i32.load offset=24
        local.set 38
        i32.const -1
        local.set 39
        local.get 38
        local.get 39
        i32.add
        local.set 40
        local.get 2
        local.get 40
        i32.store offset=24
        br 0 (;@2;)
      end
      unreachable
    end
    i32.const 32
    local.set 41
    local.get 2
    local.get 41
    i32.add
    local.set 42
    local.get 42
    local.set 43
    local.get 2
    local.get 43
    i32.store
    i32.const 1061
    local.set 44
    local.get 44
    local.get 2
    call $printf
    drop
    i32.const 144
    local.set 45
    local.get 2
    local.get 45
    i32.add
    local.set 46
    local.get 46
    global.set 0
    return)
  (func $main (type 0) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 0
    local.set 2
    i32.const 16
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    global.set 0
    local.get 4
    local.get 0
    i32.store offset=12
    local.get 4
    local.get 1
    i32.store offset=8
    call $RotateArray
    i32.const 0
    local.set 5
    i32.const 16
    local.set 6
    local.get 4
    local.get 6
    i32.add
    local.set 7
    local.get 7
    global.set 0
    local.get 5
    return)
  (table (;0;) 1 1 funcref)
  (memory (;0;) 256 256)
  (global (;0;) (mut i32) (i32.const 5243984))
  (export "memory" (memory 0))
  (export "__wasm_call_ctors" (func $__wasm_call_ctors))
  (export "main" (func $main))
  (export "__indirect_function_table" (table 0))
  (data (;0;) (i32.const 1024) "Please input Character array: \00%[^\0a]\00The new Character array is: %s\0a\00"))
