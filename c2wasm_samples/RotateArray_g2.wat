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
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    local.set 0
    i32.const 160
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
    i32.const 48
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
    i32.store offset=44
    i32.const 48
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
    i32.store offset=40
    block  ;; label = @1
      loop  ;; label = @2
        local.get 2
        i32.load offset=44
        local.set 18
        local.get 2
        i32.load offset=40
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
        i32.const 48
        local.set 25
        local.get 2
        local.get 25
        i32.add
        local.set 26
        local.get 26
        local.set 27
        local.get 2
        i32.load offset=44
        local.set 28
        local.get 27
        local.get 28
        i32.add
        local.set 29
        i32.const 48
        local.set 30
        local.get 2
        local.get 30
        i32.add
        local.set 31
        local.get 31
        local.set 32
        local.get 2
        i32.load offset=40
        local.set 33
        local.get 32
        local.get 33
        i32.add
        local.set 34
        local.get 29
        local.get 34
        call $swap
        local.get 2
        i32.load offset=44
        local.set 35
        i32.const 1
        local.set 36
        local.get 35
        local.get 36
        i32.add
        local.set 37
        local.get 2
        local.get 37
        i32.store offset=44
        local.get 2
        i32.load offset=40
        local.set 38
        i32.const -1
        local.set 39
        local.get 38
        local.get 39
        i32.add
        local.set 40
        local.get 2
        local.get 40
        i32.store offset=40
        br 0 (;@2;)
      end
      unreachable
    end
    i32.const 0
    local.set 41
    local.get 2
    local.get 41
    i32.store offset=36
    i32.const 0
    local.set 42
    local.get 2
    local.get 42
    i32.store offset=32
    block  ;; label = @1
      loop  ;; label = @2
        local.get 2
        i32.load offset=32
        local.set 43
        i32.const 48
        local.set 44
        local.get 2
        local.get 44
        i32.add
        local.set 45
        local.get 45
        local.set 46
        local.get 46
        call $strlen
        local.set 47
        local.get 43
        local.set 48
        local.get 47
        local.set 49
        local.get 48
        local.get 49
        i32.le_u
        local.set 50
        i32.const 1
        local.set 51
        local.get 50
        local.get 51
        i32.and
        local.set 52
        local.get 52
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        i32.load offset=32
        local.set 53
        i32.const 48
        local.set 54
        local.get 2
        local.get 54
        i32.add
        local.set 55
        local.get 55
        local.set 56
        local.get 56
        local.get 53
        i32.add
        local.set 57
        local.get 57
        i32.load8_u
        local.set 58
        i32.const 24
        local.set 59
        local.get 58
        local.get 59
        i32.shl
        local.set 60
        local.get 60
        local.get 59
        i32.shr_s
        local.set 61
        i32.const 32
        local.set 62
        local.get 61
        local.set 63
        local.get 62
        local.set 64
        local.get 63
        local.get 64
        i32.ne
        local.set 65
        i32.const 1
        local.set 66
        local.get 65
        local.get 66
        i32.and
        local.set 67
        block  ;; label = @3
          block  ;; label = @4
            local.get 67
            i32.eqz
            br_if 0 (;@4;)
            local.get 2
            i32.load offset=32
            local.set 68
            i32.const 48
            local.set 69
            local.get 2
            local.get 69
            i32.add
            local.set 70
            local.get 70
            local.set 71
            local.get 71
            local.get 68
            i32.add
            local.set 72
            local.get 72
            i32.load8_u
            local.set 73
            i32.const 24
            local.set 74
            local.get 73
            local.get 74
            i32.shl
            local.set 75
            local.get 75
            local.get 74
            i32.shr_s
            local.set 76
            local.get 76
            i32.eqz
            br_if 0 (;@4;)
            local.get 2
            i32.load offset=36
            local.set 77
            i32.const 1
            local.set 78
            local.get 77
            local.get 78
            i32.add
            local.set 79
            local.get 2
            local.get 79
            i32.store offset=36
            br 1 (;@3;)
          end
          local.get 2
          i32.load offset=36
          local.set 80
          i32.const 1
          local.set 81
          local.get 80
          local.set 82
          local.get 81
          local.set 83
          local.get 82
          local.get 83
          i32.eq
          local.set 84
          i32.const 1
          local.set 85
          local.get 84
          local.get 85
          i32.and
          local.set 86
          block  ;; label = @4
            local.get 86
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            local.set 87
            local.get 2
            local.get 87
            i32.store offset=36
            br 1 (;@3;)
          end
          local.get 2
          i32.load offset=32
          local.set 88
          local.get 2
          i32.load offset=36
          local.set 89
          local.get 88
          local.get 89
          i32.sub
          local.set 90
          local.get 2
          local.get 90
          i32.store offset=44
          local.get 2
          i32.load offset=32
          local.set 91
          i32.const 1
          local.set 92
          local.get 91
          local.get 92
          i32.sub
          local.set 93
          local.get 2
          local.get 93
          i32.store offset=40
          block  ;; label = @4
            loop  ;; label = @5
              local.get 2
              i32.load offset=44
              local.set 94
              local.get 2
              i32.load offset=40
              local.set 95
              local.get 94
              local.set 96
              local.get 95
              local.set 97
              local.get 96
              local.get 97
              i32.lt_s
              local.set 98
              i32.const 1
              local.set 99
              local.get 98
              local.get 99
              i32.and
              local.set 100
              local.get 100
              i32.eqz
              br_if 1 (;@4;)
              i32.const 48
              local.set 101
              local.get 2
              local.get 101
              i32.add
              local.set 102
              local.get 102
              local.set 103
              local.get 2
              i32.load offset=44
              local.set 104
              local.get 103
              local.get 104
              i32.add
              local.set 105
              i32.const 48
              local.set 106
              local.get 2
              local.get 106
              i32.add
              local.set 107
              local.get 107
              local.set 108
              local.get 2
              i32.load offset=40
              local.set 109
              local.get 108
              local.get 109
              i32.add
              local.set 110
              local.get 105
              local.get 110
              call $swap
              local.get 2
              i32.load offset=44
              local.set 111
              i32.const 1
              local.set 112
              local.get 111
              local.get 112
              i32.add
              local.set 113
              local.get 2
              local.get 113
              i32.store offset=44
              local.get 2
              i32.load offset=40
              local.set 114
              i32.const -1
              local.set 115
              local.get 114
              local.get 115
              i32.add
              local.set 116
              local.get 2
              local.get 116
              i32.store offset=40
              br 0 (;@5;)
            end
            unreachable
          end
          i32.const 0
          local.set 117
          local.get 2
          local.get 117
          i32.store offset=36
        end
        local.get 2
        i32.load offset=32
        local.set 118
        i32.const 1
        local.set 119
        local.get 118
        local.get 119
        i32.add
        local.set 120
        local.get 2
        local.get 120
        i32.store offset=32
        br 0 (;@2;)
      end
      unreachable
    end
    i32.const 48
    local.set 121
    local.get 2
    local.get 121
    i32.add
    local.set 122
    local.get 122
    local.set 123
    local.get 2
    local.get 123
    i32.store
    i32.const 1061
    local.set 124
    local.get 124
    local.get 2
    call $printf
    drop
    i32.const 160
    local.set 125
    local.get 2
    local.get 125
    i32.add
    local.set 126
    local.get 126
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
