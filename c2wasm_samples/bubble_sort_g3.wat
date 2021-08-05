(module
  (type (;0;) (func (param i32 i32 i32) (result i32)))
  (type (;1;) (func (param i32) (result i32)))
  (type (;2;) (func (result i32)))
  (type (;3;) (func (param i32)))
  (type (;4;) (func))
  (type (;5;) (func (param i32 i32)))
  (type (;6;) (func (param i32 i32) (result i32)))
  (type (;7;) (func (param i32 i64 i32) (result i64)))
  (type (;8;) (func (param i32 i64 i64 i32)))
  (type (;9;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;10;) (func (param i32 f64 i32 i32 i32 i32) (result i32)))
  (type (;11;) (func (param i64 i32) (result i32)))
  (type (;12;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;13;) (func (param f64 i32) (result f64)))
  (type (;14;) (func (param i64 i64) (result f64)))
  (type (;15;) (func (param i32 i32 i32 i32 i32 i32 i32) (result i32)))
  (type (;16;) (func (param i32 i32 i32)))
  (type (;17;) (func (param i32 i32 i32 i32)))
  (type (;18;) (func (param i64 i32 i32) (result i32)))
  (type (;19;) (func (param i32 i32 i32 i32 i32)))
  (type (;20;) (func (param f64) (result i64)))
  (type (;21;) (func (param i32 i32 i64 i32) (result i64)))
  (import "wasi_snapshot_preview1" "fd_write" (func $__wasi_fd_write (type 12)))
  (import "env" "emscripten_memcpy_big" (func $emscripten_memcpy_big (type 0)))
  (import "env" "setTempRet0" (func $setTempRet0 (type 3)))
  (func $__wasm_call_ctors (type 4)
    call $emscripten_stack_init)
  (func $bubble_sort (type 5) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    local.set 2
    i32.const 32
    local.set 3
    local.get 2
    local.get 3
    i32.sub
    local.set 4
    local.get 4
    local.get 0
    i32.store offset=28
    local.get 4
    local.get 1
    i32.store offset=24
    i32.const 0
    local.set 5
    local.get 4
    local.get 5
    i32.store offset=20
    block  ;; label = @1
      loop  ;; label = @2
        local.get 4
        i32.load offset=20
        local.set 6
        local.get 4
        i32.load offset=24
        local.set 7
        i32.const 1
        local.set 8
        local.get 7
        local.get 8
        i32.sub
        local.set 9
        local.get 6
        local.set 10
        local.get 9
        local.set 11
        local.get 10
        local.get 11
        i32.lt_s
        local.set 12
        i32.const 1
        local.set 13
        local.get 12
        local.get 13
        i32.and
        local.set 14
        local.get 14
        i32.eqz
        br_if 1 (;@1;)
        i32.const 0
        local.set 15
        local.get 4
        local.get 15
        i32.store offset=16
        block  ;; label = @3
          loop  ;; label = @4
            local.get 4
            i32.load offset=16
            local.set 16
            local.get 4
            i32.load offset=24
            local.set 17
            i32.const 1
            local.set 18
            local.get 17
            local.get 18
            i32.sub
            local.set 19
            local.get 4
            i32.load offset=20
            local.set 20
            local.get 19
            local.get 20
            i32.sub
            local.set 21
            local.get 16
            local.set 22
            local.get 21
            local.set 23
            local.get 22
            local.get 23
            i32.lt_s
            local.set 24
            i32.const 1
            local.set 25
            local.get 24
            local.get 25
            i32.and
            local.set 26
            local.get 26
            i32.eqz
            br_if 1 (;@3;)
            local.get 4
            i32.load offset=28
            local.set 27
            local.get 4
            i32.load offset=16
            local.set 28
            i32.const 2
            local.set 29
            local.get 28
            local.get 29
            i32.shl
            local.set 30
            local.get 27
            local.get 30
            i32.add
            local.set 31
            local.get 31
            i32.load
            local.set 32
            local.get 4
            i32.load offset=28
            local.set 33
            local.get 4
            i32.load offset=16
            local.set 34
            i32.const 1
            local.set 35
            local.get 34
            local.get 35
            i32.add
            local.set 36
            i32.const 2
            local.set 37
            local.get 36
            local.get 37
            i32.shl
            local.set 38
            local.get 33
            local.get 38
            i32.add
            local.set 39
            local.get 39
            i32.load
            local.set 40
            local.get 32
            local.set 41
            local.get 40
            local.set 42
            local.get 41
            local.get 42
            i32.gt_s
            local.set 43
            i32.const 1
            local.set 44
            local.get 43
            local.get 44
            i32.and
            local.set 45
            block  ;; label = @5
              local.get 45
              i32.eqz
              br_if 0 (;@5;)
              local.get 4
              i32.load offset=28
              local.set 46
              local.get 4
              i32.load offset=16
              local.set 47
              i32.const 2
              local.set 48
              local.get 47
              local.get 48
              i32.shl
              local.set 49
              local.get 46
              local.get 49
              i32.add
              local.set 50
              local.get 50
              i32.load
              local.set 51
              local.get 4
              local.get 51
              i32.store offset=12
              local.get 4
              i32.load offset=28
              local.set 52
              local.get 4
              i32.load offset=16
              local.set 53
              i32.const 1
              local.set 54
              local.get 53
              local.get 54
              i32.add
              local.set 55
              i32.const 2
              local.set 56
              local.get 55
              local.get 56
              i32.shl
              local.set 57
              local.get 52
              local.get 57
              i32.add
              local.set 58
              local.get 58
              i32.load
              local.set 59
              local.get 4
              i32.load offset=28
              local.set 60
              local.get 4
              i32.load offset=16
              local.set 61
              i32.const 2
              local.set 62
              local.get 61
              local.get 62
              i32.shl
              local.set 63
              local.get 60
              local.get 63
              i32.add
              local.set 64
              local.get 64
              local.get 59
              i32.store
              local.get 4
              i32.load offset=12
              local.set 65
              local.get 4
              i32.load offset=28
              local.set 66
              local.get 4
              i32.load offset=16
              local.set 67
              i32.const 1
              local.set 68
              local.get 67
              local.get 68
              i32.add
              local.set 69
              i32.const 2
              local.set 70
              local.get 69
              local.get 70
              i32.shl
              local.set 71
              local.get 66
              local.get 71
              i32.add
              local.set 72
              local.get 72
              local.get 65
              i32.store
            end
            local.get 4
            i32.load offset=16
            local.set 73
            i32.const 1
            local.set 74
            local.get 73
            local.get 74
            i32.add
            local.set 75
            local.get 4
            local.get 75
            i32.store offset=16
            br 0 (;@4;)
          end
          unreachable
        end
        local.get 4
        i32.load offset=20
        local.set 76
        i32.const 1
        local.set 77
        local.get 76
        local.get 77
        i32.add
        local.set 78
        local.get 4
        local.get 78
        i32.store offset=20
        br 0 (;@2;)
      end
      unreachable
    end
    return)
  (func $__original_main (type 2) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i64 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    local.set 0
    i32.const 48
    local.set 1
    local.get 0
    local.get 1
    i32.sub
    local.set 2
    local.get 2
    global.set 0
    i32.const 0
    local.set 3
    local.get 2
    local.get 3
    i32.store offset=44
    i32.const 16
    local.set 4
    local.get 2
    local.get 4
    i32.add
    local.set 5
    local.get 5
    local.set 6
    i32.const 16
    local.set 7
    local.get 6
    local.get 7
    i32.add
    local.set 8
    i32.const 0
    local.set 9
    local.get 9
    i32.load offset=1040
    local.set 10
    local.get 8
    local.get 10
    i32.store
    i32.const 8
    local.set 11
    local.get 6
    local.get 11
    i32.add
    local.set 12
    local.get 9
    i64.load offset=1032
    local.set 13
    local.get 12
    local.get 13
    i64.store
    local.get 9
    i64.load offset=1024
    local.set 14
    local.get 6
    local.get 14
    i64.store
    i32.const 16
    local.set 15
    local.get 2
    local.get 15
    i32.add
    local.set 16
    local.get 16
    local.set 17
    i32.const 5
    local.set 18
    local.get 17
    local.get 18
    call $bubble_sort
    i32.const 0
    local.set 19
    local.get 2
    local.get 19
    i32.store offset=12
    block  ;; label = @1
      loop  ;; label = @2
        local.get 2
        i32.load offset=12
        local.set 20
        i32.const 5
        local.set 21
        local.get 20
        local.set 22
        local.get 21
        local.set 23
        local.get 22
        local.get 23
        i32.lt_s
        local.set 24
        i32.const 1
        local.set 25
        local.get 24
        local.get 25
        i32.and
        local.set 26
        local.get 26
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        i32.load offset=12
        local.set 27
        i32.const 16
        local.set 28
        local.get 2
        local.get 28
        i32.add
        local.set 29
        local.get 29
        local.set 30
        i32.const 2
        local.set 31
        local.get 27
        local.get 31
        i32.shl
        local.set 32
        local.get 30
        local.get 32
        i32.add
        local.set 33
        local.get 33
        i32.load
        local.set 34
        local.get 2
        local.get 34
        i32.store
        i32.const 1098
        local.set 35
        local.get 35
        local.get 2
        call $printf
        drop
        local.get 2
        i32.load offset=12
        local.set 36
        i32.const 1
        local.set 37
        local.get 36
        local.get 37
        i32.add
        local.set 38
        local.get 2
        local.get 38
        i32.store offset=12
        br 0 (;@2;)
      end
      unreachable
    end
    i32.const 1102
    local.set 39
    i32.const 0
    local.set 40
    local.get 39
    local.get 40
    call $printf
    drop
    i32.const 0
    local.set 41
    i32.const 48
    local.set 42
    local.get 2
    local.get 42
    i32.add
    local.set 43
    local.get 43
    global.set 0
    local.get 41
    return)
  (func $main (type 6) (param i32 i32) (result i32)
    (local i32)
    call $__original_main
    local.set 2
    local.get 2
    return)
  (func $__errno_location (type 2) (result i32)
    i32.const 1984)
  (func $__wasi_syscall_ret (type 1) (param i32) (result i32)
    block  ;; label = @1
      local.get 0
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    call $__errno_location
    local.get 0
    i32.store
    i32.const -1)
  (func $__stdio_write (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 3
    global.set 0
    local.get 3
    local.get 0
    i32.load offset=28
    local.tee 4
    i32.store offset=16
    local.get 0
    i32.load offset=20
    local.set 5
    local.get 3
    local.get 2
    i32.store offset=28
    local.get 3
    local.get 1
    i32.store offset=24
    local.get 3
    local.get 5
    local.get 4
    i32.sub
    local.tee 1
    i32.store offset=20
    local.get 1
    local.get 2
    i32.add
    local.set 6
    i32.const 2
    local.set 7
    local.get 3
    i32.const 16
    i32.add
    local.set 1
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load offset=60
            local.get 3
            i32.const 16
            i32.add
            i32.const 2
            local.get 3
            i32.const 12
            i32.add
            call $__wasi_fd_write
            call $__wasi_syscall_ret
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 6
              local.get 3
              i32.load offset=12
              local.tee 4
              i32.eq
              br_if 2 (;@3;)
              local.get 4
              i32.const -1
              i32.le_s
              br_if 3 (;@2;)
              local.get 1
              local.get 4
              local.get 1
              i32.load offset=4
              local.tee 8
              i32.gt_u
              local.tee 5
              i32.const 3
              i32.shl
              i32.add
              local.tee 9
              local.get 9
              i32.load
              local.get 4
              local.get 8
              i32.const 0
              local.get 5
              select
              i32.sub
              local.tee 8
              i32.add
              i32.store
              local.get 1
              i32.const 12
              i32.const 4
              local.get 5
              select
              i32.add
              local.tee 9
              local.get 9
              i32.load
              local.get 8
              i32.sub
              i32.store
              local.get 6
              local.get 4
              i32.sub
              local.set 6
              local.get 0
              i32.load offset=60
              local.get 1
              i32.const 8
              i32.add
              local.get 1
              local.get 5
              select
              local.tee 1
              local.get 7
              local.get 5
              i32.sub
              local.tee 7
              local.get 3
              i32.const 12
              i32.add
              call $__wasi_fd_write
              call $__wasi_syscall_ret
              i32.eqz
              br_if 0 (;@5;)
            end
          end
          local.get 6
          i32.const -1
          i32.ne
          br_if 1 (;@2;)
        end
        local.get 0
        local.get 0
        i32.load offset=44
        local.tee 1
        i32.store offset=28
        local.get 0
        local.get 1
        i32.store offset=20
        local.get 0
        local.get 1
        local.get 0
        i32.load offset=48
        i32.add
        i32.store offset=16
        local.get 2
        local.set 4
        br 1 (;@1;)
      end
      i32.const 0
      local.set 4
      local.get 0
      i32.const 0
      i32.store offset=28
      local.get 0
      i64.const 0
      i64.store offset=16
      local.get 0
      local.get 0
      i32.load
      i32.const 32
      i32.or
      i32.store
      local.get 7
      i32.const 2
      i32.eq
      br_if 0 (;@1;)
      local.get 2
      local.get 1
      i32.load offset=4
      i32.sub
      local.set 4
    end
    local.get 3
    i32.const 32
    i32.add
    global.set 0
    local.get 4)
  (func $__emscripten_stdout_close (type 1) (param i32) (result i32)
    i32.const 0)
  (func $__emscripten_stdout_seek (type 7) (param i32 i64 i32) (result i64)
    i64.const 0)
  (func $memset (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i64)
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      local.get 0
      i32.add
      local.tee 3
      i32.const -1
      i32.add
      local.get 1
      i32.store8
      local.get 0
      local.get 1
      i32.store8
      local.get 2
      i32.const 3
      i32.lt_u
      br_if 0 (;@1;)
      local.get 3
      i32.const -2
      i32.add
      local.get 1
      i32.store8
      local.get 0
      local.get 1
      i32.store8 offset=1
      local.get 3
      i32.const -3
      i32.add
      local.get 1
      i32.store8
      local.get 0
      local.get 1
      i32.store8 offset=2
      local.get 2
      i32.const 7
      i32.lt_u
      br_if 0 (;@1;)
      local.get 3
      i32.const -4
      i32.add
      local.get 1
      i32.store8
      local.get 0
      local.get 1
      i32.store8 offset=3
      local.get 2
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      local.get 0
      i32.sub
      i32.const 3
      i32.and
      local.tee 4
      i32.add
      local.tee 3
      local.get 1
      i32.const 255
      i32.and
      i32.const 16843009
      i32.mul
      local.tee 1
      i32.store
      local.get 3
      local.get 2
      local.get 4
      i32.sub
      i32.const -4
      i32.and
      local.tee 4
      i32.add
      local.tee 2
      i32.const -4
      i32.add
      local.get 1
      i32.store
      local.get 4
      i32.const 9
      i32.lt_u
      br_if 0 (;@1;)
      local.get 3
      local.get 1
      i32.store offset=8
      local.get 3
      local.get 1
      i32.store offset=4
      local.get 2
      i32.const -8
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -12
      i32.add
      local.get 1
      i32.store
      local.get 4
      i32.const 25
      i32.lt_u
      br_if 0 (;@1;)
      local.get 3
      local.get 1
      i32.store offset=24
      local.get 3
      local.get 1
      i32.store offset=20
      local.get 3
      local.get 1
      i32.store offset=16
      local.get 3
      local.get 1
      i32.store offset=12
      local.get 2
      i32.const -16
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -20
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -24
      i32.add
      local.get 1
      i32.store
      local.get 2
      i32.const -28
      i32.add
      local.get 1
      i32.store
      local.get 4
      local.get 3
      i32.const 4
      i32.and
      i32.const 24
      i32.or
      local.tee 5
      i32.sub
      local.tee 2
      i32.const 32
      i32.lt_u
      br_if 0 (;@1;)
      local.get 1
      i64.extend_i32_u
      i64.const 4294967297
      i64.mul
      local.set 6
      local.get 3
      local.get 5
      i32.add
      local.set 1
      loop  ;; label = @2
        local.get 1
        local.get 6
        i64.store offset=24
        local.get 1
        local.get 6
        i64.store offset=16
        local.get 1
        local.get 6
        i64.store offset=8
        local.get 1
        local.get 6
        i64.store
        local.get 1
        i32.const 32
        i32.add
        local.set 1
        local.get 2
        i32.const -32
        i32.add
        local.tee 2
        i32.const 31
        i32.gt_u
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $isdigit (type 1) (param i32) (result i32)
    local.get 0
    i32.const -48
    i32.add
    i32.const 10
    i32.lt_u)
  (func $memchr (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32)
    local.get 2
    i32.const 0
    i32.ne
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 3
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          i32.const 255
          i32.and
          local.set 4
          loop  ;; label = @4
            local.get 0
            i32.load8_u
            local.get 4
            i32.eq
            br_if 2 (;@2;)
            local.get 2
            i32.const -1
            i32.add
            local.tee 2
            i32.const 0
            i32.ne
            local.set 3
            local.get 0
            i32.const 1
            i32.add
            local.tee 0
            i32.const 3
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            local.get 2
            br_if 0 (;@4;)
          end
        end
        local.get 3
        i32.eqz
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.load8_u
        local.get 1
        i32.const 255
        i32.and
        i32.eq
        br_if 0 (;@2;)
        local.get 2
        i32.const 4
        i32.lt_u
        br_if 0 (;@2;)
        local.get 1
        i32.const 255
        i32.and
        i32.const 16843009
        i32.mul
        local.set 4
        loop  ;; label = @3
          local.get 0
          i32.load
          local.get 4
          i32.xor
          local.tee 3
          i32.const -1
          i32.xor
          local.get 3
          i32.const -16843009
          i32.add
          i32.and
          i32.const -2139062144
          i32.and
          br_if 1 (;@2;)
          local.get 0
          i32.const 4
          i32.add
          local.set 0
          local.get 2
          i32.const -4
          i32.add
          local.tee 2
          i32.const 3
          i32.gt_u
          br_if 0 (;@3;)
        end
      end
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.const 255
      i32.and
      local.set 3
      loop  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u
          local.get 3
          i32.ne
          br_if 0 (;@3;)
          local.get 0
          return
        end
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 2
        i32.const -1
        i32.add
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    i32.const 0)
  (func $__pthread_self (type 2) (result i32)
    i32.const 1748)
  (func $wcrtomb (type 0) (param i32 i32 i32) (result i32)
    (local i32)
    i32.const 1
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        i32.const 127
        i32.le_u
        br_if 1 (;@1;)
        block  ;; label = @3
          block  ;; label = @4
            call $__pthread_self
            i32.load offset=172
            i32.load
            br_if 0 (;@4;)
            local.get 1
            i32.const -128
            i32.and
            i32.const 57216
            i32.eq
            br_if 3 (;@1;)
            call $__errno_location
            i32.const 25
            i32.store
            br 1 (;@3;)
          end
          block  ;; label = @4
            local.get 1
            i32.const 2047
            i32.gt_u
            br_if 0 (;@4;)
            local.get 0
            local.get 1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=1
            local.get 0
            local.get 1
            i32.const 6
            i32.shr_u
            i32.const 192
            i32.or
            i32.store8
            i32.const 2
            return
          end
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.const 55296
              i32.lt_u
              br_if 0 (;@5;)
              local.get 1
              i32.const -8192
              i32.and
              i32.const 57344
              i32.ne
              br_if 1 (;@4;)
            end
            local.get 0
            local.get 1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=2
            local.get 0
            local.get 1
            i32.const 12
            i32.shr_u
            i32.const 224
            i32.or
            i32.store8
            local.get 0
            local.get 1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=1
            i32.const 3
            return
          end
          block  ;; label = @4
            local.get 1
            i32.const -65536
            i32.add
            i32.const 1048575
            i32.gt_u
            br_if 0 (;@4;)
            local.get 0
            local.get 1
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=3
            local.get 0
            local.get 1
            i32.const 18
            i32.shr_u
            i32.const 240
            i32.or
            i32.store8
            local.get 0
            local.get 1
            i32.const 6
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=2
            local.get 0
            local.get 1
            i32.const 12
            i32.shr_u
            i32.const 63
            i32.and
            i32.const 128
            i32.or
            i32.store8 offset=1
            i32.const 4
            return
          end
          call $__errno_location
          i32.const 25
          i32.store
        end
        i32.const -1
        local.set 3
      end
      local.get 3
      return
    end
    local.get 0
    local.get 1
    i32.store8
    i32.const 1)
  (func $wctomb (type 6) (param i32 i32) (result i32)
    block  ;; label = @1
      local.get 0
      br_if 0 (;@1;)
      i32.const 0
      return
    end
    local.get 0
    local.get 1
    i32.const 0
    call $wcrtomb)
  (func $frexp (type 13) (param f64 i32) (result f64)
    (local i64 i32)
    block  ;; label = @1
      local.get 0
      i64.reinterpret_f64
      local.tee 2
      i64.const 52
      i64.shr_u
      i32.wrap_i64
      i32.const 2047
      i32.and
      local.tee 3
      i32.const 2047
      i32.eq
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 3
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            f64.const 0x0p+0 (;=0;)
            f64.ne
            br_if 0 (;@4;)
            i32.const 0
            local.set 3
            br 1 (;@3;)
          end
          local.get 0
          f64.const 0x1p+64 (;=1.84467e+19;)
          f64.mul
          local.get 1
          call $frexp
          local.set 0
          local.get 1
          i32.load
          i32.const -64
          i32.add
          local.set 3
        end
        local.get 1
        local.get 3
        i32.store
        local.get 0
        return
      end
      local.get 1
      local.get 3
      i32.const -1022
      i32.add
      i32.store
      local.get 2
      i64.const -9218868437227405313
      i64.and
      i64.const 4602678819172646912
      i64.or
      f64.reinterpret_i64
      local.set 0
    end
    local.get 0)
  (func $__ashlti3 (type 8) (param i32 i64 i64 i32)
    (local i64)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const 64
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          local.get 3
          i32.const -64
          i32.add
          i64.extend_i32_u
          i64.shl
          local.set 2
          i64.const 0
          local.set 1
          br 1 (;@2;)
        end
        local.get 3
        i32.eqz
        br_if 1 (;@1;)
        local.get 1
        i32.const 64
        local.get 3
        i32.sub
        i64.extend_i32_u
        i64.shr_u
        local.get 2
        local.get 3
        i64.extend_i32_u
        local.tee 4
        i64.shl
        i64.or
        local.set 2
        local.get 1
        local.get 4
        i64.shl
        local.set 1
      end
      local.get 2
      i64.const 0
      i64.or
      local.set 2
    end
    local.get 0
    local.get 1
    i64.store
    local.get 0
    local.get 2
    i64.store offset=8)
  (func $__lshrti3 (type 8) (param i32 i64 i64 i32)
    (local i64)
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.const 64
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 3
        i32.const -64
        i32.add
        i64.extend_i32_u
        i64.shr_u
        local.set 1
        i64.const 0
        local.set 2
        br 1 (;@1;)
      end
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      i32.const 64
      local.get 3
      i32.sub
      i64.extend_i32_u
      i64.shl
      local.get 1
      local.get 3
      i64.extend_i32_u
      local.tee 4
      i64.shr_u
      i64.or
      local.set 1
      local.get 2
      local.get 4
      i64.shr_u
      local.set 2
    end
    local.get 0
    local.get 1
    i64.store
    local.get 0
    local.get 2
    i64.store offset=8)
  (func $__trunctfdf2 (type 14) (param i64 i64) (result f64)
    (local i32 i64 i64 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 2
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i64.const 9223372036854775807
        i64.and
        local.tee 3
        i64.const -4323737117252386816
        i64.add
        local.get 3
        i64.const -4899634919602388992
        i64.add
        i64.ge_u
        br_if 0 (;@2;)
        local.get 0
        i64.const 60
        i64.shr_u
        local.get 1
        i64.const 4
        i64.shl
        i64.or
        local.set 3
        block  ;; label = @3
          local.get 0
          i64.const 1152921504606846975
          i64.and
          local.tee 0
          i64.const 576460752303423489
          i64.lt_u
          br_if 0 (;@3;)
          local.get 3
          i64.const 4611686018427387905
          i64.add
          local.set 4
          br 2 (;@1;)
        end
        local.get 3
        i64.const 4611686018427387904
        i64.add
        local.set 4
        local.get 0
        i64.const 576460752303423488
        i64.xor
        i64.const 0
        i64.ne
        br_if 1 (;@1;)
        local.get 4
        local.get 3
        i64.const 1
        i64.and
        i64.add
        local.set 4
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i64.eqz
        local.get 3
        i64.const 9223090561878065152
        i64.lt_u
        local.get 3
        i64.const 9223090561878065152
        i64.eq
        select
        br_if 0 (;@2;)
        local.get 0
        i64.const 60
        i64.shr_u
        local.get 1
        i64.const 4
        i64.shl
        i64.or
        i64.const 2251799813685247
        i64.and
        i64.const 9221120237041090560
        i64.or
        local.set 4
        br 1 (;@1;)
      end
      i64.const 9218868437227405312
      local.set 4
      local.get 3
      i64.const 4899634919602388991
      i64.gt_u
      br_if 0 (;@1;)
      i64.const 0
      local.set 4
      local.get 3
      i64.const 48
      i64.shr_u
      i32.wrap_i64
      local.tee 5
      i32.const 15249
      i32.lt_u
      br_if 0 (;@1;)
      local.get 2
      i32.const 16
      i32.add
      local.get 0
      local.get 1
      i64.const 281474976710655
      i64.and
      i64.const 281474976710656
      i64.or
      local.tee 3
      local.get 5
      i32.const -15233
      i32.add
      call $__ashlti3
      local.get 2
      local.get 0
      local.get 3
      i32.const 15361
      local.get 5
      i32.sub
      call $__lshrti3
      local.get 2
      i64.load
      local.tee 3
      i64.const 60
      i64.shr_u
      local.get 2
      i32.const 8
      i32.add
      i64.load
      i64.const 4
      i64.shl
      i64.or
      local.set 4
      block  ;; label = @2
        local.get 3
        i64.const 1152921504606846975
        i64.and
        local.get 2
        i64.load offset=16
        local.get 2
        i32.const 16
        i32.add
        i32.const 8
        i32.add
        i64.load
        i64.or
        i64.const 0
        i64.ne
        i64.extend_i32_u
        i64.or
        local.tee 3
        i64.const 576460752303423489
        i64.lt_u
        br_if 0 (;@2;)
        local.get 4
        i64.const 1
        i64.add
        local.set 4
        br 1 (;@1;)
      end
      local.get 3
      i64.const 576460752303423488
      i64.xor
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
      local.get 4
      i64.const 1
      i64.and
      local.get 4
      i64.add
      local.set 4
    end
    local.get 2
    i32.const 32
    i32.add
    global.set 0
    local.get 4
    local.get 1
    i64.const -9223372036854775808
    i64.and
    i64.or
    f64.reinterpret_i64)
  (func $__lock (type 3) (param i32))
  (func $__unlock (type 3) (param i32))
  (func $__ofl_lock (type 2) (result i32)
    i32.const 3096
    call $__lock
    i32.const 3104)
  (func $__ofl_unlock (type 4)
    i32.const 3096
    call $__unlock)
  (func $__towrite (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    local.get 0
    i32.load8_u offset=74
    local.tee 1
    i32.const -1
    i32.add
    local.get 1
    i32.or
    i32.store8 offset=74
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 1
      i32.const 8
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.const 32
      i32.or
      i32.store
      i32.const -1
      return
    end
    local.get 0
    i64.const 0
    i64.store offset=4 align=4
    local.get 0
    local.get 0
    i32.load offset=44
    local.tee 1
    i32.store offset=28
    local.get 0
    local.get 1
    i32.store offset=20
    local.get 0
    local.get 1
    local.get 0
    i32.load offset=48
    i32.add
    i32.store offset=16
    i32.const 0)
  (func $memcpy (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      local.get 2
      i32.const 512
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      local.get 2
      call $emscripten_memcpy_big
      drop
      local.get 0
      return
    end
    local.get 0
    local.get 2
    i32.add
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        local.get 0
        i32.xor
        i32.const 3
        i32.and
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.const 3
            i32.and
            br_if 0 (;@4;)
            local.get 0
            local.set 2
            br 1 (;@3;)
          end
          block  ;; label = @4
            local.get 2
            i32.const 1
            i32.ge_s
            br_if 0 (;@4;)
            local.get 0
            local.set 2
            br 1 (;@3;)
          end
          local.get 0
          local.set 2
          loop  ;; label = @4
            local.get 2
            local.get 1
            i32.load8_u
            i32.store8
            local.get 1
            i32.const 1
            i32.add
            local.set 1
            local.get 2
            i32.const 1
            i32.add
            local.tee 2
            i32.const 3
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            local.get 2
            local.get 3
            i32.lt_u
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          local.get 3
          i32.const -4
          i32.and
          local.tee 4
          i32.const 64
          i32.lt_u
          br_if 0 (;@3;)
          local.get 2
          local.get 4
          i32.const -64
          i32.add
          local.tee 5
          i32.gt_u
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 2
            local.get 1
            i32.load
            i32.store
            local.get 2
            local.get 1
            i32.load offset=4
            i32.store offset=4
            local.get 2
            local.get 1
            i32.load offset=8
            i32.store offset=8
            local.get 2
            local.get 1
            i32.load offset=12
            i32.store offset=12
            local.get 2
            local.get 1
            i32.load offset=16
            i32.store offset=16
            local.get 2
            local.get 1
            i32.load offset=20
            i32.store offset=20
            local.get 2
            local.get 1
            i32.load offset=24
            i32.store offset=24
            local.get 2
            local.get 1
            i32.load offset=28
            i32.store offset=28
            local.get 2
            local.get 1
            i32.load offset=32
            i32.store offset=32
            local.get 2
            local.get 1
            i32.load offset=36
            i32.store offset=36
            local.get 2
            local.get 1
            i32.load offset=40
            i32.store offset=40
            local.get 2
            local.get 1
            i32.load offset=44
            i32.store offset=44
            local.get 2
            local.get 1
            i32.load offset=48
            i32.store offset=48
            local.get 2
            local.get 1
            i32.load offset=52
            i32.store offset=52
            local.get 2
            local.get 1
            i32.load offset=56
            i32.store offset=56
            local.get 2
            local.get 1
            i32.load offset=60
            i32.store offset=60
            local.get 1
            i32.const 64
            i32.add
            local.set 1
            local.get 2
            i32.const 64
            i32.add
            local.tee 2
            local.get 5
            i32.le_u
            br_if 0 (;@4;)
          end
        end
        local.get 2
        local.get 4
        i32.ge_u
        br_if 1 (;@1;)
        loop  ;; label = @3
          local.get 2
          local.get 1
          i32.load
          i32.store
          local.get 1
          i32.const 4
          i32.add
          local.set 1
          local.get 2
          i32.const 4
          i32.add
          local.tee 2
          local.get 4
          i32.lt_u
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
        unreachable
      end
      block  ;; label = @2
        local.get 3
        i32.const 4
        i32.ge_u
        br_if 0 (;@2;)
        local.get 0
        local.set 2
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 3
        i32.const -4
        i32.add
        local.tee 4
        local.get 0
        i32.ge_u
        br_if 0 (;@2;)
        local.get 0
        local.set 2
        br 1 (;@1;)
      end
      local.get 0
      local.set 2
      loop  ;; label = @2
        local.get 2
        local.get 1
        i32.load8_u
        i32.store8
        local.get 2
        local.get 1
        i32.load8_u offset=1
        i32.store8 offset=1
        local.get 2
        local.get 1
        i32.load8_u offset=2
        i32.store8 offset=2
        local.get 2
        local.get 1
        i32.load8_u offset=3
        i32.store8 offset=3
        local.get 1
        i32.const 4
        i32.add
        local.set 1
        local.get 2
        i32.const 4
        i32.add
        local.tee 2
        local.get 4
        i32.le_u
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      local.get 3
      i32.ge_u
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 2
        local.get 1
        i32.load8_u
        i32.store8
        local.get 1
        i32.const 1
        i32.add
        local.set 1
        local.get 2
        i32.const 1
        i32.add
        local.tee 2
        local.get 3
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $__fwritex (type 0) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=16
        local.tee 3
        br_if 0 (;@2;)
        i32.const 0
        local.set 4
        local.get 2
        call $__towrite
        br_if 1 (;@1;)
        local.get 2
        i32.load offset=16
        local.set 3
      end
      block  ;; label = @2
        local.get 3
        local.get 2
        i32.load offset=20
        local.tee 5
        i32.sub
        local.get 1
        i32.ge_u
        br_if 0 (;@2;)
        local.get 2
        local.get 0
        local.get 1
        local.get 2
        i32.load offset=36
        call_indirect (type 0)
        return
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.load8_s offset=75
          i32.const -1
          i32.le_s
          br_if 0 (;@3;)
          local.get 1
          local.set 4
          loop  ;; label = @4
            block  ;; label = @5
              local.get 4
              local.tee 3
              br_if 0 (;@5;)
              local.get 1
              local.set 3
              br 3 (;@2;)
            end
            local.get 0
            local.get 3
            i32.const -1
            i32.add
            local.tee 4
            i32.add
            i32.load8_u
            i32.const 10
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 2
          local.get 0
          local.get 3
          local.get 2
          i32.load offset=36
          call_indirect (type 0)
          local.tee 4
          local.get 3
          i32.lt_u
          br_if 2 (;@1;)
          local.get 0
          local.get 3
          i32.add
          local.set 0
          local.get 1
          local.get 3
          i32.sub
          local.set 3
          local.get 2
          i32.load offset=20
          local.set 5
          br 1 (;@2;)
        end
        local.get 1
        local.set 3
      end
      local.get 5
      local.get 0
      local.get 3
      call $memcpy
      drop
      local.get 2
      local.get 2
      i32.load offset=20
      local.get 3
      i32.add
      i32.store offset=20
      local.get 1
      local.set 4
    end
    local.get 4)
  (func $__vfprintf_internal (type 9) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32)
    global.get 0
    i32.const 208
    i32.sub
    local.tee 5
    global.set 0
    local.get 5
    local.get 2
    i32.store offset=204
    i32.const 0
    local.set 2
    local.get 5
    i32.const 160
    i32.add
    i32.const 0
    i32.const 40
    call $memset
    drop
    local.get 5
    local.get 5
    i32.load offset=204
    i32.store offset=200
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        local.get 1
        local.get 5
        i32.const 200
        i32.add
        local.get 5
        i32.const 80
        i32.add
        local.get 5
        i32.const 160
        i32.add
        local.get 3
        local.get 4
        call $printf_core
        i32.const 0
        i32.ge_s
        br_if 0 (;@2;)
        i32.const -1
        local.set 1
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 0
        i32.load offset=76
        i32.const 0
        i32.lt_s
        br_if 0 (;@2;)
        local.get 0
        call $__lockfile
        local.set 2
      end
      local.get 0
      i32.load
      local.set 6
      block  ;; label = @2
        local.get 0
        i32.load8_s offset=74
        i32.const 0
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        local.get 6
        i32.const -33
        i32.and
        i32.store
      end
      local.get 6
      i32.const 32
      i32.and
      local.set 6
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load offset=48
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          local.get 1
          local.get 5
          i32.const 200
          i32.add
          local.get 5
          i32.const 80
          i32.add
          local.get 5
          i32.const 160
          i32.add
          local.get 3
          local.get 4
          call $printf_core
          local.set 1
          br 1 (;@2;)
        end
        local.get 0
        i32.const 80
        i32.store offset=48
        local.get 0
        local.get 5
        i32.const 80
        i32.add
        i32.store offset=16
        local.get 0
        local.get 5
        i32.store offset=28
        local.get 0
        local.get 5
        i32.store offset=20
        local.get 0
        i32.load offset=44
        local.set 7
        local.get 0
        local.get 5
        i32.store offset=44
        local.get 0
        local.get 1
        local.get 5
        i32.const 200
        i32.add
        local.get 5
        i32.const 80
        i32.add
        local.get 5
        i32.const 160
        i32.add
        local.get 3
        local.get 4
        call $printf_core
        local.set 1
        local.get 7
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 0
        i32.const 0
        local.get 0
        i32.load offset=36
        call_indirect (type 0)
        drop
        local.get 0
        i32.const 0
        i32.store offset=48
        local.get 0
        local.get 7
        i32.store offset=44
        local.get 0
        i32.const 0
        i32.store offset=28
        local.get 0
        i32.const 0
        i32.store offset=16
        local.get 0
        i32.load offset=20
        local.set 3
        local.get 0
        i32.const 0
        i32.store offset=20
        local.get 1
        i32.const -1
        local.get 3
        select
        local.set 1
      end
      local.get 0
      local.get 0
      i32.load
      local.tee 3
      local.get 6
      i32.or
      i32.store
      i32.const -1
      local.get 1
      local.get 3
      i32.const 32
      i32.and
      select
      local.set 1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      call $__unlockfile
    end
    local.get 5
    i32.const 208
    i32.add
    global.set 0
    local.get 1)
  (func $printf_core (type 15) (param i32 i32 i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64)
    global.get 0
    i32.const 80
    i32.sub
    local.tee 7
    global.set 0
    local.get 7
    local.get 1
    i32.store offset=76
    local.get 7
    i32.const 55
    i32.add
    local.set 8
    local.get 7
    i32.const 56
    i32.add
    local.set 9
    i32.const 0
    local.set 10
    i32.const 0
    local.set 11
    i32.const 0
    local.set 1
    loop (result i32)  ;; label = @1
      block  ;; label = @2
        local.get 11
        i32.const 0
        i32.lt_s
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 1
          i32.const 2147483647
          local.get 11
          i32.sub
          i32.le_s
          br_if 0 (;@3;)
          call $__errno_location
          i32.const 61
          i32.store
          i32.const -1
          local.set 11
          br 1 (;@2;)
        end
        local.get 1
        local.get 11
        i32.add
        local.set 11
      end
      local.get 7
      i32.load offset=76
      local.tee 12
      local.set 1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 12
                              i32.load8_u
                              local.tee 13
                              i32.eqz
                              br_if 0 (;@13;)
                              loop  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      local.get 13
                                      i32.const 255
                                      i32.and
                                      local.tee 13
                                      br_if 0 (;@17;)
                                      local.get 1
                                      local.set 13
                                      br 1 (;@16;)
                                    end
                                    local.get 13
                                    i32.const 37
                                    i32.ne
                                    br_if 1 (;@15;)
                                    local.get 1
                                    local.set 13
                                    loop  ;; label = @17
                                      local.get 1
                                      i32.load8_u offset=1
                                      i32.const 37
                                      i32.ne
                                      br_if 1 (;@16;)
                                      local.get 7
                                      local.get 1
                                      i32.const 2
                                      i32.add
                                      local.tee 14
                                      i32.store offset=76
                                      local.get 13
                                      i32.const 1
                                      i32.add
                                      local.set 13
                                      local.get 1
                                      i32.load8_u offset=2
                                      local.set 15
                                      local.get 14
                                      local.set 1
                                      local.get 15
                                      i32.const 37
                                      i32.eq
                                      br_if 0 (;@17;)
                                    end
                                  end
                                  local.get 13
                                  local.get 12
                                  i32.sub
                                  local.set 1
                                  block  ;; label = @16
                                    local.get 0
                                    i32.eqz
                                    br_if 0 (;@16;)
                                    local.get 0
                                    local.get 12
                                    local.get 1
                                    call $out
                                  end
                                  local.get 1
                                  br_if 14 (;@1;)
                                  local.get 7
                                  i32.load offset=76
                                  i32.load8_s offset=1
                                  call $isdigit
                                  local.set 1
                                  local.get 7
                                  i32.load offset=76
                                  local.set 13
                                  local.get 1
                                  i32.eqz
                                  br_if 3 (;@12;)
                                  local.get 13
                                  i32.load8_u offset=2
                                  i32.const 36
                                  i32.ne
                                  br_if 3 (;@12;)
                                  local.get 13
                                  i32.const 3
                                  i32.add
                                  local.set 1
                                  local.get 13
                                  i32.load8_s offset=1
                                  i32.const -48
                                  i32.add
                                  local.set 16
                                  i32.const 1
                                  local.set 10
                                  br 4 (;@11;)
                                end
                                local.get 7
                                local.get 1
                                i32.const 1
                                i32.add
                                local.tee 14
                                i32.store offset=76
                                local.get 1
                                i32.load8_u offset=1
                                local.set 13
                                local.get 14
                                local.set 1
                                br 0 (;@14;)
                              end
                              unreachable
                            end
                            local.get 11
                            local.set 17
                            local.get 0
                            br_if 8 (;@4;)
                            local.get 10
                            i32.eqz
                            br_if 2 (;@10;)
                            i32.const 1
                            local.set 1
                            block  ;; label = @13
                              loop  ;; label = @14
                                local.get 4
                                local.get 1
                                i32.const 2
                                i32.shl
                                i32.add
                                i32.load
                                local.tee 13
                                i32.eqz
                                br_if 1 (;@13;)
                                local.get 3
                                local.get 1
                                i32.const 3
                                i32.shl
                                i32.add
                                local.get 13
                                local.get 2
                                local.get 6
                                call $pop_arg
                                i32.const 1
                                local.set 17
                                local.get 1
                                i32.const 1
                                i32.add
                                local.tee 1
                                i32.const 10
                                i32.ne
                                br_if 0 (;@14;)
                                br 10 (;@4;)
                              end
                              unreachable
                            end
                            i32.const 1
                            local.set 17
                            local.get 1
                            i32.const 10
                            i32.ge_u
                            br_if 8 (;@4;)
                            loop  ;; label = @13
                              local.get 4
                              local.get 1
                              i32.const 2
                              i32.shl
                              i32.add
                              i32.load
                              br_if 8 (;@5;)
                              i32.const 1
                              local.set 17
                              local.get 1
                              i32.const 1
                              i32.add
                              local.tee 1
                              i32.const 10
                              i32.eq
                              br_if 9 (;@4;)
                              br 0 (;@13;)
                            end
                            unreachable
                          end
                          local.get 13
                          i32.const 1
                          i32.add
                          local.set 1
                          i32.const -1
                          local.set 16
                        end
                        local.get 7
                        local.get 1
                        i32.store offset=76
                        i32.const 0
                        local.set 18
                        block  ;; label = @11
                          local.get 1
                          i32.load8_s
                          local.tee 15
                          i32.const -32
                          i32.add
                          local.tee 13
                          i32.const 31
                          i32.gt_u
                          br_if 0 (;@11;)
                          i32.const 1
                          local.get 13
                          i32.shl
                          local.tee 13
                          i32.const 75913
                          i32.and
                          i32.eqz
                          br_if 0 (;@11;)
                          block  ;; label = @12
                            loop  ;; label = @13
                              local.get 7
                              local.get 1
                              i32.const 1
                              i32.add
                              local.tee 14
                              i32.store offset=76
                              local.get 1
                              i32.load8_s offset=1
                              local.tee 15
                              i32.const -32
                              i32.add
                              local.tee 1
                              i32.const 32
                              i32.ge_u
                              br_if 1 (;@12;)
                              i32.const 1
                              local.get 1
                              i32.shl
                              local.tee 1
                              i32.const 75913
                              i32.and
                              i32.eqz
                              br_if 1 (;@12;)
                              local.get 1
                              local.get 13
                              i32.or
                              local.set 13
                              local.get 14
                              local.set 1
                              br 0 (;@13;)
                            end
                            unreachable
                          end
                          local.get 14
                          local.set 1
                          local.get 13
                          local.set 18
                        end
                        block  ;; label = @11
                          block  ;; label = @12
                            local.get 15
                            i32.const 42
                            i32.ne
                            br_if 0 (;@12;)
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 1
                                i32.load8_s offset=1
                                call $isdigit
                                i32.eqz
                                br_if 0 (;@14;)
                                local.get 7
                                i32.load offset=76
                                local.tee 13
                                i32.load8_u offset=2
                                i32.const 36
                                i32.ne
                                br_if 0 (;@14;)
                                local.get 13
                                i32.load8_s offset=1
                                i32.const 2
                                i32.shl
                                local.get 4
                                i32.add
                                i32.const -192
                                i32.add
                                i32.const 10
                                i32.store
                                local.get 13
                                i32.const 3
                                i32.add
                                local.set 1
                                local.get 13
                                i32.load8_s offset=1
                                i32.const 3
                                i32.shl
                                local.get 3
                                i32.add
                                i32.const -384
                                i32.add
                                i32.load
                                local.set 19
                                i32.const 1
                                local.set 10
                                br 1 (;@13;)
                              end
                              local.get 10
                              br_if 8 (;@5;)
                              i32.const 0
                              local.set 10
                              i32.const 0
                              local.set 19
                              block  ;; label = @14
                                local.get 0
                                i32.eqz
                                br_if 0 (;@14;)
                                local.get 2
                                local.get 2
                                i32.load
                                local.tee 1
                                i32.const 4
                                i32.add
                                i32.store
                                local.get 1
                                i32.load
                                local.set 19
                              end
                              local.get 7
                              i32.load offset=76
                              i32.const 1
                              i32.add
                              local.set 1
                            end
                            local.get 7
                            local.get 1
                            i32.store offset=76
                            local.get 19
                            i32.const -1
                            i32.gt_s
                            br_if 1 (;@11;)
                            i32.const 0
                            local.get 19
                            i32.sub
                            local.set 19
                            local.get 18
                            i32.const 8192
                            i32.or
                            local.set 18
                            br 1 (;@11;)
                          end
                          local.get 7
                          i32.const 76
                          i32.add
                          call $getint
                          local.tee 19
                          i32.const 0
                          i32.lt_s
                          br_if 6 (;@5;)
                          local.get 7
                          i32.load offset=76
                          local.set 1
                        end
                        i32.const -1
                        local.set 20
                        block  ;; label = @11
                          local.get 1
                          i32.load8_u
                          i32.const 46
                          i32.ne
                          br_if 0 (;@11;)
                          block  ;; label = @12
                            local.get 1
                            i32.load8_u offset=1
                            i32.const 42
                            i32.ne
                            br_if 0 (;@12;)
                            block  ;; label = @13
                              local.get 1
                              i32.load8_s offset=2
                              call $isdigit
                              i32.eqz
                              br_if 0 (;@13;)
                              local.get 7
                              i32.load offset=76
                              local.tee 1
                              i32.load8_u offset=3
                              i32.const 36
                              i32.ne
                              br_if 0 (;@13;)
                              local.get 1
                              i32.load8_s offset=2
                              i32.const 2
                              i32.shl
                              local.get 4
                              i32.add
                              i32.const -192
                              i32.add
                              i32.const 10
                              i32.store
                              local.get 1
                              i32.load8_s offset=2
                              i32.const 3
                              i32.shl
                              local.get 3
                              i32.add
                              i32.const -384
                              i32.add
                              i32.load
                              local.set 20
                              local.get 7
                              local.get 1
                              i32.const 4
                              i32.add
                              local.tee 1
                              i32.store offset=76
                              br 2 (;@11;)
                            end
                            local.get 10
                            br_if 7 (;@5;)
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 0
                                br_if 0 (;@14;)
                                i32.const 0
                                local.set 20
                                br 1 (;@13;)
                              end
                              local.get 2
                              local.get 2
                              i32.load
                              local.tee 1
                              i32.const 4
                              i32.add
                              i32.store
                              local.get 1
                              i32.load
                              local.set 20
                            end
                            local.get 7
                            local.get 7
                            i32.load offset=76
                            i32.const 2
                            i32.add
                            local.tee 1
                            i32.store offset=76
                            br 1 (;@11;)
                          end
                          local.get 7
                          local.get 1
                          i32.const 1
                          i32.add
                          i32.store offset=76
                          local.get 7
                          i32.const 76
                          i32.add
                          call $getint
                          local.set 20
                          local.get 7
                          i32.load offset=76
                          local.set 1
                        end
                        i32.const 0
                        local.set 13
                        loop  ;; label = @11
                          local.get 13
                          local.set 14
                          i32.const -1
                          local.set 17
                          local.get 1
                          i32.load8_s
                          i32.const -65
                          i32.add
                          i32.const 57
                          i32.gt_u
                          br_if 7 (;@4;)
                          local.get 7
                          local.get 1
                          i32.const 1
                          i32.add
                          local.tee 15
                          i32.store offset=76
                          local.get 1
                          i32.load8_s
                          local.set 13
                          local.get 15
                          local.set 1
                          local.get 13
                          local.get 14
                          i32.const 58
                          i32.mul
                          i32.add
                          i32.const 1055
                          i32.add
                          i32.load8_u
                          local.tee 13
                          i32.const -1
                          i32.add
                          i32.const 8
                          i32.lt_u
                          br_if 0 (;@11;)
                        end
                        local.get 13
                        i32.const 19
                        i32.eq
                        br_if 2 (;@8;)
                        local.get 13
                        i32.eqz
                        br_if 6 (;@4;)
                        block  ;; label = @11
                          local.get 16
                          i32.const 0
                          i32.lt_s
                          br_if 0 (;@11;)
                          local.get 4
                          local.get 16
                          i32.const 2
                          i32.shl
                          i32.add
                          local.get 13
                          i32.store
                          local.get 7
                          local.get 3
                          local.get 16
                          i32.const 3
                          i32.shl
                          i32.add
                          i64.load
                          i64.store offset=64
                          br 4 (;@7;)
                        end
                        local.get 0
                        br_if 1 (;@9;)
                      end
                      i32.const 0
                      local.set 17
                      br 5 (;@4;)
                    end
                    local.get 7
                    i32.const 64
                    i32.add
                    local.get 13
                    local.get 2
                    local.get 6
                    call $pop_arg
                    local.get 7
                    i32.load offset=76
                    local.set 15
                    br 2 (;@6;)
                  end
                  i32.const -1
                  local.set 17
                  local.get 16
                  i32.const -1
                  i32.gt_s
                  br_if 3 (;@4;)
                end
                i32.const 0
                local.set 1
                local.get 0
                i32.eqz
                br_if 5 (;@1;)
              end
              local.get 18
              i32.const -65537
              i32.and
              local.tee 21
              local.get 18
              local.get 18
              i32.const 8192
              i32.and
              select
              local.set 13
              i32.const 0
              local.set 17
              i32.const 1044
              local.set 16
              local.get 9
              local.set 18
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              local.get 15
                                              i32.const -1
                                              i32.add
                                              i32.load8_s
                                              local.tee 1
                                              i32.const -33
                                              i32.and
                                              local.get 1
                                              local.get 1
                                              i32.const 15
                                              i32.and
                                              i32.const 3
                                              i32.eq
                                              select
                                              local.get 1
                                              local.get 14
                                              select
                                              local.tee 1
                                              i32.const -88
                                              i32.add
                                              br_table 4 (;@17;) 19 (;@2;) 19 (;@2;) 19 (;@2;) 19 (;@2;) 19 (;@2;) 19 (;@2;) 19 (;@2;) 19 (;@2;) 14 (;@7;) 19 (;@2;) 15 (;@6;) 6 (;@15;) 14 (;@7;) 14 (;@7;) 14 (;@7;) 19 (;@2;) 6 (;@15;) 19 (;@2;) 19 (;@2;) 19 (;@2;) 19 (;@2;) 2 (;@19;) 5 (;@16;) 3 (;@18;) 19 (;@2;) 19 (;@2;) 9 (;@12;) 19 (;@2;) 1 (;@20;) 19 (;@2;) 19 (;@2;) 4 (;@17;) 0 (;@21;)
                                            end
                                            local.get 9
                                            local.set 18
                                            block  ;; label = @21
                                              local.get 1
                                              i32.const -65
                                              i32.add
                                              br_table 14 (;@7;) 19 (;@2;) 11 (;@10;) 19 (;@2;) 14 (;@7;) 14 (;@7;) 14 (;@7;) 0 (;@21;)
                                            end
                                            local.get 1
                                            i32.const 83
                                            i32.eq
                                            br_if 9 (;@11;)
                                            br 17 (;@3;)
                                          end
                                          i32.const 0
                                          local.set 17
                                          i32.const 1044
                                          local.set 16
                                          local.get 7
                                          i64.load offset=64
                                          local.set 22
                                          br 5 (;@14;)
                                        end
                                        i32.const 0
                                        local.set 1
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              block  ;; label = @22
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      local.get 14
                                                      i32.const 255
                                                      i32.and
                                                      br_table 0 (;@25;) 1 (;@24;) 2 (;@23;) 3 (;@22;) 4 (;@21;) 24 (;@1;) 5 (;@20;) 6 (;@19;) 24 (;@1;)
                                                    end
                                                    local.get 7
                                                    i32.load offset=64
                                                    local.get 11
                                                    i32.store
                                                    br 23 (;@1;)
                                                  end
                                                  local.get 7
                                                  i32.load offset=64
                                                  local.get 11
                                                  i32.store
                                                  br 22 (;@1;)
                                                end
                                                local.get 7
                                                i32.load offset=64
                                                local.get 11
                                                i64.extend_i32_s
                                                i64.store
                                                br 21 (;@1;)
                                              end
                                              local.get 7
                                              i32.load offset=64
                                              local.get 11
                                              i32.store16
                                              br 20 (;@1;)
                                            end
                                            local.get 7
                                            i32.load offset=64
                                            local.get 11
                                            i32.store8
                                            br 19 (;@1;)
                                          end
                                          local.get 7
                                          i32.load offset=64
                                          local.get 11
                                          i32.store
                                          br 18 (;@1;)
                                        end
                                        local.get 7
                                        i32.load offset=64
                                        local.get 11
                                        i64.extend_i32_s
                                        i64.store
                                        br 17 (;@1;)
                                      end
                                      local.get 20
                                      i32.const 8
                                      local.get 20
                                      i32.const 8
                                      i32.gt_u
                                      select
                                      local.set 20
                                      local.get 13
                                      i32.const 8
                                      i32.or
                                      local.set 13
                                      i32.const 120
                                      local.set 1
                                    end
                                    local.get 7
                                    i64.load offset=64
                                    local.get 9
                                    local.get 1
                                    i32.const 32
                                    i32.and
                                    call $fmt_x
                                    local.set 12
                                    i32.const 0
                                    local.set 17
                                    i32.const 1044
                                    local.set 16
                                    local.get 7
                                    i64.load offset=64
                                    i64.eqz
                                    br_if 3 (;@13;)
                                    local.get 13
                                    i32.const 8
                                    i32.and
                                    i32.eqz
                                    br_if 3 (;@13;)
                                    local.get 1
                                    i32.const 4
                                    i32.shr_u
                                    i32.const 1044
                                    i32.add
                                    local.set 16
                                    i32.const 2
                                    local.set 17
                                    br 3 (;@13;)
                                  end
                                  i32.const 0
                                  local.set 17
                                  i32.const 1044
                                  local.set 16
                                  local.get 7
                                  i64.load offset=64
                                  local.get 9
                                  call $fmt_o
                                  local.set 12
                                  local.get 13
                                  i32.const 8
                                  i32.and
                                  i32.eqz
                                  br_if 2 (;@13;)
                                  local.get 20
                                  local.get 9
                                  local.get 12
                                  i32.sub
                                  local.tee 1
                                  i32.const 1
                                  i32.add
                                  local.get 20
                                  local.get 1
                                  i32.gt_s
                                  select
                                  local.set 20
                                  br 2 (;@13;)
                                end
                                block  ;; label = @15
                                  local.get 7
                                  i64.load offset=64
                                  local.tee 22
                                  i64.const -1
                                  i64.gt_s
                                  br_if 0 (;@15;)
                                  local.get 7
                                  i64.const 0
                                  local.get 22
                                  i64.sub
                                  local.tee 22
                                  i64.store offset=64
                                  i32.const 1
                                  local.set 17
                                  i32.const 1044
                                  local.set 16
                                  br 1 (;@14;)
                                end
                                block  ;; label = @15
                                  local.get 13
                                  i32.const 2048
                                  i32.and
                                  i32.eqz
                                  br_if 0 (;@15;)
                                  i32.const 1
                                  local.set 17
                                  i32.const 1045
                                  local.set 16
                                  br 1 (;@14;)
                                end
                                i32.const 1046
                                i32.const 1044
                                local.get 13
                                i32.const 1
                                i32.and
                                local.tee 17
                                select
                                local.set 16
                              end
                              local.get 22
                              local.get 9
                              call $fmt_u
                              local.set 12
                            end
                            local.get 13
                            i32.const -65537
                            i32.and
                            local.get 13
                            local.get 20
                            i32.const -1
                            i32.gt_s
                            select
                            local.set 13
                            block  ;; label = @13
                              local.get 7
                              i64.load offset=64
                              local.tee 22
                              i64.const 0
                              i64.ne
                              br_if 0 (;@13;)
                              local.get 20
                              br_if 0 (;@13;)
                              i32.const 0
                              local.set 20
                              local.get 9
                              local.set 12
                              br 10 (;@3;)
                            end
                            local.get 20
                            local.get 9
                            local.get 12
                            i32.sub
                            local.get 22
                            i64.eqz
                            i32.add
                            local.tee 1
                            local.get 20
                            local.get 1
                            i32.gt_s
                            select
                            local.set 20
                            br 9 (;@3;)
                          end
                          i32.const 0
                          local.set 17
                          local.get 7
                          i32.load offset=64
                          local.tee 1
                          i32.const 1091
                          local.get 1
                          select
                          local.tee 12
                          i32.const 0
                          local.get 20
                          call $memchr
                          local.tee 1
                          local.get 12
                          local.get 20
                          i32.add
                          local.get 1
                          select
                          local.set 18
                          local.get 21
                          local.set 13
                          local.get 1
                          local.get 12
                          i32.sub
                          local.get 20
                          local.get 1
                          select
                          local.set 20
                          br 9 (;@2;)
                        end
                        block  ;; label = @11
                          local.get 20
                          i32.eqz
                          br_if 0 (;@11;)
                          local.get 7
                          i32.load offset=64
                          local.set 14
                          br 2 (;@9;)
                        end
                        i32.const 0
                        local.set 1
                        local.get 0
                        i32.const 32
                        local.get 19
                        i32.const 0
                        local.get 13
                        call $pad
                        br 2 (;@8;)
                      end
                      local.get 7
                      i32.const 0
                      i32.store offset=12
                      local.get 7
                      local.get 7
                      i64.load offset=64
                      i64.store32 offset=8
                      local.get 7
                      local.get 7
                      i32.const 8
                      i32.add
                      i32.store offset=64
                      i32.const -1
                      local.set 20
                      local.get 7
                      i32.const 8
                      i32.add
                      local.set 14
                    end
                    i32.const 0
                    local.set 1
                    block  ;; label = @9
                      loop  ;; label = @10
                        local.get 14
                        i32.load
                        local.tee 15
                        i32.eqz
                        br_if 1 (;@9;)
                        block  ;; label = @11
                          local.get 7
                          i32.const 4
                          i32.add
                          local.get 15
                          call $wctomb
                          local.tee 15
                          i32.const 0
                          i32.lt_s
                          local.tee 12
                          br_if 0 (;@11;)
                          local.get 15
                          local.get 20
                          local.get 1
                          i32.sub
                          i32.gt_u
                          br_if 0 (;@11;)
                          local.get 14
                          i32.const 4
                          i32.add
                          local.set 14
                          local.get 20
                          local.get 15
                          local.get 1
                          i32.add
                          local.tee 1
                          i32.gt_u
                          br_if 1 (;@10;)
                          br 2 (;@9;)
                        end
                      end
                      i32.const -1
                      local.set 17
                      local.get 12
                      br_if 5 (;@4;)
                    end
                    local.get 0
                    i32.const 32
                    local.get 19
                    local.get 1
                    local.get 13
                    call $pad
                    block  ;; label = @9
                      local.get 1
                      br_if 0 (;@9;)
                      i32.const 0
                      local.set 1
                      br 1 (;@8;)
                    end
                    i32.const 0
                    local.set 14
                    local.get 7
                    i32.load offset=64
                    local.set 15
                    loop  ;; label = @9
                      local.get 15
                      i32.load
                      local.tee 12
                      i32.eqz
                      br_if 1 (;@8;)
                      local.get 7
                      i32.const 4
                      i32.add
                      local.get 12
                      call $wctomb
                      local.tee 12
                      local.get 14
                      i32.add
                      local.tee 14
                      local.get 1
                      i32.gt_s
                      br_if 1 (;@8;)
                      local.get 0
                      local.get 7
                      i32.const 4
                      i32.add
                      local.get 12
                      call $out
                      local.get 15
                      i32.const 4
                      i32.add
                      local.set 15
                      local.get 14
                      local.get 1
                      i32.lt_u
                      br_if 0 (;@9;)
                    end
                  end
                  local.get 0
                  i32.const 32
                  local.get 19
                  local.get 1
                  local.get 13
                  i32.const 8192
                  i32.xor
                  call $pad
                  local.get 19
                  local.get 1
                  local.get 19
                  local.get 1
                  i32.gt_s
                  select
                  local.set 1
                  br 6 (;@1;)
                end
                local.get 0
                local.get 7
                f64.load offset=64
                local.get 19
                local.get 20
                local.get 13
                local.get 1
                local.get 5
                call_indirect (type 10)
                local.set 1
                br 5 (;@1;)
              end
              local.get 7
              local.get 7
              i64.load offset=64
              i64.store8 offset=55
              i32.const 1
              local.set 20
              local.get 8
              local.set 12
              local.get 9
              local.set 18
              local.get 21
              local.set 13
              br 3 (;@2;)
            end
            i32.const -1
            local.set 17
          end
          local.get 7
          i32.const 80
          i32.add
          global.set 0
          local.get 17
          return
        end
        local.get 9
        local.set 18
      end
      local.get 0
      i32.const 32
      local.get 17
      local.get 18
      local.get 12
      i32.sub
      local.tee 15
      local.get 20
      local.get 20
      local.get 15
      i32.lt_s
      select
      local.tee 20
      i32.add
      local.tee 14
      local.get 19
      local.get 19
      local.get 14
      i32.lt_s
      select
      local.tee 1
      local.get 14
      local.get 13
      call $pad
      local.get 0
      local.get 16
      local.get 17
      call $out
      local.get 0
      i32.const 48
      local.get 1
      local.get 14
      local.get 13
      i32.const 65536
      i32.xor
      call $pad
      local.get 0
      i32.const 48
      local.get 20
      local.get 15
      i32.const 0
      call $pad
      local.get 0
      local.get 12
      local.get 15
      call $out
      local.get 0
      i32.const 32
      local.get 1
      local.get 14
      local.get 13
      i32.const 8192
      i32.xor
      call $pad
      br 0 (;@1;)
    end)
  (func $out (type 16) (param i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load8_u
      i32.const 32
      i32.and
      br_if 0 (;@1;)
      local.get 1
      local.get 2
      local.get 0
      call $__fwritex
      drop
    end)
  (func $pop_arg (type 17) (param i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const 20
      i32.gt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 1
                          i32.const -9
                          i32.add
                          br_table 0 (;@11;) 1 (;@10;) 2 (;@9;) 3 (;@8;) 4 (;@7;) 5 (;@6;) 6 (;@5;) 7 (;@4;) 8 (;@3;) 9 (;@2;) 10 (;@1;)
                        end
                        local.get 2
                        local.get 2
                        i32.load
                        local.tee 1
                        i32.const 4
                        i32.add
                        i32.store
                        local.get 0
                        local.get 1
                        i32.load
                        i32.store
                        return
                      end
                      local.get 2
                      local.get 2
                      i32.load
                      local.tee 1
                      i32.const 4
                      i32.add
                      i32.store
                      local.get 0
                      local.get 1
                      i64.load32_s
                      i64.store
                      return
                    end
                    local.get 2
                    local.get 2
                    i32.load
                    local.tee 1
                    i32.const 4
                    i32.add
                    i32.store
                    local.get 0
                    local.get 1
                    i64.load32_u
                    i64.store
                    return
                  end
                  local.get 2
                  local.get 2
                  i32.load
                  i32.const 7
                  i32.add
                  i32.const -8
                  i32.and
                  local.tee 1
                  i32.const 8
                  i32.add
                  i32.store
                  local.get 0
                  local.get 1
                  i64.load
                  i64.store
                  return
                end
                local.get 2
                local.get 2
                i32.load
                local.tee 1
                i32.const 4
                i32.add
                i32.store
                local.get 0
                local.get 1
                i64.load16_s
                i64.store
                return
              end
              local.get 2
              local.get 2
              i32.load
              local.tee 1
              i32.const 4
              i32.add
              i32.store
              local.get 0
              local.get 1
              i64.load16_u
              i64.store
              return
            end
            local.get 2
            local.get 2
            i32.load
            local.tee 1
            i32.const 4
            i32.add
            i32.store
            local.get 0
            local.get 1
            i64.load8_s
            i64.store
            return
          end
          local.get 2
          local.get 2
          i32.load
          local.tee 1
          i32.const 4
          i32.add
          i32.store
          local.get 0
          local.get 1
          i64.load8_u
          i64.store
          return
        end
        local.get 2
        local.get 2
        i32.load
        i32.const 7
        i32.add
        i32.const -8
        i32.and
        local.tee 1
        i32.const 8
        i32.add
        i32.store
        local.get 0
        local.get 1
        f64.load
        f64.store
        return
      end
      local.get 0
      local.get 2
      local.get 3
      call_indirect (type 5)
    end)
  (func $getint (type 1) (param i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load
        i32.load8_s
        call $isdigit
        br_if 0 (;@2;)
        i32.const 0
        local.set 1
        br 1 (;@1;)
      end
      i32.const 0
      local.set 1
      loop  ;; label = @2
        local.get 0
        i32.load
        local.tee 2
        i32.load8_s
        local.set 3
        local.get 0
        local.get 2
        i32.const 1
        i32.add
        i32.store
        local.get 1
        local.get 3
        i32.add
        i32.const -48
        i32.add
        local.set 1
        local.get 2
        i32.load8_s offset=1
        call $isdigit
        i32.eqz
        br_if 1 (;@1;)
        local.get 1
        i32.const 10
        i32.mul
        local.set 1
        br 0 (;@2;)
      end
      unreachable
    end
    local.get 1)
  (func $fmt_x (type 18) (param i64 i32 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i64.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 0
        i32.wrap_i64
        i32.const 15
        i32.and
        i32.const 1584
        i32.add
        i32.load8_u
        local.get 2
        i32.or
        i32.store8
        local.get 0
        i64.const 15
        i64.gt_u
        local.set 3
        local.get 0
        i64.const 4
        i64.shr_u
        local.set 0
        local.get 3
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $fmt_o (type 11) (param i64 i32) (result i32)
    (local i32)
    block  ;; label = @1
      local.get 0
      i64.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 0
        i32.wrap_i64
        i32.const 7
        i32.and
        i32.const 48
        i32.or
        i32.store8
        local.get 0
        i64.const 7
        i64.gt_u
        local.set 2
        local.get 0
        i64.const 3
        i64.shr_u
        local.set 0
        local.get 2
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $fmt_u (type 11) (param i64 i32) (result i32)
    (local i64 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.const 4294967296
        i64.ge_u
        br_if 0 (;@2;)
        local.get 0
        local.set 2
        br 1 (;@1;)
      end
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 0
        local.get 0
        i64.const 10
        i64.div_u
        local.tee 2
        i64.const 10
        i64.mul
        i64.sub
        i32.wrap_i64
        i32.const 48
        i32.or
        i32.store8
        local.get 0
        i64.const 42949672959
        i64.gt_u
        local.set 3
        local.get 2
        local.set 0
        local.get 3
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      i32.wrap_i64
      local.tee 3
      i32.eqz
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        local.get 3
        local.get 3
        i32.const 10
        i32.div_u
        local.tee 4
        i32.const 10
        i32.mul
        i32.sub
        i32.const 48
        i32.or
        i32.store8
        local.get 3
        i32.const 9
        i32.gt_u
        local.set 5
        local.get 4
        local.set 3
        local.get 5
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $pad (type 19) (param i32 i32 i32 i32 i32)
    (local i32)
    global.get 0
    i32.const 256
    i32.sub
    local.tee 5
    global.set 0
    block  ;; label = @1
      local.get 4
      i32.const 73728
      i32.and
      br_if 0 (;@1;)
      local.get 2
      local.get 3
      i32.le_s
      br_if 0 (;@1;)
      local.get 5
      local.get 1
      i32.const 255
      i32.and
      local.get 2
      local.get 3
      i32.sub
      local.tee 2
      i32.const 256
      local.get 2
      i32.const 256
      i32.lt_u
      local.tee 3
      select
      call $memset
      drop
      block  ;; label = @2
        local.get 3
        br_if 0 (;@2;)
        loop  ;; label = @3
          local.get 0
          local.get 5
          i32.const 256
          call $out
          local.get 2
          i32.const -256
          i32.add
          local.tee 2
          i32.const 255
          i32.gt_u
          br_if 0 (;@3;)
        end
      end
      local.get 0
      local.get 5
      local.get 2
      call $out
    end
    local.get 5
    i32.const 256
    i32.add
    global.set 0)
  (func $vfprintf (type 0) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    i32.const 4
    i32.const 5
    call $__vfprintf_internal)
  (func $fmt_fp (type 10) (param i32 f64 i32 i32 i32 i32) (result i32)
    (local i32 i32 i64 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i32 i32 i32 i32 i32 f64)
    global.get 0
    i32.const 560
    i32.sub
    local.tee 6
    global.set 0
    i32.const 0
    local.set 7
    local.get 6
    i32.const 0
    i32.store offset=44
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        call $__DOUBLE_BITS
        local.tee 8
        i64.const -1
        i64.gt_s
        br_if 0 (;@2;)
        i32.const 1
        local.set 9
        i32.const 1054
        local.set 10
        local.get 1
        f64.neg
        local.tee 1
        call $__DOUBLE_BITS
        local.set 8
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 4
        i32.const 2048
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        i32.const 1
        local.set 9
        i32.const 1057
        local.set 10
        br 1 (;@1;)
      end
      i32.const 1060
      i32.const 1055
      local.get 4
      i32.const 1
      i32.and
      local.tee 9
      select
      local.set 10
      local.get 9
      i32.eqz
      local.set 7
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 8
        i64.const 9218868437227405312
        i64.and
        i64.const 9218868437227405312
        i64.ne
        br_if 0 (;@2;)
        local.get 0
        i32.const 32
        local.get 2
        local.get 9
        i32.const 3
        i32.add
        local.tee 11
        local.get 4
        i32.const -65537
        i32.and
        call $pad
        local.get 0
        local.get 10
        local.get 9
        call $out
        local.get 0
        i32.const 1073
        i32.const 1081
        local.get 5
        i32.const 32
        i32.and
        local.tee 12
        select
        i32.const 1077
        i32.const 1085
        local.get 12
        select
        local.get 1
        local.get 1
        f64.ne
        select
        i32.const 3
        call $out
        local.get 0
        i32.const 32
        local.get 2
        local.get 11
        local.get 4
        i32.const 8192
        i32.xor
        call $pad
        br 1 (;@1;)
      end
      local.get 6
      i32.const 16
      i32.add
      local.set 13
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              local.get 6
              i32.const 44
              i32.add
              call $frexp
              local.tee 1
              local.get 1
              f64.add
              local.tee 1
              f64.const 0x0p+0 (;=0;)
              f64.eq
              br_if 0 (;@5;)
              local.get 6
              local.get 6
              i32.load offset=44
              local.tee 12
              i32.const -1
              i32.add
              i32.store offset=44
              local.get 5
              i32.const 32
              i32.or
              local.tee 14
              i32.const 97
              i32.ne
              br_if 1 (;@4;)
              br 3 (;@2;)
            end
            local.get 5
            i32.const 32
            i32.or
            local.tee 14
            i32.const 97
            i32.eq
            br_if 2 (;@2;)
            i32.const 6
            local.get 3
            local.get 3
            i32.const 0
            i32.lt_s
            select
            local.set 15
            local.get 6
            i32.load offset=44
            local.set 16
            br 1 (;@3;)
          end
          local.get 6
          local.get 12
          i32.const -29
          i32.add
          local.tee 16
          i32.store offset=44
          i32.const 6
          local.get 3
          local.get 3
          i32.const 0
          i32.lt_s
          select
          local.set 15
          local.get 1
          f64.const 0x1p+28 (;=2.68435e+08;)
          f64.mul
          local.set 1
        end
        local.get 6
        i32.const 48
        i32.add
        local.get 6
        i32.const 336
        i32.add
        local.get 16
        i32.const 0
        i32.lt_s
        select
        local.tee 17
        local.set 18
        loop  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              f64.const 0x1p+32 (;=4.29497e+09;)
              f64.lt
              local.get 1
              f64.const 0x0p+0 (;=0;)
              f64.ge
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              local.get 1
              i32.trunc_f64_u
              local.set 12
              br 1 (;@4;)
            end
            i32.const 0
            local.set 12
          end
          local.get 18
          local.get 12
          i32.store
          local.get 18
          i32.const 4
          i32.add
          local.set 18
          local.get 1
          local.get 12
          f64.convert_i32_u
          f64.sub
          f64.const 0x1.dcd65p+29 (;=1e+09;)
          f64.mul
          local.tee 1
          f64.const 0x0p+0 (;=0;)
          f64.ne
          br_if 0 (;@3;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 16
            i32.const 1
            i32.ge_s
            br_if 0 (;@4;)
            local.get 16
            local.set 3
            local.get 18
            local.set 12
            local.get 17
            local.set 19
            br 1 (;@3;)
          end
          local.get 17
          local.set 19
          local.get 16
          local.set 3
          loop  ;; label = @4
            local.get 3
            i32.const 29
            local.get 3
            i32.const 29
            i32.lt_s
            select
            local.set 3
            block  ;; label = @5
              local.get 18
              i32.const -4
              i32.add
              local.tee 12
              local.get 19
              i32.lt_u
              br_if 0 (;@5;)
              local.get 3
              i64.extend_i32_u
              local.set 20
              i64.const 0
              local.set 8
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 12
                  local.get 12
                  i64.load32_u
                  local.get 20
                  i64.shl
                  local.get 8
                  i64.add
                  local.tee 8
                  local.get 8
                  i64.const 1000000000
                  i64.div_u
                  local.tee 8
                  i64.const 1000000000
                  i64.mul
                  i64.sub
                  i64.store32
                  local.get 12
                  i32.const -4
                  i32.add
                  local.tee 12
                  local.get 19
                  i32.lt_u
                  br_if 1 (;@6;)
                  local.get 8
                  i64.const 4294967295
                  i64.and
                  local.set 8
                  br 0 (;@7;)
                end
                unreachable
              end
              local.get 8
              i32.wrap_i64
              local.tee 12
              i32.eqz
              br_if 0 (;@5;)
              local.get 19
              i32.const -4
              i32.add
              local.tee 19
              local.get 12
              i32.store
            end
            block  ;; label = @5
              loop  ;; label = @6
                local.get 18
                local.tee 12
                local.get 19
                i32.le_u
                br_if 1 (;@5;)
                local.get 12
                i32.const -4
                i32.add
                local.tee 18
                i32.load
                i32.eqz
                br_if 0 (;@6;)
              end
            end
            local.get 6
            local.get 6
            i32.load offset=44
            local.get 3
            i32.sub
            local.tee 3
            i32.store offset=44
            local.get 12
            local.set 18
            local.get 3
            i32.const 0
            i32.gt_s
            br_if 0 (;@4;)
          end
        end
        local.get 15
        i32.const 25
        i32.add
        i32.const 9
        i32.div_s
        local.set 18
        block  ;; label = @3
          local.get 3
          i32.const -1
          i32.gt_s
          br_if 0 (;@3;)
          local.get 18
          i32.const 1
          i32.add
          local.set 21
          local.get 14
          i32.const 102
          i32.eq
          local.set 22
          loop  ;; label = @4
            i32.const 9
            i32.const 0
            local.get 3
            i32.sub
            local.get 3
            i32.const -9
            i32.lt_s
            select
            local.set 11
            block  ;; label = @5
              block  ;; label = @6
                local.get 19
                local.get 12
                i32.ge_u
                br_if 0 (;@6;)
                i32.const 1000000000
                local.get 11
                i32.shr_u
                local.set 23
                i32.const -1
                local.get 11
                i32.shl
                i32.const -1
                i32.xor
                local.set 24
                i32.const 0
                local.set 3
                local.get 19
                local.set 18
                loop  ;; label = @7
                  local.get 18
                  local.get 18
                  i32.load
                  local.tee 25
                  local.get 11
                  i32.shr_u
                  local.get 3
                  i32.add
                  i32.store
                  local.get 25
                  local.get 24
                  i32.and
                  local.get 23
                  i32.mul
                  local.set 3
                  local.get 18
                  i32.const 4
                  i32.add
                  local.tee 18
                  local.get 12
                  i32.lt_u
                  br_if 0 (;@7;)
                end
                local.get 19
                local.get 19
                i32.const 4
                i32.add
                local.get 19
                i32.load
                select
                local.set 19
                local.get 3
                i32.eqz
                br_if 1 (;@5;)
                local.get 12
                local.get 3
                i32.store
                local.get 12
                i32.const 4
                i32.add
                local.set 12
                br 1 (;@5;)
              end
              local.get 19
              local.get 19
              i32.const 4
              i32.add
              local.get 19
              i32.load
              select
              local.set 19
            end
            local.get 6
            local.get 6
            i32.load offset=44
            local.get 11
            i32.add
            local.tee 3
            i32.store offset=44
            local.get 17
            local.get 19
            local.get 22
            select
            local.tee 18
            local.get 21
            i32.const 2
            i32.shl
            i32.add
            local.get 12
            local.get 12
            local.get 18
            i32.sub
            i32.const 2
            i32.shr_s
            local.get 21
            i32.gt_s
            select
            local.set 12
            local.get 3
            i32.const 0
            i32.lt_s
            br_if 0 (;@4;)
          end
        end
        i32.const 0
        local.set 18
        block  ;; label = @3
          local.get 19
          local.get 12
          i32.ge_u
          br_if 0 (;@3;)
          local.get 17
          local.get 19
          i32.sub
          i32.const 2
          i32.shr_s
          i32.const 9
          i32.mul
          local.set 18
          local.get 19
          i32.load
          local.tee 25
          i32.const 10
          i32.lt_u
          br_if 0 (;@3;)
          i32.const 100
          local.set 3
          loop  ;; label = @4
            local.get 18
            i32.const 1
            i32.add
            local.set 18
            local.get 25
            local.get 3
            i32.lt_u
            br_if 1 (;@3;)
            local.get 3
            i32.const 10
            i32.mul
            local.set 3
            br 0 (;@4;)
          end
          unreachable
        end
        block  ;; label = @3
          local.get 15
          i32.const 0
          local.get 18
          local.get 14
          i32.const 102
          i32.eq
          select
          i32.sub
          local.get 14
          i32.const 103
          i32.eq
          local.get 15
          i32.const 0
          i32.ne
          i32.and
          i32.sub
          local.tee 3
          local.get 12
          local.get 17
          i32.sub
          i32.const 2
          i32.shr_s
          i32.const 9
          i32.mul
          i32.const -9
          i32.add
          i32.ge_s
          br_if 0 (;@3;)
          local.get 3
          i32.const 9216
          i32.add
          local.tee 25
          i32.const 9
          i32.div_s
          local.tee 23
          i32.const 2
          i32.shl
          local.get 6
          i32.const 48
          i32.add
          i32.const 4
          i32.or
          local.get 6
          i32.const 340
          i32.add
          local.get 16
          i32.const 0
          i32.lt_s
          select
          i32.add
          i32.const -4096
          i32.add
          local.set 11
          i32.const 10
          local.set 3
          block  ;; label = @4
            local.get 25
            local.get 23
            i32.const 9
            i32.mul
            i32.sub
            local.tee 25
            i32.const 7
            i32.gt_s
            br_if 0 (;@4;)
            i32.const 100
            local.set 3
            loop  ;; label = @5
              local.get 25
              i32.const 1
              i32.add
              local.tee 25
              i32.const 8
              i32.eq
              br_if 1 (;@4;)
              local.get 3
              i32.const 10
              i32.mul
              local.set 3
              br 0 (;@5;)
            end
            unreachable
          end
          local.get 11
          i32.const 4
          i32.add
          local.set 24
          block  ;; label = @4
            block  ;; label = @5
              local.get 11
              i32.load
              local.tee 25
              local.get 25
              local.get 3
              i32.div_u
              local.tee 21
              local.get 3
              i32.mul
              i32.sub
              local.tee 23
              br_if 0 (;@5;)
              local.get 24
              local.get 12
              i32.eq
              br_if 1 (;@4;)
            end
            f64.const 0x1p-1 (;=0.5;)
            f64.const 0x1p+0 (;=1;)
            f64.const 0x1.8p+0 (;=1.5;)
            local.get 24
            local.get 12
            i32.eq
            select
            f64.const 0x1.8p+0 (;=1.5;)
            local.get 23
            local.get 3
            i32.const 1
            i32.shr_u
            local.tee 24
            i32.eq
            select
            local.get 23
            local.get 24
            i32.lt_u
            select
            local.set 26
            f64.const 0x1.0000000000001p+53 (;=9.0072e+15;)
            f64.const 0x1p+53 (;=9.0072e+15;)
            local.get 21
            i32.const 1
            i32.and
            select
            local.set 1
            block  ;; label = @5
              local.get 7
              br_if 0 (;@5;)
              local.get 10
              i32.load8_u
              i32.const 45
              i32.ne
              br_if 0 (;@5;)
              local.get 26
              f64.neg
              local.set 26
              local.get 1
              f64.neg
              local.set 1
            end
            local.get 11
            local.get 25
            local.get 23
            i32.sub
            local.tee 25
            i32.store
            local.get 1
            local.get 26
            f64.add
            local.get 1
            f64.eq
            br_if 0 (;@4;)
            local.get 11
            local.get 25
            local.get 3
            i32.add
            local.tee 18
            i32.store
            block  ;; label = @5
              local.get 18
              i32.const 1000000000
              i32.lt_u
              br_if 0 (;@5;)
              loop  ;; label = @6
                local.get 11
                i32.const 0
                i32.store
                block  ;; label = @7
                  local.get 11
                  i32.const -4
                  i32.add
                  local.tee 11
                  local.get 19
                  i32.ge_u
                  br_if 0 (;@7;)
                  local.get 19
                  i32.const -4
                  i32.add
                  local.tee 19
                  i32.const 0
                  i32.store
                end
                local.get 11
                local.get 11
                i32.load
                i32.const 1
                i32.add
                local.tee 18
                i32.store
                local.get 18
                i32.const 999999999
                i32.gt_u
                br_if 0 (;@6;)
              end
            end
            local.get 17
            local.get 19
            i32.sub
            i32.const 2
            i32.shr_s
            i32.const 9
            i32.mul
            local.set 18
            local.get 19
            i32.load
            local.tee 25
            i32.const 10
            i32.lt_u
            br_if 0 (;@4;)
            i32.const 100
            local.set 3
            loop  ;; label = @5
              local.get 18
              i32.const 1
              i32.add
              local.set 18
              local.get 25
              local.get 3
              i32.lt_u
              br_if 1 (;@4;)
              local.get 3
              i32.const 10
              i32.mul
              local.set 3
              br 0 (;@5;)
            end
            unreachable
          end
          local.get 11
          i32.const 4
          i32.add
          local.tee 3
          local.get 12
          local.get 12
          local.get 3
          i32.gt_u
          select
          local.set 12
        end
        block  ;; label = @3
          loop  ;; label = @4
            local.get 12
            local.tee 3
            local.get 19
            i32.le_u
            local.tee 25
            br_if 1 (;@3;)
            local.get 3
            i32.const -4
            i32.add
            local.tee 12
            i32.load
            i32.eqz
            br_if 0 (;@4;)
          end
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 14
            i32.const 103
            i32.eq
            br_if 0 (;@4;)
            local.get 4
            i32.const 8
            i32.and
            local.set 24
            br 1 (;@3;)
          end
          local.get 18
          i32.const -1
          i32.xor
          i32.const -1
          local.get 15
          i32.const 1
          local.get 15
          select
          local.tee 12
          local.get 18
          i32.gt_s
          local.get 18
          i32.const -5
          i32.gt_s
          i32.and
          local.tee 11
          select
          local.get 12
          i32.add
          local.set 15
          i32.const -1
          i32.const -2
          local.get 11
          select
          local.get 5
          i32.add
          local.set 5
          local.get 4
          i32.const 8
          i32.and
          local.tee 24
          br_if 0 (;@3;)
          i32.const -9
          local.set 12
          block  ;; label = @4
            local.get 25
            br_if 0 (;@4;)
            local.get 3
            i32.const -4
            i32.add
            i32.load
            local.tee 11
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            local.set 12
            local.get 11
            i32.const 10
            i32.rem_u
            br_if 0 (;@4;)
            i32.const 0
            local.set 25
            i32.const 100
            local.set 12
            block  ;; label = @5
              loop  ;; label = @6
                local.get 11
                local.get 12
                i32.rem_u
                br_if 1 (;@5;)
                local.get 25
                i32.const 1
                i32.add
                local.set 25
                local.get 12
                i32.const 10
                i32.mul
                local.set 12
                br 0 (;@6;)
              end
              unreachable
            end
            local.get 25
            i32.const -1
            i32.xor
            local.set 12
          end
          local.get 3
          local.get 17
          i32.sub
          i32.const 2
          i32.shr_s
          i32.const 9
          i32.mul
          local.set 25
          block  ;; label = @4
            local.get 5
            i32.const -33
            i32.and
            i32.const 70
            i32.ne
            br_if 0 (;@4;)
            i32.const 0
            local.set 24
            local.get 15
            local.get 25
            local.get 12
            i32.add
            i32.const -9
            i32.add
            local.tee 12
            i32.const 0
            local.get 12
            i32.const 0
            i32.gt_s
            select
            local.tee 12
            local.get 15
            local.get 12
            i32.lt_s
            select
            local.set 15
            br 1 (;@3;)
          end
          i32.const 0
          local.set 24
          local.get 15
          local.get 18
          local.get 25
          i32.add
          local.get 12
          i32.add
          i32.const -9
          i32.add
          local.tee 12
          i32.const 0
          local.get 12
          i32.const 0
          i32.gt_s
          select
          local.tee 12
          local.get 15
          local.get 12
          i32.lt_s
          select
          local.set 15
        end
        local.get 15
        local.get 24
        i32.or
        i32.const 0
        i32.ne
        local.set 21
        block  ;; label = @3
          block  ;; label = @4
            local.get 5
            i32.const -33
            i32.and
            local.tee 25
            i32.const 70
            i32.ne
            br_if 0 (;@4;)
            local.get 18
            i32.const 0
            local.get 18
            i32.const 0
            i32.gt_s
            select
            local.set 12
            br 1 (;@3;)
          end
          block  ;; label = @4
            local.get 13
            local.get 18
            local.get 18
            i32.const 31
            i32.shr_s
            local.tee 12
            i32.add
            local.get 12
            i32.xor
            i64.extend_i32_u
            local.get 13
            call $fmt_u
            local.tee 12
            i32.sub
            i32.const 1
            i32.gt_s
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 12
              i32.const -1
              i32.add
              local.tee 12
              i32.const 48
              i32.store8
              local.get 13
              local.get 12
              i32.sub
              i32.const 2
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          local.get 12
          i32.const -2
          i32.add
          local.tee 22
          local.get 5
          i32.store8
          local.get 12
          i32.const -1
          i32.add
          i32.const 45
          i32.const 43
          local.get 18
          i32.const 0
          i32.lt_s
          select
          i32.store8
          local.get 13
          local.get 22
          i32.sub
          local.set 12
        end
        local.get 0
        i32.const 32
        local.get 2
        local.get 9
        local.get 15
        i32.add
        local.get 21
        i32.add
        local.get 12
        i32.add
        i32.const 1
        i32.add
        local.tee 11
        local.get 4
        call $pad
        local.get 0
        local.get 10
        local.get 9
        call $out
        local.get 0
        i32.const 48
        local.get 2
        local.get 11
        local.get 4
        i32.const 65536
        i32.xor
        call $pad
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 25
                i32.const 70
                i32.ne
                br_if 0 (;@6;)
                local.get 6
                i32.const 16
                i32.add
                i32.const 8
                i32.or
                local.set 23
                local.get 6
                i32.const 16
                i32.add
                i32.const 9
                i32.or
                local.set 18
                local.get 17
                local.get 19
                local.get 19
                local.get 17
                i32.gt_u
                select
                local.tee 25
                local.set 19
                loop  ;; label = @7
                  local.get 19
                  i64.load32_u
                  local.get 18
                  call $fmt_u
                  local.set 12
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 19
                      local.get 25
                      i32.eq
                      br_if 0 (;@9;)
                      local.get 12
                      local.get 6
                      i32.const 16
                      i32.add
                      i32.le_u
                      br_if 1 (;@8;)
                      loop  ;; label = @10
                        local.get 12
                        i32.const -1
                        i32.add
                        local.tee 12
                        i32.const 48
                        i32.store8
                        local.get 12
                        local.get 6
                        i32.const 16
                        i32.add
                        i32.gt_u
                        br_if 0 (;@10;)
                        br 2 (;@8;)
                      end
                      unreachable
                    end
                    local.get 12
                    local.get 18
                    i32.ne
                    br_if 0 (;@8;)
                    local.get 6
                    i32.const 48
                    i32.store8 offset=24
                    local.get 23
                    local.set 12
                  end
                  local.get 0
                  local.get 12
                  local.get 18
                  local.get 12
                  i32.sub
                  call $out
                  local.get 19
                  i32.const 4
                  i32.add
                  local.tee 19
                  local.get 17
                  i32.le_u
                  br_if 0 (;@7;)
                end
                i32.const 0
                local.set 12
                local.get 21
                i32.eqz
                br_if 2 (;@4;)
                local.get 0
                i32.const 1089
                i32.const 1
                call $out
                local.get 19
                local.get 3
                i32.ge_u
                br_if 1 (;@5;)
                local.get 15
                i32.const 1
                i32.lt_s
                br_if 1 (;@5;)
                loop  ;; label = @7
                  block  ;; label = @8
                    local.get 19
                    i64.load32_u
                    local.get 18
                    call $fmt_u
                    local.tee 12
                    local.get 6
                    i32.const 16
                    i32.add
                    i32.le_u
                    br_if 0 (;@8;)
                    loop  ;; label = @9
                      local.get 12
                      i32.const -1
                      i32.add
                      local.tee 12
                      i32.const 48
                      i32.store8
                      local.get 12
                      local.get 6
                      i32.const 16
                      i32.add
                      i32.gt_u
                      br_if 0 (;@9;)
                    end
                  end
                  local.get 0
                  local.get 12
                  local.get 15
                  i32.const 9
                  local.get 15
                  i32.const 9
                  i32.lt_s
                  select
                  call $out
                  local.get 15
                  i32.const -9
                  i32.add
                  local.set 12
                  local.get 19
                  i32.const 4
                  i32.add
                  local.tee 19
                  local.get 3
                  i32.ge_u
                  br_if 3 (;@4;)
                  local.get 15
                  i32.const 9
                  i32.gt_s
                  local.set 25
                  local.get 12
                  local.set 15
                  local.get 25
                  br_if 0 (;@7;)
                  br 3 (;@4;)
                end
                unreachable
              end
              block  ;; label = @6
                local.get 15
                i32.const 0
                i32.lt_s
                br_if 0 (;@6;)
                local.get 3
                local.get 19
                i32.const 4
                i32.add
                local.get 3
                local.get 19
                i32.gt_u
                select
                local.set 23
                local.get 6
                i32.const 16
                i32.add
                i32.const 9
                i32.or
                local.set 3
                local.get 6
                i32.const 16
                i32.add
                i32.const 8
                i32.or
                local.set 17
                local.get 19
                local.set 18
                loop  ;; label = @7
                  block  ;; label = @8
                    local.get 18
                    i64.load32_u
                    local.get 3
                    call $fmt_u
                    local.tee 12
                    local.get 3
                    i32.ne
                    br_if 0 (;@8;)
                    local.get 6
                    i32.const 48
                    i32.store8 offset=24
                    local.get 17
                    local.set 12
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 18
                      local.get 19
                      i32.eq
                      br_if 0 (;@9;)
                      local.get 12
                      local.get 6
                      i32.const 16
                      i32.add
                      i32.le_u
                      br_if 1 (;@8;)
                      loop  ;; label = @10
                        local.get 12
                        i32.const -1
                        i32.add
                        local.tee 12
                        i32.const 48
                        i32.store8
                        local.get 12
                        local.get 6
                        i32.const 16
                        i32.add
                        i32.gt_u
                        br_if 0 (;@10;)
                        br 2 (;@8;)
                      end
                      unreachable
                    end
                    local.get 0
                    local.get 12
                    i32.const 1
                    call $out
                    local.get 12
                    i32.const 1
                    i32.add
                    local.set 12
                    block  ;; label = @9
                      local.get 15
                      i32.const 0
                      i32.gt_s
                      br_if 0 (;@9;)
                      local.get 24
                      i32.eqz
                      br_if 1 (;@8;)
                    end
                    local.get 0
                    i32.const 1089
                    i32.const 1
                    call $out
                  end
                  local.get 0
                  local.get 12
                  local.get 3
                  local.get 12
                  i32.sub
                  local.tee 25
                  local.get 15
                  local.get 15
                  local.get 25
                  i32.gt_s
                  select
                  call $out
                  local.get 15
                  local.get 25
                  i32.sub
                  local.set 15
                  local.get 18
                  i32.const 4
                  i32.add
                  local.tee 18
                  local.get 23
                  i32.ge_u
                  br_if 1 (;@6;)
                  local.get 15
                  i32.const -1
                  i32.gt_s
                  br_if 0 (;@7;)
                end
              end
              local.get 0
              i32.const 48
              local.get 15
              i32.const 18
              i32.add
              i32.const 18
              i32.const 0
              call $pad
              local.get 0
              local.get 22
              local.get 13
              local.get 22
              i32.sub
              call $out
              br 2 (;@3;)
            end
            local.get 15
            local.set 12
          end
          local.get 0
          i32.const 48
          local.get 12
          i32.const 9
          i32.add
          i32.const 9
          i32.const 0
          call $pad
        end
        local.get 0
        i32.const 32
        local.get 2
        local.get 11
        local.get 4
        i32.const 8192
        i32.xor
        call $pad
        br 1 (;@1;)
      end
      local.get 10
      i32.const 9
      i32.add
      local.get 10
      local.get 5
      i32.const 32
      i32.and
      local.tee 18
      select
      local.set 15
      block  ;; label = @2
        local.get 3
        i32.const 11
        i32.gt_u
        br_if 0 (;@2;)
        i32.const 12
        local.get 3
        i32.sub
        local.tee 12
        i32.eqz
        br_if 0 (;@2;)
        f64.const 0x1p+3 (;=8;)
        local.set 26
        loop  ;; label = @3
          local.get 26
          f64.const 0x1p+4 (;=16;)
          f64.mul
          local.set 26
          local.get 12
          i32.const -1
          i32.add
          local.tee 12
          br_if 0 (;@3;)
        end
        block  ;; label = @3
          local.get 15
          i32.load8_u
          i32.const 45
          i32.ne
          br_if 0 (;@3;)
          local.get 26
          local.get 1
          f64.neg
          local.get 26
          f64.sub
          f64.add
          f64.neg
          local.set 1
          br 1 (;@2;)
        end
        local.get 1
        local.get 26
        f64.add
        local.get 26
        f64.sub
        local.set 1
      end
      block  ;; label = @2
        local.get 6
        i32.load offset=44
        local.tee 12
        local.get 12
        i32.const 31
        i32.shr_s
        local.tee 12
        i32.add
        local.get 12
        i32.xor
        i64.extend_i32_u
        local.get 13
        call $fmt_u
        local.tee 12
        local.get 13
        i32.ne
        br_if 0 (;@2;)
        local.get 6
        i32.const 48
        i32.store8 offset=15
        local.get 6
        i32.const 15
        i32.add
        local.set 12
      end
      local.get 9
      i32.const 2
      i32.or
      local.set 24
      local.get 6
      i32.load offset=44
      local.set 19
      local.get 12
      i32.const -2
      i32.add
      local.tee 23
      local.get 5
      i32.const 15
      i32.add
      i32.store8
      local.get 12
      i32.const -1
      i32.add
      i32.const 45
      i32.const 43
      local.get 19
      i32.const 0
      i32.lt_s
      select
      i32.store8
      local.get 4
      i32.const 8
      i32.and
      local.set 25
      local.get 6
      i32.const 16
      i32.add
      local.set 19
      loop  ;; label = @2
        local.get 19
        local.set 12
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            f64.abs
            f64.const 0x1p+31 (;=2.14748e+09;)
            f64.lt
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            i32.trunc_f64_s
            local.set 19
            br 1 (;@3;)
          end
          i32.const -2147483648
          local.set 19
        end
        local.get 12
        local.get 19
        i32.const 1584
        i32.add
        i32.load8_u
        local.get 18
        i32.or
        i32.store8
        local.get 1
        local.get 19
        f64.convert_i32_s
        f64.sub
        f64.const 0x1p+4 (;=16;)
        f64.mul
        local.set 1
        block  ;; label = @3
          local.get 12
          i32.const 1
          i32.add
          local.tee 19
          local.get 6
          i32.const 16
          i32.add
          i32.sub
          i32.const 1
          i32.ne
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 1
            f64.const 0x0p+0 (;=0;)
            f64.ne
            br_if 0 (;@4;)
            local.get 3
            i32.const 0
            i32.gt_s
            br_if 0 (;@4;)
            local.get 25
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 12
          i32.const 46
          i32.store8 offset=1
          local.get 12
          i32.const 2
          i32.add
          local.set 19
        end
        local.get 1
        f64.const 0x0p+0 (;=0;)
        f64.ne
        br_if 0 (;@2;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.eqz
          br_if 0 (;@3;)
          local.get 19
          local.get 6
          i32.const 16
          i32.add
          i32.sub
          i32.const -2
          i32.add
          local.get 3
          i32.ge_s
          br_if 0 (;@3;)
          local.get 3
          local.get 13
          i32.add
          local.get 23
          i32.sub
          i32.const 2
          i32.add
          local.set 12
          br 1 (;@2;)
        end
        local.get 13
        local.get 6
        i32.const 16
        i32.add
        local.get 23
        i32.add
        i32.sub
        local.get 19
        i32.add
        local.set 12
      end
      local.get 0
      i32.const 32
      local.get 2
      local.get 12
      local.get 24
      i32.add
      local.tee 11
      local.get 4
      call $pad
      local.get 0
      local.get 15
      local.get 24
      call $out
      local.get 0
      i32.const 48
      local.get 2
      local.get 11
      local.get 4
      i32.const 65536
      i32.xor
      call $pad
      local.get 0
      local.get 6
      i32.const 16
      i32.add
      local.get 19
      local.get 6
      i32.const 16
      i32.add
      i32.sub
      local.tee 19
      call $out
      local.get 0
      i32.const 48
      local.get 12
      local.get 19
      local.get 13
      local.get 23
      i32.sub
      local.tee 18
      i32.add
      i32.sub
      i32.const 0
      i32.const 0
      call $pad
      local.get 0
      local.get 23
      local.get 18
      call $out
      local.get 0
      i32.const 32
      local.get 2
      local.get 11
      local.get 4
      i32.const 8192
      i32.xor
      call $pad
    end
    local.get 6
    i32.const 560
    i32.add
    global.set 0
    local.get 2
    local.get 11
    local.get 11
    local.get 2
    i32.lt_s
    select)
  (func $pop_arg_long_double (type 5) (param i32 i32)
    (local i32)
    local.get 1
    local.get 1
    i32.load
    i32.const 15
    i32.add
    i32.const -16
    i32.and
    local.tee 2
    i32.const 16
    i32.add
    i32.store
    local.get 0
    local.get 2
    i64.load
    local.get 2
    i64.load offset=8
    call $__trunctfdf2
    f64.store)
  (func $__DOUBLE_BITS (type 20) (param f64) (result i64)
    local.get 0
    i64.reinterpret_f64)
  (func $printf (type 6) (param i32 i32) (result i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    local.get 1
    i32.store offset=12
    i32.const 0
    i32.load offset=1104
    local.get 0
    local.get 1
    call $vfprintf
    local.set 1
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    local.get 1)
  (func $__lockfile (type 1) (param i32) (result i32)
    i32.const 1)
  (func $__unlockfile (type 3) (param i32))
  (func $stackSave (type 2) (result i32)
    global.get 0)
  (func $stackRestore (type 3) (param i32)
    local.get 0
    global.set 0)
  (func $stackAlloc (type 1) (param i32) (result i32)
    (local i32 i32)
    global.get 0
    local.get 0
    i32.sub
    i32.const -16
    i32.and
    local.tee 1
    global.set 0
    local.get 1)
  (func $emscripten_stack_init (type 4)
    i32.const 5246000
    global.set 2
    i32.const 3108
    i32.const 15
    i32.add
    i32.const -16
    i32.and
    global.set 1)
  (func $emscripten_stack_get_free (type 2) (result i32)
    global.get 0
    global.get 1
    i32.sub)
  (func $emscripten_stack_get_end (type 2) (result i32)
    global.get 1)
  (func $fflush (type 1) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 0
          i32.load offset=76
          i32.const -1
          i32.gt_s
          br_if 0 (;@3;)
          local.get 0
          call $__fflush_unlocked
          return
        end
        local.get 0
        call $__lockfile
        local.set 1
        local.get 0
        call $__fflush_unlocked
        local.set 2
        local.get 1
        i32.eqz
        br_if 1 (;@1;)
        local.get 0
        call $__unlockfile
        local.get 2
        return
      end
      i32.const 0
      local.set 2
      block  ;; label = @2
        i32.const 0
        i32.load offset=1744
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=1744
        call $fflush
        local.set 2
      end
      block  ;; label = @2
        call $__ofl_lock
        i32.load
        local.tee 0
        i32.eqz
        br_if 0 (;@2;)
        loop  ;; label = @3
          i32.const 0
          local.set 1
          block  ;; label = @4
            local.get 0
            i32.load offset=76
            i32.const 0
            i32.lt_s
            br_if 0 (;@4;)
            local.get 0
            call $__lockfile
            local.set 1
          end
          block  ;; label = @4
            local.get 0
            i32.load offset=20
            local.get 0
            i32.load offset=28
            i32.le_u
            br_if 0 (;@4;)
            local.get 0
            call $__fflush_unlocked
            local.get 2
            i32.or
            local.set 2
          end
          block  ;; label = @4
            local.get 1
            i32.eqz
            br_if 0 (;@4;)
            local.get 0
            call $__unlockfile
          end
          local.get 0
          i32.load offset=56
          local.tee 0
          br_if 0 (;@3;)
        end
      end
      call $__ofl_unlock
    end
    local.get 2)
  (func $__fflush_unlocked (type 1) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=20
      local.get 0
      i32.load offset=28
      i32.le_u
      br_if 0 (;@1;)
      local.get 0
      i32.const 0
      i32.const 0
      local.get 0
      i32.load offset=36
      call_indirect (type 0)
      drop
      local.get 0
      i32.load offset=20
      br_if 0 (;@1;)
      i32.const -1
      return
    end
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.tee 1
      local.get 0
      i32.load offset=8
      local.tee 2
      i32.ge_u
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      local.get 2
      i32.sub
      i64.extend_i32_s
      i32.const 1
      local.get 0
      i32.load offset=40
      call_indirect (type 7)
      drop
    end
    local.get 0
    i32.const 0
    i32.store offset=28
    local.get 0
    i64.const 0
    i64.store offset=16
    local.get 0
    i64.const 0
    i64.store offset=4 align=4
    i32.const 0)
  (func $dynCall_jiji (type 21) (param $fptr i32) (param $0 i32) (param $1 i64) (param $2 i32) (result i64)
    local.get $0
    local.get $1
    local.get $2
    local.get $fptr
    call_indirect (type 7))
  (func $legalstub$dynCall_jiji (type 9) (param i32 i32 i32 i32 i32) (result i32)
    (local i64)
    local.get 0
    local.get 1
    local.get 2
    i64.extend_i32_u
    local.get 3
    i64.extend_i32_u
    i64.const 32
    i64.shl
    i64.or
    local.get 4
    call $dynCall_jiji
    local.set 5
    local.get 5
    i64.const 32
    i64.shr_u
    i32.wrap_i64
    call $setTempRet0
    local.get 5
    i32.wrap_i64)
  (table (;0;) 6 6 funcref)
  (memory (;0;) 256 256)
  (global (;0;) (mut i32) (i32.const 5246000))
  (global (;1;) (mut i32) (i32.const 0))
  (global (;2;) (mut i32) (i32.const 0))
  (export "memory" (memory 0))
  (export "__wasm_call_ctors" (func $__wasm_call_ctors))
  (export "main" (func $main))
  (export "__indirect_function_table" (table 0))
  (export "fflush" (func $fflush))
  (export "__errno_location" (func $__errno_location))
  (export "stackSave" (func $stackSave))
  (export "stackRestore" (func $stackRestore))
  (export "stackAlloc" (func $stackAlloc))
  (export "emscripten_stack_init" (func $emscripten_stack_init))
  (export "emscripten_stack_get_free" (func $emscripten_stack_get_free))
  (export "emscripten_stack_get_end" (func $emscripten_stack_get_end))
  (export "dynCall_jiji" (func $legalstub$dynCall_jiji))
  (elem (;0;) (i32.const 1) func $__emscripten_stdout_close $__stdio_write $__emscripten_stdout_seek $fmt_fp $pop_arg_long_double)
  (data (;0;) (i32.const 1024) "\03\00\00\00\01\00\00\00\05\00\00\00\02\00\00\00\04\00\00\00-+   0X0x\00-0X+0X 0X-0x+0x 0x\00nan\00inf\00NAN\00INF\00.\00(null)\00%d \00\0a\00@\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\11\00\0a\00\11\11\11\00\00\00\00\05\00\00\00\00\00\00\09\00\00\00\00\0b\00\00\00\00\00\00\00\00\11\00\0f\0a\11\11\11\03\0a\07\00\01\00\09\0b\0b\00\00\09\06\0b\00\00\0b\00\06\11\00\00\00\11\11\11\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0b\00\00\00\00\00\00\00\00\11\00\0a\0a\11\11\11\00\0a\00\00\02\00\09\0b\00\00\00\09\00\0b\00\00\0b\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0c\00\00\00\00\00\00\00\00\00\00\00\0c\00\00\00\00\0c\00\00\00\00\09\0c\00\00\00\00\00\0c\00\00\0c\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\0d\00\00\00\04\0d\00\00\00\00\09\0e\00\00\00\00\00\0e\00\00\0e\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\10\00\00\00\00\00\00\00\00\00\00\00\0f\00\00\00\00\0f\00\00\00\00\09\10\00\00\00\00\00\10\00\00\10\00\00\12\00\00\00\12\12\12\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\12\00\00\00\12\12\12\00\00\00\00\00\00\09\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0b\00\00\00\00\00\00\00\00\00\00\00\0a\00\00\00\00\0a\00\00\00\00\09\0b\00\00\00\00\00\0b\00\00\0b\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0c\00\00\00\00\00\00\00\00\00\00\00\0c\00\00\00\00\0c\00\00\00\00\09\0c\00\00\00\00\00\0c\00\00\0c\00\000123456789ABCDEF")
  (data (;1;) (i32.const 1600) "\05\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\02\00\00\00\03\00\00\00\d8\07\00\00\00\04\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0a\ff\ff\ff\ff\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00@\06\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\0c\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00"))
