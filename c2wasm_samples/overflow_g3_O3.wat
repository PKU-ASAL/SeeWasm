(module
  (type (;0;) (func (param i32) (result i32)))
  (type (;1;) (func (param i32 i32 i32) (result i32)))
  (type (;2;) (func (param i32 i32) (result i32)))
  (type (;3;) (func (result i32)))
  (type (;4;) (func (param i32 i64 i64 i64 i64)))
  (type (;5;) (func (param i32)))
  (type (;6;) (func (param i32 i32)))
  (type (;7;) (func (param i32 i32 i32 i32) (result i32)))
  (type (;8;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;9;) (func (param i32 i64 i32) (result i64)))
  (type (;10;) (func (param i32 i64 i64 i32)))
  (type (;11;) (func (param i32 i32 i32 i32)))
  (type (;12;) (func (param i64 i64 i64 i64) (result i32)))
  (type (;13;) (func (param i64 i32) (result i32)))
  (type (;14;) (func))
  (type (;15;) (func (param i32 i64)))
  (type (;16;) (func (param i32 i64 i64)))
  (type (;17;) (func (param i32 i32 i32 i32 i32 i32)))
  (type (;18;) (func (param i32 i32 i32 i32 i32 i32 i32)))
  (type (;19;) (func (param i32 i32) (result i64)))
  (type (;20;) (func (param i32 i32 i32 i64) (result i64)))
  (type (;21;) (func (param i32 i32 i64)))
  (type (;22;) (func (param i32 f32)))
  (type (;23;) (func (param i64 i64) (result f32)))
  (type (;24;) (func (param i64 i64) (result f64)))
  (type (;25;) (func (param i32 f64)))
  (type (;26;) (func (param f64 i32) (result f64)))
  (type (;27;) (func (param i64 i64) (result i32)))
  (type (;28;) (func (param i32 i32 i32 i32 i32 i32 i32) (result i32)))
  (type (;29;) (func (param i32 f64 i32 i32 i32 i32) (result i32)))
  (type (;30;) (func (param i32 i32 i32)))
  (type (;31;) (func (param i64 i32 i32) (result i32)))
  (type (;32;) (func (param i32 i32 i32 i32 i32)))
  (type (;33;) (func (param i32 i32 i64 i32) (result i64)))
  (type (;34;) (func (param i32 i64 i32 i32) (result i32)))
  (import "wasi_snapshot_preview1" "fd_close" (func $__wasi_fd_close (type 0)))
  (import "wasi_snapshot_preview1" "fd_read" (func $__wasi_fd_read (type 7)))
  (import "env" "emscripten_resize_heap" (func $emscripten_resize_heap (type 0)))
  (import "env" "emscripten_memcpy_big" (func $emscripten_memcpy_big (type 1)))
  (import "wasi_snapshot_preview1" "fd_write" (func $__wasi_fd_write (type 7)))
  (import "env" "setTempRet0" (func $setTempRet0 (type 5)))
  (import "wasi_snapshot_preview1" "fd_seek" (func $legalimport$__wasi_fd_seek (type 8)))
  (func $__wasm_call_ctors (type 14)
    nop)
  (func $__original_main (type 3) (result i32)
    (local i32 i32)
    global.get 0
    i32.const 96
    i32.sub
    local.tee 0
    global.set 0
    local.get 0
    local.get 0
    i32.const 92
    i32.add
    i32.store offset=80
    i32.const 1050
    local.get 0
    i32.const 80
    i32.add
    call $scanf
    drop
    local.get 0
    local.get 0
    i32.load offset=92
    i32.const 2147483640
    i32.add
    i32.store offset=64
    i32.const 1050
    local.get 0
    i32.const -64
    i32.sub
    call $iprintf
    drop
    local.get 0
    local.get 0
    i32.const 92
    i32.add
    i32.store offset=48
    i32.const 1050
    local.get 0
    i32.const 48
    i32.add
    call $scanf
    drop
    local.get 0
    i32.load offset=92
    local.tee 1
    i32.const 3
    i32.le_s
    if  ;; label = @1
      local.get 0
      local.get 1
      i32.const 2147483640
      i32.add
      i32.store offset=32
      i32.const 1050
      local.get 0
      i32.const 32
      i32.add
      call $iprintf
      drop
    end
    local.get 0
    local.get 0
    i32.const 92
    i32.add
    i32.store offset=16
    i32.const 1043
    local.get 0
    i32.const 16
    i32.add
    call $scanf
    drop
    local.get 0
    i32.load offset=92
    local.tee 1
    i32.const 3
    i32.le_u
    if  ;; label = @1
      local.get 0
      local.get 1
      i32.const 2147483640
      i32.add
      i32.store
      i32.const 1043
      local.get 0
      call $iprintf
      drop
    end
    local.get 0
    i32.const 96
    i32.add
    global.set 0
    i32.const 0)
  (func $main (type 2) (param i32 i32) (result i32)
    call $__original_main)
  (func $scanf (type 2) (param i32 i32) (result i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    local.get 1
    i32.store offset=12
    local.get 0
    local.get 1
    call $vscanf
    local.set 1
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    local.get 1)
  (func $vscanf (type 2) (param i32 i32) (result i32)
    i32.const 1060
    i32.load
    local.get 0
    local.get 1
    call $vfscanf)
  (func $dummy (type 0) (param i32) (result i32)
    local.get 0)
  (func $__stdio_close (type 0) (param i32) (result i32)
    local.get 0
    i32.load offset=60
    call $dummy
    call $__wasi_fd_close)
  (func $__stdio_seek (type 9) (param i32 i64 i32) (result i64)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    local.get 0
    i32.load offset=60
    local.get 1
    local.get 2
    i32.const 255
    i32.and
    local.get 3
    i32.const 8
    i32.add
    call $legalfunc$__wasi_fd_seek
    call $__wasi_syscall_ret
    local.set 0
    local.get 3
    i64.load offset=8
    local.set 1
    local.get 3
    i32.const 16
    i32.add
    global.set 0
    i64.const -1
    local.get 1
    local.get 0
    select)
  (func $isspace (type 0) (param i32) (result i32)
    local.get 0
    i32.const 32
    i32.eq
    local.get 0
    i32.const 9
    i32.sub
    i32.const 5
    i32.lt_u
    i32.or)
  (func $__shlim (type 15) (param i32 i64)
    (local i32 i32 i64)
    local.get 0
    local.get 1
    i64.store offset=112
    local.get 0
    local.get 0
    i32.load offset=8
    local.tee 2
    local.get 0
    i32.load offset=4
    local.tee 3
    i32.sub
    i64.extend_i32_s
    local.tee 4
    i64.store offset=120
    local.get 0
    local.get 3
    local.get 1
    i32.wrap_i64
    i32.add
    local.get 2
    local.get 1
    local.get 4
    i64.lt_s
    select
    local.get 2
    local.get 1
    i64.const 0
    i64.ne
    select
    i32.store offset=104)
  (func $__shgetc (type 0) (param i32) (result i32)
    (local i64 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i64.load offset=112
        local.tee 1
        i64.eqz
        i32.eqz
        if  ;; label = @3
          local.get 0
          i64.load offset=120
          local.get 1
          i64.ge_s
          br_if 1 (;@2;)
        end
        local.get 0
        call $__uflow
        local.tee 4
        i32.const -1
        i32.gt_s
        br_if 1 (;@1;)
      end
      local.get 0
      i32.const 0
      i32.store offset=104
      i32.const -1
      return
    end
    local.get 0
    block (result i32)  ;; label = @1
      local.get 0
      i32.load offset=8
      local.tee 3
      local.tee 2
      local.get 0
      i64.load offset=112
      local.tee 1
      i64.eqz
      br_if 0 (;@1;)
      drop
      local.get 3
      local.tee 2
      local.get 1
      local.get 0
      i64.load offset=120
      i64.const -1
      i64.xor
      i64.add
      local.tee 1
      local.get 3
      local.get 0
      i32.load offset=4
      local.tee 5
      i32.sub
      i64.extend_i32_s
      i64.ge_s
      br_if 0 (;@1;)
      drop
      local.get 5
      local.get 1
      i32.wrap_i64
      i32.add
    end
    local.tee 2
    i32.store offset=104
    local.get 0
    i32.load offset=4
    local.set 2
    local.get 3
    if  ;; label = @1
      local.get 0
      local.get 0
      i64.load offset=120
      local.get 3
      local.get 2
      i32.sub
      i32.const 1
      i32.add
      i64.extend_i32_s
      i64.add
      i64.store offset=120
    end
    local.get 2
    i32.const 1
    i32.sub
    local.tee 0
    i32.load8_u
    local.get 4
    i32.ne
    if  ;; label = @1
      local.get 0
      local.get 4
      i32.store8
    end
    local.get 4)
  (func $isdigit (type 0) (param i32) (result i32)
    local.get 0
    i32.const 48
    i32.sub
    i32.const 10
    i32.lt_u)
  (func $__errno_location (type 3) (result i32)
    i32.const 3672)
  (func $copysignl (type 4) (param i32 i64 i64 i64 i64)
    local.get 0
    local.get 1
    i64.store
    local.get 0
    local.get 2
    i64.const 281474976710655
    i64.and
    local.get 4
    i64.const 48
    i64.shr_u
    i32.wrap_i64
    i32.const 32768
    i32.and
    local.get 2
    i64.const 48
    i64.shr_u
    i32.wrap_i64
    i32.const 32767
    i32.and
    i32.or
    i64.extend_i32_u
    i64.const 48
    i64.shl
    i64.or
    i64.store offset=8)
  (func $scalbnl (type 10) (param i32 i64 i64 i32)
    (local i32)
    global.get 0
    i32.const 80
    i32.sub
    local.tee 4
    global.set 0
    block  ;; label = @1
      local.get 3
      i32.const 16384
      i32.ge_s
      if  ;; label = @2
        local.get 4
        i32.const 32
        i32.add
        local.get 1
        local.get 2
        i64.const 0
        i64.const 9222809086901354496
        call $__multf3
        local.get 4
        i64.load offset=40
        local.set 2
        local.get 4
        i64.load offset=32
        local.set 1
        local.get 3
        i32.const 32767
        i32.lt_s
        if  ;; label = @3
          local.get 3
          i32.const 16383
          i32.sub
          local.set 3
          br 2 (;@1;)
        end
        local.get 4
        i32.const 16
        i32.add
        local.get 1
        local.get 2
        i64.const 0
        i64.const 9222809086901354496
        call $__multf3
        local.get 3
        i32.const 49149
        local.get 3
        i32.const 49149
        i32.lt_s
        select
        i32.const 32766
        i32.sub
        local.set 3
        local.get 4
        i64.load offset=24
        local.set 2
        local.get 4
        i64.load offset=16
        local.set 1
        br 1 (;@1;)
      end
      local.get 3
      i32.const -16383
      i32.gt_s
      br_if 0 (;@1;)
      local.get 4
      i32.const -64
      i32.sub
      local.get 1
      local.get 2
      i64.const 0
      i64.const 281474976710656
      call $__multf3
      local.get 4
      i64.load offset=72
      local.set 2
      local.get 4
      i64.load offset=64
      local.set 1
      local.get 3
      i32.const -32765
      i32.gt_s
      if  ;; label = @2
        local.get 3
        i32.const 16382
        i32.add
        local.set 3
        br 1 (;@1;)
      end
      local.get 4
      i32.const 48
      i32.add
      local.get 1
      local.get 2
      i64.const 0
      i64.const 281474976710656
      call $__multf3
      local.get 3
      i32.const -49146
      local.get 3
      i32.const -49146
      i32.gt_s
      select
      i32.const 32764
      i32.add
      local.set 3
      local.get 4
      i64.load offset=56
      local.set 2
      local.get 4
      i64.load offset=48
      local.set 1
    end
    local.get 4
    local.get 1
    local.get 2
    i64.const 0
    local.get 3
    i32.const 16383
    i32.add
    i64.extend_i32_u
    i64.const 48
    i64.shl
    call $__multf3
    local.get 0
    local.get 4
    i64.load offset=8
    i64.store offset=8
    local.get 0
    local.get 4
    i64.load
    i64.store
    local.get 4
    i32.const 80
    i32.add
    global.set 0)
  (func $fabsl (type 16) (param i32 i64 i64)
    local.get 0
    local.get 2
    i64.const 9223372036854775807
    i64.and
    i64.store offset=8
    local.get 0
    local.get 1
    i64.store)
  (func $__floatscan (type 11) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i64 i64 i32 i32)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 6
    global.set 0
    block  ;; label = @1
      local.get 2
      i32.const 2
      i32.le_u
      if  ;; label = @2
        local.get 1
        local.set 5
        local.get 2
        i32.const 2
        i32.shl
        local.tee 2
        i32.const 1132
        i32.add
        i32.load
        local.set 10
        local.get 2
        i32.const 1120
        i32.add
        i32.load
        local.set 11
        loop  ;; label = @3
          block (result i32)  ;; label = @4
            local.get 1
            i32.load offset=4
            local.tee 2
            local.get 1
            i32.load offset=104
            i32.lt_u
            if  ;; label = @5
              local.get 5
              local.get 2
              i32.const 1
              i32.add
              i32.store offset=4
              local.get 2
              i32.load8_u
              br 1 (;@4;)
            end
            local.get 1
            call $__shgetc
          end
          local.tee 2
          call $isspace
          br_if 0 (;@3;)
        end
        i32.const 1
        local.set 7
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.const 43
            i32.sub
            br_table 0 (;@4;) 1 (;@3;) 0 (;@4;) 1 (;@3;)
          end
          i32.const -1
          i32.const 1
          local.get 2
          i32.const 45
          i32.eq
          select
          local.set 7
          local.get 1
          i32.load offset=4
          local.tee 2
          local.get 1
          i32.load offset=104
          i32.lt_u
          if  ;; label = @4
            local.get 5
            local.get 2
            i32.const 1
            i32.add
            i32.store offset=4
            local.get 2
            i32.load8_u
            local.set 2
            br 1 (;@3;)
          end
          local.get 1
          call $__shgetc
          local.set 2
        end
        block  ;; label = @3
          block  ;; label = @4
            loop  ;; label = @5
              local.get 4
              i32.const 1024
              i32.add
              i32.load8_s
              local.get 2
              i32.const 32
              i32.or
              i32.eq
              if  ;; label = @6
                block  ;; label = @7
                  local.get 4
                  i32.const 6
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 1
                  i32.load offset=4
                  local.tee 2
                  local.get 1
                  i32.load offset=104
                  i32.lt_u
                  if  ;; label = @8
                    local.get 5
                    local.get 2
                    i32.const 1
                    i32.add
                    i32.store offset=4
                    local.get 2
                    i32.load8_u
                    local.set 2
                    br 1 (;@7;)
                  end
                  local.get 1
                  call $__shgetc
                  local.set 2
                end
                local.get 4
                i32.const 1
                i32.add
                local.tee 4
                i32.const 8
                i32.ne
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
            end
            local.get 4
            i32.const 3
            i32.ne
            if  ;; label = @5
              local.get 4
              i32.const 8
              i32.eq
              br_if 1 (;@4;)
              local.get 4
              i32.const 4
              i32.lt_u
              br_if 2 (;@3;)
              local.get 3
              i32.eqz
              br_if 2 (;@3;)
              local.get 4
              i32.const 8
              i32.eq
              br_if 1 (;@4;)
            end
            local.get 1
            i32.load offset=104
            local.tee 1
            if  ;; label = @5
              local.get 5
              local.get 5
              i32.load offset=4
              i32.const 1
              i32.sub
              i32.store offset=4
            end
            local.get 3
            i32.eqz
            br_if 0 (;@4;)
            local.get 4
            i32.const 4
            i32.lt_u
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 1
              if  ;; label = @6
                local.get 5
                local.get 5
                i32.load offset=4
                i32.const 1
                i32.sub
                i32.store offset=4
              end
              local.get 4
              i32.const 1
              i32.sub
              local.tee 4
              i32.const 3
              i32.gt_u
              br_if 0 (;@5;)
            end
          end
          local.get 6
          local.get 7
          f32.convert_i32_s
          f32.const inf (;=inf;)
          f32.mul
          call $__extendsftf2
          local.get 6
          i64.load offset=8
          local.set 8
          local.get 6
          i64.load
          local.set 9
          br 2 (;@1;)
        end
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 4
              br_if 0 (;@5;)
              i32.const 0
              local.set 4
              loop  ;; label = @6
                local.get 4
                i32.const 1046
                i32.add
                i32.load8_s
                local.get 2
                i32.const 32
                i32.or
                i32.ne
                br_if 1 (;@5;)
                block  ;; label = @7
                  local.get 4
                  i32.const 1
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 1
                  i32.load offset=4
                  local.tee 2
                  local.get 1
                  i32.load offset=104
                  i32.lt_u
                  if  ;; label = @8
                    local.get 5
                    local.get 2
                    i32.const 1
                    i32.add
                    i32.store offset=4
                    local.get 2
                    i32.load8_u
                    local.set 2
                    br 1 (;@7;)
                  end
                  local.get 1
                  call $__shgetc
                  local.set 2
                end
                local.get 4
                i32.const 1
                i32.add
                local.tee 4
                i32.const 3
                i32.ne
                br_if 0 (;@6;)
              end
              br 1 (;@4;)
            end
            block  ;; label = @5
              block  ;; label = @6
                local.get 4
                br_table 0 (;@6;) 1 (;@5;) 1 (;@5;) 2 (;@4;) 1 (;@5;)
              end
              block  ;; label = @6
                local.get 2
                i32.const 48
                i32.ne
                br_if 0 (;@6;)
                block (result i32)  ;; label = @7
                  local.get 1
                  i32.load offset=4
                  local.tee 4
                  local.get 1
                  i32.load offset=104
                  i32.lt_u
                  if  ;; label = @8
                    local.get 5
                    local.get 4
                    i32.const 1
                    i32.add
                    i32.store offset=4
                    local.get 4
                    i32.load8_u
                    br 1 (;@7;)
                  end
                  local.get 1
                  call $__shgetc
                end
                local.tee 4
                i32.const -33
                i32.and
                i32.const 88
                i32.eq
                if  ;; label = @7
                  local.get 6
                  i32.const 16
                  i32.add
                  local.get 1
                  local.get 11
                  local.get 10
                  local.get 7
                  local.get 3
                  call $hexfloat
                  local.get 6
                  i64.load offset=24
                  local.set 8
                  local.get 6
                  i64.load offset=16
                  local.set 9
                  br 6 (;@1;)
                end
                local.get 1
                i32.load offset=104
                i32.eqz
                br_if 0 (;@6;)
                local.get 5
                local.get 5
                i32.load offset=4
                i32.const 1
                i32.sub
                i32.store offset=4
              end
              local.get 6
              i32.const 32
              i32.add
              local.get 1
              local.get 2
              local.get 11
              local.get 10
              local.get 7
              local.get 3
              call $decfloat
              local.get 6
              i64.load offset=40
              local.set 8
              local.get 6
              i64.load offset=32
              local.set 9
              br 4 (;@1;)
            end
            local.get 1
            i32.load offset=104
            if  ;; label = @5
              local.get 5
              local.get 5
              i32.load offset=4
              i32.const 1
              i32.sub
              i32.store offset=4
            end
            br 1 (;@3;)
          end
          block  ;; label = @4
            block (result i32)  ;; label = @5
              local.get 1
              i32.load offset=4
              local.tee 2
              local.get 1
              i32.load offset=104
              i32.lt_u
              if  ;; label = @6
                local.get 5
                local.get 2
                i32.const 1
                i32.add
                i32.store offset=4
                local.get 2
                i32.load8_u
                br 1 (;@5;)
              end
              local.get 1
              call $__shgetc
            end
            local.tee 2
            i32.const 40
            i32.eq
            if  ;; label = @5
              i32.const 1
              local.set 4
              br 1 (;@4;)
            end
            i64.const 9223231299366420480
            local.set 8
            local.get 1
            i32.load offset=104
            i32.eqz
            br_if 3 (;@1;)
            local.get 5
            local.get 5
            i32.load offset=4
            i32.const 1
            i32.sub
            i32.store offset=4
            br 3 (;@1;)
          end
          loop  ;; label = @4
            block (result i32)  ;; label = @5
              local.get 1
              i32.load offset=4
              local.tee 2
              local.get 1
              i32.load offset=104
              i32.lt_u
              if  ;; label = @6
                local.get 5
                local.get 2
                i32.const 1
                i32.add
                i32.store offset=4
                local.get 2
                i32.load8_u
                br 1 (;@5;)
              end
              local.get 1
              call $__shgetc
            end
            local.tee 2
            i32.const 65
            i32.sub
            local.set 7
            block  ;; label = @5
              block  ;; label = @6
                local.get 2
                i32.const 48
                i32.sub
                i32.const 10
                i32.lt_u
                br_if 0 (;@6;)
                local.get 7
                i32.const 26
                i32.lt_u
                br_if 0 (;@6;)
                local.get 2
                i32.const 97
                i32.sub
                local.set 7
                local.get 2
                i32.const 95
                i32.eq
                br_if 0 (;@6;)
                local.get 7
                i32.const 26
                i32.ge_u
                br_if 1 (;@5;)
              end
              local.get 4
              i32.const 1
              i32.add
              local.set 4
              br 1 (;@4;)
            end
          end
          i64.const 9223231299366420480
          local.set 8
          local.get 2
          i32.const 41
          i32.eq
          br_if 2 (;@1;)
          local.get 1
          i32.load offset=104
          local.tee 2
          if  ;; label = @4
            local.get 5
            local.get 5
            i32.load offset=4
            i32.const 1
            i32.sub
            i32.store offset=4
          end
          local.get 3
          if  ;; label = @4
            local.get 4
            i32.eqz
            br_if 3 (;@1;)
            loop  ;; label = @5
              local.get 4
              i32.const 1
              i32.sub
              local.set 4
              local.get 2
              if  ;; label = @6
                local.get 5
                local.get 5
                i32.load offset=4
                i32.const 1
                i32.sub
                i32.store offset=4
              end
              local.get 4
              br_if 0 (;@5;)
            end
            br 3 (;@1;)
          end
        end
        call $__errno_location
        i32.const 28
        i32.store
        local.get 1
        i64.const 0
        call $__shlim
      end
      i64.const 0
      local.set 8
    end
    local.get 0
    local.get 9
    i64.store
    local.get 0
    local.get 8
    i64.store offset=8
    local.get 6
    i32.const 48
    i32.add
    global.set 0)
  (func $hexfloat (type 17) (param i32 i32 i32 i32 i32 i32)
    (local i32 i32 i64 i64 i64 i64 i64 i32 i64 i32 i32 i64 i32 i32 i32)
    global.get 0
    i32.const 432
    i32.sub
    local.tee 6
    global.set 0
    block (result i32)  ;; label = @1
      local.get 1
      i32.load offset=4
      local.tee 7
      local.get 1
      i32.load offset=104
      i32.lt_u
      if  ;; label = @2
        local.get 1
        local.get 7
        i32.const 1
        i32.add
        i32.store offset=4
        local.get 7
        i32.load8_u
        br 1 (;@1;)
      end
      local.get 1
      call $__shgetc
    end
    local.set 7
    block  ;; label = @1
      block (result i32)  ;; label = @2
        loop  ;; label = @3
          block  ;; label = @4
            local.get 7
            i32.const 48
            i32.ne
            if  ;; label = @5
              local.get 7
              i32.const 46
              i32.ne
              br_if 4 (;@1;)
              local.get 1
              i32.load offset=4
              local.tee 7
              local.get 1
              i32.load offset=104
              i32.ge_u
              br_if 1 (;@4;)
              local.get 1
              local.get 7
              i32.const 1
              i32.add
              i32.store offset=4
              local.get 7
              i32.load8_u
              br 3 (;@2;)
            end
            local.get 1
            i32.load offset=4
            local.tee 7
            local.get 1
            i32.load offset=104
            i32.lt_u
            if  ;; label = @5
              i32.const 1
              local.set 16
              local.get 1
              local.get 7
              i32.const 1
              i32.add
              i32.store offset=4
              local.get 7
              i32.load8_u
              local.set 7
              br 2 (;@3;)
            end
            i32.const 1
            local.set 16
            local.get 1
            call $__shgetc
            local.set 7
            br 1 (;@3;)
          end
        end
        local.get 1
        call $__shgetc
      end
      local.set 7
      i32.const 1
      local.set 15
      local.get 7
      i32.const 48
      i32.ne
      br_if 0 (;@1;)
      loop  ;; label = @2
        block (result i32)  ;; label = @3
          local.get 1
          i32.load offset=4
          local.tee 7
          local.get 1
          i32.load offset=104
          i32.lt_u
          if  ;; label = @4
            local.get 1
            local.get 7
            i32.const 1
            i32.add
            i32.store offset=4
            local.get 7
            i32.load8_u
            br 1 (;@3;)
          end
          local.get 1
          call $__shgetc
        end
        local.set 7
        local.get 12
        i64.const 1
        i64.sub
        local.set 12
        local.get 7
        i32.const 48
        i32.eq
        br_if 0 (;@2;)
      end
      i32.const 1
      local.set 16
    end
    i64.const 4611404543450677248
    local.set 11
    block  ;; label = @1
      loop  ;; label = @2
        block  ;; label = @3
          local.get 7
          i32.const 32
          i32.or
          local.set 19
          block  ;; label = @4
            block  ;; label = @5
              local.get 7
              i32.const 48
              i32.sub
              local.tee 20
              i32.const 10
              i32.lt_u
              br_if 0 (;@5;)
              local.get 19
              i32.const 97
              i32.sub
              i32.const 6
              i32.ge_u
              i32.const 0
              local.get 7
              i32.const 46
              i32.ne
              select
              br_if 4 (;@1;)
              local.get 7
              i32.const 46
              i32.ne
              br_if 0 (;@5;)
              local.get 15
              br_if 2 (;@3;)
              i32.const 1
              local.set 15
              local.get 9
              local.set 12
              br 1 (;@4;)
            end
            local.get 19
            i32.const 87
            i32.sub
            local.get 20
            local.get 7
            i32.const 57
            i32.gt_s
            select
            local.set 7
            block  ;; label = @5
              local.get 9
              i64.const 7
              i64.le_s
              if  ;; label = @6
                local.get 7
                local.get 13
                i32.const 4
                i32.shl
                i32.add
                local.set 13
                br 1 (;@5;)
              end
              local.get 9
              i64.const 28
              i64.le_s
              if  ;; label = @6
                local.get 6
                i32.const 48
                i32.add
                local.get 7
                call $__floatsitf
                local.get 6
                i32.const 32
                i32.add
                local.get 14
                local.get 11
                i64.const 0
                i64.const 4610278643543834624
                call $__multf3
                local.get 6
                i32.const 16
                i32.add
                local.get 6
                i64.load offset=32
                local.tee 14
                local.get 6
                i64.load offset=40
                local.tee 11
                local.get 6
                i64.load offset=48
                local.get 6
                i64.load offset=56
                call $__multf3
                local.get 6
                local.get 8
                local.get 10
                local.get 6
                i64.load offset=16
                local.get 6
                i64.load offset=24
                call $__addtf3
                local.get 6
                i64.load offset=8
                local.set 10
                local.get 6
                i64.load
                local.set 8
                br 1 (;@5;)
              end
              local.get 7
              i32.eqz
              br_if 0 (;@5;)
              local.get 18
              br_if 0 (;@5;)
              local.get 6
              i32.const 80
              i32.add
              local.get 14
              local.get 11
              i64.const 0
              i64.const 4611123068473966592
              call $__multf3
              local.get 6
              i32.const -64
              i32.sub
              local.get 8
              local.get 10
              local.get 6
              i64.load offset=80
              local.get 6
              i64.load offset=88
              call $__addtf3
              local.get 6
              i64.load offset=72
              local.set 10
              i32.const 1
              local.set 18
              local.get 6
              i64.load offset=64
              local.set 8
            end
            local.get 9
            i64.const 1
            i64.add
            local.set 9
            i32.const 1
            local.set 16
          end
          local.get 1
          i32.load offset=4
          local.tee 7
          local.get 1
          i32.load offset=104
          i32.lt_u
          if  ;; label = @4
            local.get 1
            local.get 7
            i32.const 1
            i32.add
            i32.store offset=4
            local.get 7
            i32.load8_u
            local.set 7
            br 2 (;@2;)
          end
          local.get 1
          call $__shgetc
          local.set 7
          br 1 (;@2;)
        end
      end
      i32.const 46
      local.set 7
    end
    block (result i64)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 16
          i32.eqz
          if  ;; label = @4
            local.get 1
            i32.load offset=104
            i32.eqz
            if  ;; label = @5
              local.get 5
              br_if 3 (;@2;)
              br 2 (;@3;)
            end
            local.get 1
            local.get 1
            i32.load offset=4
            local.tee 7
            i32.const 1
            i32.sub
            i32.store offset=4
            local.get 5
            i32.eqz
            br_if 1 (;@3;)
            local.get 1
            local.get 7
            i32.const 2
            i32.sub
            i32.store offset=4
            local.get 15
            i32.eqz
            br_if 2 (;@2;)
            local.get 1
            local.get 7
            i32.const 3
            i32.sub
            i32.store offset=4
            br 2 (;@2;)
          end
          local.get 9
          i64.const 7
          i64.le_s
          if  ;; label = @4
            local.get 9
            local.set 11
            loop  ;; label = @5
              local.get 13
              i32.const 4
              i32.shl
              local.set 13
              local.get 11
              i64.const 1
              i64.add
              local.tee 11
              i64.const 8
              i64.ne
              br_if 0 (;@5;)
            end
          end
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 7
                i32.const -33
                i32.and
                i32.const 80
                i32.eq
                if  ;; label = @7
                  local.get 1
                  local.get 5
                  call $scanexp
                  local.tee 11
                  i64.const -9223372036854775808
                  i64.ne
                  br_if 3 (;@4;)
                  local.get 5
                  if  ;; label = @8
                    local.get 1
                    i32.load offset=104
                    br_if 2 (;@6;)
                    br 3 (;@5;)
                  end
                  i64.const 0
                  local.set 8
                  local.get 1
                  i64.const 0
                  call $__shlim
                  i64.const 0
                  br 6 (;@1;)
                end
                local.get 1
                i32.load offset=104
                i32.eqz
                br_if 1 (;@5;)
              end
              local.get 1
              local.get 1
              i32.load offset=4
              i32.const 1
              i32.sub
              i32.store offset=4
            end
            i64.const 0
            local.set 11
          end
          local.get 13
          i32.eqz
          if  ;; label = @4
            local.get 6
            i32.const 112
            i32.add
            local.get 4
            f64.convert_i32_s
            f64.const 0x0p+0 (;=0;)
            f64.mul
            call $__extenddftf2
            local.get 6
            i64.load offset=112
            local.set 8
            local.get 6
            i64.load offset=120
            br 3 (;@1;)
          end
          local.get 12
          local.get 9
          local.get 15
          select
          i64.const 2
          i64.shl
          local.get 11
          i64.add
          i64.const 32
          i64.sub
          local.tee 9
          i32.const 0
          local.get 3
          i32.sub
          i64.extend_i32_u
          i64.gt_s
          if  ;; label = @4
            call $__errno_location
            i32.const 68
            i32.store
            local.get 6
            i32.const 160
            i32.add
            local.get 4
            call $__floatsitf
            local.get 6
            i32.const 144
            i32.add
            local.get 6
            i64.load offset=160
            local.get 6
            i64.load offset=168
            i64.const -1
            i64.const 9223090561878065151
            call $__multf3
            local.get 6
            i32.const 128
            i32.add
            local.get 6
            i64.load offset=144
            local.get 6
            i64.load offset=152
            i64.const -1
            i64.const 9223090561878065151
            call $__multf3
            local.get 6
            i64.load offset=128
            local.set 8
            local.get 6
            i64.load offset=136
            br 3 (;@1;)
          end
          local.get 3
          i32.const 226
          i32.sub
          i64.extend_i32_s
          local.get 9
          i64.le_s
          if  ;; label = @4
            local.get 13
            i32.const -1
            i32.gt_s
            if  ;; label = @5
              loop  ;; label = @6
                local.get 6
                i32.const 416
                i32.add
                local.get 8
                local.get 10
                i64.const 0
                i64.const -4611967493404098560
                call $__addtf3
                local.get 8
                local.get 10
                i64.const 0
                i64.const 4611123068473966592
                call $__getf2
                local.set 7
                local.get 6
                i32.const 400
                i32.add
                local.get 8
                local.get 10
                local.get 8
                local.get 6
                i64.load offset=416
                local.get 7
                i32.const 0
                i32.lt_s
                local.tee 1
                select
                local.get 10
                local.get 6
                i64.load offset=424
                local.get 1
                select
                call $__addtf3
                local.get 9
                i64.const 1
                i64.sub
                local.set 9
                local.get 6
                i64.load offset=408
                local.set 10
                local.get 6
                i64.load offset=400
                local.set 8
                local.get 13
                i32.const 1
                i32.shl
                local.get 7
                i32.const -1
                i32.gt_s
                i32.or
                local.tee 13
                i32.const -1
                i32.gt_s
                br_if 0 (;@6;)
              end
            end
            block (result i64)  ;; label = @5
              local.get 9
              local.get 3
              i64.extend_i32_s
              i64.sub
              i64.const 32
              i64.add
              local.tee 12
              i32.wrap_i64
              local.tee 7
              i32.const 0
              local.get 7
              i32.const 0
              i32.gt_s
              select
              local.get 2
              local.get 12
              local.get 2
              i64.extend_i32_u
              i64.lt_s
              select
              local.tee 7
              i32.const 113
              i32.ge_s
              if  ;; label = @6
                local.get 6
                i32.const 384
                i32.add
                local.get 4
                call $__floatsitf
                local.get 6
                i64.load offset=392
                local.set 12
                local.get 6
                i64.load offset=384
                local.set 14
                i64.const 0
                br 1 (;@5;)
              end
              local.get 6
              i32.const 352
              i32.add
              f64.const 0x1p+0 (;=1;)
              i32.const 144
              local.get 7
              i32.sub
              call $scalbn
              call $__extenddftf2
              local.get 6
              i32.const 336
              i32.add
              local.get 4
              call $__floatsitf
              local.get 6
              i32.const 368
              i32.add
              local.get 6
              i64.load offset=352
              local.get 6
              i64.load offset=360
              local.get 6
              i64.load offset=336
              local.tee 14
              local.get 6
              i64.load offset=344
              local.tee 12
              call $copysignl
              local.get 6
              i64.load offset=376
              local.set 17
              local.get 6
              i64.load offset=368
            end
            local.set 11
            local.get 6
            i32.const 320
            i32.add
            local.get 13
            local.get 13
            i32.const 1
            i32.and
            i32.eqz
            local.get 8
            local.get 10
            i64.const 0
            i64.const 0
            call $__letf2
            i32.const 0
            i32.ne
            local.get 7
            i32.const 32
            i32.lt_s
            i32.and
            i32.and
            local.tee 7
            i32.add
            call $__floatunsitf
            local.get 6
            i32.const 304
            i32.add
            local.get 14
            local.get 12
            local.get 6
            i64.load offset=320
            local.get 6
            i64.load offset=328
            call $__multf3
            local.get 6
            i32.const 272
            i32.add
            local.get 6
            i64.load offset=304
            local.get 6
            i64.load offset=312
            local.get 11
            local.get 17
            call $__addtf3
            local.get 6
            i32.const 288
            i32.add
            i64.const 0
            local.get 8
            local.get 7
            select
            i64.const 0
            local.get 10
            local.get 7
            select
            local.get 14
            local.get 12
            call $__multf3
            local.get 6
            i32.const 256
            i32.add
            local.get 6
            i64.load offset=288
            local.get 6
            i64.load offset=296
            local.get 6
            i64.load offset=272
            local.get 6
            i64.load offset=280
            call $__addtf3
            local.get 6
            i32.const 240
            i32.add
            local.get 6
            i64.load offset=256
            local.get 6
            i64.load offset=264
            local.get 11
            local.get 17
            call $__subtf3
            local.get 6
            i64.load offset=240
            local.tee 8
            local.get 6
            i64.load offset=248
            local.tee 10
            i64.const 0
            i64.const 0
            call $__letf2
            i32.eqz
            if  ;; label = @5
              call $__errno_location
              i32.const 68
              i32.store
            end
            local.get 6
            i32.const 224
            i32.add
            local.get 8
            local.get 10
            local.get 9
            i32.wrap_i64
            call $scalbnl
            local.get 6
            i64.load offset=224
            local.set 8
            local.get 6
            i64.load offset=232
            br 3 (;@1;)
          end
          call $__errno_location
          i32.const 68
          i32.store
          local.get 6
          i32.const 208
          i32.add
          local.get 4
          call $__floatsitf
          local.get 6
          i32.const 192
          i32.add
          local.get 6
          i64.load offset=208
          local.get 6
          i64.load offset=216
          i64.const 0
          i64.const 281474976710656
          call $__multf3
          local.get 6
          i32.const 176
          i32.add
          local.get 6
          i64.load offset=192
          local.get 6
          i64.load offset=200
          i64.const 0
          i64.const 281474976710656
          call $__multf3
          local.get 6
          i64.load offset=176
          local.set 8
          local.get 6
          i64.load offset=184
          br 2 (;@1;)
        end
        local.get 1
        i64.const 0
        call $__shlim
      end
      local.get 6
      i32.const 96
      i32.add
      local.get 4
      f64.convert_i32_s
      f64.const 0x0p+0 (;=0;)
      f64.mul
      call $__extenddftf2
      local.get 6
      i64.load offset=96
      local.set 8
      local.get 6
      i64.load offset=104
    end
    local.set 9
    local.get 0
    local.get 8
    i64.store
    local.get 0
    local.get 9
    i64.store offset=8
    local.get 6
    i32.const 432
    i32.add
    global.set 0)
  (func $decfloat (type 18) (param i32 i32 i32 i32 i32 i32 i32)
    (local i32 i32 i64 i64 i32 i32 i32 i32 i32 i64 i64 i32 i64 i64 i32 i32 f64 i32 i32)
    global.get 0
    i32.const 8976
    i32.sub
    local.tee 7
    global.set 0
    i32.const 0
    local.get 3
    local.get 4
    i32.add
    local.tee 24
    i32.sub
    local.set 25
    block  ;; label = @1
      block (result i32)  ;; label = @2
        loop  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.const 48
            i32.ne
            if  ;; label = @5
              local.get 2
              i32.const 46
              i32.ne
              br_if 4 (;@1;)
              local.get 1
              i32.load offset=4
              local.tee 2
              local.get 1
              i32.load offset=104
              i32.ge_u
              br_if 1 (;@4;)
              local.get 1
              local.get 2
              i32.const 1
              i32.add
              i32.store offset=4
              local.get 2
              i32.load8_u
              br 3 (;@2;)
            end
            local.get 1
            i32.load offset=4
            local.tee 2
            local.get 1
            i32.load offset=104
            i32.lt_u
            if  ;; label = @5
              i32.const 1
              local.set 12
              local.get 1
              local.get 2
              i32.const 1
              i32.add
              i32.store offset=4
              local.get 2
              i32.load8_u
              local.set 2
              br 2 (;@3;)
            end
            i32.const 1
            local.set 12
            local.get 1
            call $__shgetc
            local.set 2
            br 1 (;@3;)
          end
        end
        local.get 1
        call $__shgetc
      end
      local.set 2
      i32.const 1
      local.set 11
      local.get 2
      i32.const 48
      i32.ne
      br_if 0 (;@1;)
      loop  ;; label = @2
        block (result i32)  ;; label = @3
          local.get 1
          i32.load offset=4
          local.tee 2
          local.get 1
          i32.load offset=104
          i32.lt_u
          if  ;; label = @4
            local.get 1
            local.get 2
            i32.const 1
            i32.add
            i32.store offset=4
            local.get 2
            i32.load8_u
            br 1 (;@3;)
          end
          local.get 1
          call $__shgetc
        end
        local.set 2
        local.get 9
        i64.const 1
        i64.sub
        local.set 9
        local.get 2
        i32.const 48
        i32.eq
        br_if 0 (;@2;)
      end
      i32.const 1
      local.set 12
    end
    local.get 7
    i32.const 0
    i32.store offset=784
    local.get 2
    i32.const 48
    i32.sub
    local.set 13
    block (result i64)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 2
                    i32.const 46
                    i32.eq
                    local.tee 8
                    if  ;; label = @9
                      br 1 (;@8;)
                    end
                    local.get 13
                    i32.const 9
                    i32.gt_u
                    br_if 1 (;@7;)
                  end
                  loop  ;; label = @8
                    block  ;; label = @9
                      local.get 8
                      i32.const 1
                      i32.and
                      if  ;; label = @10
                        local.get 11
                        i32.eqz
                        if  ;; label = @11
                          local.get 10
                          local.set 9
                          i32.const 1
                          local.set 11
                          br 2 (;@9;)
                        end
                        local.get 12
                        i32.eqz
                        local.set 8
                        br 4 (;@6;)
                      end
                      local.get 10
                      i64.const 1
                      i64.add
                      local.set 10
                      local.get 14
                      i32.const 2044
                      i32.le_s
                      if  ;; label = @10
                        local.get 18
                        local.get 10
                        i32.wrap_i64
                        local.tee 21
                        local.get 2
                        i32.const 48
                        i32.eq
                        local.tee 12
                        select
                        local.set 18
                        local.get 7
                        i32.const 784
                        i32.add
                        local.get 14
                        i32.const 2
                        i32.shl
                        i32.add
                        local.tee 8
                        block (result i32)  ;; label = @11
                          local.get 15
                          if  ;; label = @12
                            local.get 2
                            local.get 8
                            i32.load
                            i32.const 10
                            i32.mul
                            i32.add
                            i32.const 48
                            i32.sub
                            local.set 13
                          end
                          local.get 13
                        end
                        i32.store
                        i32.const 1
                        local.set 12
                        i32.const 0
                        local.get 15
                        i32.const 1
                        i32.add
                        local.tee 2
                        local.get 2
                        i32.const 9
                        i32.eq
                        local.tee 2
                        select
                        local.set 15
                        local.get 2
                        local.get 14
                        i32.add
                        local.set 14
                        br 1 (;@9;)
                      end
                      local.get 2
                      i32.const 48
                      i32.eq
                      br_if 0 (;@9;)
                      local.get 7
                      local.get 7
                      i32.load offset=8960
                      i32.const 1
                      i32.or
                      i32.store offset=8960
                      i32.const 18396
                      local.set 18
                    end
                    block (result i32)  ;; label = @9
                      local.get 1
                      i32.load offset=4
                      local.tee 2
                      local.get 1
                      i32.load offset=104
                      i32.lt_u
                      if  ;; label = @10
                        local.get 1
                        local.get 2
                        i32.const 1
                        i32.add
                        i32.store offset=4
                        local.get 2
                        i32.load8_u
                        br 1 (;@9;)
                      end
                      local.get 1
                      call $__shgetc
                    end
                    local.tee 2
                    i32.const 48
                    i32.sub
                    local.set 13
                    local.get 2
                    i32.const 46
                    i32.eq
                    local.tee 8
                    br_if 0 (;@8;)
                    local.get 13
                    i32.const 10
                    i32.lt_u
                    br_if 0 (;@8;)
                  end
                end
                local.get 9
                local.get 10
                local.get 11
                select
                local.set 9
                block  ;; label = @7
                  local.get 12
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 2
                  i32.const -33
                  i32.and
                  i32.const 69
                  i32.ne
                  br_if 0 (;@7;)
                  block  ;; label = @8
                    local.get 1
                    local.get 6
                    call $scanexp
                    local.tee 16
                    i64.const -9223372036854775808
                    i64.ne
                    br_if 0 (;@8;)
                    local.get 6
                    i32.eqz
                    br_if 5 (;@3;)
                    i64.const 0
                    local.set 16
                    local.get 1
                    i32.load offset=104
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 1
                    local.get 1
                    i32.load offset=4
                    i32.const 1
                    i32.sub
                    i32.store offset=4
                  end
                  local.get 12
                  i32.eqz
                  br_if 3 (;@4;)
                  local.get 9
                  local.get 16
                  i64.add
                  local.set 9
                  br 5 (;@2;)
                end
                local.get 12
                i32.eqz
                local.set 8
                local.get 2
                i32.const 0
                i32.lt_s
                br_if 1 (;@5;)
              end
              local.get 1
              i32.load offset=104
              i32.eqz
              br_if 0 (;@5;)
              local.get 1
              local.get 1
              i32.load offset=4
              i32.const 1
              i32.sub
              i32.store offset=4
            end
            local.get 8
            i32.eqz
            br_if 2 (;@2;)
          end
          call $__errno_location
          i32.const 28
          i32.store
        end
        i64.const 0
        local.set 10
        local.get 1
        i64.const 0
        call $__shlim
        i64.const 0
        br 1 (;@1;)
      end
      local.get 7
      i32.load offset=784
      local.tee 1
      i32.eqz
      if  ;; label = @2
        local.get 7
        local.get 5
        f64.convert_i32_s
        f64.const 0x0p+0 (;=0;)
        f64.mul
        call $__extenddftf2
        local.get 7
        i64.load
        local.set 10
        local.get 7
        i64.load offset=8
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 10
        i64.const 9
        i64.gt_s
        br_if 0 (;@2;)
        local.get 9
        local.get 10
        i64.ne
        br_if 0 (;@2;)
        local.get 3
        i32.const 30
        i32.le_s
        i32.const 0
        local.get 1
        local.get 3
        i32.shr_u
        select
        br_if 0 (;@2;)
        local.get 7
        i32.const 48
        i32.add
        local.get 5
        call $__floatsitf
        local.get 7
        i32.const 32
        i32.add
        local.get 1
        call $__floatunsitf
        local.get 7
        i32.const 16
        i32.add
        local.get 7
        i64.load offset=48
        local.get 7
        i64.load offset=56
        local.get 7
        i64.load offset=32
        local.get 7
        i64.load offset=40
        call $__multf3
        local.get 7
        i64.load offset=16
        local.set 10
        local.get 7
        i64.load offset=24
        br 1 (;@1;)
      end
      local.get 4
      i32.const -2
      i32.div_s
      i64.extend_i32_u
      local.get 9
      i64.lt_s
      if  ;; label = @2
        call $__errno_location
        i32.const 68
        i32.store
        local.get 7
        i32.const 96
        i32.add
        local.get 5
        call $__floatsitf
        local.get 7
        i32.const 80
        i32.add
        local.get 7
        i64.load offset=96
        local.get 7
        i64.load offset=104
        i64.const -1
        i64.const 9223090561878065151
        call $__multf3
        local.get 7
        i32.const -64
        i32.sub
        local.get 7
        i64.load offset=80
        local.get 7
        i64.load offset=88
        i64.const -1
        i64.const 9223090561878065151
        call $__multf3
        local.get 7
        i64.load offset=64
        local.set 10
        local.get 7
        i64.load offset=72
        br 1 (;@1;)
      end
      local.get 4
      i32.const 226
      i32.sub
      i64.extend_i32_s
      local.get 9
      i64.gt_s
      if  ;; label = @2
        call $__errno_location
        i32.const 68
        i32.store
        local.get 7
        i32.const 144
        i32.add
        local.get 5
        call $__floatsitf
        local.get 7
        i32.const 128
        i32.add
        local.get 7
        i64.load offset=144
        local.get 7
        i64.load offset=152
        i64.const 0
        i64.const 281474976710656
        call $__multf3
        local.get 7
        i32.const 112
        i32.add
        local.get 7
        i64.load offset=128
        local.get 7
        i64.load offset=136
        i64.const 0
        i64.const 281474976710656
        call $__multf3
        local.get 7
        i64.load offset=112
        local.set 10
        local.get 7
        i64.load offset=120
        br 1 (;@1;)
      end
      local.get 15
      if  ;; label = @2
        local.get 15
        i32.const 8
        i32.le_s
        if  ;; label = @3
          local.get 7
          i32.const 784
          i32.add
          local.get 14
          i32.const 2
          i32.shl
          i32.add
          local.tee 2
          i32.load
          local.set 1
          loop  ;; label = @4
            local.get 1
            i32.const 10
            i32.mul
            local.set 1
            local.get 15
            i32.const 1
            i32.add
            local.tee 15
            i32.const 9
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 2
          local.get 1
          i32.store
        end
        local.get 14
        i32.const 1
        i32.add
        local.set 14
      end
      local.get 9
      i32.wrap_i64
      local.set 11
      block  ;; label = @2
        local.get 18
        i32.const 9
        i32.ge_s
        br_if 0 (;@2;)
        local.get 11
        local.get 18
        i32.lt_s
        br_if 0 (;@2;)
        local.get 11
        i32.const 17
        i32.gt_s
        br_if 0 (;@2;)
        local.get 11
        i32.const 9
        i32.eq
        if  ;; label = @3
          local.get 7
          i32.const 192
          i32.add
          local.get 5
          call $__floatsitf
          local.get 7
          i32.const 176
          i32.add
          local.get 7
          i32.load offset=784
          call $__floatunsitf
          local.get 7
          i32.const 160
          i32.add
          local.get 7
          i64.load offset=192
          local.get 7
          i64.load offset=200
          local.get 7
          i64.load offset=176
          local.get 7
          i64.load offset=184
          call $__multf3
          local.get 7
          i64.load offset=160
          local.set 10
          local.get 7
          i64.load offset=168
          br 2 (;@1;)
        end
        local.get 11
        i32.const 8
        i32.le_s
        if  ;; label = @3
          local.get 7
          i32.const 272
          i32.add
          local.get 5
          call $__floatsitf
          local.get 7
          i32.const 256
          i32.add
          local.get 7
          i32.load offset=784
          call $__floatunsitf
          local.get 7
          i32.const 240
          i32.add
          local.get 7
          i64.load offset=272
          local.get 7
          i64.load offset=280
          local.get 7
          i64.load offset=256
          local.get 7
          i64.load offset=264
          call $__multf3
          local.get 7
          i32.const 224
          i32.add
          i32.const 0
          local.get 11
          i32.sub
          i32.const 2
          i32.shl
          i32.const 1120
          i32.add
          i32.load
          call $__floatsitf
          local.get 7
          i32.const 208
          i32.add
          local.get 7
          i64.load offset=240
          local.get 7
          i64.load offset=248
          local.get 7
          i64.load offset=224
          local.get 7
          i64.load offset=232
          call $__divtf3
          local.get 7
          i64.load offset=208
          local.set 10
          local.get 7
          i64.load offset=216
          br 2 (;@1;)
        end
        local.get 3
        local.get 11
        i32.const -3
        i32.mul
        i32.add
        i32.const 27
        i32.add
        local.tee 2
        i32.const 30
        i32.le_s
        i32.const 0
        local.get 7
        i32.load offset=784
        local.tee 1
        local.get 2
        i32.shr_u
        select
        br_if 0 (;@2;)
        local.get 7
        i32.const 352
        i32.add
        local.get 5
        call $__floatsitf
        local.get 7
        i32.const 336
        i32.add
        local.get 1
        call $__floatunsitf
        local.get 7
        i32.const 320
        i32.add
        local.get 7
        i64.load offset=352
        local.get 7
        i64.load offset=360
        local.get 7
        i64.load offset=336
        local.get 7
        i64.load offset=344
        call $__multf3
        local.get 7
        i32.const 304
        i32.add
        local.get 11
        i32.const 2
        i32.shl
        i32.const 1048
        i32.add
        i32.load
        call $__floatsitf
        local.get 7
        i32.const 288
        i32.add
        local.get 7
        i64.load offset=320
        local.get 7
        i64.load offset=328
        local.get 7
        i64.load offset=304
        local.get 7
        i64.load offset=312
        call $__multf3
        local.get 7
        i64.load offset=288
        local.set 10
        local.get 7
        i64.load offset=296
        br 1 (;@1;)
      end
      loop  ;; label = @2
        local.get 7
        i32.const 784
        i32.add
        local.get 14
        local.tee 2
        i32.const 1
        i32.sub
        local.tee 14
        i32.const 2
        i32.shl
        i32.add
        i32.load
        i32.eqz
        br_if 0 (;@2;)
      end
      i32.const 0
      local.set 15
      block  ;; label = @2
        local.get 11
        i32.const 9
        i32.rem_s
        local.tee 1
        i32.eqz
        if  ;; label = @3
          i32.const 0
          local.set 8
          br 1 (;@2;)
        end
        local.get 1
        local.get 1
        i32.const 9
        i32.add
        local.get 11
        i32.const -1
        i32.gt_s
        select
        local.set 6
        block  ;; label = @3
          local.get 2
          i32.eqz
          if  ;; label = @4
            i32.const 0
            local.set 8
            i32.const 0
            local.set 2
            br 1 (;@3;)
          end
          i32.const 1000000000
          i32.const 0
          local.get 6
          i32.sub
          i32.const 2
          i32.shl
          i32.const 1120
          i32.add
          i32.load
          local.tee 12
          i32.div_s
          local.set 21
          i32.const 0
          local.set 13
          i32.const 0
          local.set 1
          i32.const 0
          local.set 8
          loop  ;; label = @4
            local.get 7
            i32.const 784
            i32.add
            local.get 1
            i32.const 2
            i32.shl
            i32.add
            local.tee 14
            local.get 14
            i32.load
            local.tee 14
            local.get 12
            i32.div_u
            local.tee 18
            local.get 13
            i32.add
            local.tee 13
            i32.store
            local.get 8
            i32.const 1
            i32.add
            i32.const 2047
            i32.and
            local.get 8
            local.get 13
            i32.eqz
            local.get 1
            local.get 8
            i32.eq
            i32.and
            local.tee 13
            select
            local.set 8
            local.get 11
            i32.const 9
            i32.sub
            local.get 11
            local.get 13
            select
            local.set 11
            local.get 21
            local.get 14
            local.get 12
            local.get 18
            i32.mul
            i32.sub
            i32.mul
            local.set 13
            local.get 1
            i32.const 1
            i32.add
            local.tee 1
            local.get 2
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 13
          i32.eqz
          br_if 0 (;@3;)
          local.get 7
          i32.const 784
          i32.add
          local.get 2
          i32.const 2
          i32.shl
          i32.add
          local.get 13
          i32.store
          local.get 2
          i32.const 1
          i32.add
          local.set 2
        end
        local.get 11
        local.get 6
        i32.sub
        i32.const 9
        i32.add
        local.set 11
      end
      loop  ;; label = @2
        local.get 7
        i32.const 784
        i32.add
        local.get 8
        i32.const 2
        i32.shl
        i32.add
        local.set 18
        block  ;; label = @3
          loop  ;; label = @4
            local.get 11
            i32.const 36
            i32.ge_s
            if  ;; label = @5
              local.get 11
              i32.const 36
              i32.ne
              br_if 2 (;@3;)
              local.get 18
              i32.load
              i32.const 10384593
              i32.ge_u
              br_if 2 (;@3;)
            end
            local.get 2
            i32.const 2047
            i32.add
            local.set 12
            i32.const 0
            local.set 13
            loop  ;; label = @5
              local.get 13
              i64.extend_i32_u
              local.get 7
              i32.const 784
              i32.add
              local.get 12
              i32.const 2047
              i32.and
              local.tee 1
              i32.const 2
              i32.shl
              i32.add
              local.tee 12
              i64.load32_u
              i64.const 29
              i64.shl
              i64.add
              local.tee 9
              i64.const 1000000001
              i64.lt_u
              if (result i32)  ;; label = @6
                i32.const 0
              else
                local.get 9
                local.get 9
                i64.const 1000000000
                i64.div_u
                local.tee 10
                i64.const 1000000000
                i64.mul
                i64.sub
                local.set 9
                local.get 10
                i32.wrap_i64
              end
              local.set 13
              local.get 12
              local.get 9
              i32.wrap_i64
              local.tee 14
              i32.store
              local.get 2
              local.get 2
              local.get 2
              local.get 1
              local.get 14
              select
              local.get 1
              local.get 8
              i32.eq
              select
              local.get 1
              local.get 2
              i32.const 1
              i32.sub
              i32.const 2047
              i32.and
              i32.ne
              select
              local.set 2
              local.get 1
              i32.const 1
              i32.sub
              local.set 12
              local.get 1
              local.get 8
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 15
            i32.const 29
            i32.sub
            local.set 15
            local.get 13
            i32.eqz
            br_if 0 (;@4;)
          end
          local.get 2
          local.get 8
          i32.const 1
          i32.sub
          i32.const 2047
          i32.and
          local.tee 8
          i32.eq
          if  ;; label = @4
            local.get 7
            i32.const 784
            i32.add
            local.get 2
            i32.const 2046
            i32.add
            i32.const 2047
            i32.and
            i32.const 2
            i32.shl
            i32.add
            local.tee 1
            local.get 1
            i32.load
            local.get 7
            i32.const 784
            i32.add
            local.get 2
            i32.const 1
            i32.sub
            i32.const 2047
            i32.and
            local.tee 1
            i32.const 2
            i32.shl
            i32.add
            i32.load
            i32.or
            i32.store
            local.get 1
            local.set 2
          end
          local.get 11
          i32.const 9
          i32.add
          local.set 11
          local.get 7
          i32.const 784
          i32.add
          local.get 8
          i32.const 2
          i32.shl
          i32.add
          local.get 13
          i32.store
          br 1 (;@2;)
        end
      end
      block  ;; label = @2
        loop  ;; label = @3
          local.get 2
          i32.const 1
          i32.add
          i32.const 2047
          i32.and
          local.set 6
          local.get 7
          i32.const 784
          i32.add
          local.get 2
          i32.const 1
          i32.sub
          i32.const 2047
          i32.and
          i32.const 2
          i32.shl
          i32.add
          local.set 22
          loop  ;; label = @4
            i32.const 9
            i32.const 1
            local.get 11
            i32.const 45
            i32.gt_s
            select
            local.set 14
            block  ;; label = @5
              loop  ;; label = @6
                local.get 8
                local.set 12
                i32.const 0
                local.set 1
                block  ;; label = @7
                  loop  ;; label = @8
                    block  ;; label = @9
                      local.get 1
                      local.get 12
                      i32.add
                      i32.const 2047
                      i32.and
                      local.tee 8
                      local.get 2
                      i32.eq
                      br_if 0 (;@9;)
                      local.get 7
                      i32.const 784
                      i32.add
                      local.get 8
                      i32.const 2
                      i32.shl
                      i32.add
                      i32.load
                      local.tee 8
                      local.get 1
                      i32.const 2
                      i32.shl
                      i32.const 1072
                      i32.add
                      i32.load
                      local.tee 13
                      i32.lt_u
                      br_if 0 (;@9;)
                      local.get 8
                      local.get 13
                      i32.gt_u
                      br_if 2 (;@7;)
                      local.get 1
                      i32.const 1
                      i32.add
                      local.tee 1
                      i32.const 4
                      i32.ne
                      br_if 1 (;@8;)
                    end
                  end
                  local.get 11
                  i32.const 36
                  i32.ne
                  br_if 0 (;@7;)
                  i64.const 0
                  local.set 9
                  i32.const 0
                  local.set 1
                  i64.const 0
                  local.set 10
                  loop  ;; label = @8
                    local.get 2
                    local.get 1
                    local.get 12
                    i32.add
                    i32.const 2047
                    i32.and
                    local.tee 8
                    i32.eq
                    if  ;; label = @9
                      local.get 2
                      i32.const 1
                      i32.add
                      i32.const 2047
                      i32.and
                      local.tee 2
                      i32.const 2
                      i32.shl
                      local.get 7
                      i32.add
                      i32.const 0
                      i32.store offset=780
                    end
                    local.get 7
                    i32.const 768
                    i32.add
                    local.get 9
                    local.get 10
                    i64.const 0
                    i64.const 4619810130798575616
                    call $__multf3
                    local.get 7
                    i32.const 752
                    i32.add
                    local.get 7
                    i32.const 784
                    i32.add
                    local.get 8
                    i32.const 2
                    i32.shl
                    i32.add
                    i32.load
                    call $__floatunsitf
                    local.get 7
                    i32.const 736
                    i32.add
                    local.get 7
                    i64.load offset=768
                    local.get 7
                    i64.load offset=776
                    local.get 7
                    i64.load offset=752
                    local.get 7
                    i64.load offset=760
                    call $__addtf3
                    local.get 7
                    i64.load offset=744
                    local.set 10
                    local.get 7
                    i64.load offset=736
                    local.set 9
                    local.get 1
                    i32.const 1
                    i32.add
                    local.tee 1
                    i32.const 4
                    i32.ne
                    br_if 0 (;@8;)
                  end
                  local.get 7
                  i32.const 720
                  i32.add
                  local.get 5
                  call $__floatsitf
                  local.get 7
                  i32.const 704
                  i32.add
                  local.get 9
                  local.get 10
                  local.get 7
                  i64.load offset=720
                  local.get 7
                  i64.load offset=728
                  call $__multf3
                  local.get 7
                  i64.load offset=712
                  local.set 10
                  i64.const 0
                  local.set 9
                  local.get 7
                  i64.load offset=704
                  local.set 16
                  local.get 15
                  i32.const 113
                  i32.add
                  local.tee 13
                  local.get 4
                  i32.sub
                  local.tee 1
                  i32.const 0
                  local.get 1
                  i32.const 0
                  i32.gt_s
                  select
                  local.get 3
                  local.get 1
                  local.get 3
                  i32.lt_s
                  local.tee 11
                  select
                  local.tee 8
                  i32.const 112
                  i32.le_s
                  br_if 2 (;@5;)
                  br 5 (;@2;)
                end
                local.get 14
                local.get 15
                i32.add
                local.set 15
                local.get 2
                local.set 8
                local.get 2
                local.get 12
                i32.eq
                br_if 0 (;@6;)
              end
              i32.const 1000000000
              local.get 14
              i32.shr_u
              local.set 18
              i32.const -1
              local.get 14
              i32.shl
              i32.const -1
              i32.xor
              local.set 21
              i32.const 0
              local.set 1
              local.get 12
              local.set 8
              loop  ;; label = @6
                local.get 7
                i32.const 784
                i32.add
                local.get 12
                i32.const 2
                i32.shl
                i32.add
                local.tee 13
                local.get 13
                i32.load
                local.tee 13
                local.get 14
                i32.shr_u
                local.get 1
                i32.add
                local.tee 1
                i32.store
                local.get 8
                i32.const 1
                i32.add
                i32.const 2047
                i32.and
                local.get 8
                local.get 1
                i32.eqz
                local.get 8
                local.get 12
                i32.eq
                i32.and
                local.tee 1
                select
                local.set 8
                local.get 11
                i32.const 9
                i32.sub
                local.get 11
                local.get 1
                select
                local.set 11
                local.get 13
                local.get 21
                i32.and
                local.get 18
                i32.mul
                local.set 1
                local.get 12
                i32.const 1
                i32.add
                i32.const 2047
                i32.and
                local.tee 12
                local.get 2
                i32.ne
                br_if 0 (;@6;)
              end
              local.get 1
              i32.eqz
              br_if 1 (;@4;)
              local.get 6
              local.get 8
              i32.ne
              if  ;; label = @6
                local.get 7
                i32.const 784
                i32.add
                local.get 2
                i32.const 2
                i32.shl
                i32.add
                local.get 1
                i32.store
                local.get 6
                local.set 2
                br 3 (;@3;)
              end
              local.get 22
              local.get 22
              i32.load
              i32.const 1
              i32.or
              i32.store
              local.get 6
              local.set 8
              br 1 (;@4;)
            end
          end
        end
        local.get 7
        i32.const 656
        i32.add
        f64.const 0x1p+0 (;=1;)
        i32.const 225
        local.get 8
        i32.sub
        call $scalbn
        call $__extenddftf2
        local.get 7
        i32.const 688
        i32.add
        local.get 7
        i64.load offset=656
        local.get 7
        i64.load offset=664
        local.get 16
        local.get 10
        call $copysignl
        local.get 7
        i64.load offset=696
        local.set 20
        local.get 7
        i64.load offset=688
        local.set 19
        local.get 7
        i32.const 640
        i32.add
        f64.const 0x1p+0 (;=1;)
        i32.const 113
        local.get 8
        i32.sub
        call $scalbn
        call $__extenddftf2
        local.get 7
        i32.const 672
        i32.add
        local.get 16
        local.get 10
        local.get 7
        i64.load offset=640
        local.get 7
        i64.load offset=648
        call $fmodl
        local.get 7
        i32.const 624
        i32.add
        local.get 16
        local.get 10
        local.get 7
        i64.load offset=672
        local.tee 9
        local.get 7
        i64.load offset=680
        local.tee 17
        call $__subtf3
        local.get 7
        i32.const 608
        i32.add
        local.get 19
        local.get 20
        local.get 7
        i64.load offset=624
        local.get 7
        i64.load offset=632
        call $__addtf3
        local.get 7
        i64.load offset=616
        local.set 10
        local.get 7
        i64.load offset=608
        local.set 16
      end
      block  ;; label = @2
        local.get 12
        i32.const 4
        i32.add
        i32.const 2047
        i32.and
        local.tee 14
        local.get 2
        i32.eq
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 7
          i32.const 784
          i32.add
          local.get 14
          i32.const 2
          i32.shl
          i32.add
          i32.load
          local.tee 14
          i32.const 499999999
          i32.le_u
          if  ;; label = @4
            local.get 14
            i32.const 1
            local.get 12
            i32.const 5
            i32.add
            i32.const 2047
            i32.and
            local.get 2
            i32.eq
            select
            i32.eqz
            br_if 1 (;@3;)
            local.get 7
            i32.const 496
            i32.add
            local.get 5
            f64.convert_i32_s
            f64.const 0x1p-2 (;=0.25;)
            f64.mul
            call $__extenddftf2
            local.get 7
            i32.const 480
            i32.add
            local.get 9
            local.get 17
            local.get 7
            i64.load offset=496
            local.get 7
            i64.load offset=504
            call $__addtf3
            local.get 7
            i64.load offset=488
            local.set 17
            local.get 7
            i64.load offset=480
            local.set 9
            br 1 (;@3;)
          end
          local.get 14
          i32.const 500000000
          i32.ne
          if  ;; label = @4
            local.get 7
            i32.const 592
            i32.add
            local.get 5
            f64.convert_i32_s
            f64.const 0x1.8p-1 (;=0.75;)
            f64.mul
            call $__extenddftf2
            local.get 7
            i32.const 576
            i32.add
            local.get 9
            local.get 17
            local.get 7
            i64.load offset=592
            local.get 7
            i64.load offset=600
            call $__addtf3
            local.get 7
            i64.load offset=584
            local.set 17
            local.get 7
            i64.load offset=576
            local.set 9
            br 1 (;@3;)
          end
          local.get 5
          f64.convert_i32_s
          local.set 23
          local.get 2
          local.get 12
          i32.const 5
          i32.add
          i32.const 2047
          i32.and
          i32.eq
          if  ;; label = @4
            local.get 7
            i32.const 528
            i32.add
            local.get 23
            f64.const 0x1p-1 (;=0.5;)
            f64.mul
            call $__extenddftf2
            local.get 7
            i32.const 512
            i32.add
            local.get 9
            local.get 17
            local.get 7
            i64.load offset=528
            local.get 7
            i64.load offset=536
            call $__addtf3
            local.get 7
            i64.load offset=520
            local.set 17
            local.get 7
            i64.load offset=512
            local.set 9
            br 1 (;@3;)
          end
          local.get 7
          i32.const 560
          i32.add
          local.get 23
          f64.const 0x1.8p-1 (;=0.75;)
          f64.mul
          call $__extenddftf2
          local.get 7
          i32.const 544
          i32.add
          local.get 9
          local.get 17
          local.get 7
          i64.load offset=560
          local.get 7
          i64.load offset=568
          call $__addtf3
          local.get 7
          i64.load offset=552
          local.set 17
          local.get 7
          i64.load offset=544
          local.set 9
        end
        local.get 8
        i32.const 111
        i32.gt_s
        br_if 0 (;@2;)
        local.get 7
        i32.const 464
        i32.add
        local.get 9
        local.get 17
        i64.const 0
        i64.const 4611404543450677248
        call $fmodl
        local.get 7
        i64.load offset=464
        local.get 7
        i64.load offset=472
        i64.const 0
        i64.const 0
        call $__letf2
        br_if 0 (;@2;)
        local.get 7
        i32.const 448
        i32.add
        local.get 9
        local.get 17
        i64.const 0
        i64.const 4611404543450677248
        call $__addtf3
        local.get 7
        i64.load offset=456
        local.set 17
        local.get 7
        i64.load offset=448
        local.set 9
      end
      local.get 7
      i32.const 432
      i32.add
      local.get 16
      local.get 10
      local.get 9
      local.get 17
      call $__addtf3
      local.get 7
      i32.const 416
      i32.add
      local.get 7
      i64.load offset=432
      local.get 7
      i64.load offset=440
      local.get 19
      local.get 20
      call $__subtf3
      local.get 7
      i64.load offset=424
      local.set 10
      local.get 7
      i64.load offset=416
      local.set 16
      block  ;; label = @2
        i32.const -2
        local.get 24
        i32.sub
        local.get 13
        i32.const 2147483647
        i32.and
        i32.ge_s
        br_if 0 (;@2;)
        local.get 7
        i32.const 400
        i32.add
        local.get 16
        local.get 10
        call $fabsl
        local.get 7
        i32.const 384
        i32.add
        local.get 16
        local.get 10
        i64.const 0
        i64.const 4611123068473966592
        call $__multf3
        local.get 7
        i64.load offset=400
        local.tee 19
        local.get 7
        i64.load offset=408
        local.tee 20
        i64.const 0
        i64.const 4643211215818981376
        call $__getf2
        local.set 2
        local.get 10
        local.get 7
        i64.load offset=392
        local.get 2
        i32.const 0
        i32.lt_s
        local.tee 13
        select
        local.set 10
        local.get 16
        local.get 7
        i64.load offset=384
        local.get 13
        select
        local.set 16
        local.get 25
        local.get 15
        local.get 2
        i32.const -1
        i32.gt_s
        i32.add
        local.tee 15
        i32.const 110
        i32.add
        i32.ge_s
        if  ;; label = @3
          local.get 11
          local.get 11
          local.get 1
          local.get 8
          i32.ne
          i32.and
          local.get 19
          local.get 20
          i64.const 0
          i64.const 4643211215818981376
          call $__getf2
          i32.const 0
          i32.lt_s
          select
          i32.const 1
          i32.ne
          br_if 1 (;@2;)
          local.get 9
          local.get 17
          i64.const 0
          i64.const 0
          call $__letf2
          i32.eqz
          br_if 1 (;@2;)
        end
        call $__errno_location
        i32.const 68
        i32.store
      end
      local.get 7
      i32.const 368
      i32.add
      local.get 16
      local.get 10
      local.get 15
      call $scalbnl
      local.get 7
      i64.load offset=368
      local.set 10
      local.get 7
      i64.load offset=376
    end
    local.set 9
    local.get 0
    local.get 10
    i64.store
    local.get 0
    local.get 9
    i64.store offset=8
    local.get 7
    i32.const 8976
    i32.add
    global.set 0)
  (func $scanexp (type 19) (param i32 i32) (result i64)
    (local i32 i32 i64 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block (result i32)  ;; label = @4
            local.get 0
            i32.load offset=4
            local.tee 2
            local.get 0
            i32.load offset=104
            i32.lt_u
            if  ;; label = @5
              local.get 0
              local.get 2
              i32.const 1
              i32.add
              i32.store offset=4
              local.get 2
              i32.load8_u
              br 1 (;@4;)
            end
            local.get 0
            call $__shgetc
          end
          local.tee 2
          i32.const 43
          i32.sub
          br_table 1 (;@2;) 0 (;@3;) 1 (;@2;) 0 (;@3;)
        end
        local.get 2
        i32.const 48
        i32.sub
        local.set 5
        br 1 (;@1;)
      end
      block (result i32)  ;; label = @2
        local.get 0
        i32.load offset=4
        local.tee 3
        local.get 0
        i32.load offset=104
        i32.lt_u
        if  ;; label = @3
          local.get 0
          local.get 3
          i32.const 1
          i32.add
          i32.store offset=4
          local.get 3
          i32.load8_u
          br 1 (;@2;)
        end
        local.get 0
        call $__shgetc
      end
      local.set 3
      local.get 2
      i32.const 45
      i32.eq
      local.set 6
      block  ;; label = @2
        local.get 3
        i32.const 48
        i32.sub
        local.tee 5
        i32.const 10
        i32.lt_u
        br_if 0 (;@2;)
        local.get 1
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.load offset=104
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        local.get 0
        i32.load offset=4
        i32.const 1
        i32.sub
        i32.store offset=4
      end
      local.get 3
      local.set 2
    end
    block  ;; label = @1
      local.get 5
      i32.const 10
      i32.lt_u
      if  ;; label = @2
        i32.const 0
        local.set 3
        loop  ;; label = @3
          local.get 2
          local.get 3
          i32.const 10
          i32.mul
          i32.add
          local.set 3
          block (result i32)  ;; label = @4
            local.get 0
            i32.load offset=4
            local.tee 2
            local.get 0
            i32.load offset=104
            i32.lt_u
            if  ;; label = @5
              local.get 0
              local.get 2
              i32.const 1
              i32.add
              i32.store offset=4
              local.get 2
              i32.load8_u
              br 1 (;@4;)
            end
            local.get 0
            call $__shgetc
          end
          local.tee 2
          i32.const 48
          i32.sub
          local.tee 5
          i32.const 9
          i32.le_u
          i32.const 0
          local.get 3
          i32.const 48
          i32.sub
          local.tee 3
          i32.const 214748364
          i32.lt_s
          select
          br_if 0 (;@3;)
        end
        local.get 3
        i64.extend_i32_s
        local.set 4
        block  ;; label = @3
          local.get 5
          i32.const 10
          i32.ge_u
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 2
            i64.extend_i32_u
            local.get 4
            i64.const 10
            i64.mul
            i64.add
            local.set 4
            block (result i32)  ;; label = @5
              local.get 0
              i32.load offset=4
              local.tee 2
              local.get 0
              i32.load offset=104
              i32.lt_u
              if  ;; label = @6
                local.get 0
                local.get 2
                i32.const 1
                i32.add
                i32.store offset=4
                local.get 2
                i32.load8_u
                br 1 (;@5;)
              end
              local.get 0
              call $__shgetc
            end
            local.set 2
            local.get 4
            i64.const 48
            i64.sub
            local.set 4
            local.get 2
            i32.const 48
            i32.sub
            local.tee 5
            i32.const 9
            i32.gt_u
            br_if 1 (;@3;)
            local.get 4
            i64.const 92233720368547758
            i64.lt_s
            br_if 0 (;@4;)
          end
        end
        local.get 5
        i32.const 10
        i32.lt_u
        if  ;; label = @3
          loop  ;; label = @4
            block (result i32)  ;; label = @5
              local.get 0
              i32.load offset=4
              local.tee 2
              local.get 0
              i32.load offset=104
              i32.lt_u
              if  ;; label = @6
                local.get 0
                local.get 2
                i32.const 1
                i32.add
                i32.store offset=4
                local.get 2
                i32.load8_u
                br 1 (;@5;)
              end
              local.get 0
              call $__shgetc
            end
            local.tee 2
            i32.const 48
            i32.sub
            i32.const 10
            i32.lt_u
            br_if 0 (;@4;)
          end
        end
        local.get 0
        i32.load offset=104
        if  ;; label = @3
          local.get 0
          local.get 0
          i32.load offset=4
          i32.const 1
          i32.sub
          i32.store offset=4
        end
        i64.const 0
        local.get 4
        i64.sub
        local.get 4
        local.get 6
        select
        local.set 4
        br 1 (;@1;)
      end
      i64.const -9223372036854775808
      local.set 4
      local.get 0
      i32.load offset=104
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 0
      i32.load offset=4
      i32.const 1
      i32.sub
      i32.store offset=4
      i64.const -9223372036854775808
      return
    end
    local.get 4)
  (func $__intscan (type 20) (param i32 i32 i32 i64) (result i64)
    (local i32 i64 i32 i64 i64 i32 i32 i64 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 10
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 1
                i32.const 36
                i32.le_u
                if  ;; label = @7
                  loop  ;; label = @8
                    block (result i32)  ;; label = @9
                      local.get 0
                      i32.load offset=4
                      local.tee 4
                      local.get 0
                      i32.load offset=104
                      i32.lt_u
                      if  ;; label = @10
                        local.get 0
                        local.get 4
                        i32.const 1
                        i32.add
                        i32.store offset=4
                        local.get 4
                        i32.load8_u
                        br 1 (;@9;)
                      end
                      local.get 0
                      call $__shgetc
                    end
                    local.tee 4
                    call $isspace
                    br_if 0 (;@8;)
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 4
                      i32.const 43
                      i32.sub
                      br_table 0 (;@9;) 1 (;@8;) 0 (;@9;) 1 (;@8;)
                    end
                    i32.const -1
                    i32.const 0
                    local.get 4
                    i32.const 45
                    i32.eq
                    select
                    local.set 9
                    local.get 0
                    i32.load offset=4
                    local.tee 4
                    local.get 0
                    i32.load offset=104
                    i32.lt_u
                    if  ;; label = @9
                      local.get 0
                      local.get 4
                      i32.const 1
                      i32.add
                      i32.store offset=4
                      local.get 4
                      i32.load8_u
                      local.set 4
                      br 1 (;@8;)
                    end
                    local.get 0
                    call $__shgetc
                    local.set 4
                  end
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 1
                      i32.const -17
                      i32.and
                      br_if 0 (;@9;)
                      local.get 4
                      i32.const 48
                      i32.ne
                      br_if 0 (;@9;)
                      block (result i32)  ;; label = @10
                        local.get 0
                        i32.load offset=4
                        local.tee 4
                        local.get 0
                        i32.load offset=104
                        i32.lt_u
                        if  ;; label = @11
                          local.get 0
                          local.get 4
                          i32.const 1
                          i32.add
                          i32.store offset=4
                          local.get 4
                          i32.load8_u
                          br 1 (;@10;)
                        end
                        local.get 0
                        call $__shgetc
                      end
                      local.tee 4
                      i32.const -33
                      i32.and
                      i32.const 88
                      i32.eq
                      if  ;; label = @10
                        block (result i32)  ;; label = @11
                          local.get 0
                          i32.load offset=4
                          local.tee 4
                          local.get 0
                          i32.load offset=104
                          i32.lt_u
                          if  ;; label = @12
                            local.get 0
                            local.get 4
                            i32.const 1
                            i32.add
                            i32.store offset=4
                            local.get 4
                            i32.load8_u
                            br 1 (;@11;)
                          end
                          local.get 0
                          call $__shgetc
                        end
                        local.set 4
                        i32.const 16
                        local.set 1
                        local.get 4
                        i32.const 1153
                        i32.add
                        i32.load8_u
                        i32.const 16
                        i32.lt_u
                        br_if 5 (;@5;)
                        local.get 0
                        i32.load offset=104
                        i32.eqz
                        if  ;; label = @11
                          i64.const 0
                          local.set 3
                          local.get 2
                          br_if 10 (;@1;)
                          br 9 (;@2;)
                        end
                        local.get 0
                        local.get 0
                        i32.load offset=4
                        local.tee 4
                        i32.const 1
                        i32.sub
                        i32.store offset=4
                        local.get 2
                        i32.eqz
                        br_if 8 (;@2;)
                        local.get 0
                        local.get 4
                        i32.const 2
                        i32.sub
                        i32.store offset=4
                        i64.const 0
                        local.set 3
                        br 9 (;@1;)
                      end
                      local.get 1
                      br_if 1 (;@8;)
                      i32.const 8
                      local.set 1
                      br 4 (;@5;)
                    end
                    local.get 1
                    i32.const 10
                    local.get 1
                    select
                    local.tee 1
                    local.get 4
                    i32.const 1153
                    i32.add
                    i32.load8_u
                    i32.gt_u
                    br_if 0 (;@8;)
                    local.get 0
                    i32.load offset=104
                    if  ;; label = @9
                      local.get 0
                      local.get 0
                      i32.load offset=4
                      i32.const 1
                      i32.sub
                      i32.store offset=4
                    end
                    i64.const 0
                    local.set 3
                    local.get 0
                    i64.const 0
                    call $__shlim
                    call $__errno_location
                    i32.const 28
                    i32.store
                    br 7 (;@1;)
                  end
                  local.get 1
                  i32.const 10
                  i32.ne
                  br_if 2 (;@5;)
                  local.get 4
                  i32.const 48
                  i32.sub
                  local.tee 2
                  i32.const 9
                  i32.le_u
                  if  ;; label = @8
                    i32.const 0
                    local.set 1
                    loop  ;; label = @9
                      local.get 1
                      i32.const 10
                      i32.mul
                      local.set 1
                      block (result i32)  ;; label = @10
                        local.get 0
                        i32.load offset=4
                        local.tee 4
                        local.get 0
                        i32.load offset=104
                        i32.lt_u
                        if  ;; label = @11
                          local.get 0
                          local.get 4
                          i32.const 1
                          i32.add
                          i32.store offset=4
                          local.get 4
                          i32.load8_u
                          br 1 (;@10;)
                        end
                        local.get 0
                        call $__shgetc
                      end
                      local.set 4
                      local.get 1
                      local.get 2
                      i32.add
                      local.set 1
                      local.get 4
                      i32.const 48
                      i32.sub
                      local.tee 2
                      i32.const 9
                      i32.le_u
                      i32.const 0
                      local.get 1
                      i32.const 429496729
                      i32.lt_u
                      select
                      br_if 0 (;@9;)
                    end
                    local.get 1
                    i64.extend_i32_u
                    local.set 5
                  end
                  local.get 2
                  i32.const 9
                  i32.gt_u
                  br_if 1 (;@6;)
                  local.get 5
                  i64.const 10
                  i64.mul
                  local.set 7
                  local.get 2
                  i64.extend_i32_u
                  local.set 8
                  loop  ;; label = @8
                    block (result i32)  ;; label = @9
                      local.get 0
                      i32.load offset=4
                      local.tee 4
                      local.get 0
                      i32.load offset=104
                      i32.lt_u
                      if  ;; label = @10
                        local.get 0
                        local.get 4
                        i32.const 1
                        i32.add
                        i32.store offset=4
                        local.get 4
                        i32.load8_u
                        br 1 (;@9;)
                      end
                      local.get 0
                      call $__shgetc
                    end
                    local.set 4
                    local.get 7
                    local.get 8
                    i64.add
                    local.set 5
                    local.get 4
                    i32.const 48
                    i32.sub
                    local.tee 2
                    i32.const 9
                    i32.gt_u
                    br_if 2 (;@6;)
                    local.get 5
                    i64.const 1844674407370955162
                    i64.ge_u
                    br_if 2 (;@6;)
                    local.get 5
                    i64.const 10
                    i64.mul
                    local.tee 7
                    local.get 2
                    i64.extend_i32_u
                    local.tee 8
                    i64.const -1
                    i64.xor
                    i64.le_u
                    br_if 0 (;@8;)
                  end
                  i32.const 10
                  local.set 1
                  br 3 (;@4;)
                end
                call $__errno_location
                i32.const 28
                i32.store
                i64.const 0
                local.set 3
                br 5 (;@1;)
              end
              i32.const 10
              local.set 1
              local.get 2
              i32.const 9
              i32.le_u
              br_if 1 (;@4;)
              br 2 (;@3;)
            end
            local.get 1
            local.get 1
            i32.const 1
            i32.sub
            i32.and
            if  ;; label = @5
              local.get 4
              i32.const 1153
              i32.add
              i32.load8_u
              local.tee 6
              local.get 1
              i32.lt_u
              if  ;; label = @6
                i32.const 0
                local.set 2
                loop  ;; label = @7
                  local.get 1
                  local.get 2
                  i32.mul
                  local.set 2
                  block (result i32)  ;; label = @8
                    local.get 0
                    i32.load offset=4
                    local.tee 4
                    local.get 0
                    i32.load offset=104
                    i32.lt_u
                    if  ;; label = @9
                      local.get 0
                      local.get 4
                      i32.const 1
                      i32.add
                      i32.store offset=4
                      local.get 4
                      i32.load8_u
                      br 1 (;@8;)
                    end
                    local.get 0
                    call $__shgetc
                  end
                  local.set 4
                  local.get 2
                  local.get 6
                  i32.add
                  local.set 2
                  local.get 4
                  i32.const 1153
                  i32.add
                  i32.load8_u
                  local.tee 6
                  local.get 1
                  i32.lt_u
                  i32.const 0
                  local.get 2
                  i32.const 119304647
                  i32.lt_u
                  select
                  br_if 0 (;@7;)
                end
                local.get 2
                i64.extend_i32_u
                local.set 5
              end
              local.get 1
              local.get 6
              i32.le_u
              br_if 1 (;@4;)
              local.get 1
              i64.extend_i32_u
              local.set 7
              loop  ;; label = @6
                local.get 5
                local.get 7
                i64.mul
                local.tee 8
                local.get 6
                i64.extend_i32_u
                i64.const 255
                i64.and
                local.tee 11
                i64.const -1
                i64.xor
                i64.gt_u
                br_if 2 (;@4;)
                block (result i32)  ;; label = @7
                  local.get 0
                  i32.load offset=4
                  local.tee 4
                  local.get 0
                  i32.load offset=104
                  i32.lt_u
                  if  ;; label = @8
                    local.get 0
                    local.get 4
                    i32.const 1
                    i32.add
                    i32.store offset=4
                    local.get 4
                    i32.load8_u
                    br 1 (;@7;)
                  end
                  local.get 0
                  call $__shgetc
                end
                local.set 4
                local.get 8
                local.get 11
                i64.add
                local.set 5
                local.get 1
                local.get 4
                i32.const 1153
                i32.add
                i32.load8_u
                local.tee 6
                i32.le_u
                br_if 2 (;@4;)
                local.get 10
                local.get 7
                i64.const 0
                local.get 5
                i64.const 0
                call $__multi3
                local.get 10
                i64.load offset=8
                i64.eqz
                br_if 0 (;@6;)
              end
              br 1 (;@4;)
            end
            local.get 1
            i32.const 23
            i32.mul
            i32.const 5
            i32.shr_u
            i32.const 7
            i32.and
            i32.const 1409
            i32.add
            i32.load8_s
            local.set 12
            local.get 4
            i32.const 1153
            i32.add
            i32.load8_u
            local.tee 2
            local.get 1
            i32.lt_u
            if  ;; label = @5
              loop  ;; label = @6
                local.get 6
                local.get 12
                i32.shl
                local.set 6
                block (result i32)  ;; label = @7
                  local.get 0
                  i32.load offset=4
                  local.tee 4
                  local.get 0
                  i32.load offset=104
                  i32.lt_u
                  if  ;; label = @8
                    local.get 0
                    local.get 4
                    i32.const 1
                    i32.add
                    i32.store offset=4
                    local.get 4
                    i32.load8_u
                    br 1 (;@7;)
                  end
                  local.get 0
                  call $__shgetc
                end
                local.set 4
                local.get 2
                local.get 6
                i32.or
                local.set 6
                local.get 4
                i32.const 1153
                i32.add
                i32.load8_u
                local.tee 2
                local.get 1
                i32.lt_u
                i32.const 0
                local.get 6
                i32.const 134217728
                i32.lt_u
                select
                br_if 0 (;@6;)
              end
              local.get 6
              i64.extend_i32_u
              local.set 5
            end
            local.get 1
            local.get 2
            i32.le_u
            br_if 0 (;@4;)
            i64.const -1
            local.get 12
            i64.extend_i32_u
            local.tee 8
            i64.shr_u
            local.tee 11
            local.get 5
            i64.lt_u
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 5
              local.get 8
              i64.shl
              local.set 5
              local.get 2
              i64.extend_i32_u
              i64.const 255
              i64.and
              local.set 7
              block (result i32)  ;; label = @6
                local.get 0
                i32.load offset=4
                local.tee 4
                local.get 0
                i32.load offset=104
                i32.lt_u
                if  ;; label = @7
                  local.get 0
                  local.get 4
                  i32.const 1
                  i32.add
                  i32.store offset=4
                  local.get 4
                  i32.load8_u
                  br 1 (;@6;)
                end
                local.get 0
                call $__shgetc
              end
              local.set 4
              local.get 5
              local.get 7
              i64.or
              local.set 5
              local.get 1
              local.get 4
              i32.const 1153
              i32.add
              i32.load8_u
              local.tee 2
              i32.le_u
              br_if 1 (;@4;)
              local.get 5
              local.get 11
              i64.le_u
              br_if 0 (;@5;)
            end
          end
          local.get 1
          local.get 4
          i32.const 1153
          i32.add
          i32.load8_u
          i32.le_u
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 1
            block (result i32)  ;; label = @5
              local.get 0
              i32.load offset=4
              local.tee 4
              local.get 0
              i32.load offset=104
              i32.lt_u
              if  ;; label = @6
                local.get 0
                local.get 4
                i32.const 1
                i32.add
                i32.store offset=4
                local.get 4
                i32.load8_u
                br 1 (;@5;)
              end
              local.get 0
              call $__shgetc
            end
            local.tee 4
            i32.const 1153
            i32.add
            i32.load8_u
            i32.gt_u
            br_if 0 (;@4;)
          end
          call $__errno_location
          i32.const 68
          i32.store
          local.get 9
          i32.const 0
          local.get 3
          i64.const 1
          i64.and
          i64.eqz
          select
          local.set 9
          local.get 3
          local.set 5
        end
        local.get 0
        i32.load offset=104
        if  ;; label = @3
          local.get 0
          local.get 0
          i32.load offset=4
          i32.const 1
          i32.sub
          i32.store offset=4
        end
        block  ;; label = @3
          local.get 3
          local.get 5
          i64.gt_u
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 3
            i32.wrap_i64
            i32.const 1
            i32.and
            br_if 0 (;@4;)
            local.get 9
            br_if 0 (;@4;)
            call $__errno_location
            i32.const 68
            i32.store
            local.get 3
            i64.const 1
            i64.sub
            local.set 3
            br 3 (;@1;)
          end
          local.get 3
          local.get 5
          i64.ge_u
          br_if 0 (;@3;)
          call $__errno_location
          i32.const 68
          i32.store
          br 2 (;@1;)
        end
        local.get 5
        local.get 9
        i64.extend_i32_s
        local.tee 3
        i64.xor
        local.get 3
        i64.sub
        local.set 3
        br 1 (;@1;)
      end
      i64.const 0
      local.set 3
      local.get 0
      i64.const 0
      call $__shlim
    end
    local.get 10
    i32.const 16
    i32.add
    global.set 0
    local.get 3)
  (func $vfscanf (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i64 i32 i64 i32 i32 i32 i64 i32 i32)
    global.get 0
    i32.const 304
    i32.sub
    local.tee 5
    global.set 0
    local.get 0
    i32.load offset=76
    i32.const 0
    i32.ge_s
    if  ;; label = @1
      local.get 0
      call $__lockfile
      local.set 19
    end
    block  ;; label = @1
      local.get 1
      i32.load8_u
      local.tee 4
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              loop  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 4
                    i32.const 255
                    i32.and
                    call $isspace
                    if  ;; label = @9
                      loop  ;; label = @10
                        local.get 1
                        local.tee 4
                        i32.const 1
                        i32.add
                        local.set 1
                        local.get 4
                        i32.load8_u offset=1
                        call $isspace
                        br_if 0 (;@10;)
                      end
                      local.get 0
                      i64.const 0
                      call $__shlim
                      loop  ;; label = @10
                        block (result i32)  ;; label = @11
                          local.get 0
                          i32.load offset=4
                          local.tee 1
                          local.get 0
                          i32.load offset=104
                          i32.lt_u
                          if  ;; label = @12
                            local.get 0
                            local.get 1
                            i32.const 1
                            i32.add
                            i32.store offset=4
                            local.get 1
                            i32.load8_u
                            br 1 (;@11;)
                          end
                          local.get 0
                          call $__shgetc
                        end
                        local.tee 1
                        call $isspace
                        br_if 0 (;@10;)
                      end
                      local.get 0
                      i32.load offset=4
                      local.set 1
                      local.get 0
                      i32.load offset=104
                      if  ;; label = @10
                        local.get 0
                        local.get 1
                        i32.const 1
                        i32.sub
                        local.tee 1
                        i32.store offset=4
                      end
                      local.get 1
                      local.get 0
                      i32.load offset=8
                      i32.sub
                      i64.extend_i32_s
                      local.get 0
                      i64.load offset=120
                      local.get 11
                      i64.add
                      i64.add
                      local.set 11
                      br 1 (;@8;)
                    end
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 1
                          i32.load8_u
                          local.tee 4
                          i32.const 37
                          i32.eq
                          if  ;; label = @12
                            local.get 1
                            i32.load8_u offset=1
                            local.tee 3
                            i32.const 42
                            i32.eq
                            br_if 1 (;@11;)
                            local.get 3
                            i32.const 37
                            i32.ne
                            br_if 2 (;@10;)
                          end
                          local.get 0
                          i64.const 0
                          call $__shlim
                          local.get 1
                          local.get 4
                          i32.const 37
                          i32.eq
                          i32.add
                          local.set 4
                          block (result i32)  ;; label = @12
                            local.get 0
                            i32.load offset=4
                            local.tee 1
                            local.get 0
                            i32.load offset=104
                            i32.lt_u
                            if  ;; label = @13
                              local.get 0
                              local.get 1
                              i32.const 1
                              i32.add
                              i32.store offset=4
                              local.get 1
                              i32.load8_u
                              br 1 (;@12;)
                            end
                            local.get 0
                            call $__shgetc
                          end
                          local.tee 1
                          local.get 4
                          i32.load8_u
                          i32.ne
                          if  ;; label = @12
                            local.get 0
                            i32.load offset=104
                            if  ;; label = @13
                              local.get 0
                              local.get 0
                              i32.load offset=4
                              i32.const 1
                              i32.sub
                              i32.store offset=4
                            end
                            local.get 1
                            i32.const -1
                            i32.gt_s
                            br_if 11 (;@1;)
                            i32.const 0
                            local.set 14
                            local.get 15
                            br_if 11 (;@1;)
                            br 9 (;@3;)
                          end
                          local.get 11
                          i64.const 1
                          i64.add
                          local.set 11
                          br 3 (;@8;)
                        end
                        local.get 1
                        i32.const 2
                        i32.add
                        local.set 4
                        i32.const 0
                        local.set 7
                        br 1 (;@9;)
                      end
                      block  ;; label = @10
                        local.get 3
                        call $isdigit
                        i32.eqz
                        br_if 0 (;@10;)
                        local.get 1
                        i32.load8_u offset=2
                        i32.const 36
                        i32.ne
                        br_if 0 (;@10;)
                        local.get 1
                        i32.const 3
                        i32.add
                        local.set 4
                        local.get 2
                        local.get 1
                        i32.load8_u offset=1
                        i32.const 48
                        i32.sub
                        call $arg_n
                        local.set 7
                        br 1 (;@9;)
                      end
                      local.get 1
                      i32.const 1
                      i32.add
                      local.set 4
                      local.get 2
                      i32.load
                      local.set 7
                      local.get 2
                      i32.const 4
                      i32.add
                      local.set 2
                    end
                    i32.const 0
                    local.set 14
                    i32.const 0
                    local.set 1
                    local.get 4
                    i32.load8_u
                    call $isdigit
                    if  ;; label = @9
                      loop  ;; label = @10
                        local.get 4
                        i32.load8_u
                        local.get 1
                        i32.const 10
                        i32.mul
                        i32.add
                        i32.const 48
                        i32.sub
                        local.set 1
                        local.get 4
                        i32.load8_u offset=1
                        local.set 3
                        local.get 4
                        i32.const 1
                        i32.add
                        local.set 4
                        local.get 3
                        call $isdigit
                        br_if 0 (;@10;)
                      end
                    end
                    local.get 4
                    i32.load8_u
                    local.tee 10
                    i32.const 109
                    i32.ne
                    if (result i32)  ;; label = @9
                      local.get 4
                    else
                      i32.const 0
                      local.set 8
                      local.get 7
                      i32.const 0
                      i32.ne
                      local.set 14
                      local.get 4
                      i32.load8_u offset=1
                      local.set 10
                      i32.const 0
                      local.set 9
                      local.get 4
                      i32.const 1
                      i32.add
                    end
                    local.tee 3
                    i32.const 1
                    i32.add
                    local.set 4
                    i32.const 3
                    local.set 6
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block  ;; label = @13
                              block  ;; label = @14
                                local.get 10
                                i32.const 255
                                i32.and
                                i32.const 65
                                i32.sub
                                br_table 4 (;@10;) 10 (;@4;) 4 (;@10;) 10 (;@4;) 4 (;@10;) 4 (;@10;) 4 (;@10;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 3 (;@11;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 4 (;@10;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 4 (;@10;) 10 (;@4;) 10 (;@4;) 4 (;@10;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 10 (;@4;) 4 (;@10;) 10 (;@4;) 4 (;@10;) 4 (;@10;) 4 (;@10;) 4 (;@10;) 4 (;@10;) 0 (;@14;) 4 (;@10;) 5 (;@9;) 10 (;@4;) 1 (;@13;) 10 (;@4;) 4 (;@10;) 4 (;@10;) 4 (;@10;) 10 (;@4;) 10 (;@4;) 4 (;@10;) 2 (;@12;) 4 (;@10;) 10 (;@4;) 10 (;@4;) 4 (;@10;) 10 (;@4;) 2 (;@12;) 10 (;@4;)
                              end
                              local.get 3
                              i32.const 2
                              i32.add
                              local.get 4
                              local.get 3
                              i32.load8_u offset=1
                              i32.const 104
                              i32.eq
                              local.tee 3
                              select
                              local.set 4
                              i32.const -2
                              i32.const -1
                              local.get 3
                              select
                              local.set 6
                              br 4 (;@9;)
                            end
                            local.get 3
                            i32.const 2
                            i32.add
                            local.get 4
                            local.get 3
                            i32.load8_u offset=1
                            i32.const 108
                            i32.eq
                            local.tee 3
                            select
                            local.set 4
                            i32.const 3
                            i32.const 1
                            local.get 3
                            select
                            local.set 6
                            br 3 (;@9;)
                          end
                          i32.const 1
                          local.set 6
                          br 2 (;@9;)
                        end
                        i32.const 2
                        local.set 6
                        br 1 (;@9;)
                      end
                      i32.const 0
                      local.set 6
                      local.get 3
                      local.set 4
                    end
                    i32.const 1
                    local.get 6
                    local.get 4
                    i32.load8_u
                    local.tee 3
                    i32.const 47
                    i32.and
                    i32.const 3
                    i32.eq
                    local.tee 10
                    select
                    local.set 16
                    block  ;; label = @9
                      local.get 3
                      i32.const 32
                      i32.or
                      local.get 3
                      local.get 10
                      select
                      local.tee 12
                      i32.const 91
                      i32.eq
                      br_if 0 (;@9;)
                      block  ;; label = @10
                        local.get 12
                        i32.const 110
                        i32.ne
                        if  ;; label = @11
                          local.get 12
                          i32.const 99
                          i32.ne
                          br_if 1 (;@10;)
                          local.get 1
                          i32.const 1
                          local.get 1
                          i32.const 1
                          i32.gt_s
                          select
                          local.set 1
                          br 2 (;@9;)
                        end
                        local.get 7
                        local.get 16
                        local.get 11
                        call $store_int
                        br 2 (;@8;)
                      end
                      local.get 0
                      i64.const 0
                      call $__shlim
                      loop  ;; label = @10
                        block (result i32)  ;; label = @11
                          local.get 0
                          i32.load offset=4
                          local.tee 3
                          local.get 0
                          i32.load offset=104
                          i32.lt_u
                          if  ;; label = @12
                            local.get 0
                            local.get 3
                            i32.const 1
                            i32.add
                            i32.store offset=4
                            local.get 3
                            i32.load8_u
                            br 1 (;@11;)
                          end
                          local.get 0
                          call $__shgetc
                        end
                        local.tee 3
                        call $isspace
                        br_if 0 (;@10;)
                      end
                      local.get 0
                      i32.load offset=4
                      local.set 3
                      local.get 0
                      i32.load offset=104
                      if  ;; label = @10
                        local.get 0
                        local.get 3
                        i32.const 1
                        i32.sub
                        local.tee 3
                        i32.store offset=4
                      end
                      local.get 3
                      local.get 0
                      i32.load offset=8
                      i32.sub
                      i64.extend_i32_s
                      local.get 0
                      i64.load offset=120
                      local.get 11
                      i64.add
                      i64.add
                      local.set 11
                    end
                    local.get 0
                    local.get 1
                    i64.extend_i32_s
                    local.tee 13
                    call $__shlim
                    block  ;; label = @9
                      local.get 0
                      i32.load offset=4
                      local.tee 6
                      local.get 0
                      i32.load offset=104
                      local.tee 3
                      i32.lt_u
                      if  ;; label = @10
                        local.get 0
                        local.get 6
                        i32.const 1
                        i32.add
                        i32.store offset=4
                        br 1 (;@9;)
                      end
                      local.get 0
                      call $__shgetc
                      i32.const 0
                      i32.lt_s
                      br_if 5 (;@4;)
                      local.get 0
                      i32.load offset=104
                      local.set 3
                    end
                    local.get 3
                    if  ;; label = @9
                      local.get 0
                      local.get 0
                      i32.load offset=4
                      i32.const 1
                      i32.sub
                      i32.store offset=4
                    end
                    i32.const 16
                    local.set 3
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
                                            local.get 12
                                            i32.const 88
                                            i32.sub
                                            br_table 6 (;@14;) 11 (;@9;) 11 (;@9;) 2 (;@18;) 11 (;@9;) 11 (;@9;) 11 (;@9;) 11 (;@9;) 11 (;@9;) 1 (;@19;) 11 (;@9;) 2 (;@18;) 4 (;@16;) 1 (;@19;) 1 (;@19;) 1 (;@19;) 11 (;@9;) 5 (;@15;) 11 (;@9;) 11 (;@9;) 11 (;@9;) 11 (;@9;) 11 (;@9;) 3 (;@17;) 6 (;@14;) 11 (;@9;) 11 (;@9;) 2 (;@18;) 11 (;@9;) 4 (;@16;) 11 (;@9;) 11 (;@9;) 6 (;@14;) 0 (;@20;)
                                          end
                                          local.get 12
                                          i32.const 65
                                          i32.sub
                                          local.tee 1
                                          i32.const 6
                                          i32.gt_u
                                          br_if 10 (;@9;)
                                          i32.const 1
                                          local.get 1
                                          i32.shl
                                          i32.const 113
                                          i32.and
                                          i32.eqz
                                          br_if 10 (;@9;)
                                        end
                                        local.get 5
                                        i32.const 8
                                        i32.add
                                        local.get 0
                                        local.get 16
                                        i32.const 0
                                        call $__floatscan
                                        local.get 0
                                        i64.load offset=120
                                        i64.const 0
                                        local.get 0
                                        i32.load offset=4
                                        local.get 0
                                        i32.load offset=8
                                        i32.sub
                                        i64.extend_i32_s
                                        i64.sub
                                        i64.eq
                                        br_if 16 (;@2;)
                                        local.get 7
                                        i32.eqz
                                        br_if 9 (;@9;)
                                        local.get 5
                                        i64.load offset=16
                                        local.set 13
                                        local.get 5
                                        i64.load offset=8
                                        local.set 17
                                        local.get 16
                                        br_table 5 (;@13;) 6 (;@12;) 7 (;@11;) 9 (;@9;)
                                      end
                                      local.get 12
                                      i32.const 239
                                      i32.and
                                      i32.const 99
                                      i32.eq
                                      if  ;; label = @18
                                        local.get 5
                                        i32.const 32
                                        i32.add
                                        i32.const -1
                                        i32.const 257
                                        call $memset
                                        drop
                                        local.get 5
                                        i32.const 0
                                        i32.store8 offset=32
                                        local.get 12
                                        i32.const 115
                                        i32.ne
                                        br_if 8 (;@10;)
                                        local.get 5
                                        i32.const 0
                                        i32.store8 offset=65
                                        local.get 5
                                        i32.const 0
                                        i32.store8 offset=46
                                        local.get 5
                                        i32.const 0
                                        i32.store offset=42 align=2
                                        br 8 (;@10;)
                                      end
                                      local.get 5
                                      i32.const 32
                                      i32.add
                                      local.get 4
                                      i32.load8_u offset=1
                                      local.tee 6
                                      i32.const 94
                                      i32.eq
                                      local.tee 3
                                      i32.const 257
                                      call $memset
                                      drop
                                      local.get 5
                                      i32.const 0
                                      i32.store8 offset=32
                                      local.get 4
                                      i32.const 2
                                      i32.add
                                      local.get 4
                                      i32.const 1
                                      i32.add
                                      local.get 3
                                      select
                                      local.set 10
                                      block (result i32)  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            local.get 4
                                            i32.const 2
                                            i32.const 1
                                            local.get 3
                                            select
                                            i32.add
                                            i32.load8_u
                                            local.tee 4
                                            i32.const 45
                                            i32.ne
                                            if  ;; label = @21
                                              local.get 4
                                              i32.const 93
                                              i32.eq
                                              br_if 1 (;@20;)
                                              local.get 6
                                              i32.const 94
                                              i32.ne
                                              local.set 6
                                              local.get 10
                                              br 3 (;@18;)
                                            end
                                            local.get 5
                                            local.get 6
                                            i32.const 94
                                            i32.ne
                                            local.tee 6
                                            i32.store8 offset=78
                                            br 1 (;@19;)
                                          end
                                          local.get 5
                                          local.get 6
                                          i32.const 94
                                          i32.ne
                                          local.tee 6
                                          i32.store8 offset=126
                                        end
                                        local.get 10
                                        i32.const 1
                                        i32.add
                                      end
                                      local.set 4
                                      loop  ;; label = @18
                                        block  ;; label = @19
                                          local.get 4
                                          i32.load8_u
                                          local.tee 3
                                          i32.const 45
                                          i32.ne
                                          if  ;; label = @20
                                            local.get 3
                                            i32.eqz
                                            br_if 16 (;@4;)
                                            local.get 3
                                            i32.const 93
                                            i32.ne
                                            br_if 1 (;@19;)
                                            br 10 (;@10;)
                                          end
                                          i32.const 45
                                          local.set 3
                                          local.get 4
                                          i32.load8_u offset=1
                                          local.tee 18
                                          i32.eqz
                                          br_if 0 (;@19;)
                                          local.get 18
                                          i32.const 93
                                          i32.eq
                                          br_if 0 (;@19;)
                                          local.get 4
                                          i32.const 1
                                          i32.add
                                          local.set 10
                                          block  ;; label = @20
                                            local.get 18
                                            local.get 4
                                            i32.const 1
                                            i32.sub
                                            i32.load8_u
                                            local.tee 4
                                            i32.le_u
                                            if  ;; label = @21
                                              local.get 18
                                              local.set 3
                                              br 1 (;@20;)
                                            end
                                            loop  ;; label = @21
                                              local.get 4
                                              i32.const 1
                                              i32.add
                                              local.tee 4
                                              local.get 5
                                              i32.const 32
                                              i32.add
                                              i32.add
                                              local.get 6
                                              i32.store8
                                              local.get 4
                                              local.get 10
                                              i32.load8_u
                                              local.tee 3
                                              i32.lt_u
                                              br_if 0 (;@21;)
                                            end
                                          end
                                          local.get 10
                                          local.set 4
                                        end
                                        local.get 3
                                        local.get 5
                                        i32.add
                                        local.get 6
                                        i32.store8 offset=33
                                        local.get 4
                                        i32.const 1
                                        i32.add
                                        local.set 4
                                        br 0 (;@18;)
                                      end
                                      unreachable
                                    end
                                    i32.const 8
                                    local.set 3
                                    br 2 (;@14;)
                                  end
                                  i32.const 10
                                  local.set 3
                                  br 1 (;@14;)
                                end
                                i32.const 0
                                local.set 3
                              end
                              local.get 0
                              local.get 3
                              i32.const 0
                              i64.const -1
                              call $__intscan
                              local.set 13
                              local.get 0
                              i64.load offset=120
                              i64.const 0
                              local.get 0
                              i32.load offset=4
                              local.get 0
                              i32.load offset=8
                              i32.sub
                              i64.extend_i32_s
                              i64.sub
                              i64.eq
                              br_if 11 (;@2;)
                              block  ;; label = @14
                                local.get 12
                                i32.const 112
                                i32.ne
                                br_if 0 (;@14;)
                                local.get 7
                                i32.eqz
                                br_if 0 (;@14;)
                                local.get 7
                                local.get 13
                                i64.store32
                                br 5 (;@9;)
                              end
                              local.get 7
                              local.get 16
                              local.get 13
                              call $store_int
                              br 4 (;@9;)
                            end
                            local.get 7
                            local.get 17
                            local.get 13
                            call $__trunctfsf2
                            f32.store
                            br 3 (;@9;)
                          end
                          local.get 7
                          local.get 17
                          local.get 13
                          call $__trunctfdf2
                          f64.store
                          br 2 (;@9;)
                        end
                        local.get 7
                        local.get 17
                        i64.store
                        local.get 7
                        local.get 13
                        i64.store offset=8
                        br 1 (;@9;)
                      end
                      local.get 1
                      i32.const 1
                      i32.add
                      i32.const 31
                      local.get 12
                      i32.const 99
                      i32.eq
                      local.tee 10
                      select
                      local.set 6
                      block  ;; label = @10
                        local.get 16
                        i32.const 1
                        i32.ne
                        local.tee 18
                        i32.eqz
                        if  ;; label = @11
                          local.get 7
                          local.set 3
                          local.get 14
                          if  ;; label = @12
                            local.get 6
                            i32.const 2
                            i32.shl
                            call $dlmalloc
                            local.tee 3
                            i32.eqz
                            br_if 7 (;@5;)
                          end
                          local.get 5
                          i64.const 0
                          i64.store offset=296
                          i32.const 0
                          local.set 1
                          local.get 14
                          local.set 8
                          loop  ;; label = @12
                            local.get 3
                            local.set 9
                            block  ;; label = @13
                              loop  ;; label = @14
                                block (result i32)  ;; label = @15
                                  local.get 0
                                  i32.load offset=4
                                  local.tee 3
                                  local.get 0
                                  i32.load offset=104
                                  i32.lt_u
                                  if  ;; label = @16
                                    local.get 0
                                    local.get 3
                                    i32.const 1
                                    i32.add
                                    i32.store offset=4
                                    local.get 3
                                    i32.load8_u
                                    br 1 (;@15;)
                                  end
                                  local.get 0
                                  call $__shgetc
                                end
                                local.tee 3
                                local.get 5
                                i32.add
                                i32.load8_u offset=33
                                i32.eqz
                                br_if 1 (;@13;)
                                local.get 5
                                local.get 3
                                i32.store8 offset=27
                                local.get 5
                                i32.const 28
                                i32.add
                                local.get 5
                                i32.const 27
                                i32.add
                                i32.const 1
                                local.get 5
                                i32.const 296
                                i32.add
                                call $mbrtowc
                                local.tee 3
                                i32.const -2
                                i32.eq
                                br_if 0 (;@14;)
                                local.get 3
                                i32.const -1
                                i32.eq
                                br_if 7 (;@7;)
                                local.get 9
                                if  ;; label = @15
                                  local.get 9
                                  local.get 1
                                  i32.const 2
                                  i32.shl
                                  i32.add
                                  local.get 5
                                  i32.load offset=28
                                  i32.store
                                  local.get 1
                                  i32.const 1
                                  i32.add
                                  local.set 1
                                end
                                local.get 8
                                local.get 1
                                local.get 6
                                i32.eq
                                i32.and
                                i32.eqz
                                br_if 0 (;@14;)
                              end
                              local.get 9
                              local.get 6
                              i32.const 1
                              i32.shl
                              i32.const 1
                              i32.or
                              local.tee 6
                              i32.const 2
                              i32.shl
                              call $dlrealloc
                              local.tee 3
                              br_if 1 (;@12;)
                              br 6 (;@7;)
                            end
                          end
                          local.get 5
                          i32.const 296
                          i32.add
                          call $mbsinit
                          i32.eqz
                          br_if 4 (;@7;)
                          i32.const 0
                          local.set 8
                          br 1 (;@10;)
                        end
                        local.get 14
                        if  ;; label = @11
                          i32.const 0
                          local.set 1
                          local.get 6
                          call $dlmalloc
                          local.tee 3
                          i32.eqz
                          br_if 6 (;@5;)
                          loop  ;; label = @12
                            local.get 3
                            local.set 8
                            loop  ;; label = @13
                              block (result i32)  ;; label = @14
                                local.get 0
                                i32.load offset=4
                                local.tee 3
                                local.get 0
                                i32.load offset=104
                                i32.lt_u
                                if  ;; label = @15
                                  local.get 0
                                  local.get 3
                                  i32.const 1
                                  i32.add
                                  i32.store offset=4
                                  local.get 3
                                  i32.load8_u
                                  br 1 (;@14;)
                                end
                                local.get 0
                                call $__shgetc
                              end
                              local.tee 3
                              local.get 5
                              i32.add
                              i32.load8_u offset=33
                              i32.eqz
                              if  ;; label = @14
                                i32.const 0
                                local.set 9
                                br 4 (;@10;)
                              end
                              local.get 1
                              local.get 8
                              i32.add
                              local.get 3
                              i32.store8
                              local.get 1
                              i32.const 1
                              i32.add
                              local.tee 1
                              local.get 6
                              i32.ne
                              br_if 0 (;@13;)
                            end
                            i32.const 0
                            local.set 9
                            local.get 8
                            local.get 6
                            i32.const 1
                            i32.shl
                            i32.const 1
                            i32.or
                            local.tee 6
                            call $dlrealloc
                            local.tee 3
                            br_if 0 (;@12;)
                          end
                          br 7 (;@4;)
                        end
                        i32.const 0
                        local.set 1
                        local.get 7
                        if  ;; label = @11
                          loop  ;; label = @12
                            block (result i32)  ;; label = @13
                              local.get 0
                              i32.load offset=4
                              local.tee 3
                              local.get 0
                              i32.load offset=104
                              i32.lt_u
                              if  ;; label = @14
                                local.get 0
                                local.get 3
                                i32.const 1
                                i32.add
                                i32.store offset=4
                                local.get 3
                                i32.load8_u
                                br 1 (;@13;)
                              end
                              local.get 0
                              call $__shgetc
                            end
                            local.tee 3
                            local.get 5
                            i32.add
                            i32.load8_u offset=33
                            if  ;; label = @13
                              local.get 1
                              local.get 7
                              i32.add
                              local.get 3
                              i32.store8
                              local.get 1
                              i32.const 1
                              i32.add
                              local.set 1
                              br 1 (;@12;)
                            else
                              i32.const 0
                              local.set 9
                              local.get 7
                              local.set 8
                              br 3 (;@10;)
                            end
                            unreachable
                          end
                          unreachable
                        end
                        loop  ;; label = @11
                          block (result i32)  ;; label = @12
                            local.get 0
                            i32.load offset=4
                            local.tee 1
                            local.get 0
                            i32.load offset=104
                            i32.lt_u
                            if  ;; label = @13
                              local.get 0
                              local.get 1
                              i32.const 1
                              i32.add
                              i32.store offset=4
                              local.get 1
                              i32.load8_u
                              br 1 (;@12;)
                            end
                            local.get 0
                            call $__shgetc
                          end
                          local.tee 1
                          local.get 5
                          i32.add
                          i32.load8_u offset=33
                          br_if 0 (;@11;)
                        end
                        i32.const 0
                        local.set 8
                        i32.const 0
                        local.set 9
                        i32.const 0
                        local.set 1
                      end
                      local.get 0
                      i32.load offset=4
                      local.set 3
                      local.get 0
                      i32.load offset=104
                      if  ;; label = @10
                        local.get 0
                        local.get 3
                        i32.const 1
                        i32.sub
                        local.tee 3
                        i32.store offset=4
                      end
                      local.get 0
                      i64.load offset=120
                      local.get 3
                      local.get 0
                      i32.load offset=8
                      i32.sub
                      i64.extend_i32_s
                      i64.add
                      local.tee 17
                      i64.eqz
                      br_if 7 (;@2;)
                      local.get 12
                      i32.const 99
                      i32.eq
                      i32.const 0
                      local.get 13
                      local.get 17
                      i64.ne
                      select
                      br_if 7 (;@2;)
                      block  ;; label = @10
                        local.get 14
                        i32.eqz
                        br_if 0 (;@10;)
                        local.get 18
                        i32.eqz
                        if  ;; label = @11
                          local.get 7
                          local.get 9
                          i32.store
                          br 1 (;@10;)
                        end
                        local.get 7
                        local.get 8
                        i32.store
                      end
                      local.get 10
                      br_if 0 (;@9;)
                      local.get 9
                      if  ;; label = @10
                        local.get 9
                        local.get 1
                        i32.const 2
                        i32.shl
                        i32.add
                        i32.const 0
                        i32.store
                      end
                      local.get 8
                      i32.eqz
                      if  ;; label = @10
                        i32.const 0
                        local.set 8
                        br 1 (;@9;)
                      end
                      local.get 1
                      local.get 8
                      i32.add
                      i32.const 0
                      i32.store8
                    end
                    local.get 0
                    i32.load offset=4
                    local.get 0
                    i32.load offset=8
                    i32.sub
                    i64.extend_i32_s
                    local.get 0
                    i64.load offset=120
                    local.get 11
                    i64.add
                    i64.add
                    local.set 11
                    local.get 15
                    local.get 7
                    i32.const 0
                    i32.ne
                    i32.add
                    local.set 15
                  end
                  local.get 4
                  i32.const 1
                  i32.add
                  local.set 1
                  local.get 4
                  i32.load8_u offset=1
                  local.tee 4
                  br_if 1 (;@6;)
                  br 6 (;@1;)
                end
              end
              i32.const 0
              local.set 8
              br 1 (;@4;)
            end
            i32.const 0
            local.set 8
            i32.const 0
            local.set 9
          end
          local.get 15
          br_if 1 (;@2;)
        end
        i32.const -1
        local.set 15
      end
      local.get 14
      i32.eqz
      br_if 0 (;@1;)
      local.get 8
      call $dlfree
      local.get 9
      call $dlfree
    end
    local.get 19
    if  ;; label = @1
      local.get 0
      call $__unlockfile
    end
    local.get 5
    i32.const 304
    i32.add
    global.set 0
    local.get 15)
  (func $arg_n (type 2) (param i32 i32) (result i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    local.get 0
    i32.store offset=12
    local.get 2
    local.get 0
    local.get 1
    i32.const 2
    i32.shl
    i32.const 4
    i32.sub
    i32.const 0
    local.get 1
    i32.const 1
    i32.gt_u
    select
    i32.add
    local.tee 0
    i32.const 4
    i32.add
    i32.store offset=8
    local.get 0
    i32.load)
  (func $store_int (type 21) (param i32 i32 i64)
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.const 2
              i32.add
              br_table 0 (;@5;) 1 (;@4;) 2 (;@3;) 2 (;@3;) 4 (;@1;) 3 (;@2;) 4 (;@1;)
            end
            local.get 0
            local.get 2
            i64.store8
            return
          end
          local.get 0
          local.get 2
          i64.store16
          return
        end
        local.get 0
        local.get 2
        i64.store32
        return
      end
      local.get 0
      local.get 2
      i64.store
    end)
  (func $__uflow (type 0) (param i32) (result i32)
    (local i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 1
    global.set 0
    i32.const -1
    local.set 2
    block  ;; label = @1
      local.get 0
      call $__toread
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.const 15
      i32.add
      i32.const 1
      local.get 0
      i32.load offset=32
      call_indirect (type 1)
      i32.const 1
      i32.ne
      br_if 0 (;@1;)
      local.get 1
      i32.load8_u offset=15
      local.set 2
    end
    local.get 1
    i32.const 16
    i32.add
    global.set 0
    local.get 2)
  (func $__stdio_read (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 3
    global.set 0
    local.get 3
    local.get 1
    i32.store offset=16
    local.get 3
    local.get 2
    local.get 0
    i32.load offset=48
    local.tee 4
    i32.const 0
    i32.ne
    i32.sub
    i32.store offset=20
    local.get 0
    i32.load offset=44
    local.set 5
    local.get 3
    local.get 4
    i32.store offset=28
    local.get 3
    local.get 5
    i32.store offset=24
    i32.const -1
    local.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=60
        local.get 3
        i32.const 16
        i32.add
        i32.const 2
        local.get 3
        i32.const 12
        i32.add
        call $__wasi_fd_read
        call $__wasi_syscall_ret
        i32.eqz
        if  ;; label = @3
          local.get 3
          i32.load offset=12
          local.tee 4
          i32.const 0
          i32.gt_s
          br_if 1 (;@2;)
        end
        local.get 0
        local.get 0
        i32.load
        local.get 4
        i32.const 48
        i32.and
        i32.const 16
        i32.xor
        i32.or
        i32.store
        br 1 (;@1;)
      end
      local.get 4
      local.get 3
      i32.load offset=20
      local.tee 6
      i32.le_u
      br_if 0 (;@1;)
      local.get 0
      local.get 0
      i32.load offset=44
      local.tee 5
      i32.store offset=4
      local.get 0
      local.get 5
      local.get 4
      local.get 6
      i32.sub
      i32.add
      i32.store offset=8
      local.get 0
      i32.load offset=48
      if  ;; label = @2
        local.get 0
        local.get 5
        i32.const 1
        i32.add
        i32.store offset=4
        local.get 1
        local.get 2
        i32.add
        i32.const 1
        i32.sub
        local.get 5
        i32.load8_u
        i32.store8
      end
      local.get 2
      local.set 4
    end
    local.get 3
    i32.const 32
    i32.add
    global.set 0
    local.get 4)
  (func $__toread (type 0) (param i32) (result i32)
    (local i32 i32)
    local.get 0
    local.get 0
    i32.load8_u offset=74
    local.tee 1
    i32.const 1
    i32.sub
    local.get 1
    i32.or
    i32.store8 offset=74
    local.get 0
    i32.load offset=20
    local.get 0
    i32.load offset=28
    i32.gt_u
    if  ;; label = @1
      local.get 0
      i32.const 0
      i32.const 0
      local.get 0
      i32.load offset=36
      call_indirect (type 1)
      drop
    end
    local.get 0
    i32.const 0
    i32.store offset=28
    local.get 0
    i64.const 0
    i64.store offset=16
    local.get 0
    i32.load
    local.tee 1
    i32.const 4
    i32.and
    if  ;; label = @1
      local.get 0
      local.get 1
      i32.const 32
      i32.or
      i32.store
      i32.const -1
      return
    end
    local.get 0
    local.get 0
    i32.load offset=44
    local.get 0
    i32.load offset=48
    i32.add
    local.tee 2
    i32.store offset=8
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 1
    i32.const 27
    i32.shl
    i32.const 31
    i32.shr_s)
  (func $mbsinit (type 0) (param i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 1
      return
    end
    local.get 0
    i32.load
    i32.eqz)
  (func $__pthread_self (type 3) (result i32)
    i32.const 2256)
  (func $mbrtowc (type 7) (param i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 7
    global.set 0
    local.get 3
    i32.const 3740
    local.get 3
    select
    local.tee 5
    i32.load
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.eqz
          if  ;; label = @4
            local.get 3
            br_if 1 (;@3;)
            br 3 (;@1;)
          end
          i32.const -2
          local.set 4
          local.get 2
          i32.eqz
          br_if 2 (;@1;)
          local.get 0
          local.get 7
          i32.const 12
          i32.add
          local.get 0
          select
          local.set 6
          block  ;; label = @4
            local.get 3
            if  ;; label = @5
              local.get 2
              local.set 0
              br 1 (;@4;)
            end
            local.get 1
            i32.load8_u
            local.tee 3
            i32.const 24
            i32.shl
            i32.const 24
            i32.shr_s
            local.tee 0
            i32.const 0
            i32.ge_s
            if  ;; label = @5
              local.get 6
              local.get 3
              i32.store
              local.get 0
              i32.const 0
              i32.ne
              local.set 4
              br 4 (;@1;)
            end
            call $__pthread_self
            i32.load offset=172
            i32.load
            local.set 3
            local.get 1
            i32.load8_s
            local.set 0
            local.get 3
            i32.eqz
            if  ;; label = @5
              local.get 6
              local.get 0
              i32.const 57343
              i32.and
              i32.store
              i32.const 1
              local.set 4
              br 4 (;@1;)
            end
            local.get 0
            i32.const 255
            i32.and
            i32.const 194
            i32.sub
            local.tee 3
            i32.const 50
            i32.gt_u
            br_if 1 (;@3;)
            local.get 3
            i32.const 2
            i32.shl
            i32.const 1424
            i32.add
            i32.load
            local.set 3
            local.get 2
            i32.const 1
            i32.sub
            local.tee 0
            i32.eqz
            br_if 2 (;@2;)
            local.get 1
            i32.const 1
            i32.add
            local.set 1
          end
          local.get 1
          i32.load8_u
          local.tee 8
          i32.const 3
          i32.shr_u
          local.tee 9
          i32.const 16
          i32.sub
          local.get 3
          i32.const 26
          i32.shr_s
          local.get 9
          i32.add
          i32.or
          i32.const 7
          i32.gt_u
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 0
            i32.const 1
            i32.sub
            local.set 0
            local.get 8
            i32.const 128
            i32.sub
            local.get 3
            i32.const 6
            i32.shl
            i32.or
            local.tee 3
            i32.const 0
            i32.ge_s
            if  ;; label = @5
              local.get 5
              i32.const 0
              i32.store
              local.get 6
              local.get 3
              i32.store
              local.get 2
              local.get 0
              i32.sub
              local.set 4
              br 4 (;@1;)
            end
            local.get 0
            i32.eqz
            br_if 2 (;@2;)
            local.get 1
            i32.const 1
            i32.add
            local.tee 1
            i32.load8_u
            local.tee 8
            i32.const 192
            i32.and
            i32.const 128
            i32.eq
            br_if 0 (;@4;)
          end
        end
        local.get 5
        i32.const 0
        i32.store
        call $__errno_location
        i32.const 25
        i32.store
        i32.const -1
        local.set 4
        br 1 (;@1;)
      end
      local.get 5
      local.get 3
      i32.store
    end
    local.get 7
    i32.const 16
    i32.add
    global.set 0
    local.get 4)
  (func $__wasi_syscall_ret (type 0) (param i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      return
    end
    call $__errno_location
    local.get 0
    i32.store
    i32.const -1)
  (func $__extendsftf2 (type 22) (param i32 f32)
    (local i32 i32 i64 i32 i64)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    block (result i64)  ;; label = @1
      local.get 1
      i32.reinterpret_f32
      local.tee 5
      i32.const 2147483647
      i32.and
      local.tee 2
      i32.const 8388608
      i32.sub
      i32.const 2130706431
      i32.le_u
      if  ;; label = @2
        local.get 2
        i64.extend_i32_u
        i64.const 25
        i64.shl
        i64.const 4575657221408423936
        i64.add
        br 1 (;@1;)
      end
      local.get 2
      i32.const 2139095040
      i32.ge_u
      if  ;; label = @2
        local.get 5
        i64.extend_i32_u
        i64.const 25
        i64.shl
        i64.const 9223090561878065152
        i64.or
        br 1 (;@1;)
      end
      local.get 2
      i32.eqz
      if  ;; label = @2
        i64.const 0
        br 1 (;@1;)
      end
      local.get 3
      local.get 2
      i64.extend_i32_u
      i64.const 0
      local.get 2
      i32.clz
      local.tee 2
      i32.const 81
      i32.add
      call $__ashlti3
      local.get 3
      i64.load
      local.set 4
      local.get 3
      i64.load offset=8
      i64.const 281474976710656
      i64.xor
      i32.const 16265
      local.get 2
      i32.sub
      i64.extend_i32_u
      i64.const 48
      i64.shl
      i64.or
    end
    local.set 6
    local.get 0
    local.get 4
    i64.store
    local.get 0
    local.get 6
    local.get 5
    i32.const -2147483648
    i32.and
    i64.extend_i32_u
    i64.const 32
    i64.shl
    i64.or
    i64.store offset=8
    local.get 3
    i32.const 16
    i32.add
    global.set 0)
  (func $__multi3 (type 4) (param i32 i64 i64 i64 i64)
    (local i64)
    local.get 0
    local.get 1
    local.get 4
    i64.mul
    local.get 2
    local.get 3
    i64.mul
    i64.add
    local.get 3
    i64.const 32
    i64.shr_u
    local.tee 4
    local.get 1
    i64.const 32
    i64.shr_u
    local.tee 2
    i64.mul
    i64.add
    local.get 3
    i64.const 4294967295
    i64.and
    local.tee 3
    local.get 1
    i64.const 4294967295
    i64.and
    local.tee 1
    i64.mul
    local.tee 5
    i64.const 32
    i64.shr_u
    local.get 2
    local.get 3
    i64.mul
    i64.add
    local.tee 3
    i64.const 32
    i64.shr_u
    i64.add
    local.get 1
    local.get 4
    i64.mul
    local.get 3
    i64.const 4294967295
    i64.and
    i64.add
    local.tee 3
    i64.const 32
    i64.shr_u
    i64.add
    i64.store offset=8
    local.get 0
    local.get 5
    i64.const 4294967295
    i64.and
    local.get 3
    i64.const 32
    i64.shl
    i64.or
    i64.store)
  (func $__floatsitf (type 6) (param i32 i32)
    (local i32 i32 i64)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    local.get 0
    block (result i64)  ;; label = @1
      local.get 1
      i32.eqz
      if  ;; label = @2
        i64.const 0
        br 1 (;@1;)
      end
      local.get 3
      local.get 1
      local.get 1
      i32.const 31
      i32.shr_s
      local.tee 2
      i32.add
      local.get 2
      i32.xor
      local.tee 2
      i64.extend_i32_u
      i64.const 0
      local.get 2
      i32.clz
      local.tee 2
      i32.const 81
      i32.add
      call $__ashlti3
      local.get 3
      i64.load offset=8
      i64.const 281474976710656
      i64.xor
      i32.const 16414
      local.get 2
      i32.sub
      i64.extend_i32_u
      i64.const 48
      i64.shl
      i64.add
      local.get 1
      i32.const -2147483648
      i32.and
      i64.extend_i32_u
      i64.const 32
      i64.shl
      i64.or
      local.set 4
      local.get 3
      i64.load
    end
    i64.store
    local.get 0
    local.get 4
    i64.store offset=8
    local.get 3
    i32.const 16
    i32.add
    global.set 0)
  (func $__divtf3 (type 4) (param i32 i64 i64 i64 i64)
    (local i32 i64 i64 i64 i32 i64 i64 i64 i32 i64 i64 i64 i64 i64 i32 i64 i64 i32 i64)
    global.get 0
    i32.const 336
    i32.sub
    local.tee 5
    global.set 0
    local.get 4
    i64.const 281474976710655
    i64.and
    local.set 7
    local.get 2
    i64.const 281474976710655
    i64.and
    local.set 12
    local.get 2
    local.get 4
    i64.xor
    i64.const -9223372036854775808
    i64.and
    local.set 8
    local.get 4
    i64.const 48
    i64.shr_u
    i32.wrap_i64
    i32.const 32767
    i32.and
    local.set 9
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i64.const 48
        i64.shr_u
        i32.wrap_i64
        i32.const 32767
        i32.and
        local.tee 22
        i32.const 1
        i32.sub
        i32.const 32765
        i32.le_u
        if  ;; label = @3
          local.get 9
          i32.const 1
          i32.sub
          i32.const 32766
          i32.lt_u
          br_if 1 (;@2;)
        end
        local.get 1
        i64.eqz
        local.get 2
        i64.const 9223372036854775807
        i64.and
        local.tee 6
        i64.const 9223090561878065152
        i64.lt_u
        local.get 6
        i64.const 9223090561878065152
        i64.eq
        select
        i32.eqz
        if  ;; label = @3
          local.get 2
          i64.const 140737488355328
          i64.or
          local.set 8
          br 2 (;@1;)
        end
        local.get 3
        i64.eqz
        local.get 4
        i64.const 9223372036854775807
        i64.and
        local.tee 2
        i64.const 9223090561878065152
        i64.lt_u
        local.get 2
        i64.const 9223090561878065152
        i64.eq
        select
        i32.eqz
        if  ;; label = @3
          local.get 4
          i64.const 140737488355328
          i64.or
          local.set 8
          local.get 3
          local.set 1
          br 2 (;@1;)
        end
        local.get 1
        local.get 6
        i64.const 9223090561878065152
        i64.xor
        i64.or
        i64.eqz
        if  ;; label = @3
          local.get 3
          local.get 2
          i64.const 9223090561878065152
          i64.xor
          i64.or
          i64.eqz
          if  ;; label = @4
            i64.const 0
            local.set 1
            i64.const 9223231299366420480
            local.set 8
            br 3 (;@1;)
          end
          local.get 8
          i64.const 9223090561878065152
          i64.or
          local.set 8
          i64.const 0
          local.set 1
          br 2 (;@1;)
        end
        local.get 3
        local.get 2
        i64.const 9223090561878065152
        i64.xor
        i64.or
        i64.eqz
        if  ;; label = @3
          i64.const 0
          local.set 1
          br 2 (;@1;)
        end
        local.get 1
        local.get 6
        i64.or
        i64.eqz
        if  ;; label = @3
          i64.const 9223231299366420480
          local.get 8
          local.get 2
          local.get 3
          i64.or
          i64.eqz
          select
          local.set 8
          i64.const 0
          local.set 1
          br 2 (;@1;)
        end
        local.get 2
        local.get 3
        i64.or
        i64.eqz
        if  ;; label = @3
          local.get 8
          i64.const 9223090561878065152
          i64.or
          local.set 8
          i64.const 0
          local.set 1
          br 2 (;@1;)
        end
        local.get 6
        i64.const 281474976710655
        i64.le_u
        if  ;; label = @3
          local.get 5
          i32.const 320
          i32.add
          local.get 1
          local.get 12
          local.get 1
          local.get 12
          local.get 12
          i64.eqz
          local.tee 13
          select
          i64.clz
          local.get 13
          i32.const 6
          i32.shl
          i64.extend_i32_u
          i64.add
          i32.wrap_i64
          local.tee 13
          i32.const 15
          i32.sub
          call $__ashlti3
          i32.const 16
          local.get 13
          i32.sub
          local.set 13
          local.get 5
          i64.load offset=328
          local.set 12
          local.get 5
          i64.load offset=320
          local.set 1
        end
        local.get 2
        i64.const 281474976710655
        i64.gt_u
        br_if 0 (;@2;)
        local.get 5
        i32.const 304
        i32.add
        local.get 3
        local.get 7
        local.get 3
        local.get 7
        local.get 7
        i64.eqz
        local.tee 19
        select
        i64.clz
        local.get 19
        i32.const 6
        i32.shl
        i64.extend_i32_u
        i64.add
        i32.wrap_i64
        local.tee 19
        i32.const 15
        i32.sub
        call $__ashlti3
        local.get 13
        local.get 19
        i32.add
        i32.const 16
        i32.sub
        local.set 13
        local.get 5
        i64.load offset=312
        local.set 7
        local.get 5
        i64.load offset=304
        local.set 3
      end
      local.get 5
      i32.const 288
      i32.add
      local.get 7
      i64.const 281474976710656
      i64.or
      local.tee 15
      i64.const 15
      i64.shl
      local.get 3
      i64.const 49
      i64.shr_u
      i64.or
      local.tee 2
      i64.const 0
      i64.const 8432131802713292800
      local.get 2
      i64.sub
      local.tee 4
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 272
      i32.add
      i64.const 0
      local.get 5
      i64.load offset=296
      i64.sub
      i64.const 0
      local.get 4
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 256
      i32.add
      local.get 5
      i64.load offset=280
      i64.const 1
      i64.shl
      local.get 5
      i64.load offset=272
      i64.const 63
      i64.shr_u
      i64.or
      local.tee 4
      i64.const 0
      local.get 2
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 240
      i32.add
      local.get 4
      i64.const 0
      i64.const 0
      local.get 5
      i64.load offset=264
      i64.sub
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 224
      i32.add
      local.get 5
      i64.load offset=248
      i64.const 1
      i64.shl
      local.get 5
      i64.load offset=240
      i64.const 63
      i64.shr_u
      i64.or
      local.tee 4
      i64.const 0
      local.get 2
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 208
      i32.add
      local.get 4
      i64.const 0
      i64.const 0
      local.get 5
      i64.load offset=232
      i64.sub
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 192
      i32.add
      local.get 5
      i64.load offset=216
      i64.const 1
      i64.shl
      local.get 5
      i64.load offset=208
      i64.const 63
      i64.shr_u
      i64.or
      local.tee 4
      i64.const 0
      local.get 2
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 176
      i32.add
      local.get 4
      i64.const 0
      i64.const 0
      local.get 5
      i64.load offset=200
      i64.sub
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 160
      i32.add
      local.get 2
      i64.const 0
      local.get 5
      i64.load offset=184
      i64.const 1
      i64.shl
      local.get 5
      i64.load offset=176
      i64.const 63
      i64.shr_u
      i64.or
      i64.const 1
      i64.sub
      local.tee 4
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 144
      i32.add
      local.get 3
      i64.const 15
      i64.shl
      i64.const 0
      local.get 4
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 112
      i32.add
      local.get 4
      i64.const 0
      i64.const 0
      local.get 5
      i64.load offset=168
      local.get 5
      i64.load offset=160
      local.tee 7
      local.get 5
      i64.load offset=152
      i64.add
      local.tee 2
      local.get 7
      i64.lt_u
      i64.extend_i32_u
      i64.add
      local.get 2
      i64.const 1
      i64.gt_u
      i64.extend_i32_u
      i64.add
      i64.sub
      i64.const 0
      call $__multi3
      local.get 5
      i32.const 128
      i32.add
      i64.const 1
      local.get 2
      i64.sub
      i64.const 0
      local.get 4
      i64.const 0
      call $__multi3
      local.get 13
      local.get 22
      local.get 9
      i32.sub
      i32.add
      local.set 9
      block (result i64)  ;; label = @2
        local.get 5
        i64.load offset=112
        local.tee 10
        i64.const 1
        i64.shl
        local.tee 11
        local.get 5
        i64.load offset=136
        local.tee 16
        i64.const 1
        i64.shl
        local.get 5
        i64.load offset=128
        i64.const 63
        i64.shr_u
        i64.or
        i64.add
        local.tee 6
        i64.const 13927
        i64.sub
        local.tee 17
        i64.const 32
        i64.shr_u
        local.tee 2
        local.get 12
        i64.const 281474976710656
        i64.or
        local.tee 20
        i64.const 31
        i64.shr_u
        i64.const 4294967295
        i64.and
        local.tee 4
        i64.mul
        local.tee 14
        local.get 1
        i64.const 31
        i64.shr_u
        i64.const 4294967295
        i64.and
        local.tee 7
        local.get 6
        local.get 17
        i64.gt_u
        i64.extend_i32_u
        local.get 6
        local.get 11
        i64.lt_u
        i64.extend_i32_u
        local.get 5
        i64.load offset=120
        i64.const 1
        i64.shl
        local.get 10
        i64.const 63
        i64.shr_u
        i64.or
        local.get 16
        i64.const 63
        i64.shr_u
        i64.add
        i64.add
        i64.add
        i64.const 1
        i64.sub
        local.tee 10
        i64.const 32
        i64.shr_u
        local.tee 6
        i64.mul
        i64.add
        local.tee 11
        local.get 14
        i64.lt_u
        i64.extend_i32_u
        local.get 11
        local.get 10
        i64.const 4294967295
        i64.and
        local.tee 10
        local.get 1
        i64.const 63
        i64.shr_u
        local.tee 23
        local.get 12
        i64.const 1
        i64.shl
        i64.or
        i64.const 4294967295
        i64.and
        local.tee 12
        i64.mul
        i64.add
        local.tee 16
        local.get 11
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.get 4
        local.get 6
        i64.mul
        i64.add
        local.get 4
        local.get 10
        i64.mul
        local.tee 14
        local.get 6
        local.get 12
        i64.mul
        i64.add
        local.tee 11
        local.get 14
        i64.lt_u
        i64.extend_i32_u
        i64.const 32
        i64.shl
        local.get 11
        i64.const 32
        i64.shr_u
        i64.or
        i64.add
        local.get 16
        local.get 11
        i64.const 32
        i64.shl
        i64.add
        local.tee 11
        local.get 16
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.get 11
        local.get 10
        local.get 1
        i64.const 1
        i64.shl
        local.tee 21
        i64.const 4294967294
        i64.and
        local.tee 16
        i64.mul
        local.tee 18
        local.get 17
        i64.const 4294967295
        i64.and
        local.tee 17
        local.get 12
        i64.mul
        i64.add
        local.tee 14
        local.get 18
        i64.lt_u
        i64.extend_i32_u
        local.get 14
        local.get 2
        local.get 7
        i64.mul
        i64.add
        local.tee 18
        local.get 14
        i64.lt_u
        i64.extend_i32_u
        i64.add
        i64.add
        local.tee 14
        local.get 11
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.get 14
        local.get 4
        local.get 17
        i64.mul
        local.tee 11
        local.get 6
        local.get 16
        i64.mul
        i64.add
        local.tee 4
        local.get 7
        local.get 10
        i64.mul
        i64.add
        local.tee 6
        local.get 2
        local.get 12
        i64.mul
        i64.add
        local.tee 10
        i64.const 32
        i64.shr_u
        local.get 6
        local.get 10
        i64.gt_u
        i64.extend_i32_u
        local.get 4
        local.get 11
        i64.lt_u
        i64.extend_i32_u
        local.get 4
        local.get 6
        i64.gt_u
        i64.extend_i32_u
        i64.add
        i64.add
        i64.const 32
        i64.shl
        i64.or
        i64.add
        local.tee 4
        local.get 14
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.get 4
        local.get 18
        local.get 2
        local.get 16
        i64.mul
        local.tee 2
        local.get 7
        local.get 17
        i64.mul
        i64.add
        local.tee 7
        i64.const 32
        i64.shr_u
        local.get 2
        local.get 7
        i64.gt_u
        i64.extend_i32_u
        i64.const 32
        i64.shl
        i64.or
        i64.add
        local.tee 2
        local.get 18
        i64.lt_u
        i64.extend_i32_u
        local.get 2
        local.get 10
        i64.const 32
        i64.shl
        i64.add
        local.get 2
        i64.lt_u
        i64.extend_i32_u
        i64.add
        i64.add
        local.tee 2
        local.get 4
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.tee 4
        i64.const 562949953421311
        i64.le_u
        if  ;; label = @3
          local.get 20
          i64.const 1
          i64.shl
          local.get 23
          i64.or
          local.set 20
          local.get 5
          i32.const 80
          i32.add
          local.get 2
          local.get 4
          local.get 3
          local.get 15
          call $__multi3
          local.get 1
          i64.const 49
          i64.shl
          local.get 5
          i64.load offset=88
          i64.sub
          local.get 5
          i64.load offset=80
          local.tee 1
          i64.const 0
          i64.ne
          i64.extend_i32_u
          i64.sub
          local.set 6
          local.get 9
          i32.const 16382
          i32.add
          local.set 9
          i64.const 0
          local.get 1
          i64.sub
          br 1 (;@2;)
        end
        local.get 5
        i32.const 96
        i32.add
        local.get 4
        i64.const 63
        i64.shl
        local.get 2
        i64.const 1
        i64.shr_u
        i64.or
        local.tee 2
        local.get 4
        i64.const 1
        i64.shr_u
        local.tee 4
        local.get 3
        local.get 15
        call $__multi3
        local.get 1
        i64.const 48
        i64.shl
        local.get 5
        i64.load offset=104
        i64.sub
        local.get 5
        i64.load offset=96
        local.tee 7
        i64.const 0
        i64.ne
        i64.extend_i32_u
        i64.sub
        local.set 6
        local.get 9
        i32.const 16383
        i32.add
        local.set 9
        local.get 1
        local.set 21
        i64.const 0
        local.get 7
        i64.sub
      end
      local.set 7
      local.get 9
      i32.const 32767
      i32.ge_s
      if  ;; label = @2
        local.get 8
        i64.const 9223090561878065152
        i64.or
        local.set 8
        i64.const 0
        local.set 1
        br 1 (;@1;)
      end
      block (result i64)  ;; label = @2
        local.get 9
        i32.const 1
        i32.ge_s
        if  ;; label = @3
          local.get 6
          i64.const 1
          i64.shl
          local.get 7
          i64.const 63
          i64.shr_u
          i64.or
          local.set 6
          local.get 4
          i64.const 281474976710655
          i64.and
          local.get 9
          i64.extend_i32_u
          i64.const 48
          i64.shl
          i64.or
          local.set 10
          local.get 7
          i64.const 1
          i64.shl
          br 1 (;@2;)
        end
        local.get 9
        i32.const -113
        i32.le_s
        if  ;; label = @3
          i64.const 0
          local.set 1
          br 2 (;@1;)
        end
        local.get 5
        i32.const -64
        i32.sub
        local.get 2
        local.get 4
        i32.const 1
        local.get 9
        i32.sub
        call $__lshrti3
        local.get 5
        i32.const 48
        i32.add
        local.get 21
        local.get 20
        local.get 9
        i32.const 112
        i32.add
        call $__ashlti3
        local.get 5
        i32.const 32
        i32.add
        local.get 3
        local.get 15
        local.get 5
        i64.load offset=64
        local.tee 2
        local.get 5
        i64.load offset=72
        local.tee 10
        call $__multi3
        local.get 5
        i64.load offset=56
        local.get 5
        i64.load offset=40
        i64.const 1
        i64.shl
        local.get 5
        i64.load offset=32
        local.tee 1
        i64.const 63
        i64.shr_u
        i64.or
        i64.sub
        local.get 5
        i64.load offset=48
        local.tee 4
        local.get 1
        i64.const 1
        i64.shl
        local.tee 1
        i64.lt_u
        i64.extend_i32_u
        i64.sub
        local.set 6
        local.get 4
        local.get 1
        i64.sub
      end
      local.set 4
      local.get 5
      i32.const 16
      i32.add
      local.get 3
      local.get 15
      i64.const 3
      i64.const 0
      call $__multi3
      local.get 5
      local.get 3
      local.get 15
      i64.const 5
      i64.const 0
      call $__multi3
      local.get 10
      local.get 2
      local.get 2
      i64.const 1
      i64.and
      local.tee 1
      local.get 4
      i64.add
      local.tee 4
      local.get 3
      i64.gt_u
      local.get 6
      local.get 1
      local.get 4
      i64.gt_u
      i64.extend_i32_u
      i64.add
      local.tee 1
      local.get 15
      i64.gt_u
      local.get 1
      local.get 15
      i64.eq
      select
      i64.extend_i32_u
      i64.add
      local.tee 3
      local.get 2
      i64.lt_u
      i64.extend_i32_u
      i64.add
      local.tee 2
      local.get 3
      local.get 2
      i64.const 9223090561878065152
      i64.lt_u
      local.get 4
      local.get 5
      i64.load offset=16
      i64.gt_u
      local.get 1
      local.get 5
      i64.load offset=24
      local.tee 2
      i64.gt_u
      local.get 1
      local.get 2
      i64.eq
      select
      i32.and
      i64.extend_i32_u
      i64.add
      local.tee 2
      local.get 3
      i64.lt_u
      i64.extend_i32_u
      i64.add
      local.tee 3
      local.get 2
      local.get 3
      i64.const 9223090561878065152
      i64.lt_u
      local.get 4
      local.get 5
      i64.load
      i64.gt_u
      local.get 1
      local.get 5
      i64.load offset=8
      local.tee 4
      i64.gt_u
      local.get 1
      local.get 4
      i64.eq
      select
      i32.and
      i64.extend_i32_u
      i64.add
      local.tee 1
      local.get 2
      i64.lt_u
      i64.extend_i32_u
      i64.add
      local.get 8
      i64.or
      local.set 8
    end
    local.get 0
    local.get 1
    i64.store
    local.get 0
    local.get 8
    i64.store offset=8
    local.get 5
    i32.const 336
    i32.add
    global.set 0)
  (func $__addtf3 (type 4) (param i32 i64 i64 i64 i64)
    (local i32 i32 i32 i64 i64 i64 i32 i64)
    global.get 0
    i32.const 112
    i32.sub
    local.tee 6
    global.set 0
    local.get 4
    i64.const 9223372036854775807
    i64.and
    local.set 9
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i64.const 1
        i64.sub
        local.tee 8
        i64.const -1
        i64.eq
        local.get 2
        i64.const 9223372036854775807
        i64.and
        local.tee 10
        local.get 1
        local.get 8
        i64.gt_u
        i64.extend_i32_u
        i64.add
        i64.const 1
        i64.sub
        local.tee 8
        i64.const 9223090561878065151
        i64.gt_u
        local.get 8
        i64.const 9223090561878065151
        i64.eq
        select
        i32.eqz
        if  ;; label = @3
          local.get 3
          i64.const 1
          i64.sub
          local.tee 8
          i64.const -1
          i64.ne
          local.get 9
          local.get 3
          local.get 8
          i64.gt_u
          i64.extend_i32_u
          i64.add
          i64.const 1
          i64.sub
          local.tee 8
          i64.const 9223090561878065151
          i64.lt_u
          local.get 8
          i64.const 9223090561878065151
          i64.eq
          select
          br_if 1 (;@2;)
        end
        local.get 1
        i64.eqz
        local.get 10
        i64.const 9223090561878065152
        i64.lt_u
        local.get 10
        i64.const 9223090561878065152
        i64.eq
        select
        i32.eqz
        if  ;; label = @3
          local.get 2
          i64.const 140737488355328
          i64.or
          local.set 4
          local.get 1
          local.set 3
          br 2 (;@1;)
        end
        local.get 3
        i64.eqz
        local.get 9
        i64.const 9223090561878065152
        i64.lt_u
        local.get 9
        i64.const 9223090561878065152
        i64.eq
        select
        i32.eqz
        if  ;; label = @3
          local.get 4
          i64.const 140737488355328
          i64.or
          local.set 4
          br 2 (;@1;)
        end
        local.get 1
        local.get 10
        i64.const 9223090561878065152
        i64.xor
        i64.or
        i64.eqz
        if  ;; label = @3
          i64.const 9223231299366420480
          local.get 2
          local.get 1
          local.get 3
          i64.xor
          local.get 2
          local.get 4
          i64.xor
          i64.const -9223372036854775808
          i64.xor
          i64.or
          i64.eqz
          local.tee 5
          select
          local.set 4
          i64.const 0
          local.get 1
          local.get 5
          select
          local.set 3
          br 2 (;@1;)
        end
        local.get 3
        local.get 9
        i64.const 9223090561878065152
        i64.xor
        i64.or
        i64.eqz
        br_if 1 (;@1;)
        local.get 1
        local.get 10
        i64.or
        i64.eqz
        if  ;; label = @3
          local.get 3
          local.get 9
          i64.or
          i64.const 0
          i64.ne
          br_if 2 (;@1;)
          local.get 1
          local.get 3
          i64.and
          local.set 3
          local.get 2
          local.get 4
          i64.and
          local.set 4
          br 2 (;@1;)
        end
        local.get 3
        local.get 9
        i64.or
        i64.eqz
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        local.set 3
        local.get 2
        local.set 4
        br 1 (;@1;)
      end
      local.get 3
      local.get 1
      local.get 1
      local.get 3
      i64.lt_u
      local.get 9
      local.get 10
      i64.gt_u
      local.get 9
      local.get 10
      i64.eq
      select
      local.tee 7
      select
      local.set 9
      local.get 4
      local.get 2
      local.get 7
      select
      local.tee 10
      i64.const 281474976710655
      i64.and
      local.set 8
      local.get 2
      local.get 4
      local.get 7
      select
      local.tee 2
      i64.const 48
      i64.shr_u
      i32.wrap_i64
      i32.const 32767
      i32.and
      local.set 11
      local.get 10
      i64.const 48
      i64.shr_u
      i32.wrap_i64
      i32.const 32767
      i32.and
      local.tee 5
      i32.eqz
      if  ;; label = @2
        local.get 6
        i32.const 96
        i32.add
        local.get 9
        local.get 8
        local.get 9
        local.get 8
        local.get 8
        i64.eqz
        local.tee 5
        select
        i64.clz
        local.get 5
        i32.const 6
        i32.shl
        i64.extend_i32_u
        i64.add
        i32.wrap_i64
        local.tee 5
        i32.const 15
        i32.sub
        call $__ashlti3
        local.get 6
        i64.load offset=104
        local.set 8
        local.get 6
        i64.load offset=96
        local.set 9
        i32.const 16
        local.get 5
        i32.sub
        local.set 5
      end
      local.get 1
      local.get 3
      local.get 7
      select
      local.set 3
      local.get 2
      i64.const 281474976710655
      i64.and
      local.set 4
      local.get 11
      i32.eqz
      if  ;; label = @2
        local.get 6
        i32.const 80
        i32.add
        local.get 3
        local.get 4
        local.get 3
        local.get 4
        local.get 4
        i64.eqz
        local.tee 7
        select
        i64.clz
        local.get 7
        i32.const 6
        i32.shl
        i64.extend_i32_u
        i64.add
        i32.wrap_i64
        local.tee 7
        i32.const 15
        i32.sub
        call $__ashlti3
        i32.const 16
        local.get 7
        i32.sub
        local.set 11
        local.get 6
        i64.load offset=88
        local.set 4
        local.get 6
        i64.load offset=80
        local.set 3
      end
      local.get 4
      i64.const 3
      i64.shl
      local.get 3
      i64.const 61
      i64.shr_u
      i64.or
      i64.const 2251799813685248
      i64.or
      local.set 4
      local.get 8
      i64.const 3
      i64.shl
      local.get 9
      i64.const 61
      i64.shr_u
      i64.or
      local.set 1
      local.get 2
      local.get 10
      i64.xor
      local.set 8
      block (result i64)  ;; label = @2
        local.get 3
        i64.const 3
        i64.shl
        local.tee 3
        local.get 5
        local.get 11
        i32.sub
        local.tee 7
        i32.eqz
        br_if 0 (;@2;)
        drop
        local.get 7
        i32.const 127
        i32.gt_u
        if  ;; label = @3
          i64.const 0
          local.set 4
          i64.const 1
          br 1 (;@2;)
        end
        local.get 6
        i32.const -64
        i32.sub
        local.get 3
        local.get 4
        i32.const 128
        local.get 7
        i32.sub
        call $__ashlti3
        local.get 6
        i32.const 48
        i32.add
        local.get 3
        local.get 4
        local.get 7
        call $__lshrti3
        local.get 6
        i64.load offset=56
        local.set 4
        local.get 6
        i64.load offset=48
        local.get 6
        i64.load offset=64
        local.get 6
        i64.load offset=72
        i64.or
        i64.const 0
        i64.ne
        i64.extend_i32_u
        i64.or
      end
      local.set 3
      local.get 1
      i64.const 2251799813685248
      i64.or
      local.set 12
      local.get 9
      i64.const 3
      i64.shl
      local.set 2
      block  ;; label = @2
        local.get 8
        i64.const -1
        i64.le_s
        if  ;; label = @3
          local.get 2
          local.get 3
          i64.sub
          local.tee 1
          local.get 12
          local.get 4
          i64.sub
          local.get 2
          local.get 3
          i64.lt_u
          i64.extend_i32_u
          i64.sub
          local.tee 4
          i64.or
          i64.eqz
          if  ;; label = @4
            i64.const 0
            local.set 3
            i64.const 0
            local.set 4
            br 3 (;@1;)
          end
          local.get 4
          i64.const 2251799813685247
          i64.gt_u
          br_if 1 (;@2;)
          local.get 6
          i32.const 32
          i32.add
          local.get 1
          local.get 4
          local.get 1
          local.get 4
          local.get 4
          i64.eqz
          local.tee 7
          select
          i64.clz
          local.get 7
          i32.const 6
          i32.shl
          i64.extend_i32_u
          i64.add
          i32.wrap_i64
          i32.const 12
          i32.sub
          local.tee 7
          call $__ashlti3
          local.get 5
          local.get 7
          i32.sub
          local.set 5
          local.get 6
          i64.load offset=40
          local.set 4
          local.get 6
          i64.load offset=32
          local.set 1
          br 1 (;@2;)
        end
        local.get 2
        local.get 3
        i64.add
        local.tee 1
        local.get 3
        i64.lt_u
        i64.extend_i32_u
        local.get 4
        local.get 12
        i64.add
        i64.add
        local.tee 4
        i64.const 4503599627370496
        i64.and
        i64.eqz
        br_if 0 (;@2;)
        local.get 1
        i64.const 1
        i64.and
        local.get 4
        i64.const 63
        i64.shl
        local.get 1
        i64.const 1
        i64.shr_u
        i64.or
        i64.or
        local.set 1
        local.get 5
        i32.const 1
        i32.add
        local.set 5
        local.get 4
        i64.const 1
        i64.shr_u
        local.set 4
      end
      local.get 10
      i64.const -9223372036854775808
      i64.and
      local.set 2
      local.get 5
      i32.const 32767
      i32.ge_s
      if  ;; label = @2
        local.get 2
        i64.const 9223090561878065152
        i64.or
        local.set 4
        i64.const 0
        local.set 3
        br 1 (;@1;)
      end
      i32.const 0
      local.set 7
      block  ;; label = @2
        local.get 5
        i32.const 0
        i32.gt_s
        if  ;; label = @3
          local.get 5
          local.set 7
          br 1 (;@2;)
        end
        local.get 6
        i32.const 16
        i32.add
        local.get 1
        local.get 4
        local.get 5
        i32.const 127
        i32.add
        call $__ashlti3
        local.get 6
        local.get 1
        local.get 4
        i32.const 1
        local.get 5
        i32.sub
        call $__lshrti3
        local.get 6
        i64.load
        local.get 6
        i64.load offset=16
        local.get 6
        i64.load offset=24
        i64.or
        i64.const 0
        i64.ne
        i64.extend_i32_u
        i64.or
        local.set 1
        local.get 6
        i64.load offset=8
        local.set 4
      end
      local.get 4
      i64.const 61
      i64.shl
      local.get 1
      i64.const 3
      i64.shr_u
      i64.or
      local.set 3
      local.get 4
      i64.const 3
      i64.shr_u
      i64.const 281474976710655
      i64.and
      local.get 7
      i64.extend_i32_u
      i64.const 48
      i64.shl
      i64.or
      local.get 2
      i64.or
      local.set 4
      local.get 1
      i32.wrap_i64
      i32.const 7
      i32.and
      local.set 5
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                call $__fe_getround
                br_table 0 (;@6;) 1 (;@5;) 2 (;@4;) 3 (;@3;)
              end
              local.get 4
              local.get 3
              local.get 5
              i32.const 4
              i32.gt_u
              i64.extend_i32_u
              i64.add
              local.tee 1
              local.get 3
              i64.lt_u
              i64.extend_i32_u
              i64.add
              local.set 4
              local.get 5
              i32.const 4
              i32.ne
              if  ;; label = @6
                local.get 1
                local.set 3
                br 3 (;@3;)
              end
              local.get 4
              local.get 1
              i64.const 1
              i64.and
              local.tee 2
              local.get 1
              i64.add
              local.tee 3
              local.get 2
              i64.lt_u
              i64.extend_i32_u
              i64.add
              local.set 4
              br 3 (;@2;)
            end
            local.get 4
            local.get 3
            local.get 5
            i32.const 0
            i32.ne
            local.get 2
            i64.const 0
            i64.ne
            i32.and
            i64.extend_i32_u
            i64.add
            local.tee 1
            local.get 3
            i64.lt_u
            i64.extend_i32_u
            i64.add
            local.set 4
            local.get 1
            local.set 3
            br 1 (;@3;)
          end
          local.get 4
          local.get 3
          local.get 2
          i64.eqz
          local.get 5
          i32.const 0
          i32.ne
          i32.and
          i64.extend_i32_u
          i64.add
          local.tee 1
          local.get 3
          i64.lt_u
          i64.extend_i32_u
          i64.add
          local.set 4
          local.get 1
          local.set 3
        end
        local.get 5
        i32.eqz
        br_if 1 (;@1;)
      end
      call $__fe_raise_inexact
      drop
    end
    local.get 0
    local.get 3
    i64.store
    local.get 0
    local.get 4
    i64.store offset=8
    local.get 6
    i32.const 112
    i32.add
    global.set 0)
  (func $__lshrti3 (type 10) (param i32 i64 i64 i32)
    (local i64)
    block  ;; label = @1
      local.get 3
      i32.const 64
      i32.and
      if  ;; label = @2
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
  (func $__trunctfsf2 (type 23) (param i64 i64) (result f32)
    (local i64 i32 i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 4
    global.set 0
    block  ;; label = @1
      local.get 1
      i64.const 9223372036854775807
      i64.and
      local.tee 2
      i64.const 4575938696385134592
      i64.sub
      local.get 2
      i64.const 4647433340469641216
      i64.sub
      i64.lt_u
      if  ;; label = @2
        local.get 1
        i64.const 25
        i64.shr_u
        i32.wrap_i64
        local.set 5
        local.get 0
        i64.eqz
        local.get 1
        i64.const 33554431
        i64.and
        local.tee 2
        i64.const 16777216
        i64.lt_u
        local.get 2
        i64.const 16777216
        i64.eq
        select
        i32.eqz
        if  ;; label = @3
          local.get 5
          i32.const 1073741825
          i32.add
          local.set 3
          br 2 (;@1;)
        end
        local.get 5
        i32.const 1073741824
        i32.add
        local.set 3
        local.get 0
        local.get 2
        i64.const 16777216
        i64.xor
        i64.or
        i64.const 0
        i64.ne
        br_if 1 (;@1;)
        local.get 3
        local.get 5
        i32.const 1
        i32.and
        i32.add
        local.set 3
        br 1 (;@1;)
      end
      local.get 0
      i64.eqz
      local.get 2
      i64.const 9223090561878065152
      i64.lt_u
      local.get 2
      i64.const 9223090561878065152
      i64.eq
      select
      i32.eqz
      if  ;; label = @2
        local.get 1
        i64.const 25
        i64.shr_u
        i32.wrap_i64
        i32.const 4194303
        i32.and
        i32.const 2143289344
        i32.or
        local.set 3
        br 1 (;@1;)
      end
      i32.const 2139095040
      local.set 3
      local.get 2
      i64.const 4647433340469641215
      i64.gt_u
      br_if 0 (;@1;)
      i32.const 0
      local.set 3
      local.get 2
      i64.const 48
      i64.shr_u
      i32.wrap_i64
      local.tee 5
      i32.const 16145
      i32.lt_u
      br_if 0 (;@1;)
      local.get 4
      i32.const 16
      i32.add
      local.get 0
      local.get 1
      i64.const 281474976710655
      i64.and
      i64.const 281474976710656
      i64.or
      local.tee 2
      local.get 5
      i32.const 16129
      i32.sub
      call $__ashlti3
      local.get 4
      local.get 0
      local.get 2
      i32.const 16257
      local.get 5
      i32.sub
      call $__lshrti3
      local.get 4
      i64.load offset=8
      local.tee 2
      i64.const 25
      i64.shr_u
      i32.wrap_i64
      local.set 3
      local.get 4
      i64.load
      local.get 4
      i64.load offset=16
      local.get 4
      i64.load offset=24
      i64.or
      i64.const 0
      i64.ne
      i64.extend_i32_u
      i64.or
      local.tee 0
      i64.eqz
      local.get 2
      i64.const 33554431
      i64.and
      local.tee 2
      i64.const 16777216
      i64.lt_u
      local.get 2
      i64.const 16777216
      i64.eq
      select
      i32.eqz
      if  ;; label = @2
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        br 1 (;@1;)
      end
      local.get 0
      local.get 2
      i64.const 16777216
      i64.xor
      i64.or
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
      local.get 3
      i32.const 1
      i32.and
      local.get 3
      i32.add
      local.set 3
    end
    local.get 4
    i32.const 32
    i32.add
    global.set 0
    local.get 3
    local.get 1
    i64.const 32
    i64.shr_u
    i32.wrap_i64
    i32.const -2147483648
    i32.and
    i32.or
    f32.reinterpret_i32)
  (func $__trunctfdf2 (type 24) (param i64 i64) (result f64)
    (local i64 i64 i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 4
    global.set 0
    block  ;; label = @1
      local.get 1
      i64.const 9223372036854775807
      i64.and
      local.tee 2
      i64.const 4323737117252386816
      i64.sub
      local.get 2
      i64.const 4899634919602388992
      i64.sub
      i64.lt_u
      if  ;; label = @2
        local.get 1
        i64.const 4
        i64.shl
        local.get 0
        i64.const 60
        i64.shr_u
        i64.or
        local.set 2
        local.get 0
        i64.const 1152921504606846975
        i64.and
        local.tee 0
        i64.const 576460752303423489
        i64.ge_u
        if  ;; label = @3
          local.get 2
          i64.const 4611686018427387905
          i64.add
          local.set 3
          br 2 (;@1;)
        end
        local.get 2
        i64.const -4611686018427387904
        i64.sub
        local.set 3
        local.get 0
        i64.const 576460752303423488
        i64.xor
        i64.const 0
        i64.ne
        br_if 1 (;@1;)
        local.get 3
        local.get 2
        i64.const 1
        i64.and
        i64.add
        local.set 3
        br 1 (;@1;)
      end
      local.get 0
      i64.eqz
      local.get 2
      i64.const 9223090561878065152
      i64.lt_u
      local.get 2
      i64.const 9223090561878065152
      i64.eq
      select
      i32.eqz
      if  ;; label = @2
        local.get 1
        i64.const 4
        i64.shl
        local.get 0
        i64.const 60
        i64.shr_u
        i64.or
        i64.const 2251799813685247
        i64.and
        i64.const 9221120237041090560
        i64.or
        local.set 3
        br 1 (;@1;)
      end
      i64.const 9218868437227405312
      local.set 3
      local.get 2
      i64.const 4899634919602388991
      i64.gt_u
      br_if 0 (;@1;)
      i64.const 0
      local.set 3
      local.get 2
      i64.const 48
      i64.shr_u
      i32.wrap_i64
      local.tee 5
      i32.const 15249
      i32.lt_u
      br_if 0 (;@1;)
      local.get 4
      i32.const 16
      i32.add
      local.get 0
      local.get 1
      i64.const 281474976710655
      i64.and
      i64.const 281474976710656
      i64.or
      local.tee 2
      local.get 5
      i32.const 15233
      i32.sub
      call $__ashlti3
      local.get 4
      local.get 0
      local.get 2
      i32.const 15361
      local.get 5
      i32.sub
      call $__lshrti3
      local.get 4
      i64.load offset=8
      i64.const 4
      i64.shl
      local.get 4
      i64.load
      local.tee 2
      i64.const 60
      i64.shr_u
      i64.or
      local.set 3
      local.get 4
      i64.load offset=16
      local.get 4
      i64.load offset=24
      i64.or
      i64.const 0
      i64.ne
      i64.extend_i32_u
      local.get 2
      i64.const 1152921504606846975
      i64.and
      i64.or
      local.tee 2
      i64.const 576460752303423489
      i64.ge_u
      if  ;; label = @2
        local.get 3
        i64.const 1
        i64.add
        local.set 3
        br 1 (;@1;)
      end
      local.get 2
      i64.const 576460752303423488
      i64.xor
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
      local.get 3
      i64.const 1
      i64.and
      local.get 3
      i64.add
      local.set 3
    end
    local.get 4
    i32.const 32
    i32.add
    global.set 0
    local.get 3
    local.get 1
    i64.const -9223372036854775808
    i64.and
    i64.or
    f64.reinterpret_i64)
  (func $__multf3 (type 4) (param i32 i64 i64 i64 i64)
    (local i32 i64 i32 i64 i64 i64 i32 i64 i64 i64 i64 i64 i32 i64 i32 i64 i64 i64 i64 i64)
    global.get 0
    i32.const 96
    i32.sub
    local.tee 5
    global.set 0
    local.get 2
    i64.const 32
    i64.shl
    local.get 1
    i64.const 32
    i64.shr_u
    i64.or
    local.set 12
    local.get 4
    i64.const 47
    i64.shl
    local.get 3
    i64.const 17
    i64.shr_u
    i64.or
    local.set 8
    local.get 4
    i64.const 281474976710655
    i64.and
    local.tee 9
    i64.const 15
    i64.shl
    local.get 3
    i64.const 49
    i64.shr_u
    i64.or
    local.set 14
    local.get 2
    local.get 4
    i64.xor
    i64.const -9223372036854775808
    i64.and
    local.set 6
    local.get 2
    i64.const 281474976710655
    i64.and
    local.tee 10
    i64.const 32
    i64.shr_u
    local.set 15
    local.get 9
    i64.const 17
    i64.shr_u
    local.set 16
    local.get 4
    i64.const 48
    i64.shr_u
    i32.wrap_i64
    i32.const 32767
    i32.and
    local.set 7
    block  ;; label = @1
      block (result i32)  ;; label = @2
        local.get 2
        i64.const 48
        i64.shr_u
        i32.wrap_i64
        i32.const 32767
        i32.and
        local.tee 17
        i32.const 1
        i32.sub
        i32.const 32765
        i32.le_u
        if  ;; label = @3
          i32.const 0
          local.get 7
          i32.const 1
          i32.sub
          i32.const 32766
          i32.lt_u
          br_if 1 (;@2;)
          drop
        end
        local.get 1
        i64.eqz
        local.get 2
        i64.const 9223372036854775807
        i64.and
        local.tee 13
        i64.const 9223090561878065152
        i64.lt_u
        local.get 13
        i64.const 9223090561878065152
        i64.eq
        select
        i32.eqz
        if  ;; label = @3
          local.get 2
          i64.const 140737488355328
          i64.or
          local.set 6
          br 2 (;@1;)
        end
        local.get 3
        i64.eqz
        local.get 4
        i64.const 9223372036854775807
        i64.and
        local.tee 2
        i64.const 9223090561878065152
        i64.lt_u
        local.get 2
        i64.const 9223090561878065152
        i64.eq
        select
        i32.eqz
        if  ;; label = @3
          local.get 4
          i64.const 140737488355328
          i64.or
          local.set 6
          local.get 3
          local.set 1
          br 2 (;@1;)
        end
        local.get 1
        local.get 13
        i64.const 9223090561878065152
        i64.xor
        i64.or
        i64.eqz
        if  ;; label = @3
          local.get 2
          local.get 3
          i64.or
          i64.eqz
          if  ;; label = @4
            i64.const 9223231299366420480
            local.set 6
            i64.const 0
            local.set 1
            br 3 (;@1;)
          end
          local.get 6
          i64.const 9223090561878065152
          i64.or
          local.set 6
          i64.const 0
          local.set 1
          br 2 (;@1;)
        end
        local.get 3
        local.get 2
        i64.const 9223090561878065152
        i64.xor
        i64.or
        i64.eqz
        if  ;; label = @3
          local.get 1
          local.get 13
          i64.or
          local.set 2
          i64.const 0
          local.set 1
          local.get 2
          i64.eqz
          if  ;; label = @4
            i64.const 9223231299366420480
            local.set 6
            br 3 (;@1;)
          end
          local.get 6
          i64.const 9223090561878065152
          i64.or
          local.set 6
          br 2 (;@1;)
        end
        local.get 1
        local.get 13
        i64.or
        i64.eqz
        if  ;; label = @3
          i64.const 0
          local.set 1
          br 2 (;@1;)
        end
        local.get 2
        local.get 3
        i64.or
        i64.eqz
        if  ;; label = @3
          i64.const 0
          local.set 1
          br 2 (;@1;)
        end
        local.get 13
        i64.const 281474976710655
        i64.le_u
        if  ;; label = @3
          local.get 5
          i32.const 80
          i32.add
          local.get 1
          local.get 10
          local.get 1
          local.get 10
          local.get 10
          i64.eqz
          local.tee 11
          select
          i64.clz
          local.get 11
          i32.const 6
          i32.shl
          i64.extend_i32_u
          i64.add
          i32.wrap_i64
          local.tee 11
          i32.const 15
          i32.sub
          call $__ashlti3
          local.get 5
          i64.load offset=88
          local.tee 10
          i64.const 32
          i64.shl
          local.get 5
          i64.load offset=80
          local.tee 1
          i64.const 32
          i64.shr_u
          i64.or
          local.set 12
          local.get 10
          i64.const 32
          i64.shr_u
          local.set 15
          i32.const 16
          local.get 11
          i32.sub
          local.set 11
        end
        local.get 11
        local.get 2
        i64.const 281474976710655
        i64.gt_u
        br_if 0 (;@2;)
        drop
        local.get 5
        i32.const -64
        i32.sub
        local.get 3
        local.get 9
        local.get 3
        local.get 9
        local.get 9
        i64.eqz
        local.tee 19
        select
        i64.clz
        local.get 19
        i32.const 6
        i32.shl
        i64.extend_i32_u
        i64.add
        i32.wrap_i64
        local.tee 19
        i32.const 15
        i32.sub
        call $__ashlti3
        local.get 5
        i64.load offset=72
        local.tee 2
        i64.const 15
        i64.shl
        local.get 5
        i64.load offset=64
        local.tee 3
        i64.const 49
        i64.shr_u
        i64.or
        local.set 14
        local.get 2
        i64.const 47
        i64.shl
        local.get 3
        i64.const 17
        i64.shr_u
        i64.or
        local.set 8
        local.get 2
        i64.const 17
        i64.shr_u
        local.set 16
        local.get 11
        local.get 19
        i32.sub
        i32.const 16
        i32.add
      end
      local.set 11
      local.get 8
      i64.const 4294967295
      i64.and
      local.tee 2
      local.get 1
      i64.const 4294967295
      i64.and
      local.tee 4
      i64.mul
      local.tee 18
      local.get 3
      i64.const 15
      i64.shl
      i64.const 4294934528
      i64.and
      local.tee 1
      local.get 12
      i64.const 4294967295
      i64.and
      local.tee 3
      i64.mul
      i64.add
      local.tee 12
      i64.const 32
      i64.shl
      local.tee 9
      local.get 1
      local.get 4
      i64.mul
      i64.add
      local.tee 8
      local.get 9
      i64.lt_u
      i64.extend_i32_u
      local.get 2
      local.get 3
      i64.mul
      local.tee 21
      local.get 1
      local.get 10
      i64.const 4294967295
      i64.and
      local.tee 9
      i64.mul
      i64.add
      local.tee 13
      local.get 14
      i64.const 4294967295
      i64.and
      local.tee 10
      local.get 4
      i64.mul
      i64.add
      local.tee 14
      local.get 12
      local.get 18
      i64.lt_u
      i64.extend_i32_u
      i64.const 32
      i64.shl
      local.get 12
      i64.const 32
      i64.shr_u
      i64.or
      i64.add
      local.tee 18
      local.get 2
      local.get 9
      i64.mul
      local.tee 22
      local.get 1
      local.get 15
      i64.const 65536
      i64.or
      local.tee 12
      i64.mul
      i64.add
      local.tee 15
      local.get 3
      local.get 10
      i64.mul
      i64.add
      local.tee 20
      local.get 16
      i64.const 2147483647
      i64.and
      i64.const 2147483648
      i64.or
      local.tee 1
      local.get 4
      i64.mul
      i64.add
      local.tee 16
      i64.const 32
      i64.shl
      i64.add
      local.tee 23
      i64.add
      local.set 4
      local.get 7
      local.get 17
      i32.add
      local.get 11
      i32.add
      i32.const 16383
      i32.sub
      local.set 7
      block  ;; label = @2
        local.get 9
        local.get 10
        i64.mul
        local.tee 24
        local.get 2
        local.get 12
        i64.mul
        i64.add
        local.tee 2
        local.get 24
        i64.lt_u
        i64.extend_i32_u
        local.get 2
        local.get 1
        local.get 3
        i64.mul
        i64.add
        local.tee 3
        local.get 2
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.get 3
        local.get 13
        local.get 21
        i64.lt_u
        i64.extend_i32_u
        local.get 13
        local.get 14
        i64.gt_u
        i64.extend_i32_u
        i64.add
        i64.add
        local.tee 2
        local.get 3
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.get 1
        local.get 12
        i64.mul
        i64.add
        local.get 1
        local.get 9
        i64.mul
        local.tee 3
        local.get 10
        local.get 12
        i64.mul
        i64.add
        local.tee 1
        local.get 3
        i64.lt_u
        i64.extend_i32_u
        i64.const 32
        i64.shl
        local.get 1
        i64.const 32
        i64.shr_u
        i64.or
        i64.add
        local.get 2
        local.get 1
        i64.const 32
        i64.shl
        i64.add
        local.tee 1
        local.get 2
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.get 1
        local.get 16
        local.get 20
        i64.lt_u
        i64.extend_i32_u
        local.get 15
        local.get 22
        i64.lt_u
        i64.extend_i32_u
        local.get 15
        local.get 20
        i64.gt_u
        i64.extend_i32_u
        i64.add
        i64.add
        i64.const 32
        i64.shl
        local.get 16
        i64.const 32
        i64.shr_u
        i64.or
        i64.add
        local.tee 3
        local.get 1
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.get 3
        local.get 14
        local.get 18
        i64.gt_u
        i64.extend_i32_u
        local.get 18
        local.get 23
        i64.gt_u
        i64.extend_i32_u
        i64.add
        i64.add
        local.tee 2
        local.get 3
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.tee 1
        i64.const 281474976710656
        i64.and
        i64.eqz
        i32.eqz
        if  ;; label = @3
          local.get 7
          i32.const 1
          i32.add
          local.set 7
          br 1 (;@2;)
        end
        local.get 8
        i64.const 63
        i64.shr_u
        local.set 3
        local.get 1
        i64.const 1
        i64.shl
        local.get 2
        i64.const 63
        i64.shr_u
        i64.or
        local.set 1
        local.get 2
        i64.const 1
        i64.shl
        local.get 4
        i64.const 63
        i64.shr_u
        i64.or
        local.set 2
        local.get 8
        i64.const 1
        i64.shl
        local.set 8
        local.get 3
        local.get 4
        i64.const 1
        i64.shl
        i64.or
        local.set 4
      end
      local.get 7
      i32.const 32767
      i32.ge_s
      if  ;; label = @2
        local.get 6
        i64.const 9223090561878065152
        i64.or
        local.set 6
        i64.const 0
        local.set 1
        br 1 (;@1;)
      end
      local.get 6
      block (result i64)  ;; label = @2
        local.get 7
        i32.const 0
        i32.le_s
        if  ;; label = @3
          i32.const 1
          local.get 7
          i32.sub
          local.tee 17
          i32.const 128
          i32.ge_u
          if  ;; label = @4
            i64.const 0
            local.set 1
            br 3 (;@1;)
          end
          local.get 5
          i32.const 48
          i32.add
          local.get 8
          local.get 4
          local.get 7
          i32.const 127
          i32.add
          local.tee 7
          call $__ashlti3
          local.get 5
          i32.const 32
          i32.add
          local.get 2
          local.get 1
          local.get 7
          call $__ashlti3
          local.get 5
          i32.const 16
          i32.add
          local.get 8
          local.get 4
          local.get 17
          call $__lshrti3
          local.get 5
          local.get 2
          local.get 1
          local.get 17
          call $__lshrti3
          local.get 5
          i64.load offset=48
          local.get 5
          i64.load offset=56
          i64.or
          i64.const 0
          i64.ne
          i64.extend_i32_u
          local.get 5
          i64.load offset=32
          local.get 5
          i64.load offset=16
          i64.or
          i64.or
          local.set 8
          local.get 5
          i64.load offset=40
          local.get 5
          i64.load offset=24
          i64.or
          local.set 4
          local.get 5
          i64.load
          local.set 2
          local.get 5
          i64.load offset=8
          br 1 (;@2;)
        end
        local.get 1
        i64.const 281474976710655
        i64.and
        local.get 7
        i64.extend_i32_u
        i64.const 48
        i64.shl
        i64.or
      end
      local.tee 1
      i64.or
      local.set 6
      local.get 8
      i64.eqz
      local.get 4
      i64.const -1
      i64.gt_s
      local.get 4
      i64.const -9223372036854775808
      i64.eq
      select
      i32.eqz
      if  ;; label = @2
        local.get 6
        local.get 2
        i64.const 1
        i64.add
        local.tee 1
        local.get 2
        i64.lt_u
        i64.extend_i32_u
        i64.add
        local.set 6
        br 1 (;@1;)
      end
      local.get 8
      local.get 4
      i64.const -9223372036854775808
      i64.xor
      i64.or
      i64.eqz
      i32.eqz
      if  ;; label = @2
        local.get 2
        local.set 1
        br 1 (;@1;)
      end
      local.get 6
      local.get 2
      local.get 2
      i64.const 1
      i64.and
      i64.add
      local.tee 1
      local.get 2
      i64.lt_u
      i64.extend_i32_u
      i64.add
      local.set 6
    end
    local.get 0
    local.get 1
    i64.store
    local.get 0
    local.get 6
    i64.store offset=8
    local.get 5
    i32.const 96
    i32.add
    global.set 0)
  (func $__ashlti3 (type 10) (param i32 i64 i64 i32)
    (local i64)
    block  ;; label = @1
      local.get 3
      i32.const 64
      i32.and
      if  ;; label = @2
        local.get 1
        local.get 3
        i32.const -64
        i32.add
        i64.extend_i32_u
        i64.shl
        local.set 2
        i64.const 0
        local.set 1
        br 1 (;@1;)
      end
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      local.get 3
      i64.extend_i32_u
      local.tee 4
      i64.shl
      local.get 1
      i32.const 64
      local.get 3
      i32.sub
      i64.extend_i32_u
      i64.shr_u
      i64.or
      local.set 2
      local.get 1
      local.get 4
      i64.shl
      local.set 1
    end
    local.get 0
    local.get 1
    i64.store
    local.get 0
    local.get 2
    i64.store offset=8)
  (func $__fe_getround (type 3) (result i32)
    i32.const 0)
  (func $__fe_raise_inexact (type 3) (result i32)
    i32.const 0)
  (func $__letf2 (type 12) (param i64 i64 i64 i64) (result i32)
    (local i32 i64 i64)
    i32.const 1
    local.set 4
    block  ;; label = @1
      local.get 0
      i64.const 0
      i64.ne
      local.get 1
      i64.const 9223372036854775807
      i64.and
      local.tee 5
      i64.const 9223090561878065152
      i64.gt_u
      local.get 5
      i64.const 9223090561878065152
      i64.eq
      select
      br_if 0 (;@1;)
      local.get 2
      i64.const 0
      i64.ne
      local.get 3
      i64.const 9223372036854775807
      i64.and
      local.tee 6
      i64.const 9223090561878065152
      i64.gt_u
      local.get 6
      i64.const 9223090561878065152
      i64.eq
      select
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i64.or
      local.get 5
      local.get 6
      i64.or
      i64.or
      i64.eqz
      if  ;; label = @2
        i32.const 0
        return
      end
      local.get 1
      local.get 3
      i64.and
      i64.const 0
      i64.ge_s
      if  ;; label = @2
        i32.const -1
        local.set 4
        local.get 0
        local.get 2
        i64.lt_u
        local.get 1
        local.get 3
        i64.lt_s
        local.get 1
        local.get 3
        i64.eq
        select
        br_if 1 (;@1;)
        local.get 0
        local.get 2
        i64.xor
        local.get 1
        local.get 3
        i64.xor
        i64.or
        i64.const 0
        i64.ne
        return
      end
      i32.const -1
      local.set 4
      local.get 0
      local.get 2
      i64.gt_u
      local.get 1
      local.get 3
      i64.gt_s
      local.get 1
      local.get 3
      i64.eq
      select
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i64.xor
      local.get 1
      local.get 3
      i64.xor
      i64.or
      i64.const 0
      i64.ne
      local.set 4
    end
    local.get 4)
  (func $__getf2 (type 12) (param i64 i64 i64 i64) (result i32)
    (local i32 i64 i64)
    i32.const -1
    local.set 4
    block  ;; label = @1
      local.get 0
      i64.const 0
      i64.ne
      local.get 1
      i64.const 9223372036854775807
      i64.and
      local.tee 5
      i64.const 9223090561878065152
      i64.gt_u
      local.get 5
      i64.const 9223090561878065152
      i64.eq
      select
      br_if 0 (;@1;)
      local.get 2
      i64.const 0
      i64.ne
      local.get 3
      i64.const 9223372036854775807
      i64.and
      local.tee 6
      i64.const 9223090561878065152
      i64.gt_u
      local.get 6
      i64.const 9223090561878065152
      i64.eq
      select
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i64.or
      local.get 5
      local.get 6
      i64.or
      i64.or
      i64.eqz
      if  ;; label = @2
        i32.const 0
        return
      end
      local.get 1
      local.get 3
      i64.and
      i64.const 0
      i64.ge_s
      if  ;; label = @2
        local.get 0
        local.get 2
        i64.lt_u
        local.get 1
        local.get 3
        i64.lt_s
        local.get 1
        local.get 3
        i64.eq
        select
        br_if 1 (;@1;)
        local.get 0
        local.get 2
        i64.xor
        local.get 1
        local.get 3
        i64.xor
        i64.or
        i64.const 0
        i64.ne
        return
      end
      local.get 0
      local.get 2
      i64.gt_u
      local.get 1
      local.get 3
      i64.gt_s
      local.get 1
      local.get 3
      i64.eq
      select
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i64.xor
      local.get 1
      local.get 3
      i64.xor
      i64.or
      i64.const 0
      i64.ne
      local.set 4
    end
    local.get 4)
  (func $__floatunsitf (type 6) (param i32 i32)
    (local i32 i64)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    block (result i64)  ;; label = @1
      local.get 1
      i32.eqz
      if  ;; label = @2
        i64.const 0
        br 1 (;@1;)
      end
      local.get 2
      local.get 1
      i64.extend_i32_u
      i64.const 0
      local.get 1
      i32.clz
      local.tee 1
      i32.const 81
      i32.add
      call $__ashlti3
      local.get 2
      i64.load offset=8
      i64.const 281474976710656
      i64.xor
      i32.const 16414
      local.get 1
      i32.sub
      i64.extend_i32_u
      i64.const 48
      i64.shl
      i64.add
      local.set 3
      local.get 2
      i64.load
    end
    i64.store
    local.get 0
    local.get 3
    i64.store offset=8
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func $__extenddftf2 (type 25) (param i32 f64)
    (local i64 i32 i64 i64 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    block (result i64)  ;; label = @1
      local.get 1
      i64.reinterpret_f64
      local.tee 4
      i64.const 9223372036854775807
      i64.and
      local.tee 2
      i64.const 4503599627370496
      i64.sub
      i64.const 9214364837600034815
      i64.le_u
      if  ;; label = @2
        local.get 2
        i64.const 60
        i64.shl
        local.set 5
        local.get 2
        i64.const 4
        i64.shr_u
        i64.const 4323455642275676160
        i64.add
        br 1 (;@1;)
      end
      local.get 2
      i64.const 9218868437227405312
      i64.ge_u
      if  ;; label = @2
        local.get 4
        i64.const 60
        i64.shl
        local.set 5
        local.get 4
        i64.const 4
        i64.shr_u
        i64.const 9223090561878065152
        i64.or
        br 1 (;@1;)
      end
      local.get 2
      i64.eqz
      if  ;; label = @2
        i64.const 0
        br 1 (;@1;)
      end
      local.get 3
      local.get 2
      i64.const 0
      local.get 4
      i32.wrap_i64
      i32.clz
      i32.const 32
      i32.add
      local.get 2
      i64.const 32
      i64.shr_u
      i32.wrap_i64
      i32.clz
      local.get 2
      i64.const 4294967296
      i64.lt_u
      select
      local.tee 6
      i32.const 49
      i32.add
      call $__ashlti3
      local.get 3
      i64.load
      local.set 5
      local.get 3
      i64.load offset=8
      i64.const 281474976710656
      i64.xor
      i32.const 15372
      local.get 6
      i32.sub
      i64.extend_i32_u
      i64.const 48
      i64.shl
      i64.or
    end
    local.set 2
    local.get 0
    local.get 5
    i64.store
    local.get 0
    local.get 2
    local.get 4
    i64.const -9223372036854775808
    i64.and
    i64.or
    i64.store offset=8
    local.get 3
    i32.const 16
    i32.add
    global.set 0)
  (func $__subtf3 (type 4) (param i32 i64 i64 i64 i64)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 5
    global.set 0
    local.get 5
    local.get 1
    local.get 2
    local.get 3
    local.get 4
    i64.const -9223372036854775808
    i64.xor
    call $__addtf3
    local.get 5
    i64.load
    local.set 1
    local.get 0
    local.get 5
    i64.load offset=8
    i64.store offset=8
    local.get 0
    local.get 1
    i64.store
    local.get 5
    i32.const 16
    i32.add
    global.set 0)
  (func $dlmalloc (type 0) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 12
    global.set 0
    block  ;; label = @1
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
                            local.get 0
                            i32.const 244
                            i32.le_u
                            if  ;; label = @13
                              i32.const 3744
                              i32.load
                              local.tee 6
                              i32.const 16
                              local.get 0
                              i32.const 11
                              i32.add
                              i32.const -8
                              i32.and
                              local.get 0
                              i32.const 11
                              i32.lt_u
                              select
                              local.tee 5
                              i32.const 3
                              i32.shr_u
                              local.tee 1
                              i32.shr_u
                              local.tee 0
                              i32.const 3
                              i32.and
                              if  ;; label = @14
                                local.get 0
                                i32.const -1
                                i32.xor
                                i32.const 1
                                i32.and
                                local.get 1
                                i32.add
                                local.tee 2
                                i32.const 3
                                i32.shl
                                local.tee 3
                                i32.const 3792
                                i32.add
                                i32.load
                                local.tee 1
                                i32.const 8
                                i32.add
                                local.set 0
                                block  ;; label = @15
                                  local.get 1
                                  i32.load offset=8
                                  local.tee 5
                                  local.get 3
                                  i32.const 3784
                                  i32.add
                                  local.tee 3
                                  i32.eq
                                  if  ;; label = @16
                                    i32.const 3744
                                    local.get 6
                                    i32.const -2
                                    local.get 2
                                    i32.rotl
                                    i32.and
                                    i32.store
                                    br 1 (;@15;)
                                  end
                                  local.get 5
                                  local.get 3
                                  i32.store offset=12
                                  local.get 3
                                  local.get 5
                                  i32.store offset=8
                                end
                                local.get 1
                                local.get 2
                                i32.const 3
                                i32.shl
                                local.tee 2
                                i32.const 3
                                i32.or
                                i32.store offset=4
                                local.get 1
                                local.get 2
                                i32.add
                                local.tee 13
                                i32.const 4
                                i32.add
                                local.tee 1
                                local.get 13
                                i32.load offset=4
                                i32.const 1
                                i32.or
                                i32.store
                                br 13 (;@1;)
                              end
                              local.get 5
                              i32.const 3752
                              i32.load
                              local.tee 8
                              i32.le_u
                              br_if 1 (;@12;)
                              local.get 0
                              if  ;; label = @14
                                block  ;; label = @15
                                  local.get 0
                                  local.get 1
                                  i32.shl
                                  i32.const 2
                                  local.get 1
                                  i32.shl
                                  local.tee 0
                                  i32.const 0
                                  local.get 0
                                  i32.sub
                                  i32.or
                                  i32.and
                                  local.tee 0
                                  i32.const 0
                                  local.get 0
                                  i32.sub
                                  i32.and
                                  i32.const 1
                                  i32.sub
                                  local.tee 0
                                  local.get 0
                                  i32.const 12
                                  i32.shr_u
                                  i32.const 16
                                  i32.and
                                  local.tee 0
                                  i32.shr_u
                                  local.tee 1
                                  i32.const 5
                                  i32.shr_u
                                  i32.const 8
                                  i32.and
                                  local.tee 2
                                  local.get 0
                                  i32.or
                                  local.get 1
                                  local.get 2
                                  i32.shr_u
                                  local.tee 0
                                  i32.const 2
                                  i32.shr_u
                                  i32.const 4
                                  i32.and
                                  local.tee 1
                                  i32.or
                                  local.get 0
                                  local.get 1
                                  i32.shr_u
                                  local.tee 0
                                  i32.const 1
                                  i32.shr_u
                                  i32.const 2
                                  i32.and
                                  local.tee 1
                                  i32.or
                                  local.get 0
                                  local.get 1
                                  i32.shr_u
                                  local.tee 0
                                  i32.const 1
                                  i32.shr_u
                                  i32.const 1
                                  i32.and
                                  local.tee 1
                                  i32.or
                                  local.get 0
                                  local.get 1
                                  i32.shr_u
                                  i32.add
                                  local.tee 2
                                  i32.const 3
                                  i32.shl
                                  local.tee 3
                                  i32.const 3792
                                  i32.add
                                  i32.load
                                  local.tee 1
                                  i32.load offset=8
                                  local.tee 0
                                  local.get 3
                                  i32.const 3784
                                  i32.add
                                  local.tee 3
                                  i32.eq
                                  if  ;; label = @16
                                    i32.const 3744
                                    local.get 6
                                    i32.const -2
                                    local.get 2
                                    i32.rotl
                                    i32.and
                                    local.tee 6
                                    i32.store
                                    br 1 (;@15;)
                                  end
                                  local.get 0
                                  local.get 3
                                  i32.store offset=12
                                  local.get 3
                                  local.get 0
                                  i32.store offset=8
                                end
                                local.get 1
                                i32.const 8
                                i32.add
                                local.set 0
                                local.get 1
                                local.get 5
                                i32.const 3
                                i32.or
                                i32.store offset=4
                                local.get 1
                                local.get 5
                                i32.add
                                local.tee 3
                                local.get 2
                                i32.const 3
                                i32.shl
                                local.tee 4
                                local.get 5
                                i32.sub
                                local.tee 2
                                i32.const 1
                                i32.or
                                i32.store offset=4
                                local.get 1
                                local.get 4
                                i32.add
                                local.get 2
                                i32.store
                                local.get 8
                                if  ;; label = @15
                                  local.get 8
                                  i32.const 3
                                  i32.shr_u
                                  local.tee 4
                                  i32.const 3
                                  i32.shl
                                  i32.const 3784
                                  i32.add
                                  local.set 5
                                  i32.const 3764
                                  i32.load
                                  local.set 1
                                  block (result i32)  ;; label = @16
                                    local.get 6
                                    i32.const 1
                                    local.get 4
                                    i32.shl
                                    local.tee 4
                                    i32.and
                                    i32.eqz
                                    if  ;; label = @17
                                      i32.const 3744
                                      local.get 4
                                      local.get 6
                                      i32.or
                                      i32.store
                                      local.get 5
                                      br 1 (;@16;)
                                    end
                                    local.get 5
                                    i32.load offset=8
                                  end
                                  local.set 4
                                  local.get 5
                                  local.get 1
                                  i32.store offset=8
                                  local.get 4
                                  local.get 1
                                  i32.store offset=12
                                  local.get 1
                                  local.get 5
                                  i32.store offset=12
                                  local.get 1
                                  local.get 4
                                  i32.store offset=8
                                end
                                i32.const 3764
                                local.get 3
                                i32.store
                                i32.const 3752
                                local.get 2
                                i32.store
                                br 13 (;@1;)
                              end
                              i32.const 3748
                              i32.load
                              local.tee 9
                              i32.eqz
                              br_if 1 (;@12;)
                              local.get 9
                              i32.const 0
                              local.get 9
                              i32.sub
                              i32.and
                              i32.const 1
                              i32.sub
                              local.tee 0
                              local.get 0
                              i32.const 12
                              i32.shr_u
                              i32.const 16
                              i32.and
                              local.tee 0
                              i32.shr_u
                              local.tee 1
                              i32.const 5
                              i32.shr_u
                              i32.const 8
                              i32.and
                              local.tee 2
                              local.get 0
                              i32.or
                              local.get 1
                              local.get 2
                              i32.shr_u
                              local.tee 0
                              i32.const 2
                              i32.shr_u
                              i32.const 4
                              i32.and
                              local.tee 1
                              i32.or
                              local.get 0
                              local.get 1
                              i32.shr_u
                              local.tee 0
                              i32.const 1
                              i32.shr_u
                              i32.const 2
                              i32.and
                              local.tee 1
                              i32.or
                              local.get 0
                              local.get 1
                              i32.shr_u
                              local.tee 0
                              i32.const 1
                              i32.shr_u
                              i32.const 1
                              i32.and
                              local.tee 1
                              i32.or
                              local.get 0
                              local.get 1
                              i32.shr_u
                              i32.add
                              i32.const 2
                              i32.shl
                              i32.const 4048
                              i32.add
                              i32.load
                              local.tee 3
                              i32.load offset=4
                              i32.const -8
                              i32.and
                              local.get 5
                              i32.sub
                              local.set 1
                              local.get 3
                              local.set 2
                              loop  ;; label = @14
                                block  ;; label = @15
                                  local.get 2
                                  i32.load offset=16
                                  local.tee 0
                                  i32.eqz
                                  if  ;; label = @16
                                    local.get 2
                                    i32.load offset=20
                                    local.tee 0
                                    i32.eqz
                                    br_if 1 (;@15;)
                                  end
                                  local.get 0
                                  i32.load offset=4
                                  i32.const -8
                                  i32.and
                                  local.get 5
                                  i32.sub
                                  local.tee 2
                                  local.get 1
                                  local.get 1
                                  local.get 2
                                  i32.gt_u
                                  local.tee 2
                                  select
                                  local.set 1
                                  local.get 0
                                  local.get 3
                                  local.get 2
                                  select
                                  local.set 3
                                  local.get 0
                                  local.set 2
                                  br 1 (;@14;)
                                end
                              end
                              local.get 3
                              local.get 5
                              i32.add
                              local.tee 11
                              local.get 3
                              i32.le_u
                              br_if 2 (;@11;)
                              local.get 3
                              i32.load offset=24
                              local.set 10
                              local.get 3
                              local.get 3
                              i32.load offset=12
                              local.tee 4
                              i32.ne
                              if  ;; label = @14
                                local.get 3
                                i32.load offset=8
                                local.tee 0
                                i32.const 3760
                                i32.load
                                i32.lt_u
                                drop
                                local.get 0
                                local.get 4
                                i32.store offset=12
                                local.get 4
                                local.get 0
                                i32.store offset=8
                                br 12 (;@2;)
                              end
                              local.get 3
                              i32.const 20
                              i32.add
                              local.tee 2
                              i32.load
                              local.tee 0
                              i32.eqz
                              if  ;; label = @14
                                local.get 3
                                i32.load offset=16
                                local.tee 0
                                i32.eqz
                                br_if 4 (;@10;)
                                local.get 3
                                i32.const 16
                                i32.add
                                local.set 2
                              end
                              loop  ;; label = @14
                                local.get 2
                                local.set 7
                                local.get 0
                                local.tee 4
                                i32.const 20
                                i32.add
                                local.tee 2
                                i32.load
                                local.tee 0
                                br_if 0 (;@14;)
                                local.get 4
                                i32.const 16
                                i32.add
                                local.set 2
                                local.get 4
                                i32.load offset=16
                                local.tee 0
                                br_if 0 (;@14;)
                              end
                              local.get 7
                              i32.const 0
                              i32.store
                              br 11 (;@2;)
                            end
                            i32.const -1
                            local.set 5
                            local.get 0
                            i32.const -65
                            i32.gt_u
                            br_if 0 (;@12;)
                            local.get 0
                            i32.const 11
                            i32.add
                            local.tee 0
                            i32.const -8
                            i32.and
                            local.set 5
                            i32.const 3748
                            i32.load
                            local.tee 8
                            i32.eqz
                            br_if 0 (;@12;)
                            block (result i32)  ;; label = @13
                              i32.const 0
                              local.get 5
                              i32.const 256
                              i32.lt_u
                              br_if 0 (;@13;)
                              drop
                              i32.const 31
                              local.tee 7
                              local.get 5
                              i32.const 16777215
                              i32.gt_u
                              br_if 0 (;@13;)
                              drop
                              local.get 0
                              i32.const 8
                              i32.shr_u
                              local.tee 0
                              local.get 0
                              i32.const 1048320
                              i32.add
                              i32.const 16
                              i32.shr_u
                              i32.const 8
                              i32.and
                              local.tee 0
                              i32.shl
                              local.tee 1
                              local.get 1
                              i32.const 520192
                              i32.add
                              i32.const 16
                              i32.shr_u
                              i32.const 4
                              i32.and
                              local.tee 1
                              i32.shl
                              local.tee 2
                              local.get 2
                              i32.const 245760
                              i32.add
                              i32.const 16
                              i32.shr_u
                              i32.const 2
                              i32.and
                              local.tee 2
                              i32.shl
                              i32.const 15
                              i32.shr_u
                              local.get 0
                              local.get 1
                              i32.or
                              local.get 2
                              i32.or
                              i32.sub
                              local.tee 0
                              i32.const 1
                              i32.shl
                              local.get 5
                              local.get 0
                              i32.const 21
                              i32.add
                              i32.shr_u
                              i32.const 1
                              i32.and
                              i32.or
                              i32.const 28
                              i32.add
                            end
                            local.set 7
                            i32.const 0
                            local.get 5
                            i32.sub
                            local.set 1
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  local.get 7
                                  i32.const 2
                                  i32.shl
                                  i32.const 4048
                                  i32.add
                                  i32.load
                                  local.tee 2
                                  i32.eqz
                                  if  ;; label = @16
                                    i32.const 0
                                    local.set 0
                                    br 1 (;@15;)
                                  end
                                  i32.const 0
                                  local.set 0
                                  local.get 5
                                  i32.const 0
                                  i32.const 25
                                  local.get 7
                                  i32.const 1
                                  i32.shr_u
                                  i32.sub
                                  local.get 7
                                  i32.const 31
                                  i32.eq
                                  select
                                  i32.shl
                                  local.set 3
                                  loop  ;; label = @16
                                    block  ;; label = @17
                                      local.get 2
                                      i32.load offset=4
                                      i32.const -8
                                      i32.and
                                      local.get 5
                                      i32.sub
                                      local.tee 6
                                      local.get 1
                                      i32.ge_u
                                      br_if 0 (;@17;)
                                      local.get 2
                                      local.set 4
                                      local.get 6
                                      local.tee 1
                                      br_if 0 (;@17;)
                                      i32.const 0
                                      local.set 1
                                      local.get 2
                                      local.set 0
                                      br 3 (;@14;)
                                    end
                                    local.get 0
                                    local.get 2
                                    i32.load offset=20
                                    local.tee 6
                                    local.get 6
                                    local.get 2
                                    local.get 3
                                    i32.const 29
                                    i32.shr_u
                                    i32.const 4
                                    i32.and
                                    i32.add
                                    i32.load offset=16
                                    local.tee 2
                                    i32.eq
                                    select
                                    local.get 0
                                    local.get 6
                                    select
                                    local.set 0
                                    local.get 3
                                    i32.const 1
                                    i32.shl
                                    local.set 3
                                    local.get 2
                                    br_if 0 (;@16;)
                                  end
                                end
                                local.get 0
                                local.get 4
                                i32.or
                                i32.eqz
                                if  ;; label = @15
                                  i32.const 0
                                  local.set 4
                                  i32.const 2
                                  local.get 7
                                  i32.shl
                                  local.tee 0
                                  i32.const 0
                                  local.get 0
                                  i32.sub
                                  i32.or
                                  local.get 8
                                  i32.and
                                  local.tee 0
                                  i32.eqz
                                  br_if 3 (;@12;)
                                  local.get 0
                                  i32.const 0
                                  local.get 0
                                  i32.sub
                                  i32.and
                                  i32.const 1
                                  i32.sub
                                  local.tee 0
                                  local.get 0
                                  i32.const 12
                                  i32.shr_u
                                  i32.const 16
                                  i32.and
                                  local.tee 0
                                  i32.shr_u
                                  local.tee 2
                                  i32.const 5
                                  i32.shr_u
                                  i32.const 8
                                  i32.and
                                  local.tee 3
                                  local.get 0
                                  i32.or
                                  local.get 2
                                  local.get 3
                                  i32.shr_u
                                  local.tee 0
                                  i32.const 2
                                  i32.shr_u
                                  i32.const 4
                                  i32.and
                                  local.tee 2
                                  i32.or
                                  local.get 0
                                  local.get 2
                                  i32.shr_u
                                  local.tee 0
                                  i32.const 1
                                  i32.shr_u
                                  i32.const 2
                                  i32.and
                                  local.tee 2
                                  i32.or
                                  local.get 0
                                  local.get 2
                                  i32.shr_u
                                  local.tee 0
                                  i32.const 1
                                  i32.shr_u
                                  i32.const 1
                                  i32.and
                                  local.tee 2
                                  i32.or
                                  local.get 0
                                  local.get 2
                                  i32.shr_u
                                  i32.add
                                  i32.const 2
                                  i32.shl
                                  i32.const 4048
                                  i32.add
                                  i32.load
                                  local.set 0
                                end
                                local.get 0
                                i32.eqz
                                br_if 1 (;@13;)
                              end
                              loop  ;; label = @14
                                local.get 0
                                i32.load offset=4
                                i32.const -8
                                i32.and
                                local.get 5
                                i32.sub
                                local.tee 6
                                local.get 1
                                i32.lt_u
                                local.set 3
                                local.get 6
                                local.get 1
                                local.get 3
                                select
                                local.set 1
                                local.get 0
                                local.get 4
                                local.get 3
                                select
                                local.set 4
                                local.get 0
                                i32.load offset=16
                                local.tee 2
                                i32.eqz
                                if  ;; label = @15
                                  local.get 0
                                  i32.load offset=20
                                  local.set 2
                                end
                                local.get 2
                                local.tee 0
                                br_if 0 (;@14;)
                              end
                            end
                            local.get 4
                            i32.eqz
                            br_if 0 (;@12;)
                            local.get 1
                            i32.const 3752
                            i32.load
                            local.get 5
                            i32.sub
                            i32.ge_u
                            br_if 0 (;@12;)
                            local.get 4
                            local.get 5
                            i32.add
                            local.tee 7
                            local.get 4
                            i32.le_u
                            br_if 1 (;@11;)
                            local.get 4
                            i32.load offset=24
                            local.set 9
                            local.get 4
                            local.get 4
                            i32.load offset=12
                            local.tee 3
                            i32.ne
                            if  ;; label = @13
                              local.get 4
                              i32.load offset=8
                              local.tee 0
                              i32.const 3760
                              i32.load
                              i32.lt_u
                              drop
                              local.get 0
                              local.get 3
                              i32.store offset=12
                              local.get 3
                              local.get 0
                              i32.store offset=8
                              br 10 (;@3;)
                            end
                            local.get 4
                            i32.const 20
                            i32.add
                            local.tee 2
                            i32.load
                            local.tee 0
                            i32.eqz
                            if  ;; label = @13
                              local.get 4
                              i32.load offset=16
                              local.tee 0
                              i32.eqz
                              br_if 4 (;@9;)
                              local.get 4
                              i32.const 16
                              i32.add
                              local.set 2
                            end
                            loop  ;; label = @13
                              local.get 2
                              local.set 6
                              local.get 0
                              local.tee 3
                              i32.const 20
                              i32.add
                              local.tee 2
                              i32.load
                              local.tee 0
                              br_if 0 (;@13;)
                              local.get 3
                              i32.const 16
                              i32.add
                              local.set 2
                              local.get 3
                              i32.load offset=16
                              local.tee 0
                              br_if 0 (;@13;)
                            end
                            local.get 6
                            i32.const 0
                            i32.store
                            br 9 (;@3;)
                          end
                          local.get 5
                          i32.const 3752
                          i32.load
                          local.tee 0
                          i32.le_u
                          if  ;; label = @12
                            i32.const 3764
                            i32.load
                            local.set 1
                            block  ;; label = @13
                              local.get 0
                              local.get 5
                              i32.sub
                              local.tee 2
                              i32.const 16
                              i32.ge_u
                              if  ;; label = @14
                                i32.const 3752
                                local.get 2
                                i32.store
                                i32.const 3764
                                local.get 1
                                local.get 5
                                i32.add
                                local.tee 3
                                i32.store
                                local.get 3
                                local.get 2
                                i32.const 1
                                i32.or
                                i32.store offset=4
                                local.get 0
                                local.get 1
                                i32.add
                                local.get 2
                                i32.store
                                local.get 1
                                local.get 5
                                i32.const 3
                                i32.or
                                i32.store offset=4
                                br 1 (;@13;)
                              end
                              i32.const 3764
                              i32.const 0
                              i32.store
                              i32.const 3752
                              i32.const 0
                              i32.store
                              local.get 1
                              local.get 0
                              i32.const 3
                              i32.or
                              i32.store offset=4
                              local.get 0
                              local.get 1
                              i32.add
                              local.tee 14
                              i32.const 4
                              i32.add
                              local.tee 0
                              local.get 14
                              i32.load offset=4
                              i32.const 1
                              i32.or
                              i32.store
                            end
                            local.get 1
                            i32.const 8
                            i32.add
                            local.set 0
                            br 11 (;@1;)
                          end
                          local.get 5
                          i32.const 3756
                          i32.load
                          local.tee 3
                          i32.lt_u
                          if  ;; label = @12
                            i32.const 3756
                            local.get 3
                            local.get 5
                            i32.sub
                            local.tee 1
                            i32.store
                            i32.const 3768
                            i32.const 3768
                            i32.load
                            local.tee 0
                            local.get 5
                            i32.add
                            local.tee 2
                            i32.store
                            local.get 2
                            local.get 1
                            i32.const 1
                            i32.or
                            i32.store offset=4
                            local.get 0
                            local.get 5
                            i32.const 3
                            i32.or
                            i32.store offset=4
                            local.get 0
                            i32.const 8
                            i32.add
                            local.set 0
                            br 11 (;@1;)
                          end
                          i32.const 0
                          local.set 0
                          local.get 5
                          i32.const 47
                          i32.add
                          local.tee 8
                          block (result i32)  ;; label = @12
                            i32.const 4216
                            i32.load
                            if  ;; label = @13
                              i32.const 4224
                              i32.load
                              br 1 (;@12;)
                            end
                            i32.const 4228
                            i64.const -1
                            i64.store align=4
                            i32.const 4220
                            i64.const 17592186048512
                            i64.store align=4
                            i32.const 4216
                            local.get 12
                            i32.const 12
                            i32.add
                            i32.const -16
                            i32.and
                            i32.const 1431655768
                            i32.xor
                            i32.store
                            i32.const 4236
                            i32.const 0
                            i32.store
                            i32.const 4188
                            i32.const 0
                            i32.store
                            i32.const 4096
                          end
                          local.tee 1
                          i32.add
                          local.tee 6
                          i32.const 0
                          local.get 1
                          i32.sub
                          local.tee 7
                          i32.and
                          local.tee 4
                          local.get 5
                          i32.le_u
                          br_if 10 (;@1;)
                          i32.const 4184
                          i32.load
                          local.tee 1
                          if  ;; label = @12
                            i32.const 4176
                            i32.load
                            local.tee 2
                            local.get 4
                            i32.add
                            local.tee 9
                            local.get 2
                            i32.le_u
                            br_if 11 (;@1;)
                            local.get 1
                            local.get 9
                            i32.lt_u
                            br_if 11 (;@1;)
                          end
                          i32.const 4188
                          i32.load8_u
                          i32.const 4
                          i32.and
                          br_if 5 (;@6;)
                          block  ;; label = @12
                            block  ;; label = @13
                              i32.const 3768
                              i32.load
                              local.tee 1
                              if  ;; label = @14
                                i32.const 4192
                                local.set 0
                                loop  ;; label = @15
                                  local.get 1
                                  local.get 0
                                  i32.load
                                  local.tee 2
                                  i32.ge_u
                                  if  ;; label = @16
                                    local.get 2
                                    local.get 0
                                    i32.load offset=4
                                    i32.add
                                    local.get 1
                                    i32.gt_u
                                    br_if 3 (;@13;)
                                  end
                                  local.get 0
                                  i32.load offset=8
                                  local.tee 0
                                  br_if 0 (;@15;)
                                end
                              end
                              i32.const 0
                              call $sbrk
                              local.tee 3
                              i32.const -1
                              i32.eq
                              br_if 6 (;@7;)
                              local.get 4
                              local.set 6
                              i32.const 4220
                              i32.load
                              local.tee 0
                              i32.const 1
                              i32.sub
                              local.tee 1
                              local.get 3
                              i32.and
                              if  ;; label = @14
                                local.get 4
                                local.get 3
                                i32.sub
                                local.get 1
                                local.get 3
                                i32.add
                                i32.const 0
                                local.get 0
                                i32.sub
                                i32.and
                                i32.add
                                local.set 6
                              end
                              local.get 5
                              local.get 6
                              i32.ge_u
                              br_if 6 (;@7;)
                              local.get 6
                              i32.const 2147483646
                              i32.gt_u
                              br_if 6 (;@7;)
                              i32.const 4184
                              i32.load
                              local.tee 0
                              if  ;; label = @14
                                i32.const 4176
                                i32.load
                                local.tee 1
                                local.get 6
                                i32.add
                                local.tee 2
                                local.get 1
                                i32.le_u
                                br_if 7 (;@7;)
                                local.get 0
                                local.get 2
                                i32.lt_u
                                br_if 7 (;@7;)
                              end
                              local.get 6
                              call $sbrk
                              local.tee 0
                              local.get 3
                              i32.ne
                              br_if 1 (;@12;)
                              br 8 (;@5;)
                            end
                            local.get 6
                            local.get 3
                            i32.sub
                            local.get 7
                            i32.and
                            local.tee 6
                            i32.const 2147483646
                            i32.gt_u
                            br_if 5 (;@7;)
                            local.get 6
                            call $sbrk
                            local.tee 3
                            local.get 0
                            i32.load
                            local.get 0
                            i32.load offset=4
                            i32.add
                            i32.eq
                            br_if 4 (;@8;)
                            local.get 3
                            local.set 0
                          end
                          block  ;; label = @12
                            local.get 0
                            i32.const -1
                            i32.eq
                            br_if 0 (;@12;)
                            local.get 5
                            i32.const 48
                            i32.add
                            local.get 6
                            i32.le_u
                            br_if 0 (;@12;)
                            i32.const 4224
                            i32.load
                            local.tee 1
                            local.get 8
                            local.get 6
                            i32.sub
                            i32.add
                            i32.const 0
                            local.get 1
                            i32.sub
                            i32.and
                            local.tee 1
                            i32.const 2147483646
                            i32.gt_u
                            if  ;; label = @13
                              local.get 0
                              local.set 3
                              br 8 (;@5;)
                            end
                            local.get 1
                            call $sbrk
                            i32.const -1
                            i32.ne
                            if  ;; label = @13
                              local.get 1
                              local.get 6
                              i32.add
                              local.set 6
                              local.get 0
                              local.set 3
                              br 8 (;@5;)
                            end
                            i32.const 0
                            local.get 6
                            i32.sub
                            call $sbrk
                            drop
                            br 5 (;@7;)
                          end
                          local.get 0
                          local.set 3
                          local.get 0
                          i32.const -1
                          i32.ne
                          br_if 6 (;@5;)
                          br 4 (;@7;)
                        end
                        unreachable
                      end
                      i32.const 0
                      local.set 4
                      br 7 (;@2;)
                    end
                    i32.const 0
                    local.set 3
                    br 5 (;@3;)
                  end
                  local.get 3
                  i32.const -1
                  i32.ne
                  br_if 2 (;@5;)
                end
                i32.const 4188
                i32.const 4188
                i32.load
                i32.const 4
                i32.or
                i32.store
              end
              local.get 4
              i32.const 2147483646
              i32.gt_u
              br_if 1 (;@4;)
              local.get 4
              call $sbrk
              local.set 3
              i32.const 0
              call $sbrk
              local.set 0
              local.get 3
              i32.const -1
              i32.eq
              br_if 1 (;@4;)
              local.get 0
              i32.const -1
              i32.eq
              br_if 1 (;@4;)
              local.get 0
              local.get 3
              i32.le_u
              br_if 1 (;@4;)
              local.get 0
              local.get 3
              i32.sub
              local.tee 6
              local.get 5
              i32.const 40
              i32.add
              i32.le_u
              br_if 1 (;@4;)
            end
            i32.const 4176
            i32.const 4176
            i32.load
            local.get 6
            i32.add
            local.tee 0
            i32.store
            i32.const 4180
            i32.load
            local.get 0
            i32.lt_u
            if  ;; label = @5
              i32.const 4180
              local.get 0
              i32.store
            end
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  i32.const 3768
                  i32.load
                  local.tee 1
                  if  ;; label = @8
                    i32.const 4192
                    local.set 0
                    loop  ;; label = @9
                      local.get 3
                      local.get 0
                      i32.load
                      local.tee 2
                      local.get 0
                      i32.load offset=4
                      local.tee 4
                      i32.add
                      i32.eq
                      br_if 2 (;@7;)
                      local.get 0
                      i32.load offset=8
                      local.tee 0
                      br_if 0 (;@9;)
                    end
                    br 2 (;@6;)
                  end
                  i32.const 3760
                  i32.load
                  local.tee 0
                  i32.const 0
                  local.get 0
                  local.get 3
                  i32.le_u
                  select
                  i32.eqz
                  if  ;; label = @8
                    i32.const 3760
                    local.get 3
                    i32.store
                  end
                  i32.const 0
                  local.set 0
                  i32.const 4196
                  local.get 6
                  i32.store
                  i32.const 4192
                  local.get 3
                  i32.store
                  i32.const 3776
                  i32.const -1
                  i32.store
                  i32.const 3780
                  i32.const 4216
                  i32.load
                  i32.store
                  i32.const 4204
                  i32.const 0
                  i32.store
                  loop  ;; label = @8
                    local.get 0
                    i32.const 3
                    i32.shl
                    local.tee 1
                    i32.const 3792
                    i32.add
                    local.get 1
                    i32.const 3784
                    i32.add
                    local.tee 2
                    i32.store
                    local.get 1
                    i32.const 3796
                    i32.add
                    local.get 2
                    i32.store
                    local.get 0
                    i32.const 1
                    i32.add
                    local.tee 0
                    i32.const 32
                    i32.ne
                    br_if 0 (;@8;)
                  end
                  i32.const 3768
                  local.get 3
                  i32.const -8
                  local.get 3
                  i32.sub
                  i32.const 7
                  i32.and
                  i32.const 0
                  local.get 3
                  i32.const 8
                  i32.add
                  i32.const 7
                  i32.and
                  select
                  local.tee 0
                  i32.add
                  local.tee 1
                  i32.store
                  i32.const 3756
                  local.get 6
                  local.get 0
                  i32.sub
                  i32.const 40
                  i32.sub
                  local.tee 0
                  i32.store
                  local.get 1
                  local.get 0
                  i32.const 1
                  i32.or
                  i32.store offset=4
                  local.get 3
                  local.get 6
                  i32.add
                  i32.const 36
                  i32.sub
                  i32.const 40
                  i32.store
                  i32.const 3772
                  i32.const 4232
                  i32.load
                  i32.store
                  br 2 (;@5;)
                end
                local.get 0
                i32.load8_u offset=12
                i32.const 8
                i32.and
                br_if 0 (;@6;)
                local.get 1
                local.get 2
                i32.lt_u
                br_if 0 (;@6;)
                local.get 1
                local.get 3
                i32.ge_u
                br_if 0 (;@6;)
                local.get 0
                local.get 4
                local.get 6
                i32.add
                i32.store offset=4
                i32.const 3768
                local.get 1
                i32.const -8
                local.get 1
                i32.sub
                i32.const 7
                i32.and
                i32.const 0
                local.get 1
                i32.const 8
                i32.add
                i32.const 7
                i32.and
                select
                local.tee 0
                i32.add
                local.tee 2
                i32.store
                i32.const 3756
                i32.const 3756
                i32.load
                local.get 6
                i32.add
                local.tee 3
                local.get 0
                i32.sub
                local.tee 0
                i32.store
                local.get 2
                local.get 0
                i32.const 1
                i32.or
                i32.store offset=4
                local.get 1
                local.get 3
                i32.add
                i32.const 40
                i32.store offset=4
                i32.const 3772
                i32.const 4232
                i32.load
                i32.store
                br 1 (;@5;)
              end
              i32.const 3760
              i32.load
              local.tee 7
              local.get 3
              i32.gt_u
              if  ;; label = @6
                i32.const 3760
                local.get 3
                i32.store
                local.get 3
                local.set 7
              end
              local.get 3
              local.get 6
              i32.add
              local.set 4
              i32.const 4192
              local.set 0
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        block  ;; label = @11
                          loop  ;; label = @12
                            local.get 4
                            local.get 0
                            i32.load
                            i32.ne
                            if  ;; label = @13
                              local.get 0
                              i32.load offset=8
                              local.tee 0
                              br_if 1 (;@12;)
                              br 2 (;@11;)
                            end
                          end
                          local.get 0
                          i32.load8_u offset=12
                          i32.const 8
                          i32.and
                          i32.eqz
                          br_if 1 (;@10;)
                        end
                        i32.const 4192
                        local.set 0
                        loop  ;; label = @11
                          local.get 1
                          local.get 0
                          i32.load
                          local.tee 2
                          i32.ge_u
                          if  ;; label = @12
                            local.get 2
                            local.get 0
                            i32.load offset=4
                            i32.add
                            local.tee 2
                            local.get 1
                            i32.gt_u
                            br_if 3 (;@9;)
                          end
                          local.get 0
                          i32.load offset=8
                          local.set 0
                          br 0 (;@11;)
                        end
                        unreachable
                      end
                      local.get 0
                      local.get 3
                      i32.store
                      local.get 0
                      local.get 0
                      i32.load offset=4
                      local.get 6
                      i32.add
                      i32.store offset=4
                      local.get 3
                      i32.const -8
                      local.get 3
                      i32.sub
                      i32.const 7
                      i32.and
                      i32.const 0
                      local.get 3
                      i32.const 8
                      i32.add
                      i32.const 7
                      i32.and
                      select
                      i32.add
                      local.tee 6
                      local.get 5
                      i32.const 3
                      i32.or
                      i32.store offset=4
                      local.get 4
                      i32.const -8
                      local.get 4
                      i32.sub
                      i32.const 7
                      i32.and
                      i32.const 0
                      local.get 4
                      i32.const 8
                      i32.add
                      i32.const 7
                      i32.and
                      select
                      i32.add
                      local.tee 4
                      local.get 5
                      local.get 6
                      i32.add
                      local.tee 5
                      i32.sub
                      local.set 2
                      local.get 1
                      local.get 4
                      i32.eq
                      if  ;; label = @10
                        i32.const 3768
                        local.get 5
                        i32.store
                        i32.const 3756
                        i32.const 3756
                        i32.load
                        local.get 2
                        i32.add
                        local.tee 0
                        i32.store
                        local.get 5
                        local.get 0
                        i32.const 1
                        i32.or
                        i32.store offset=4
                        br 3 (;@7;)
                      end
                      local.get 4
                      i32.const 3764
                      i32.load
                      i32.eq
                      if  ;; label = @10
                        i32.const 3764
                        local.get 5
                        i32.store
                        i32.const 3752
                        i32.const 3752
                        i32.load
                        local.get 2
                        i32.add
                        local.tee 0
                        i32.store
                        local.get 5
                        local.get 0
                        i32.const 1
                        i32.or
                        i32.store offset=4
                        local.get 0
                        local.get 5
                        i32.add
                        local.get 0
                        i32.store
                        br 3 (;@7;)
                      end
                      local.get 4
                      i32.load offset=4
                      local.tee 0
                      i32.const 3
                      i32.and
                      i32.const 1
                      i32.eq
                      if  ;; label = @10
                        local.get 0
                        i32.const -8
                        i32.and
                        local.set 8
                        block  ;; label = @11
                          local.get 0
                          i32.const 255
                          i32.le_u
                          if  ;; label = @12
                            local.get 4
                            i32.load offset=8
                            local.tee 1
                            local.get 0
                            i32.const 3
                            i32.shr_u
                            local.tee 7
                            i32.const 3
                            i32.shl
                            i32.const 3784
                            i32.add
                            local.tee 3
                            i32.eq
                            drop
                            local.get 1
                            local.get 4
                            i32.load offset=12
                            local.tee 0
                            i32.eq
                            if  ;; label = @13
                              i32.const 3744
                              i32.const 3744
                              i32.load
                              i32.const -2
                              local.get 7
                              i32.rotl
                              i32.and
                              i32.store
                              br 2 (;@11;)
                            end
                            local.get 1
                            local.get 0
                            i32.store offset=12
                            local.get 0
                            local.get 1
                            i32.store offset=8
                            br 1 (;@11;)
                          end
                          local.get 4
                          i32.load offset=24
                          local.set 9
                          block  ;; label = @12
                            local.get 4
                            local.get 4
                            i32.load offset=12
                            local.tee 3
                            i32.ne
                            if  ;; label = @13
                              local.get 4
                              i32.load offset=8
                              local.tee 0
                              local.get 3
                              i32.store offset=12
                              local.get 3
                              local.get 0
                              i32.store offset=8
                              br 1 (;@12;)
                            end
                            block  ;; label = @13
                              local.get 4
                              i32.const 20
                              i32.add
                              local.tee 0
                              i32.load
                              local.tee 1
                              br_if 0 (;@13;)
                              local.get 4
                              i32.const 16
                              i32.add
                              local.tee 0
                              i32.load
                              local.tee 1
                              br_if 0 (;@13;)
                              i32.const 0
                              local.set 3
                              br 1 (;@12;)
                            end
                            loop  ;; label = @13
                              local.get 0
                              local.set 7
                              local.get 1
                              local.tee 3
                              i32.const 20
                              i32.add
                              local.tee 0
                              i32.load
                              local.tee 1
                              br_if 0 (;@13;)
                              local.get 3
                              i32.const 16
                              i32.add
                              local.set 0
                              local.get 3
                              i32.load offset=16
                              local.tee 1
                              br_if 0 (;@13;)
                            end
                            local.get 7
                            i32.const 0
                            i32.store
                          end
                          local.get 9
                          i32.eqz
                          br_if 0 (;@11;)
                          block  ;; label = @12
                            local.get 4
                            local.get 4
                            i32.load offset=28
                            local.tee 1
                            i32.const 2
                            i32.shl
                            i32.const 4048
                            i32.add
                            local.tee 0
                            i32.load
                            i32.eq
                            if  ;; label = @13
                              local.get 0
                              local.get 3
                              i32.store
                              local.get 3
                              br_if 1 (;@12;)
                              i32.const 3748
                              i32.const 3748
                              i32.load
                              i32.const -2
                              local.get 1
                              i32.rotl
                              i32.and
                              i32.store
                              br 2 (;@11;)
                            end
                            local.get 9
                            i32.const 16
                            i32.const 20
                            local.get 9
                            i32.load offset=16
                            local.get 4
                            i32.eq
                            select
                            i32.add
                            local.get 3
                            i32.store
                            local.get 3
                            i32.eqz
                            br_if 1 (;@11;)
                          end
                          local.get 3
                          local.get 9
                          i32.store offset=24
                          local.get 4
                          i32.load offset=16
                          local.tee 0
                          if  ;; label = @12
                            local.get 3
                            local.get 0
                            i32.store offset=16
                            local.get 0
                            local.get 3
                            i32.store offset=24
                          end
                          local.get 4
                          i32.load offset=20
                          local.tee 0
                          i32.eqz
                          br_if 0 (;@11;)
                          local.get 3
                          local.get 0
                          i32.store offset=20
                          local.get 0
                          local.get 3
                          i32.store offset=24
                        end
                        local.get 4
                        local.get 8
                        i32.add
                        local.set 4
                        local.get 2
                        local.get 8
                        i32.add
                        local.set 2
                      end
                      local.get 4
                      local.get 4
                      i32.load offset=4
                      i32.const -2
                      i32.and
                      i32.store offset=4
                      local.get 5
                      local.get 2
                      i32.const 1
                      i32.or
                      i32.store offset=4
                      local.get 2
                      local.get 5
                      i32.add
                      local.get 2
                      i32.store
                      local.get 2
                      i32.const 255
                      i32.le_u
                      if  ;; label = @10
                        local.get 2
                        i32.const 3
                        i32.shr_u
                        local.tee 1
                        i32.const 3
                        i32.shl
                        i32.const 3784
                        i32.add
                        local.set 0
                        block (result i32)  ;; label = @11
                          i32.const 3744
                          i32.load
                          local.tee 2
                          i32.const 1
                          local.get 1
                          i32.shl
                          local.tee 1
                          i32.and
                          i32.eqz
                          if  ;; label = @12
                            i32.const 3744
                            local.get 1
                            local.get 2
                            i32.or
                            i32.store
                            local.get 0
                            br 1 (;@11;)
                          end
                          local.get 0
                          i32.load offset=8
                        end
                        local.set 1
                        local.get 0
                        local.get 5
                        i32.store offset=8
                        local.get 1
                        local.get 5
                        i32.store offset=12
                        local.get 5
                        local.get 0
                        i32.store offset=12
                        local.get 5
                        local.get 1
                        i32.store offset=8
                        br 3 (;@7;)
                      end
                      i32.const 31
                      local.set 0
                      local.get 2
                      i32.const 16777215
                      i32.le_u
                      if  ;; label = @10
                        local.get 2
                        i32.const 8
                        i32.shr_u
                        local.tee 0
                        local.get 0
                        i32.const 1048320
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 8
                        i32.and
                        local.tee 0
                        i32.shl
                        local.tee 1
                        local.get 1
                        i32.const 520192
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 4
                        i32.and
                        local.tee 1
                        i32.shl
                        local.tee 3
                        local.get 3
                        i32.const 245760
                        i32.add
                        i32.const 16
                        i32.shr_u
                        i32.const 2
                        i32.and
                        local.tee 3
                        i32.shl
                        i32.const 15
                        i32.shr_u
                        local.get 0
                        local.get 1
                        i32.or
                        local.get 3
                        i32.or
                        i32.sub
                        local.tee 0
                        i32.const 1
                        i32.shl
                        local.get 2
                        local.get 0
                        i32.const 21
                        i32.add
                        i32.shr_u
                        i32.const 1
                        i32.and
                        i32.or
                        i32.const 28
                        i32.add
                        local.set 0
                      end
                      local.get 5
                      local.get 0
                      i32.store offset=28
                      local.get 5
                      i64.const 0
                      i64.store offset=16 align=4
                      local.get 0
                      i32.const 2
                      i32.shl
                      i32.const 4048
                      i32.add
                      local.set 1
                      block  ;; label = @10
                        i32.const 3748
                        i32.load
                        local.tee 3
                        i32.const 1
                        local.get 0
                        i32.shl
                        local.tee 4
                        i32.and
                        i32.eqz
                        if  ;; label = @11
                          i32.const 3748
                          local.get 3
                          local.get 4
                          i32.or
                          i32.store
                          local.get 1
                          local.get 5
                          i32.store
                          br 1 (;@10;)
                        end
                        local.get 2
                        i32.const 0
                        i32.const 25
                        local.get 0
                        i32.const 1
                        i32.shr_u
                        i32.sub
                        local.get 0
                        i32.const 31
                        i32.eq
                        select
                        i32.shl
                        local.set 0
                        local.get 1
                        i32.load
                        local.set 3
                        loop  ;; label = @11
                          local.get 3
                          local.tee 1
                          i32.load offset=4
                          i32.const -8
                          i32.and
                          local.get 2
                          i32.eq
                          br_if 3 (;@8;)
                          local.get 0
                          i32.const 29
                          i32.shr_u
                          local.set 3
                          local.get 0
                          i32.const 1
                          i32.shl
                          local.set 0
                          local.get 1
                          local.get 3
                          i32.const 4
                          i32.and
                          i32.add
                          local.tee 15
                          i32.const 16
                          i32.add
                          local.tee 4
                          i32.load
                          local.tee 3
                          br_if 0 (;@11;)
                        end
                        local.get 15
                        local.get 5
                        i32.store offset=16
                      end
                      local.get 5
                      local.get 1
                      i32.store offset=24
                      local.get 5
                      local.get 5
                      i32.store offset=12
                      local.get 5
                      local.get 5
                      i32.store offset=8
                      br 2 (;@7;)
                    end
                    i32.const 3768
                    local.get 3
                    i32.const -8
                    local.get 3
                    i32.sub
                    i32.const 7
                    i32.and
                    i32.const 0
                    local.get 3
                    i32.const 8
                    i32.add
                    i32.const 7
                    i32.and
                    select
                    local.tee 0
                    i32.add
                    local.tee 7
                    i32.store
                    i32.const 3756
                    local.get 6
                    local.get 0
                    i32.sub
                    i32.const 40
                    i32.sub
                    local.tee 0
                    i32.store
                    local.get 7
                    local.get 0
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    local.get 4
                    i32.const 36
                    i32.sub
                    i32.const 40
                    i32.store
                    i32.const 3772
                    i32.const 4232
                    i32.load
                    i32.store
                    local.get 1
                    local.get 2
                    i32.const 39
                    local.get 2
                    i32.sub
                    i32.const 7
                    i32.and
                    i32.const 0
                    local.get 2
                    i32.const 39
                    i32.sub
                    i32.const 7
                    i32.and
                    select
                    i32.add
                    i32.const 47
                    i32.sub
                    local.tee 0
                    local.get 0
                    local.get 1
                    i32.const 16
                    i32.add
                    i32.lt_u
                    select
                    local.tee 4
                    i32.const 27
                    i32.store offset=4
                    local.get 4
                    i32.const 4200
                    i64.load align=4
                    i64.store offset=16 align=4
                    local.get 4
                    i32.const 4192
                    i64.load align=4
                    i64.store offset=8 align=4
                    i32.const 4200
                    local.get 4
                    i32.const 8
                    i32.add
                    i32.store
                    i32.const 4196
                    local.get 6
                    i32.store
                    i32.const 4192
                    local.get 3
                    i32.store
                    i32.const 4204
                    i32.const 0
                    i32.store
                    local.get 4
                    i32.const 24
                    i32.add
                    local.set 0
                    loop  ;; label = @9
                      local.get 0
                      i32.const 7
                      i32.store offset=4
                      local.get 0
                      i32.const 8
                      i32.add
                      local.set 3
                      local.get 0
                      i32.const 4
                      i32.add
                      local.set 0
                      local.get 2
                      local.get 3
                      i32.gt_u
                      br_if 0 (;@9;)
                    end
                    local.get 1
                    local.get 4
                    i32.eq
                    br_if 3 (;@5;)
                    local.get 4
                    local.get 4
                    i32.load offset=4
                    i32.const -2
                    i32.and
                    i32.store offset=4
                    local.get 1
                    local.get 4
                    local.get 1
                    i32.sub
                    local.tee 6
                    i32.const 1
                    i32.or
                    i32.store offset=4
                    local.get 4
                    local.get 6
                    i32.store
                    local.get 6
                    i32.const 255
                    i32.le_u
                    if  ;; label = @9
                      local.get 6
                      i32.const 3
                      i32.shr_u
                      local.tee 2
                      i32.const 3
                      i32.shl
                      i32.const 3784
                      i32.add
                      local.set 0
                      block (result i32)  ;; label = @10
                        i32.const 3744
                        i32.load
                        local.tee 3
                        i32.const 1
                        local.get 2
                        i32.shl
                        local.tee 2
                        i32.and
                        i32.eqz
                        if  ;; label = @11
                          i32.const 3744
                          local.get 2
                          local.get 3
                          i32.or
                          i32.store
                          local.get 0
                          br 1 (;@10;)
                        end
                        local.get 0
                        i32.load offset=8
                      end
                      local.set 2
                      local.get 0
                      local.get 1
                      i32.store offset=8
                      local.get 2
                      local.get 1
                      i32.store offset=12
                      local.get 1
                      local.get 0
                      i32.store offset=12
                      local.get 1
                      local.get 2
                      i32.store offset=8
                      br 4 (;@5;)
                    end
                    i32.const 31
                    local.set 0
                    local.get 1
                    i64.const 0
                    i64.store offset=16 align=4
                    local.get 6
                    i32.const 16777215
                    i32.le_u
                    if  ;; label = @9
                      local.get 6
                      i32.const 8
                      i32.shr_u
                      local.tee 0
                      local.get 0
                      i32.const 1048320
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 8
                      i32.and
                      local.tee 0
                      i32.shl
                      local.tee 2
                      local.get 2
                      i32.const 520192
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 4
                      i32.and
                      local.tee 2
                      i32.shl
                      local.tee 3
                      local.get 3
                      i32.const 245760
                      i32.add
                      i32.const 16
                      i32.shr_u
                      i32.const 2
                      i32.and
                      local.tee 3
                      i32.shl
                      i32.const 15
                      i32.shr_u
                      local.get 0
                      local.get 2
                      i32.or
                      local.get 3
                      i32.or
                      i32.sub
                      local.tee 0
                      i32.const 1
                      i32.shl
                      local.get 6
                      local.get 0
                      i32.const 21
                      i32.add
                      i32.shr_u
                      i32.const 1
                      i32.and
                      i32.or
                      i32.const 28
                      i32.add
                      local.set 0
                    end
                    local.get 1
                    local.get 0
                    i32.store offset=28
                    local.get 0
                    i32.const 2
                    i32.shl
                    i32.const 4048
                    i32.add
                    local.set 2
                    block  ;; label = @9
                      i32.const 3748
                      i32.load
                      local.tee 3
                      i32.const 1
                      local.get 0
                      i32.shl
                      local.tee 4
                      i32.and
                      i32.eqz
                      if  ;; label = @10
                        i32.const 3748
                        local.get 3
                        local.get 4
                        i32.or
                        i32.store
                        local.get 2
                        local.get 1
                        i32.store
                        br 1 (;@9;)
                      end
                      local.get 6
                      i32.const 0
                      i32.const 25
                      local.get 0
                      i32.const 1
                      i32.shr_u
                      i32.sub
                      local.get 0
                      i32.const 31
                      i32.eq
                      select
                      i32.shl
                      local.set 0
                      local.get 2
                      i32.load
                      local.set 3
                      loop  ;; label = @10
                        local.get 3
                        local.tee 2
                        i32.load offset=4
                        i32.const -8
                        i32.and
                        local.get 6
                        i32.eq
                        br_if 4 (;@6;)
                        local.get 0
                        i32.const 29
                        i32.shr_u
                        local.set 3
                        local.get 0
                        i32.const 1
                        i32.shl
                        local.set 0
                        local.get 2
                        local.get 3
                        i32.const 4
                        i32.and
                        i32.add
                        local.tee 16
                        i32.const 16
                        i32.add
                        local.tee 4
                        i32.load
                        local.tee 3
                        br_if 0 (;@10;)
                      end
                      local.get 16
                      local.get 1
                      i32.store offset=16
                    end
                    local.get 1
                    local.get 2
                    i32.store offset=24
                    local.get 1
                    local.get 1
                    i32.store offset=12
                    local.get 1
                    local.get 1
                    i32.store offset=8
                    br 3 (;@5;)
                  end
                  local.get 1
                  i32.load offset=8
                  local.tee 0
                  local.get 5
                  i32.store offset=12
                  local.get 1
                  local.get 5
                  i32.store offset=8
                  local.get 5
                  i32.const 0
                  i32.store offset=24
                  local.get 5
                  local.get 1
                  i32.store offset=12
                  local.get 5
                  local.get 0
                  i32.store offset=8
                end
                local.get 6
                i32.const 8
                i32.add
                local.set 0
                br 5 (;@1;)
              end
              local.get 2
              i32.load offset=8
              local.tee 0
              local.get 1
              i32.store offset=12
              local.get 2
              local.get 1
              i32.store offset=8
              local.get 1
              i32.const 0
              i32.store offset=24
              local.get 1
              local.get 2
              i32.store offset=12
              local.get 1
              local.get 0
              i32.store offset=8
            end
            i32.const 3756
            i32.load
            local.tee 0
            local.get 5
            i32.le_u
            br_if 0 (;@4;)
            i32.const 3756
            local.get 0
            local.get 5
            i32.sub
            local.tee 1
            i32.store
            i32.const 3768
            i32.const 3768
            i32.load
            local.tee 0
            local.get 5
            i32.add
            local.tee 2
            i32.store
            local.get 2
            local.get 1
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 0
            local.get 5
            i32.const 3
            i32.or
            i32.store offset=4
            local.get 0
            i32.const 8
            i32.add
            local.set 0
            br 3 (;@1;)
          end
          call $__errno_location
          i32.const 48
          i32.store
          i32.const 0
          local.set 0
          br 2 (;@1;)
        end
        block  ;; label = @3
          local.get 9
          i32.eqz
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 4
            i32.load offset=28
            local.tee 2
            i32.const 2
            i32.shl
            i32.const 4048
            i32.add
            local.tee 0
            i32.load
            local.get 4
            i32.eq
            if  ;; label = @5
              local.get 0
              local.get 3
              i32.store
              local.get 3
              br_if 1 (;@4;)
              i32.const 3748
              local.get 8
              i32.const -2
              local.get 2
              i32.rotl
              i32.and
              local.tee 8
              i32.store
              br 2 (;@3;)
            end
            local.get 9
            i32.const 16
            i32.const 20
            local.get 9
            i32.load offset=16
            local.get 4
            i32.eq
            select
            i32.add
            local.get 3
            i32.store
            local.get 3
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 3
          local.get 9
          i32.store offset=24
          local.get 4
          i32.load offset=16
          local.tee 0
          if  ;; label = @4
            local.get 3
            local.get 0
            i32.store offset=16
            local.get 0
            local.get 3
            i32.store offset=24
          end
          local.get 4
          i32.load offset=20
          local.tee 0
          i32.eqz
          br_if 0 (;@3;)
          local.get 3
          local.get 0
          i32.store offset=20
          local.get 0
          local.get 3
          i32.store offset=24
        end
        block  ;; label = @3
          local.get 1
          i32.const 15
          i32.le_u
          if  ;; label = @4
            local.get 4
            local.get 1
            local.get 5
            i32.add
            local.tee 0
            i32.const 3
            i32.or
            i32.store offset=4
            local.get 0
            local.get 4
            i32.add
            local.tee 17
            i32.const 4
            i32.add
            local.tee 0
            local.get 17
            i32.load offset=4
            i32.const 1
            i32.or
            i32.store
            br 1 (;@3;)
          end
          local.get 4
          local.get 5
          i32.const 3
          i32.or
          i32.store offset=4
          local.get 7
          local.get 1
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 1
          local.get 7
          i32.add
          local.get 1
          i32.store
          local.get 1
          i32.const 255
          i32.le_u
          if  ;; label = @4
            local.get 1
            i32.const 3
            i32.shr_u
            local.tee 1
            i32.const 3
            i32.shl
            i32.const 3784
            i32.add
            local.set 0
            block (result i32)  ;; label = @5
              i32.const 3744
              i32.load
              local.tee 2
              i32.const 1
              local.get 1
              i32.shl
              local.tee 1
              i32.and
              i32.eqz
              if  ;; label = @6
                i32.const 3744
                local.get 1
                local.get 2
                i32.or
                i32.store
                local.get 0
                br 1 (;@5;)
              end
              local.get 0
              i32.load offset=8
            end
            local.set 1
            local.get 0
            local.get 7
            i32.store offset=8
            local.get 1
            local.get 7
            i32.store offset=12
            local.get 7
            local.get 0
            i32.store offset=12
            local.get 7
            local.get 1
            i32.store offset=8
            br 1 (;@3;)
          end
          i32.const 31
          local.set 0
          local.get 1
          i32.const 16777215
          i32.le_u
          if  ;; label = @4
            local.get 1
            i32.const 8
            i32.shr_u
            local.tee 0
            local.get 0
            i32.const 1048320
            i32.add
            i32.const 16
            i32.shr_u
            i32.const 8
            i32.and
            local.tee 0
            i32.shl
            local.tee 2
            local.get 2
            i32.const 520192
            i32.add
            i32.const 16
            i32.shr_u
            i32.const 4
            i32.and
            local.tee 2
            i32.shl
            local.tee 5
            local.get 5
            i32.const 245760
            i32.add
            i32.const 16
            i32.shr_u
            i32.const 2
            i32.and
            local.tee 5
            i32.shl
            i32.const 15
            i32.shr_u
            local.get 0
            local.get 2
            i32.or
            local.get 5
            i32.or
            i32.sub
            local.tee 0
            i32.const 1
            i32.shl
            local.get 1
            local.get 0
            i32.const 21
            i32.add
            i32.shr_u
            i32.const 1
            i32.and
            i32.or
            i32.const 28
            i32.add
            local.set 0
          end
          local.get 7
          local.get 0
          i32.store offset=28
          local.get 7
          i64.const 0
          i64.store offset=16 align=4
          local.get 0
          i32.const 2
          i32.shl
          i32.const 4048
          i32.add
          local.set 2
          block  ;; label = @4
            block  ;; label = @5
              local.get 8
              i32.const 1
              local.get 0
              i32.shl
              local.tee 5
              i32.and
              i32.eqz
              if  ;; label = @6
                i32.const 3748
                local.get 5
                local.get 8
                i32.or
                i32.store
                local.get 2
                local.get 7
                i32.store
                br 1 (;@5;)
              end
              local.get 1
              i32.const 0
              i32.const 25
              local.get 0
              i32.const 1
              i32.shr_u
              i32.sub
              local.get 0
              i32.const 31
              i32.eq
              select
              i32.shl
              local.set 0
              local.get 2
              i32.load
              local.set 5
              loop  ;; label = @6
                local.get 5
                local.tee 2
                i32.load offset=4
                i32.const -8
                i32.and
                local.get 1
                i32.eq
                br_if 2 (;@4;)
                local.get 0
                i32.const 29
                i32.shr_u
                local.set 5
                local.get 0
                i32.const 1
                i32.shl
                local.set 0
                local.get 2
                local.get 5
                i32.const 4
                i32.and
                i32.add
                local.tee 18
                i32.const 16
                i32.add
                local.tee 3
                i32.load
                local.tee 5
                br_if 0 (;@6;)
              end
              local.get 18
              local.get 7
              i32.store offset=16
            end
            local.get 7
            local.get 2
            i32.store offset=24
            local.get 7
            local.get 7
            i32.store offset=12
            local.get 7
            local.get 7
            i32.store offset=8
            br 1 (;@3;)
          end
          local.get 2
          i32.load offset=8
          local.tee 0
          local.get 7
          i32.store offset=12
          local.get 2
          local.get 7
          i32.store offset=8
          local.get 7
          i32.const 0
          i32.store offset=24
          local.get 7
          local.get 2
          i32.store offset=12
          local.get 7
          local.get 0
          i32.store offset=8
        end
        local.get 4
        i32.const 8
        i32.add
        local.set 0
        br 1 (;@1;)
      end
      block  ;; label = @2
        local.get 10
        i32.eqz
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 3
          i32.load offset=28
          local.tee 2
          i32.const 2
          i32.shl
          i32.const 4048
          i32.add
          local.tee 0
          i32.load
          local.get 3
          i32.eq
          if  ;; label = @4
            local.get 0
            local.get 4
            i32.store
            local.get 4
            br_if 1 (;@3;)
            i32.const 3748
            local.get 9
            i32.const -2
            local.get 2
            i32.rotl
            i32.and
            i32.store
            br 2 (;@2;)
          end
          local.get 10
          i32.const 16
          i32.const 20
          local.get 10
          i32.load offset=16
          local.get 3
          i32.eq
          select
          i32.add
          local.get 4
          i32.store
          local.get 4
          i32.eqz
          br_if 1 (;@2;)
        end
        local.get 4
        local.get 10
        i32.store offset=24
        local.get 3
        i32.load offset=16
        local.tee 0
        if  ;; label = @3
          local.get 4
          local.get 0
          i32.store offset=16
          local.get 0
          local.get 4
          i32.store offset=24
        end
        local.get 3
        i32.load offset=20
        local.tee 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 4
        local.get 0
        i32.store offset=20
        local.get 0
        local.get 4
        i32.store offset=24
      end
      block  ;; label = @2
        local.get 1
        i32.const 15
        i32.le_u
        if  ;; label = @3
          local.get 3
          local.get 1
          local.get 5
          i32.add
          local.tee 0
          i32.const 3
          i32.or
          i32.store offset=4
          local.get 0
          local.get 3
          i32.add
          local.tee 19
          i32.const 4
          i32.add
          local.tee 0
          local.get 19
          i32.load offset=4
          i32.const 1
          i32.or
          i32.store
          br 1 (;@2;)
        end
        local.get 3
        local.get 5
        i32.const 3
        i32.or
        i32.store offset=4
        local.get 11
        local.get 1
        i32.const 1
        i32.or
        i32.store offset=4
        local.get 1
        local.get 11
        i32.add
        local.get 1
        i32.store
        local.get 8
        if  ;; label = @3
          local.get 8
          i32.const 3
          i32.shr_u
          local.tee 5
          i32.const 3
          i32.shl
          i32.const 3784
          i32.add
          local.set 2
          i32.const 3764
          i32.load
          local.set 0
          block (result i32)  ;; label = @4
            i32.const 1
            local.get 5
            i32.shl
            local.tee 5
            local.get 6
            i32.and
            i32.eqz
            if  ;; label = @5
              i32.const 3744
              local.get 5
              local.get 6
              i32.or
              i32.store
              local.get 2
              br 1 (;@4;)
            end
            local.get 2
            i32.load offset=8
          end
          local.set 5
          local.get 2
          local.get 0
          i32.store offset=8
          local.get 5
          local.get 0
          i32.store offset=12
          local.get 0
          local.get 2
          i32.store offset=12
          local.get 0
          local.get 5
          i32.store offset=8
        end
        i32.const 3764
        local.get 11
        i32.store
        i32.const 3752
        local.get 1
        i32.store
      end
      local.get 3
      i32.const 8
      i32.add
      local.set 0
    end
    local.get 12
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func $dlfree (type 5) (param i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 8
        i32.sub
        local.tee 2
        local.get 0
        i32.const 4
        i32.sub
        i32.load
        local.tee 1
        i32.const -8
        i32.and
        local.tee 0
        i32.add
        local.set 5
        block  ;; label = @3
          local.get 1
          i32.const 1
          i32.and
          br_if 0 (;@3;)
          local.get 1
          i32.const 3
          i32.and
          i32.eqz
          br_if 1 (;@2;)
          local.get 2
          local.get 2
          i32.load
          local.tee 1
          i32.sub
          local.tee 2
          i32.const 3760
          i32.load
          local.tee 4
          i32.lt_u
          br_if 1 (;@2;)
          local.get 0
          local.get 1
          i32.add
          local.set 0
          local.get 2
          i32.const 3764
          i32.load
          i32.ne
          if  ;; label = @4
            local.get 1
            i32.const 255
            i32.le_u
            if  ;; label = @5
              local.get 2
              i32.load offset=8
              local.tee 4
              local.get 1
              i32.const 3
              i32.shr_u
              local.tee 7
              i32.const 3
              i32.shl
              i32.const 3784
              i32.add
              local.tee 3
              i32.eq
              drop
              local.get 4
              local.get 2
              i32.load offset=12
              local.tee 1
              i32.eq
              if  ;; label = @6
                i32.const 3744
                i32.const 3744
                i32.load
                i32.const -2
                local.get 7
                i32.rotl
                i32.and
                i32.store
                br 3 (;@3;)
              end
              local.get 4
              local.get 1
              i32.store offset=12
              local.get 1
              local.get 4
              i32.store offset=8
              br 2 (;@3;)
            end
            local.get 2
            i32.load offset=24
            local.set 6
            block  ;; label = @5
              local.get 2
              local.get 2
              i32.load offset=12
              local.tee 3
              i32.ne
              if  ;; label = @6
                local.get 2
                i32.load offset=8
                local.tee 1
                local.get 3
                i32.store offset=12
                local.get 3
                local.get 1
                i32.store offset=8
                br 1 (;@5;)
              end
              block  ;; label = @6
                local.get 2
                i32.const 20
                i32.add
                local.tee 1
                i32.load
                local.tee 4
                br_if 0 (;@6;)
                local.get 2
                i32.const 16
                i32.add
                local.tee 1
                i32.load
                local.tee 4
                br_if 0 (;@6;)
                i32.const 0
                local.set 3
                br 1 (;@5;)
              end
              loop  ;; label = @6
                local.get 1
                local.set 7
                local.get 4
                local.tee 3
                i32.const 20
                i32.add
                local.tee 1
                i32.load
                local.tee 4
                br_if 0 (;@6;)
                local.get 3
                i32.const 16
                i32.add
                local.set 1
                local.get 3
                i32.load offset=16
                local.tee 4
                br_if 0 (;@6;)
              end
              local.get 7
              i32.const 0
              i32.store
            end
            local.get 6
            i32.eqz
            br_if 1 (;@3;)
            block  ;; label = @5
              local.get 2
              local.get 2
              i32.load offset=28
              local.tee 4
              i32.const 2
              i32.shl
              i32.const 4048
              i32.add
              local.tee 1
              i32.load
              i32.eq
              if  ;; label = @6
                local.get 1
                local.get 3
                i32.store
                local.get 3
                br_if 1 (;@5;)
                i32.const 3748
                i32.const 3748
                i32.load
                i32.const -2
                local.get 4
                i32.rotl
                i32.and
                i32.store
                br 3 (;@3;)
              end
              local.get 6
              i32.const 16
              i32.const 20
              local.get 6
              i32.load offset=16
              local.get 2
              i32.eq
              select
              i32.add
              local.get 3
              i32.store
              local.get 3
              i32.eqz
              br_if 2 (;@3;)
            end
            local.get 3
            local.get 6
            i32.store offset=24
            local.get 2
            i32.load offset=16
            local.tee 1
            if  ;; label = @5
              local.get 3
              local.get 1
              i32.store offset=16
              local.get 1
              local.get 3
              i32.store offset=24
            end
            local.get 2
            i32.load offset=20
            local.tee 1
            i32.eqz
            br_if 1 (;@3;)
            local.get 3
            local.get 1
            i32.store offset=20
            local.get 1
            local.get 3
            i32.store offset=24
            br 1 (;@3;)
          end
          local.get 5
          i32.load offset=4
          local.tee 1
          i32.const 3
          i32.and
          i32.const 3
          i32.ne
          br_if 0 (;@3;)
          i32.const 3752
          local.get 0
          i32.store
          local.get 5
          local.get 1
          i32.const -2
          i32.and
          i32.store offset=4
          br 2 (;@1;)
        end
        local.get 2
        local.get 5
        i32.ge_u
        br_if 0 (;@2;)
        local.get 5
        i32.load offset=4
        local.tee 1
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 1
          i32.const 2
          i32.and
          i32.eqz
          if  ;; label = @4
            local.get 5
            i32.const 3768
            i32.load
            i32.eq
            if  ;; label = @5
              i32.const 3768
              local.get 2
              i32.store
              i32.const 3756
              i32.const 3756
              i32.load
              local.get 0
              i32.add
              local.tee 0
              i32.store
              local.get 2
              local.get 0
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 2
              i32.const 3764
              i32.load
              i32.ne
              br_if 3 (;@2;)
              i32.const 3752
              i32.const 0
              i32.store
              i32.const 3764
              i32.const 0
              i32.store
              return
            end
            local.get 5
            i32.const 3764
            i32.load
            i32.eq
            if  ;; label = @5
              i32.const 3764
              local.get 2
              i32.store
              i32.const 3752
              i32.const 3752
              i32.load
              local.get 0
              i32.add
              local.tee 0
              i32.store
              br 4 (;@1;)
            end
            local.get 1
            i32.const -8
            i32.and
            local.get 0
            i32.add
            local.set 0
            block  ;; label = @5
              local.get 1
              i32.const 255
              i32.le_u
              if  ;; label = @6
                local.get 5
                i32.load offset=8
                local.tee 4
                local.get 1
                i32.const 3
                i32.shr_u
                local.tee 7
                i32.const 3
                i32.shl
                i32.const 3784
                i32.add
                local.tee 3
                i32.eq
                drop
                local.get 4
                local.get 5
                i32.load offset=12
                local.tee 1
                i32.eq
                if  ;; label = @7
                  i32.const 3744
                  i32.const 3744
                  i32.load
                  i32.const -2
                  local.get 7
                  i32.rotl
                  i32.and
                  i32.store
                  br 2 (;@5;)
                end
                local.get 4
                local.get 1
                i32.store offset=12
                local.get 1
                local.get 4
                i32.store offset=8
                br 1 (;@5;)
              end
              local.get 5
              i32.load offset=24
              local.set 6
              block  ;; label = @6
                local.get 5
                local.get 5
                i32.load offset=12
                local.tee 3
                i32.ne
                if  ;; label = @7
                  local.get 5
                  i32.load offset=8
                  local.tee 1
                  i32.const 3760
                  i32.load
                  i32.lt_u
                  drop
                  local.get 1
                  local.get 3
                  i32.store offset=12
                  local.get 3
                  local.get 1
                  i32.store offset=8
                  br 1 (;@6;)
                end
                block  ;; label = @7
                  local.get 5
                  i32.const 20
                  i32.add
                  local.tee 1
                  i32.load
                  local.tee 4
                  br_if 0 (;@7;)
                  local.get 5
                  i32.const 16
                  i32.add
                  local.tee 1
                  i32.load
                  local.tee 4
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 3
                  br 1 (;@6;)
                end
                loop  ;; label = @7
                  local.get 1
                  local.set 7
                  local.get 4
                  local.tee 3
                  i32.const 20
                  i32.add
                  local.tee 1
                  i32.load
                  local.tee 4
                  br_if 0 (;@7;)
                  local.get 3
                  i32.const 16
                  i32.add
                  local.set 1
                  local.get 3
                  i32.load offset=16
                  local.tee 4
                  br_if 0 (;@7;)
                end
                local.get 7
                i32.const 0
                i32.store
              end
              local.get 6
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 5
                local.get 5
                i32.load offset=28
                local.tee 4
                i32.const 2
                i32.shl
                i32.const 4048
                i32.add
                local.tee 1
                i32.load
                i32.eq
                if  ;; label = @7
                  local.get 1
                  local.get 3
                  i32.store
                  local.get 3
                  br_if 1 (;@6;)
                  i32.const 3748
                  i32.const 3748
                  i32.load
                  i32.const -2
                  local.get 4
                  i32.rotl
                  i32.and
                  i32.store
                  br 2 (;@5;)
                end
                local.get 6
                i32.const 16
                i32.const 20
                local.get 6
                i32.load offset=16
                local.get 5
                i32.eq
                select
                i32.add
                local.get 3
                i32.store
                local.get 3
                i32.eqz
                br_if 1 (;@5;)
              end
              local.get 3
              local.get 6
              i32.store offset=24
              local.get 5
              i32.load offset=16
              local.tee 1
              if  ;; label = @6
                local.get 3
                local.get 1
                i32.store offset=16
                local.get 1
                local.get 3
                i32.store offset=24
              end
              local.get 5
              i32.load offset=20
              local.tee 1
              i32.eqz
              br_if 0 (;@5;)
              local.get 3
              local.get 1
              i32.store offset=20
              local.get 1
              local.get 3
              i32.store offset=24
            end
            local.get 2
            local.get 0
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 0
            local.get 2
            i32.add
            local.get 0
            i32.store
            local.get 2
            i32.const 3764
            i32.load
            i32.ne
            br_if 1 (;@3;)
            i32.const 3752
            local.get 0
            i32.store
            return
          end
          local.get 5
          local.get 1
          i32.const -2
          i32.and
          i32.store offset=4
          local.get 2
          local.get 0
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 0
          local.get 2
          i32.add
          local.get 0
          i32.store
        end
        local.get 0
        i32.const 255
        i32.le_u
        if  ;; label = @3
          local.get 0
          i32.const 3
          i32.shr_u
          local.tee 1
          i32.const 3
          i32.shl
          i32.const 3784
          i32.add
          local.set 0
          block (result i32)  ;; label = @4
            i32.const 3744
            i32.load
            local.tee 4
            i32.const 1
            local.get 1
            i32.shl
            local.tee 1
            i32.and
            i32.eqz
            if  ;; label = @5
              i32.const 3744
              local.get 1
              local.get 4
              i32.or
              i32.store
              local.get 0
              br 1 (;@4;)
            end
            local.get 0
            i32.load offset=8
          end
          local.set 1
          local.get 0
          local.get 2
          i32.store offset=8
          local.get 1
          local.get 2
          i32.store offset=12
          local.get 2
          local.get 0
          i32.store offset=12
          local.get 2
          local.get 1
          i32.store offset=8
          return
        end
        i32.const 31
        local.set 1
        local.get 2
        i64.const 0
        i64.store offset=16 align=4
        local.get 0
        i32.const 16777215
        i32.le_u
        if  ;; label = @3
          local.get 0
          i32.const 8
          i32.shr_u
          local.tee 1
          local.get 1
          i32.const 1048320
          i32.add
          i32.const 16
          i32.shr_u
          i32.const 8
          i32.and
          local.tee 1
          i32.shl
          local.tee 4
          local.get 4
          i32.const 520192
          i32.add
          i32.const 16
          i32.shr_u
          i32.const 4
          i32.and
          local.tee 4
          i32.shl
          local.tee 3
          local.get 3
          i32.const 245760
          i32.add
          i32.const 16
          i32.shr_u
          i32.const 2
          i32.and
          local.tee 3
          i32.shl
          i32.const 15
          i32.shr_u
          local.get 1
          local.get 4
          i32.or
          local.get 3
          i32.or
          i32.sub
          local.tee 1
          i32.const 1
          i32.shl
          local.get 0
          local.get 1
          i32.const 21
          i32.add
          i32.shr_u
          i32.const 1
          i32.and
          i32.or
          i32.const 28
          i32.add
          local.set 1
        end
        local.get 2
        local.get 1
        i32.store offset=28
        local.get 1
        i32.const 2
        i32.shl
        i32.const 4048
        i32.add
        local.set 4
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              i32.const 3748
              i32.load
              local.tee 3
              i32.const 1
              local.get 1
              i32.shl
              local.tee 5
              i32.and
              i32.eqz
              if  ;; label = @6
                i32.const 3748
                local.get 3
                local.get 5
                i32.or
                i32.store
                local.get 4
                local.get 2
                i32.store
                br 1 (;@5;)
              end
              local.get 0
              i32.const 0
              i32.const 25
              local.get 1
              i32.const 1
              i32.shr_u
              i32.sub
              local.get 1
              i32.const 31
              i32.eq
              select
              i32.shl
              local.set 1
              local.get 4
              i32.load
              local.set 3
              loop  ;; label = @6
                local.get 3
                local.tee 4
                i32.load offset=4
                i32.const -8
                i32.and
                local.get 0
                i32.eq
                br_if 2 (;@4;)
                local.get 1
                i32.const 29
                i32.shr_u
                local.set 3
                local.get 1
                i32.const 1
                i32.shl
                local.set 1
                local.get 4
                local.get 3
                i32.const 4
                i32.and
                i32.add
                local.tee 8
                i32.const 16
                i32.add
                local.tee 5
                i32.load
                local.tee 3
                br_if 0 (;@6;)
              end
              local.get 8
              local.get 2
              i32.store offset=16
            end
            local.get 2
            local.get 4
            i32.store offset=24
            local.get 2
            local.get 2
            i32.store offset=12
            local.get 2
            local.get 2
            i32.store offset=8
            br 1 (;@3;)
          end
          local.get 4
          i32.load offset=8
          local.tee 0
          local.get 2
          i32.store offset=12
          local.get 4
          local.get 2
          i32.store offset=8
          local.get 2
          i32.const 0
          i32.store offset=24
          local.get 2
          local.get 4
          i32.store offset=12
          local.get 2
          local.get 0
          i32.store offset=8
        end
        i32.const 3776
        i32.const 3776
        i32.load
        i32.const 1
        i32.sub
        local.tee 2
        i32.const -1
        local.get 2
        select
        i32.store
      end
      return
    end
    local.get 2
    local.get 0
    i32.const 1
    i32.or
    i32.store offset=4
    local.get 0
    local.get 2
    i32.add
    local.get 0
    i32.store)
  (func $dlrealloc (type 2) (param i32 i32) (result i32)
    (local i32 i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      local.get 1
      call $dlmalloc
      return
    end
    local.get 1
    i32.const -64
    i32.ge_u
    if  ;; label = @1
      call $__errno_location
      i32.const 48
      i32.store
      i32.const 0
      return
    end
    local.get 0
    i32.const 8
    i32.sub
    i32.const 16
    local.get 1
    i32.const 11
    i32.add
    i32.const -8
    i32.and
    local.get 1
    i32.const 11
    i32.lt_u
    select
    call $try_realloc_chunk
    local.tee 2
    if  ;; label = @1
      local.get 2
      i32.const 8
      i32.add
      return
    end
    local.get 1
    call $dlmalloc
    local.tee 2
    i32.eqz
    if  ;; label = @1
      i32.const 0
      return
    end
    local.get 2
    local.get 0
    i32.const -4
    i32.const -8
    local.get 0
    i32.const 4
    i32.sub
    i32.load
    local.tee 3
    i32.const 3
    i32.and
    select
    local.get 3
    i32.const -8
    i32.and
    i32.add
    local.tee 3
    local.get 1
    local.get 1
    local.get 3
    i32.gt_u
    select
    call $__memcpy
    drop
    local.get 0
    call $dlfree
    local.get 2)
  (func $try_realloc_chunk (type 2) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    local.get 0
    i32.load offset=4
    local.tee 6
    i32.const -8
    i32.and
    local.set 2
    block  ;; label = @1
      local.get 6
      i32.const 3
      i32.and
      i32.eqz
      if  ;; label = @2
        local.get 1
        i32.const 256
        i32.lt_u
        if  ;; label = @3
          i32.const 0
          return
        end
        local.get 1
        i32.const 4
        i32.add
        local.get 2
        i32.le_u
        if  ;; label = @3
          local.get 0
          local.set 3
          local.get 2
          local.get 1
          i32.sub
          i32.const 4224
          i32.load
          i32.const 1
          i32.shl
          i32.le_u
          br_if 2 (;@1;)
        end
        i32.const 0
        return
      end
      block  ;; label = @2
        local.get 1
        local.get 2
        i32.le_u
        if  ;; label = @3
          local.get 2
          local.get 1
          i32.sub
          local.tee 3
          i32.const 16
          i32.lt_u
          br_if 1 (;@2;)
          local.get 0
          local.get 6
          i32.const 1
          i32.and
          local.get 1
          i32.or
          i32.const 2
          i32.or
          i32.store offset=4
          local.get 0
          local.get 1
          i32.add
          local.tee 1
          local.get 3
          i32.const 3
          i32.or
          i32.store offset=4
          local.get 0
          local.get 2
          i32.const 4
          i32.or
          i32.add
          local.tee 2
          local.get 2
          i32.load
          i32.const 1
          i32.or
          i32.store
          local.get 1
          local.get 3
          call $dispose_chunk
          br 1 (;@2;)
        end
        local.get 0
        local.get 2
        i32.add
        local.tee 5
        i32.const 3768
        i32.load
        i32.eq
        if  ;; label = @3
          i32.const 3756
          i32.load
          local.get 2
          i32.add
          local.tee 2
          local.get 1
          i32.le_u
          br_if 2 (;@1;)
          local.get 0
          local.get 6
          i32.const 1
          i32.and
          local.get 1
          i32.or
          i32.const 2
          i32.or
          i32.store offset=4
          local.get 0
          local.get 1
          i32.add
          local.tee 6
          local.get 2
          local.get 1
          i32.sub
          local.tee 1
          i32.const 1
          i32.or
          i32.store offset=4
          i32.const 3756
          local.get 1
          i32.store
          i32.const 3768
          local.get 6
          i32.store
          br 1 (;@2;)
        end
        local.get 5
        i32.const 3764
        i32.load
        i32.eq
        if  ;; label = @3
          i32.const 3752
          i32.load
          local.get 2
          i32.add
          local.tee 2
          local.get 1
          i32.lt_u
          br_if 2 (;@1;)
          block  ;; label = @4
            local.get 2
            local.get 1
            i32.sub
            local.tee 3
            i32.const 16
            i32.ge_u
            if  ;; label = @5
              local.get 0
              local.get 6
              i32.const 1
              i32.and
              local.get 1
              i32.or
              i32.const 2
              i32.or
              i32.store offset=4
              local.get 0
              local.get 1
              i32.add
              local.tee 1
              local.get 3
              i32.const 1
              i32.or
              i32.store offset=4
              local.get 0
              local.get 2
              i32.add
              local.tee 2
              local.get 3
              i32.store
              local.get 2
              local.get 2
              i32.load offset=4
              i32.const -2
              i32.and
              i32.store offset=4
              br 1 (;@4;)
            end
            local.get 0
            local.get 6
            i32.const 1
            i32.and
            local.get 2
            i32.or
            i32.const 2
            i32.or
            i32.store offset=4
            local.get 0
            local.get 2
            i32.add
            local.tee 11
            i32.const 4
            i32.add
            local.tee 1
            local.get 11
            i32.load offset=4
            i32.const 1
            i32.or
            i32.store
            i32.const 0
            local.set 3
            i32.const 0
            local.set 1
          end
          i32.const 3764
          local.get 1
          i32.store
          i32.const 3752
          local.get 3
          i32.store
          br 1 (;@2;)
        end
        local.get 5
        i32.load offset=4
        local.tee 4
        i32.const 2
        i32.and
        br_if 1 (;@1;)
        local.get 4
        i32.const -8
        i32.and
        local.get 2
        i32.add
        local.tee 7
        local.get 1
        i32.lt_u
        br_if 1 (;@1;)
        local.get 7
        local.get 1
        i32.sub
        local.set 9
        block  ;; label = @3
          local.get 4
          i32.const 255
          i32.le_u
          if  ;; label = @4
            local.get 5
            i32.load offset=8
            local.tee 2
            local.get 4
            i32.const 3
            i32.shr_u
            local.tee 10
            i32.const 3
            i32.shl
            i32.const 3784
            i32.add
            local.tee 4
            i32.eq
            drop
            local.get 2
            local.get 5
            i32.load offset=12
            local.tee 3
            i32.eq
            if  ;; label = @5
              i32.const 3744
              i32.const 3744
              i32.load
              i32.const -2
              local.get 10
              i32.rotl
              i32.and
              i32.store
              br 2 (;@3;)
            end
            local.get 2
            local.get 3
            i32.store offset=12
            local.get 3
            local.get 2
            i32.store offset=8
            br 1 (;@3;)
          end
          local.get 5
          i32.load offset=24
          local.set 8
          block  ;; label = @4
            local.get 5
            local.get 5
            i32.load offset=12
            local.tee 4
            i32.ne
            if  ;; label = @5
              local.get 5
              i32.load offset=8
              local.tee 2
              i32.const 3760
              i32.load
              i32.lt_u
              drop
              local.get 2
              local.get 4
              i32.store offset=12
              local.get 4
              local.get 2
              i32.store offset=8
              br 1 (;@4;)
            end
            block  ;; label = @5
              local.get 5
              i32.const 20
              i32.add
              local.tee 2
              i32.load
              local.tee 3
              br_if 0 (;@5;)
              local.get 5
              i32.const 16
              i32.add
              local.tee 2
              i32.load
              local.tee 3
              br_if 0 (;@5;)
              i32.const 0
              local.set 4
              br 1 (;@4;)
            end
            loop  ;; label = @5
              local.get 2
              local.set 10
              local.get 3
              local.tee 4
              i32.const 20
              i32.add
              local.tee 2
              i32.load
              local.tee 3
              br_if 0 (;@5;)
              local.get 4
              i32.const 16
              i32.add
              local.set 2
              local.get 4
              i32.load offset=16
              local.tee 3
              br_if 0 (;@5;)
            end
            local.get 10
            i32.const 0
            i32.store
          end
          local.get 8
          i32.eqz
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 5
            local.get 5
            i32.load offset=28
            local.tee 3
            i32.const 2
            i32.shl
            i32.const 4048
            i32.add
            local.tee 2
            i32.load
            i32.eq
            if  ;; label = @5
              local.get 2
              local.get 4
              i32.store
              local.get 4
              br_if 1 (;@4;)
              i32.const 3748
              i32.const 3748
              i32.load
              i32.const -2
              local.get 3
              i32.rotl
              i32.and
              i32.store
              br 2 (;@3;)
            end
            local.get 8
            i32.const 16
            i32.const 20
            local.get 8
            i32.load offset=16
            local.get 5
            i32.eq
            select
            i32.add
            local.get 4
            i32.store
            local.get 4
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 4
          local.get 8
          i32.store offset=24
          local.get 5
          i32.load offset=16
          local.tee 2
          if  ;; label = @4
            local.get 4
            local.get 2
            i32.store offset=16
            local.get 2
            local.get 4
            i32.store offset=24
          end
          local.get 5
          i32.load offset=20
          local.tee 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          local.get 2
          i32.store offset=20
          local.get 2
          local.get 4
          i32.store offset=24
        end
        local.get 9
        i32.const 15
        i32.le_u
        if  ;; label = @3
          local.get 0
          local.get 6
          i32.const 1
          i32.and
          local.get 7
          i32.or
          i32.const 2
          i32.or
          i32.store offset=4
          local.get 0
          local.get 7
          i32.const 4
          i32.or
          i32.add
          local.tee 1
          local.get 1
          i32.load
          i32.const 1
          i32.or
          i32.store
          br 1 (;@2;)
        end
        local.get 0
        local.get 6
        i32.const 1
        i32.and
        local.get 1
        i32.or
        i32.const 2
        i32.or
        i32.store offset=4
        local.get 0
        local.get 1
        i32.add
        local.tee 1
        local.get 9
        i32.const 3
        i32.or
        i32.store offset=4
        local.get 0
        local.get 7
        i32.const 4
        i32.or
        i32.add
        local.tee 2
        local.get 2
        i32.load
        i32.const 1
        i32.or
        i32.store
        local.get 1
        local.get 9
        call $dispose_chunk
      end
      local.get 0
      local.set 3
    end
    local.get 3)
  (func $dispose_chunk (type 6) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    local.get 0
    local.get 1
    i32.add
    local.set 5
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=4
        local.tee 2
        i32.const 1
        i32.and
        br_if 0 (;@2;)
        local.get 2
        i32.const 3
        i32.and
        i32.eqz
        br_if 1 (;@1;)
        local.get 0
        i32.load
        local.tee 2
        local.get 1
        i32.add
        local.set 1
        block  ;; label = @3
          local.get 0
          local.get 2
          i32.sub
          local.tee 0
          i32.const 3764
          i32.load
          i32.ne
          if  ;; label = @4
            local.get 2
            i32.const 255
            i32.le_u
            if  ;; label = @5
              local.get 0
              i32.load offset=8
              local.tee 4
              local.get 2
              i32.const 3
              i32.shr_u
              local.tee 7
              i32.const 3
              i32.shl
              i32.const 3784
              i32.add
              local.tee 3
              i32.eq
              drop
              local.get 0
              i32.load offset=12
              local.tee 2
              local.get 4
              i32.ne
              br_if 2 (;@3;)
              i32.const 3744
              i32.const 3744
              i32.load
              i32.const -2
              local.get 7
              i32.rotl
              i32.and
              i32.store
              br 3 (;@2;)
            end
            local.get 0
            i32.load offset=24
            local.set 6
            block  ;; label = @5
              local.get 0
              local.get 0
              i32.load offset=12
              local.tee 3
              i32.ne
              if  ;; label = @6
                local.get 0
                i32.load offset=8
                local.tee 2
                i32.const 3760
                i32.load
                i32.lt_u
                drop
                local.get 2
                local.get 3
                i32.store offset=12
                local.get 3
                local.get 2
                i32.store offset=8
                br 1 (;@5;)
              end
              block  ;; label = @6
                local.get 0
                i32.const 20
                i32.add
                local.tee 2
                i32.load
                local.tee 4
                br_if 0 (;@6;)
                local.get 0
                i32.const 16
                i32.add
                local.tee 2
                i32.load
                local.tee 4
                br_if 0 (;@6;)
                i32.const 0
                local.set 3
                br 1 (;@5;)
              end
              loop  ;; label = @6
                local.get 2
                local.set 7
                local.get 4
                local.tee 3
                i32.const 20
                i32.add
                local.tee 2
                i32.load
                local.tee 4
                br_if 0 (;@6;)
                local.get 3
                i32.const 16
                i32.add
                local.set 2
                local.get 3
                i32.load offset=16
                local.tee 4
                br_if 0 (;@6;)
              end
              local.get 7
              i32.const 0
              i32.store
            end
            local.get 6
            i32.eqz
            br_if 2 (;@2;)
            block  ;; label = @5
              local.get 0
              local.get 0
              i32.load offset=28
              local.tee 4
              i32.const 2
              i32.shl
              i32.const 4048
              i32.add
              local.tee 2
              i32.load
              i32.eq
              if  ;; label = @6
                local.get 2
                local.get 3
                i32.store
                local.get 3
                br_if 1 (;@5;)
                i32.const 3748
                i32.const 3748
                i32.load
                i32.const -2
                local.get 4
                i32.rotl
                i32.and
                i32.store
                br 4 (;@2;)
              end
              local.get 6
              i32.const 16
              i32.const 20
              local.get 6
              i32.load offset=16
              local.get 0
              i32.eq
              select
              i32.add
              local.get 3
              i32.store
              local.get 3
              i32.eqz
              br_if 3 (;@2;)
            end
            local.get 3
            local.get 6
            i32.store offset=24
            local.get 0
            i32.load offset=16
            local.tee 2
            if  ;; label = @5
              local.get 3
              local.get 2
              i32.store offset=16
              local.get 2
              local.get 3
              i32.store offset=24
            end
            local.get 0
            i32.load offset=20
            local.tee 2
            i32.eqz
            br_if 2 (;@2;)
            local.get 3
            local.get 2
            i32.store offset=20
            local.get 2
            local.get 3
            i32.store offset=24
            br 2 (;@2;)
          end
          local.get 5
          i32.load offset=4
          local.tee 2
          i32.const 3
          i32.and
          i32.const 3
          i32.ne
          br_if 1 (;@2;)
          i32.const 3752
          local.get 1
          i32.store
          local.get 5
          local.get 2
          i32.const -2
          i32.and
          i32.store offset=4
          local.get 0
          local.get 1
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 5
          local.get 1
          i32.store
          return
        end
        local.get 4
        local.get 2
        i32.store offset=12
        local.get 2
        local.get 4
        i32.store offset=8
      end
      block  ;; label = @2
        local.get 5
        i32.load offset=4
        local.tee 2
        i32.const 2
        i32.and
        i32.eqz
        if  ;; label = @3
          local.get 5
          i32.const 3768
          i32.load
          i32.eq
          if  ;; label = @4
            i32.const 3768
            local.get 0
            i32.store
            i32.const 3756
            i32.const 3756
            i32.load
            local.get 1
            i32.add
            local.tee 1
            i32.store
            local.get 0
            local.get 1
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 0
            i32.const 3764
            i32.load
            i32.ne
            br_if 3 (;@1;)
            i32.const 3752
            i32.const 0
            i32.store
            i32.const 3764
            i32.const 0
            i32.store
            return
          end
          local.get 5
          i32.const 3764
          i32.load
          i32.eq
          if  ;; label = @4
            i32.const 3764
            local.get 0
            i32.store
            i32.const 3752
            i32.const 3752
            i32.load
            local.get 1
            i32.add
            local.tee 1
            i32.store
            local.get 0
            local.get 1
            i32.const 1
            i32.or
            i32.store offset=4
            local.get 0
            local.get 1
            i32.add
            local.get 1
            i32.store
            return
          end
          local.get 2
          i32.const -8
          i32.and
          local.get 1
          i32.add
          local.set 1
          block  ;; label = @4
            local.get 2
            i32.const 255
            i32.le_u
            if  ;; label = @5
              local.get 5
              i32.load offset=8
              local.tee 4
              local.get 2
              i32.const 3
              i32.shr_u
              local.tee 7
              i32.const 3
              i32.shl
              i32.const 3784
              i32.add
              local.tee 3
              i32.eq
              drop
              local.get 4
              local.get 5
              i32.load offset=12
              local.tee 2
              i32.eq
              if  ;; label = @6
                i32.const 3744
                i32.const 3744
                i32.load
                i32.const -2
                local.get 7
                i32.rotl
                i32.and
                i32.store
                br 2 (;@4;)
              end
              local.get 4
              local.get 2
              i32.store offset=12
              local.get 2
              local.get 4
              i32.store offset=8
              br 1 (;@4;)
            end
            local.get 5
            i32.load offset=24
            local.set 6
            block  ;; label = @5
              local.get 5
              local.get 5
              i32.load offset=12
              local.tee 3
              i32.ne
              if  ;; label = @6
                local.get 5
                i32.load offset=8
                local.tee 2
                i32.const 3760
                i32.load
                i32.lt_u
                drop
                local.get 2
                local.get 3
                i32.store offset=12
                local.get 3
                local.get 2
                i32.store offset=8
                br 1 (;@5;)
              end
              block  ;; label = @6
                local.get 5
                i32.const 20
                i32.add
                local.tee 4
                i32.load
                local.tee 2
                br_if 0 (;@6;)
                local.get 5
                i32.const 16
                i32.add
                local.tee 4
                i32.load
                local.tee 2
                br_if 0 (;@6;)
                i32.const 0
                local.set 3
                br 1 (;@5;)
              end
              loop  ;; label = @6
                local.get 4
                local.set 7
                local.get 2
                local.tee 3
                i32.const 20
                i32.add
                local.tee 4
                i32.load
                local.tee 2
                br_if 0 (;@6;)
                local.get 3
                i32.const 16
                i32.add
                local.set 4
                local.get 3
                i32.load offset=16
                local.tee 2
                br_if 0 (;@6;)
              end
              local.get 7
              i32.const 0
              i32.store
            end
            local.get 6
            i32.eqz
            br_if 0 (;@4;)
            block  ;; label = @5
              local.get 5
              local.get 5
              i32.load offset=28
              local.tee 4
              i32.const 2
              i32.shl
              i32.const 4048
              i32.add
              local.tee 2
              i32.load
              i32.eq
              if  ;; label = @6
                local.get 2
                local.get 3
                i32.store
                local.get 3
                br_if 1 (;@5;)
                i32.const 3748
                i32.const 3748
                i32.load
                i32.const -2
                local.get 4
                i32.rotl
                i32.and
                i32.store
                br 2 (;@4;)
              end
              local.get 6
              i32.const 16
              i32.const 20
              local.get 6
              i32.load offset=16
              local.get 5
              i32.eq
              select
              i32.add
              local.get 3
              i32.store
              local.get 3
              i32.eqz
              br_if 1 (;@4;)
            end
            local.get 3
            local.get 6
            i32.store offset=24
            local.get 5
            i32.load offset=16
            local.tee 2
            if  ;; label = @5
              local.get 3
              local.get 2
              i32.store offset=16
              local.get 2
              local.get 3
              i32.store offset=24
            end
            local.get 5
            i32.load offset=20
            local.tee 2
            i32.eqz
            br_if 0 (;@4;)
            local.get 3
            local.get 2
            i32.store offset=20
            local.get 2
            local.get 3
            i32.store offset=24
          end
          local.get 0
          local.get 1
          i32.const 1
          i32.or
          i32.store offset=4
          local.get 0
          local.get 1
          i32.add
          local.get 1
          i32.store
          local.get 0
          i32.const 3764
          i32.load
          i32.ne
          br_if 1 (;@2;)
          i32.const 3752
          local.get 1
          i32.store
          return
        end
        local.get 5
        local.get 2
        i32.const -2
        i32.and
        i32.store offset=4
        local.get 0
        local.get 1
        i32.const 1
        i32.or
        i32.store offset=4
        local.get 0
        local.get 1
        i32.add
        local.get 1
        i32.store
      end
      local.get 1
      i32.const 255
      i32.le_u
      if  ;; label = @2
        local.get 1
        i32.const 3
        i32.shr_u
        local.tee 2
        i32.const 3
        i32.shl
        i32.const 3784
        i32.add
        local.set 1
        block (result i32)  ;; label = @3
          i32.const 3744
          i32.load
          local.tee 4
          i32.const 1
          local.get 2
          i32.shl
          local.tee 2
          i32.and
          i32.eqz
          if  ;; label = @4
            i32.const 3744
            local.get 2
            local.get 4
            i32.or
            i32.store
            local.get 1
            br 1 (;@3;)
          end
          local.get 1
          i32.load offset=8
        end
        local.set 2
        local.get 1
        local.get 0
        i32.store offset=8
        local.get 2
        local.get 0
        i32.store offset=12
        local.get 0
        local.get 1
        i32.store offset=12
        local.get 0
        local.get 2
        i32.store offset=8
        return
      end
      i32.const 31
      local.set 2
      local.get 0
      i64.const 0
      i64.store offset=16 align=4
      local.get 1
      i32.const 16777215
      i32.le_u
      if  ;; label = @2
        local.get 1
        i32.const 8
        i32.shr_u
        local.tee 2
        local.get 2
        i32.const 1048320
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 8
        i32.and
        local.tee 2
        i32.shl
        local.tee 4
        local.get 4
        i32.const 520192
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 4
        i32.and
        local.tee 4
        i32.shl
        local.tee 3
        local.get 3
        i32.const 245760
        i32.add
        i32.const 16
        i32.shr_u
        i32.const 2
        i32.and
        local.tee 3
        i32.shl
        i32.const 15
        i32.shr_u
        local.get 2
        local.get 4
        i32.or
        local.get 3
        i32.or
        i32.sub
        local.tee 2
        i32.const 1
        i32.shl
        local.get 1
        local.get 2
        i32.const 21
        i32.add
        i32.shr_u
        i32.const 1
        i32.and
        i32.or
        i32.const 28
        i32.add
        local.set 2
      end
      local.get 0
      local.get 2
      i32.store offset=28
      local.get 2
      i32.const 2
      i32.shl
      i32.const 4048
      i32.add
      local.set 4
      block  ;; label = @2
        block  ;; label = @3
          i32.const 3748
          i32.load
          local.tee 3
          i32.const 1
          local.get 2
          i32.shl
          local.tee 5
          i32.and
          i32.eqz
          if  ;; label = @4
            i32.const 3748
            local.get 3
            local.get 5
            i32.or
            i32.store
            local.get 4
            local.get 0
            i32.store
            br 1 (;@3;)
          end
          local.get 1
          i32.const 0
          i32.const 25
          local.get 2
          i32.const 1
          i32.shr_u
          i32.sub
          local.get 2
          i32.const 31
          i32.eq
          select
          i32.shl
          local.set 2
          local.get 4
          i32.load
          local.set 3
          loop  ;; label = @4
            local.get 3
            local.tee 4
            i32.load offset=4
            i32.const -8
            i32.and
            local.get 1
            i32.eq
            br_if 2 (;@2;)
            local.get 2
            i32.const 29
            i32.shr_u
            local.set 3
            local.get 2
            i32.const 1
            i32.shl
            local.set 2
            local.get 4
            local.get 3
            i32.const 4
            i32.and
            i32.add
            local.tee 8
            i32.const 16
            i32.add
            local.tee 5
            i32.load
            local.tee 3
            br_if 0 (;@4;)
          end
          local.get 8
          local.get 0
          i32.store offset=16
        end
        local.get 0
        local.get 4
        i32.store offset=24
        local.get 0
        local.get 0
        i32.store offset=12
        local.get 0
        local.get 0
        i32.store offset=8
        return
      end
      local.get 4
      i32.load offset=8
      local.tee 1
      local.get 0
      i32.store offset=12
      local.get 4
      local.get 0
      i32.store offset=8
      local.get 0
      i32.const 0
      i32.store offset=24
      local.get 0
      local.get 4
      i32.store offset=12
      local.get 0
      local.get 1
      i32.store offset=8
    end)
  (func $emscripten_get_heap_size (type 3) (result i32)
    memory.size
    i32.const 16
    i32.shl)
  (func $sbrk (type 0) (param i32) (result i32)
    (local i32 i32)
    i32.const 2484
    i32.load
    local.tee 1
    local.get 0
    i32.const 3
    i32.add
    i32.const -4
    i32.and
    local.tee 2
    i32.add
    local.set 0
    block  ;; label = @1
      local.get 2
      i32.const 0
      local.get 0
      local.get 1
      i32.le_u
      select
      br_if 0 (;@1;)
      call $emscripten_get_heap_size
      local.get 0
      i32.lt_u
      if  ;; label = @2
        local.get 0
        call $emscripten_resize_heap
        i32.eqz
        br_if 1 (;@1;)
      end
      i32.const 2484
      local.get 0
      i32.store
      local.get 1
      return
    end
    call $__errno_location
    i32.const 48
    i32.store
    i32.const -1)
  (func $fmodl (type 4) (param i32 i64 i64 i64 i64)
    (local i32 i64 i32 i64 i32 i64 i32)
    global.get 0
    i32.const 128
    i32.sub
    local.tee 5
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          local.get 4
          i64.const 0
          i64.const 0
          call $__letf2
          i32.eqz
          br_if 0 (;@3;)
          local.get 3
          local.get 4
          call $__fpclassifyl
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          i64.const 48
          i64.shr_u
          i32.wrap_i64
          local.tee 11
          i32.const 32767
          i32.and
          local.tee 7
          i32.const 32767
          i32.ne
          br_if 1 (;@2;)
        end
        local.get 5
        i32.const 16
        i32.add
        local.get 1
        local.get 2
        local.get 3
        local.get 4
        call $__multf3
        local.get 5
        local.get 5
        i64.load offset=16
        local.tee 4
        local.get 5
        i64.load offset=24
        local.tee 3
        local.get 4
        local.get 3
        call $__divtf3
        local.get 5
        i64.load offset=8
        local.set 2
        local.get 5
        i64.load
        local.set 4
        br 1 (;@1;)
      end
      local.get 1
      local.get 2
      i64.const 281474976710655
      i64.and
      local.get 7
      i64.extend_i32_u
      i64.const 48
      i64.shl
      i64.or
      local.tee 8
      local.get 3
      local.get 4
      i64.const 281474976710655
      i64.and
      local.get 4
      i64.const 48
      i64.shr_u
      i32.wrap_i64
      i32.const 32767
      i32.and
      local.tee 9
      i64.extend_i32_u
      i64.const 48
      i64.shl
      i64.or
      local.tee 6
      call $__letf2
      i32.const 0
      i32.le_s
      if  ;; label = @2
        local.get 1
        local.get 8
        local.get 3
        local.get 6
        call $__letf2
        if  ;; label = @3
          local.get 1
          local.set 4
          br 2 (;@1;)
        end
        local.get 5
        i32.const 112
        i32.add
        local.get 1
        local.get 2
        i64.const 0
        i64.const 0
        call $__multf3
        local.get 5
        i64.load offset=120
        local.set 2
        local.get 5
        i64.load offset=112
        local.set 4
        br 1 (;@1;)
      end
      local.get 7
      if (result i64)  ;; label = @2
        local.get 1
      else
        local.get 5
        i32.const 96
        i32.add
        local.get 1
        local.get 8
        i64.const 0
        i64.const 4645181540655955968
        call $__multf3
        local.get 5
        i64.load offset=104
        local.tee 8
        i64.const 48
        i64.shr_u
        i32.wrap_i64
        i32.const 120
        i32.sub
        local.set 7
        local.get 5
        i64.load offset=96
      end
      local.set 4
      local.get 9
      i32.eqz
      if  ;; label = @2
        local.get 5
        i32.const 80
        i32.add
        local.get 3
        local.get 6
        i64.const 0
        i64.const 4645181540655955968
        call $__multf3
        local.get 5
        i64.load offset=88
        local.tee 6
        i64.const 48
        i64.shr_u
        i32.wrap_i64
        i32.const 120
        i32.sub
        local.set 9
        local.get 5
        i64.load offset=80
        local.set 3
      end
      local.get 6
      i64.const 281474976710655
      i64.and
      i64.const 281474976710656
      i64.or
      local.set 10
      local.get 8
      i64.const 281474976710655
      i64.and
      i64.const 281474976710656
      i64.or
      local.set 8
      local.get 7
      local.get 9
      i32.gt_s
      if  ;; label = @2
        loop  ;; label = @3
          block (result i64)  ;; label = @4
            local.get 8
            local.get 10
            i64.sub
            local.get 3
            local.get 4
            i64.gt_u
            i64.extend_i32_u
            i64.sub
            local.tee 6
            i64.const 0
            i64.ge_s
            if  ;; label = @5
              local.get 6
              local.get 4
              local.get 3
              i64.sub
              local.tee 4
              i64.or
              i64.eqz
              if  ;; label = @6
                local.get 5
                i32.const 32
                i32.add
                local.get 1
                local.get 2
                i64.const 0
                i64.const 0
                call $__multf3
                local.get 5
                i64.load offset=40
                local.set 2
                local.get 5
                i64.load offset=32
                local.set 4
                br 5 (;@1;)
              end
              local.get 6
              i64.const 1
              i64.shl
              local.get 4
              i64.const 63
              i64.shr_u
              i64.or
              br 1 (;@4;)
            end
            local.get 8
            i64.const 1
            i64.shl
            local.get 4
            i64.const 63
            i64.shr_u
            i64.or
          end
          local.set 8
          local.get 4
          i64.const 1
          i64.shl
          local.set 4
          local.get 7
          i32.const 1
          i32.sub
          local.tee 7
          local.get 9
          i32.gt_s
          br_if 0 (;@3;)
        end
        local.get 9
        local.set 7
      end
      block  ;; label = @2
        local.get 8
        local.get 10
        i64.sub
        local.get 3
        local.get 4
        i64.gt_u
        i64.extend_i32_u
        i64.sub
        local.tee 6
        i64.const 0
        i64.lt_s
        if  ;; label = @3
          local.get 8
          local.set 6
          br 1 (;@2;)
        end
        local.get 6
        local.get 4
        local.get 3
        i64.sub
        local.tee 4
        i64.or
        i64.const 0
        i64.ne
        br_if 0 (;@2;)
        local.get 5
        i32.const 48
        i32.add
        local.get 1
        local.get 2
        i64.const 0
        i64.const 0
        call $__multf3
        local.get 5
        i64.load offset=56
        local.set 2
        local.get 5
        i64.load offset=48
        local.set 4
        br 1 (;@1;)
      end
      local.get 6
      i64.const 281474976710655
      i64.le_u
      if  ;; label = @2
        loop  ;; label = @3
          local.get 4
          i64.const 63
          i64.shr_u
          local.set 3
          local.get 7
          i32.const 1
          i32.sub
          local.set 7
          local.get 4
          i64.const 1
          i64.shl
          local.set 4
          local.get 3
          local.get 6
          i64.const 1
          i64.shl
          i64.or
          local.tee 6
          i64.const 281474976710656
          i64.lt_u
          br_if 0 (;@3;)
        end
      end
      local.get 11
      i32.const 32768
      i32.and
      local.set 9
      local.get 7
      i32.const 0
      i32.le_s
      if  ;; label = @2
        local.get 5
        i32.const -64
        i32.sub
        local.get 4
        local.get 6
        i64.const 281474976710655
        i64.and
        local.get 7
        i32.const 120
        i32.add
        local.get 9
        i32.or
        i64.extend_i32_u
        i64.const 48
        i64.shl
        i64.or
        i64.const 0
        i64.const 4577627546245398528
        call $__multf3
        local.get 5
        i64.load offset=72
        local.set 2
        local.get 5
        i64.load offset=64
        local.set 4
        br 1 (;@1;)
      end
      local.get 6
      i64.const 281474976710655
      i64.and
      local.get 7
      local.get 9
      i32.or
      i64.extend_i32_u
      i64.const 48
      i64.shl
      i64.or
      local.set 2
    end
    local.get 0
    local.get 4
    i64.store
    local.get 0
    local.get 2
    i64.store offset=8
    local.get 5
    i32.const 128
    i32.add
    global.set 0)
  (func $scalbn (type 26) (param f64 i32) (result f64)
    block  ;; label = @1
      local.get 1
      i32.const 1024
      i32.ge_s
      if  ;; label = @2
        local.get 0
        f64.const 0x1p+1023 (;=8.98847e+307;)
        f64.mul
        local.set 0
        local.get 1
        i32.const 2047
        i32.lt_s
        if  ;; label = @3
          local.get 1
          i32.const 1023
          i32.sub
          local.set 1
          br 2 (;@1;)
        end
        local.get 0
        f64.const 0x1p+1023 (;=8.98847e+307;)
        f64.mul
        local.set 0
        local.get 1
        i32.const 3069
        local.get 1
        i32.const 3069
        i32.lt_s
        select
        i32.const 2046
        i32.sub
        local.set 1
        br 1 (;@1;)
      end
      local.get 1
      i32.const -1023
      i32.gt_s
      br_if 0 (;@1;)
      local.get 0
      f64.const 0x1p-1022 (;=2.22507e-308;)
      f64.mul
      local.set 0
      local.get 1
      i32.const -2045
      i32.gt_s
      if  ;; label = @2
        local.get 1
        i32.const 1022
        i32.add
        local.set 1
        br 1 (;@1;)
      end
      local.get 0
      f64.const 0x1p-1022 (;=2.22507e-308;)
      f64.mul
      local.set 0
      local.get 1
      i32.const -3066
      local.get 1
      i32.const -3066
      i32.gt_s
      select
      i32.const 2044
      i32.add
      local.set 1
    end
    local.get 0
    local.get 1
    i32.const 1023
    i32.add
    i64.extend_i32_u
    i64.const 52
    i64.shl
    f64.reinterpret_i64
    f64.mul)
  (func $__fpclassifyl (type 27) (param i64 i64) (result i32)
    (local i64 i32)
    local.get 1
    i64.const 281474976710655
    i64.and
    local.set 2
    block (result i32)  ;; label = @1
      local.get 1
      i64.const 48
      i64.shr_u
      i32.wrap_i64
      i32.const 32767
      i32.and
      local.tee 3
      i32.const 32767
      i32.ne
      if  ;; label = @2
        i32.const 4
        local.get 3
        br_if 1 (;@1;)
        drop
        i32.const 2
        i32.const 3
        local.get 0
        local.get 2
        i64.or
        i64.eqz
        select
        return
      end
      local.get 0
      local.get 2
      i64.or
      i64.eqz
    end)
  (func $__memcpy (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 2
    i32.const 512
    i32.ge_u
    if  ;; label = @1
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
      local.get 0
      local.get 1
      i32.xor
      i32.const 3
      i32.and
      i32.eqz
      if  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 3
          i32.and
          i32.eqz
          if  ;; label = @4
            local.get 0
            local.set 2
            br 1 (;@3;)
          end
          local.get 2
          i32.const 1
          i32.lt_s
          if  ;; label = @4
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
            i32.const -64
            i32.sub
            local.set 1
            local.get 2
            i32.const -64
            i32.sub
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
        end
        br 1 (;@1;)
      end
      local.get 3
      i32.const 4
      i32.lt_u
      if  ;; label = @2
        local.get 0
        local.set 2
        br 1 (;@1;)
      end
      local.get 0
      local.get 3
      i32.const 4
      i32.sub
      local.tee 4
      i32.gt_u
      if  ;; label = @2
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
    local.get 2
    local.get 3
    i32.lt_u
    if  ;; label = @1
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
  (func $memset (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i64 i32)
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i32.add
      local.tee 3
      i32.const 1
      i32.sub
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
      i32.const 2
      i32.sub
      local.get 1
      i32.store8
      local.get 0
      local.get 1
      i32.store8 offset=1
      local.get 3
      i32.const 3
      i32.sub
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
      i32.const 4
      i32.sub
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
      i32.const 4
      i32.sub
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
      i32.const 8
      i32.sub
      local.get 1
      i32.store
      local.get 2
      i32.const 12
      i32.sub
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
      i32.const 16
      i32.sub
      local.get 1
      i32.store
      local.get 2
      i32.const 20
      i32.sub
      local.get 1
      i32.store
      local.get 2
      i32.const 24
      i32.sub
      local.get 1
      i32.store
      local.get 2
      i32.const 28
      i32.sub
      local.get 1
      i32.store
      local.get 4
      local.get 3
      i32.const 4
      i32.and
      i32.const 24
      i32.or
      local.tee 6
      i32.sub
      local.tee 2
      i32.const 32
      i32.lt_u
      br_if 0 (;@1;)
      local.get 1
      i64.extend_i32_u
      i64.const 4294967297
      i64.mul
      local.set 5
      local.get 3
      local.get 6
      i32.add
      local.set 1
      loop  ;; label = @2
        local.get 1
        local.get 5
        i64.store offset=24
        local.get 1
        local.get 5
        i64.store offset=16
        local.get 1
        local.get 5
        i64.store offset=8
        local.get 1
        local.get 5
        i64.store
        local.get 1
        i32.const 32
        i32.add
        local.set 1
        local.get 2
        i32.const 32
        i32.sub
        local.tee 2
        i32.const 31
        i32.gt_u
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func $__stdio_write (type 1) (param i32 i32 i32) (result i32)
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
    block (result i32)  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
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
          i32.eqz
          if  ;; label = @4
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
              local.get 4
              local.get 8
              i32.const 0
              local.get 5
              select
              i32.sub
              local.tee 8
              local.get 9
              i32.load
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
        br 1 (;@1;)
      end
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
      i32.const 0
      local.tee 4
      local.get 7
      i32.const 2
      i32.eq
      br_if 0 (;@1;)
      drop
      local.get 2
      local.get 1
      i32.load offset=4
      i32.sub
    end
    local.set 4
    local.get 3
    i32.const 32
    i32.add
    global.set 0
    local.get 4)
  (func $__emscripten_stdout_close (type 0) (param i32) (result i32)
    i32.const 0)
  (func $__emscripten_stdout_seek (type 9) (param i32 i64 i32) (result i64)
    i64.const 0)
  (func $memchr (type 1) (param i32 i32 i32) (result i32)
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
            i32.const 1
            i32.sub
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
          i32.const 16843009
          i32.sub
          i32.and
          i32.const -2139062144
          i32.and
          br_if 1 (;@2;)
          local.get 0
          i32.const 4
          i32.add
          local.set 0
          local.get 2
          i32.const 4
          i32.sub
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
        local.get 3
        local.get 0
        i32.load8_u
        i32.eq
        if  ;; label = @3
          local.get 0
          return
        end
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 2
        i32.const 1
        i32.sub
        local.tee 2
        br_if 0 (;@2;)
      end
    end
    i32.const 0)
  (func $wcrtomb (type 1) (param i32 i32 i32) (result i32)
    (local i32)
    i32.const 1
    local.set 3
    block  ;; label = @1
      local.get 0
      if  ;; label = @2
        local.get 1
        i32.const 127
        i32.le_u
        br_if 1 (;@1;)
        block  ;; label = @3
          call $__pthread_self
          i32.load offset=172
          i32.load
          i32.eqz
          if  ;; label = @4
            local.get 1
            i32.const -128
            i32.and
            i32.const 57216
            i32.eq
            br_if 3 (;@1;)
            br 1 (;@3;)
          end
          local.get 1
          i32.const 2047
          i32.le_u
          if  ;; label = @4
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
          local.get 1
          i32.const 55296
          i32.ge_u
          i32.const 0
          local.get 1
          i32.const -8192
          i32.and
          i32.const 57344
          i32.ne
          select
          i32.eqz
          if  ;; label = @4
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
          local.get 1
          i32.const 65536
          i32.sub
          i32.const 1048575
          i32.le_u
          if  ;; label = @4
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
        end
        call $__errno_location
        i32.const 25
        i32.store
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
  (func $wctomb (type 2) (param i32 i32) (result i32)
    local.get 0
    i32.eqz
    if  ;; label = @1
      i32.const 0
      return
    end
    local.get 0
    local.get 1
    i32.const 0
    call $wcrtomb)
  (func $__towrite (type 0) (param i32) (result i32)
    (local i32)
    local.get 0
    local.get 0
    i32.load8_u offset=74
    local.tee 1
    i32.const 1
    i32.sub
    local.get 1
    i32.or
    i32.store8 offset=74
    local.get 0
    i32.load
    local.tee 1
    i32.const 8
    i32.and
    if  ;; label = @1
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
  (func $__fwritex (type 1) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block (result i32)  ;; label = @2
        local.get 2
        i32.load offset=16
        local.tee 3
        i32.eqz
        if  ;; label = @3
          local.get 2
          call $__towrite
          br_if 2 (;@1;)
          local.get 2
          i32.load offset=16
          local.set 3
        end
        local.get 1
        local.get 3
        local.get 2
        i32.load offset=20
        local.tee 5
        i32.sub
        i32.gt_u
      end
      if  ;; label = @2
        local.get 2
        local.get 0
        local.get 1
        local.get 2
        i32.load offset=36
        call_indirect (type 1)
        return
      end
      block  ;; label = @2
        local.get 2
        i32.load8_s offset=75
        i32.const 0
        i32.lt_s
        if  ;; label = @3
          i32.const 0
          local.set 3
          br 1 (;@2;)
        end
        local.get 1
        local.set 4
        loop  ;; label = @3
          local.get 4
          local.tee 3
          i32.eqz
          if  ;; label = @4
            i32.const 0
            local.set 3
            br 2 (;@2;)
          end
          local.get 0
          local.get 3
          i32.const 1
          i32.sub
          local.tee 4
          i32.add
          i32.load8_u
          i32.const 10
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 2
        local.get 0
        local.get 3
        local.get 2
        i32.load offset=36
        call_indirect (type 1)
        local.tee 4
        local.get 3
        i32.lt_u
        br_if 1 (;@1;)
        local.get 0
        local.get 3
        i32.add
        local.set 0
        local.get 1
        local.get 3
        i32.sub
        local.set 1
        local.get 2
        i32.load offset=20
        local.set 5
      end
      local.get 5
      local.get 0
      local.get 1
      call $__memcpy
      drop
      local.get 2
      local.get 2
      i32.load offset=20
      local.get 1
      i32.add
      i32.store offset=20
      local.get 1
      local.get 3
      i32.add
      local.set 4
    end
    local.get 4)
  (func $__vfprintf_internal (type 8) (param i32 i32 i32 i32 i32) (result i32)
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
      i32.lt_s
      if  ;; label = @2
        i32.const -1
        local.set 1
        br 1 (;@1;)
      end
      local.get 0
      i32.load offset=76
      i32.const 0
      i32.ge_s
      if  ;; label = @2
        local.get 0
        call $__lockfile
        local.set 2
      end
      local.get 0
      i32.load
      local.set 6
      local.get 0
      i32.load8_s offset=74
      i32.const 0
      i32.le_s
      if  ;; label = @2
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
      block (result i32)  ;; label = @2
        local.get 0
        i32.load offset=48
        if  ;; label = @3
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
        local.tee 1
        local.get 7
        i32.eqz
        br_if 0 (;@2;)
        drop
        local.get 0
        i32.const 0
        i32.const 0
        local.get 0
        i32.load offset=36
        call_indirect (type 1)
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
      end
      local.set 1
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
  (func $printf_core (type 28) (param i32 i32 i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i64 i32 i32)
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
    local.set 22
    local.get 7
    i32.const 56
    i32.add
    local.set 18
    i32.const 0
    local.set 1
    block  ;; label = @1
      loop  ;; label = @2
        block  ;; label = @3
          local.get 16
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          i32.const 2147483647
          local.get 16
          i32.sub
          local.get 1
          i32.lt_s
          if  ;; label = @4
            call $__errno_location
            i32.const 61
            i32.store
            i32.const -1
            local.set 16
            br 1 (;@3;)
          end
          local.get 1
          local.get 16
          i32.add
          local.set 16
        end
        local.get 7
        i32.load offset=76
        local.tee 11
        local.set 1
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 11
                i32.load8_u
                local.tee 8
                if  ;; label = @7
                  loop  ;; label = @8
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 8
                        i32.const 255
                        i32.and
                        local.tee 8
                        i32.eqz
                        if  ;; label = @11
                          local.get 1
                          local.set 8
                          br 1 (;@10;)
                        end
                        local.get 8
                        i32.const 37
                        i32.ne
                        br_if 1 (;@9;)
                        local.get 1
                        local.set 8
                        loop  ;; label = @11
                          local.get 1
                          i32.load8_u offset=1
                          i32.const 37
                          i32.ne
                          br_if 1 (;@10;)
                          local.get 7
                          local.get 1
                          i32.const 2
                          i32.add
                          local.tee 9
                          i32.store offset=76
                          local.get 8
                          i32.const 1
                          i32.add
                          local.set 8
                          local.get 1
                          i32.load8_u offset=2
                          local.set 12
                          local.get 9
                          local.set 1
                          local.get 12
                          i32.const 37
                          i32.eq
                          br_if 0 (;@11;)
                        end
                      end
                      local.get 8
                      local.get 11
                      i32.sub
                      local.set 1
                      local.get 0
                      if  ;; label = @10
                        local.get 0
                        local.get 11
                        local.get 1
                        call $out
                      end
                      local.get 1
                      br_if 7 (;@2;)
                      i32.const -1
                      local.set 17
                      i32.const 1
                      local.set 8
                      local.get 7
                      i32.load offset=76
                      i32.load8_s offset=1
                      call $isdigit
                      local.set 9
                      local.get 7
                      i32.load offset=76
                      local.set 1
                      block  ;; label = @10
                        local.get 9
                        i32.eqz
                        br_if 0 (;@10;)
                        local.get 1
                        i32.load8_u offset=2
                        i32.const 36
                        i32.ne
                        br_if 0 (;@10;)
                        local.get 1
                        i32.load8_s offset=1
                        i32.const 48
                        i32.sub
                        local.set 17
                        i32.const 1
                        local.set 19
                        i32.const 3
                        local.set 8
                      end
                      local.get 7
                      local.get 1
                      local.get 8
                      i32.add
                      local.tee 1
                      i32.store offset=76
                      i32.const 0
                      local.set 14
                      block  ;; label = @10
                        local.get 1
                        i32.load8_s
                        local.tee 12
                        i32.const 32
                        i32.sub
                        local.tee 9
                        i32.const 31
                        i32.gt_u
                        if  ;; label = @11
                          local.get 1
                          local.set 8
                          br 1 (;@10;)
                        end
                        local.get 1
                        local.set 8
                        i32.const 1
                        local.get 9
                        i32.shl
                        local.tee 9
                        i32.const 75913
                        i32.and
                        i32.eqz
                        br_if 0 (;@10;)
                        loop  ;; label = @11
                          local.get 7
                          local.get 1
                          i32.const 1
                          i32.add
                          local.tee 8
                          i32.store offset=76
                          local.get 9
                          local.get 14
                          i32.or
                          local.set 14
                          local.get 1
                          i32.load8_s offset=1
                          local.tee 12
                          i32.const 32
                          i32.sub
                          local.tee 9
                          i32.const 32
                          i32.ge_u
                          br_if 1 (;@10;)
                          local.get 8
                          local.set 1
                          i32.const 1
                          local.get 9
                          i32.shl
                          local.tee 9
                          i32.const 75913
                          i32.and
                          br_if 0 (;@11;)
                        end
                      end
                      block  ;; label = @10
                        local.get 12
                        i32.const 42
                        i32.eq
                        if  ;; label = @11
                          local.get 7
                          block (result i32)  ;; label = @12
                            block  ;; label = @13
                              local.get 8
                              i32.load8_s offset=1
                              call $isdigit
                              i32.eqz
                              br_if 0 (;@13;)
                              local.get 7
                              i32.load offset=76
                              local.tee 8
                              i32.load8_u offset=2
                              i32.const 36
                              i32.ne
                              br_if 0 (;@13;)
                              local.get 8
                              i32.load8_s offset=1
                              i32.const 2
                              i32.shl
                              local.get 4
                              i32.add
                              i32.const 192
                              i32.sub
                              i32.const 10
                              i32.store
                              local.get 8
                              i32.load8_s offset=1
                              i32.const 3
                              i32.shl
                              local.get 3
                              i32.add
                              i32.const 384
                              i32.sub
                              i32.load
                              local.set 15
                              i32.const 1
                              local.set 19
                              local.get 8
                              i32.const 3
                              i32.add
                              br 1 (;@12;)
                            end
                            local.get 19
                            br_if 6 (;@6;)
                            i32.const 0
                            local.set 19
                            i32.const 0
                            local.set 15
                            local.get 0
                            if  ;; label = @13
                              local.get 2
                              local.get 2
                              i32.load
                              local.tee 1
                              i32.const 4
                              i32.add
                              i32.store
                              local.get 1
                              i32.load
                              local.set 15
                            end
                            local.get 7
                            i32.load offset=76
                            i32.const 1
                            i32.add
                          end
                          local.tee 1
                          i32.store offset=76
                          local.get 15
                          i32.const -1
                          i32.gt_s
                          br_if 1 (;@10;)
                          i32.const 0
                          local.get 15
                          i32.sub
                          local.set 15
                          local.get 14
                          i32.const 8192
                          i32.or
                          local.set 14
                          br 1 (;@10;)
                        end
                        local.get 7
                        i32.const 76
                        i32.add
                        call $getint
                        local.tee 15
                        i32.const 0
                        i32.lt_s
                        br_if 4 (;@6;)
                        local.get 7
                        i32.load offset=76
                        local.set 1
                      end
                      i32.const -1
                      local.set 10
                      block  ;; label = @10
                        local.get 1
                        i32.load8_u
                        i32.const 46
                        i32.ne
                        br_if 0 (;@10;)
                        local.get 1
                        i32.load8_u offset=1
                        i32.const 42
                        i32.eq
                        if  ;; label = @11
                          block  ;; label = @12
                            local.get 1
                            i32.load8_s offset=2
                            call $isdigit
                            i32.eqz
                            br_if 0 (;@12;)
                            local.get 7
                            i32.load offset=76
                            local.tee 1
                            i32.load8_u offset=3
                            i32.const 36
                            i32.ne
                            br_if 0 (;@12;)
                            local.get 1
                            i32.load8_s offset=2
                            i32.const 2
                            i32.shl
                            local.get 4
                            i32.add
                            i32.const 192
                            i32.sub
                            i32.const 10
                            i32.store
                            local.get 1
                            i32.load8_s offset=2
                            i32.const 3
                            i32.shl
                            local.get 3
                            i32.add
                            i32.const 384
                            i32.sub
                            i32.load
                            local.set 10
                            local.get 7
                            local.get 1
                            i32.const 4
                            i32.add
                            local.tee 1
                            i32.store offset=76
                            br 2 (;@10;)
                          end
                          local.get 19
                          br_if 5 (;@6;)
                          local.get 0
                          if (result i32)  ;; label = @12
                            local.get 2
                            local.get 2
                            i32.load
                            local.tee 1
                            i32.const 4
                            i32.add
                            i32.store
                            local.get 1
                            i32.load
                          else
                            i32.const 0
                          end
                          local.set 10
                          local.get 7
                          local.get 7
                          i32.load offset=76
                          i32.const 2
                          i32.add
                          local.tee 1
                          i32.store offset=76
                          br 1 (;@10;)
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
                        local.set 10
                        local.get 7
                        i32.load offset=76
                        local.set 1
                      end
                      i32.const 0
                      local.set 8
                      loop  ;; label = @10
                        local.get 8
                        local.set 9
                        i32.const -1
                        local.set 13
                        local.get 1
                        i32.load8_s
                        i32.const 65
                        i32.sub
                        i32.const 57
                        i32.gt_u
                        br_if 9 (;@1;)
                        local.get 7
                        local.get 1
                        i32.const 1
                        i32.add
                        local.tee 12
                        i32.store offset=76
                        local.get 1
                        i32.load8_s
                        local.set 8
                        local.get 12
                        local.set 1
                        local.get 8
                        local.get 9
                        i32.const 58
                        i32.mul
                        i32.add
                        i32.const 1567
                        i32.add
                        i32.load8_u
                        local.tee 8
                        i32.const 1
                        i32.sub
                        i32.const 8
                        i32.lt_u
                        br_if 0 (;@10;)
                      end
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 8
                          i32.const 19
                          i32.ne
                          if  ;; label = @12
                            local.get 8
                            i32.eqz
                            br_if 11 (;@1;)
                            local.get 17
                            i32.const 0
                            i32.ge_s
                            if  ;; label = @13
                              local.get 4
                              local.get 17
                              i32.const 2
                              i32.shl
                              i32.add
                              local.get 8
                              i32.store
                              local.get 7
                              local.get 3
                              local.get 17
                              i32.const 3
                              i32.shl
                              i32.add
                              i64.load
                              i64.store offset=64
                              br 2 (;@11;)
                            end
                            local.get 0
                            i32.eqz
                            br_if 9 (;@3;)
                            local.get 7
                            i32.const -64
                            i32.sub
                            local.get 8
                            local.get 2
                            local.get 6
                            call $pop_arg
                            local.get 7
                            i32.load offset=76
                            local.set 12
                            br 2 (;@10;)
                          end
                          local.get 17
                          i32.const -1
                          i32.gt_s
                          br_if 10 (;@1;)
                        end
                        i32.const 0
                        local.set 1
                        local.get 0
                        i32.eqz
                        br_if 8 (;@2;)
                      end
                      local.get 14
                      i32.const -65537
                      i32.and
                      local.tee 21
                      local.get 14
                      local.get 14
                      i32.const 8192
                      i32.and
                      select
                      local.set 8
                      i32.const 0
                      local.set 13
                      i32.const 1033
                      local.set 17
                      local.get 18
                      local.set 14
                      block  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            block (result i32)  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      block (result i32)  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            block  ;; label = @21
                                              block  ;; label = @22
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      local.get 12
                                                      i32.const 1
                                                      i32.sub
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
                                                      local.get 9
                                                      select
                                                      local.tee 1
                                                      i32.const 88
                                                      i32.sub
                                                      br_table 4 (;@21;) 21 (;@4;) 21 (;@4;) 21 (;@4;) 21 (;@4;) 21 (;@4;) 21 (;@4;) 21 (;@4;) 21 (;@4;) 14 (;@11;) 21 (;@4;) 15 (;@10;) 6 (;@19;) 14 (;@11;) 14 (;@11;) 14 (;@11;) 21 (;@4;) 6 (;@19;) 21 (;@4;) 21 (;@4;) 21 (;@4;) 21 (;@4;) 2 (;@23;) 5 (;@20;) 3 (;@22;) 21 (;@4;) 21 (;@4;) 9 (;@16;) 21 (;@4;) 1 (;@24;) 21 (;@4;) 21 (;@4;) 4 (;@21;) 0 (;@25;)
                                                    end
                                                    block  ;; label = @25
                                                      local.get 1
                                                      i32.const 65
                                                      i32.sub
                                                      br_table 14 (;@11;) 21 (;@4;) 11 (;@14;) 21 (;@4;) 14 (;@11;) 14 (;@11;) 14 (;@11;) 0 (;@25;)
                                                    end
                                                    local.get 1
                                                    i32.const 83
                                                    i32.eq
                                                    br_if 9 (;@15;)
                                                    br 19 (;@5;)
                                                  end
                                                  local.get 7
                                                  i64.load offset=64
                                                  local.set 20
                                                  i32.const 1033
                                                  br 5 (;@18;)
                                                end
                                                i32.const 0
                                                local.set 1
                                                block  ;; label = @23
                                                  block  ;; label = @24
                                                    block  ;; label = @25
                                                      block  ;; label = @26
                                                        block  ;; label = @27
                                                          block  ;; label = @28
                                                            block  ;; label = @29
                                                              local.get 9
                                                              i32.const 255
                                                              i32.and
                                                              br_table 0 (;@29;) 1 (;@28;) 2 (;@27;) 3 (;@26;) 4 (;@25;) 27 (;@2;) 5 (;@24;) 6 (;@23;) 27 (;@2;)
                                                            end
                                                            local.get 7
                                                            i32.load offset=64
                                                            local.get 16
                                                            i32.store
                                                            br 26 (;@2;)
                                                          end
                                                          local.get 7
                                                          i32.load offset=64
                                                          local.get 16
                                                          i32.store
                                                          br 25 (;@2;)
                                                        end
                                                        local.get 7
                                                        i32.load offset=64
                                                        local.get 16
                                                        i64.extend_i32_s
                                                        i64.store
                                                        br 24 (;@2;)
                                                      end
                                                      local.get 7
                                                      i32.load offset=64
                                                      local.get 16
                                                      i32.store16
                                                      br 23 (;@2;)
                                                    end
                                                    local.get 7
                                                    i32.load offset=64
                                                    local.get 16
                                                    i32.store8
                                                    br 22 (;@2;)
                                                  end
                                                  local.get 7
                                                  i32.load offset=64
                                                  local.get 16
                                                  i32.store
                                                  br 21 (;@2;)
                                                end
                                                local.get 7
                                                i32.load offset=64
                                                local.get 16
                                                i64.extend_i32_s
                                                i64.store
                                                br 20 (;@2;)
                                              end
                                              local.get 10
                                              i32.const 8
                                              local.get 10
                                              i32.const 8
                                              i32.gt_u
                                              select
                                              local.set 10
                                              local.get 8
                                              i32.const 8
                                              i32.or
                                              local.set 8
                                              i32.const 120
                                              local.set 1
                                            end
                                            local.get 7
                                            i64.load offset=64
                                            local.get 18
                                            local.get 1
                                            i32.const 32
                                            i32.and
                                            call $fmt_x
                                            local.set 11
                                            local.get 7
                                            i64.load offset=64
                                            i64.eqz
                                            br_if 3 (;@17;)
                                            local.get 8
                                            i32.const 8
                                            i32.and
                                            i32.eqz
                                            br_if 3 (;@17;)
                                            local.get 1
                                            i32.const 4
                                            i32.shr_u
                                            i32.const 1033
                                            i32.add
                                            local.set 17
                                            i32.const 2
                                            local.set 13
                                            br 3 (;@17;)
                                          end
                                          local.get 7
                                          i64.load offset=64
                                          local.get 18
                                          call $fmt_o
                                          local.set 11
                                          local.get 8
                                          i32.const 8
                                          i32.and
                                          i32.eqz
                                          br_if 2 (;@17;)
                                          local.get 10
                                          local.get 18
                                          local.get 11
                                          i32.sub
                                          local.tee 1
                                          i32.const 1
                                          i32.add
                                          local.get 1
                                          local.get 10
                                          i32.lt_s
                                          select
                                          local.set 10
                                          br 2 (;@17;)
                                        end
                                        local.get 7
                                        i64.load offset=64
                                        local.tee 20
                                        i64.const -1
                                        i64.le_s
                                        if  ;; label = @19
                                          local.get 7
                                          i64.const 0
                                          local.get 20
                                          i64.sub
                                          local.tee 20
                                          i64.store offset=64
                                          i32.const 1
                                          local.set 13
                                          i32.const 1033
                                          br 1 (;@18;)
                                        end
                                        local.get 8
                                        i32.const 2048
                                        i32.and
                                        if  ;; label = @19
                                          i32.const 1
                                          local.set 13
                                          i32.const 1034
                                          br 1 (;@18;)
                                        end
                                        i32.const 1035
                                        i32.const 1033
                                        local.get 8
                                        i32.const 1
                                        i32.and
                                        local.tee 13
                                        select
                                      end
                                      local.set 17
                                      local.get 20
                                      local.get 18
                                      call $fmt_u
                                      local.set 11
                                    end
                                    local.get 8
                                    i32.const -65537
                                    i32.and
                                    local.get 8
                                    local.get 10
                                    i32.const -1
                                    i32.gt_s
                                    select
                                    local.set 8
                                    block  ;; label = @17
                                      local.get 7
                                      i64.load offset=64
                                      local.tee 20
                                      i64.const 0
                                      i64.ne
                                      br_if 0 (;@17;)
                                      local.get 10
                                      br_if 0 (;@17;)
                                      i32.const 0
                                      local.set 10
                                      local.get 18
                                      local.set 11
                                      br 12 (;@5;)
                                    end
                                    local.get 10
                                    local.get 20
                                    i64.eqz
                                    local.get 18
                                    local.get 11
                                    i32.sub
                                    i32.add
                                    local.tee 1
                                    local.get 1
                                    local.get 10
                                    i32.lt_s
                                    select
                                    local.set 10
                                    br 11 (;@5;)
                                  end
                                  local.get 7
                                  i32.load offset=64
                                  local.tee 1
                                  i32.const 1053
                                  local.get 1
                                  select
                                  local.tee 11
                                  i32.const 0
                                  local.get 10
                                  call $memchr
                                  local.tee 1
                                  local.get 10
                                  local.get 11
                                  i32.add
                                  local.get 1
                                  select
                                  local.set 14
                                  local.get 21
                                  local.set 8
                                  local.get 1
                                  local.get 11
                                  i32.sub
                                  local.get 10
                                  local.get 1
                                  select
                                  local.set 10
                                  br 11 (;@4;)
                                end
                                local.get 10
                                if  ;; label = @15
                                  local.get 7
                                  i32.load offset=64
                                  br 2 (;@13;)
                                end
                                i32.const 0
                                local.set 1
                                local.get 0
                                i32.const 32
                                local.get 15
                                i32.const 0
                                local.get 8
                                call $pad
                                br 2 (;@12;)
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
                              local.set 10
                              local.get 7
                              i32.const 8
                              i32.add
                            end
                            local.set 9
                            i32.const 0
                            local.set 1
                            block  ;; label = @13
                              loop  ;; label = @14
                                local.get 9
                                i32.load
                                local.tee 12
                                i32.eqz
                                br_if 1 (;@13;)
                                block  ;; label = @15
                                  local.get 7
                                  i32.const 4
                                  i32.add
                                  local.get 12
                                  call $wctomb
                                  local.tee 12
                                  i32.const 0
                                  i32.lt_s
                                  local.tee 11
                                  br_if 0 (;@15;)
                                  local.get 12
                                  local.get 10
                                  local.get 1
                                  i32.sub
                                  i32.gt_u
                                  br_if 0 (;@15;)
                                  local.get 9
                                  i32.const 4
                                  i32.add
                                  local.set 9
                                  local.get 10
                                  local.get 1
                                  local.get 12
                                  i32.add
                                  local.tee 1
                                  i32.gt_u
                                  br_if 1 (;@14;)
                                  br 2 (;@13;)
                                end
                              end
                              i32.const -1
                              local.set 13
                              local.get 11
                              br_if 12 (;@1;)
                            end
                            local.get 0
                            i32.const 32
                            local.get 15
                            local.get 1
                            local.get 8
                            call $pad
                            local.get 1
                            i32.eqz
                            if  ;; label = @13
                              i32.const 0
                              local.set 1
                              br 1 (;@12;)
                            end
                            i32.const 0
                            local.set 9
                            local.get 7
                            i32.load offset=64
                            local.set 12
                            loop  ;; label = @13
                              local.get 12
                              i32.load
                              local.tee 11
                              i32.eqz
                              br_if 1 (;@12;)
                              local.get 7
                              i32.const 4
                              i32.add
                              local.get 11
                              call $wctomb
                              local.tee 11
                              local.get 9
                              i32.add
                              local.tee 9
                              local.get 1
                              i32.gt_s
                              br_if 1 (;@12;)
                              local.get 0
                              local.get 7
                              i32.const 4
                              i32.add
                              local.get 11
                              call $out
                              local.get 12
                              i32.const 4
                              i32.add
                              local.set 12
                              local.get 1
                              local.get 9
                              i32.gt_u
                              br_if 0 (;@13;)
                            end
                          end
                          local.get 0
                          i32.const 32
                          local.get 15
                          local.get 1
                          local.get 8
                          i32.const 8192
                          i32.xor
                          call $pad
                          local.get 15
                          local.get 1
                          local.get 1
                          local.get 15
                          i32.lt_s
                          select
                          local.set 1
                          br 9 (;@2;)
                        end
                        local.get 0
                        local.get 7
                        f64.load offset=64
                        local.get 15
                        local.get 10
                        local.get 8
                        local.get 1
                        local.get 5
                        call_indirect (type 29)
                        local.set 1
                        br 8 (;@2;)
                      end
                      local.get 7
                      local.get 7
                      i64.load offset=64
                      i64.store8 offset=55
                      i32.const 1
                      local.set 10
                      local.get 22
                      local.set 11
                      local.get 21
                      local.set 8
                      br 5 (;@4;)
                    end
                    local.get 7
                    local.get 1
                    i32.const 1
                    i32.add
                    local.tee 9
                    i32.store offset=76
                    local.get 1
                    i32.load8_u offset=1
                    local.set 8
                    local.get 9
                    local.set 1
                    br 0 (;@8;)
                  end
                  unreachable
                end
                local.get 16
                local.set 13
                local.get 0
                br_if 5 (;@1;)
                local.get 19
                i32.eqz
                br_if 3 (;@3;)
                i32.const 1
                local.set 1
                loop  ;; label = @7
                  local.get 4
                  local.get 1
                  i32.const 2
                  i32.shl
                  i32.add
                  i32.load
                  local.tee 8
                  if  ;; label = @8
                    local.get 3
                    local.get 1
                    i32.const 3
                    i32.shl
                    i32.add
                    local.get 8
                    local.get 2
                    local.get 6
                    call $pop_arg
                    i32.const 1
                    local.set 13
                    local.get 1
                    i32.const 1
                    i32.add
                    local.tee 1
                    i32.const 10
                    i32.ne
                    br_if 1 (;@7;)
                    br 7 (;@1;)
                  end
                end
                i32.const 1
                local.set 13
                local.get 1
                i32.const 10
                i32.ge_u
                br_if 5 (;@1;)
                loop  ;; label = @7
                  local.get 4
                  local.get 1
                  i32.const 2
                  i32.shl
                  i32.add
                  i32.load
                  br_if 1 (;@6;)
                  local.get 1
                  i32.const 1
                  i32.add
                  local.tee 1
                  i32.const 10
                  i32.ne
                  br_if 0 (;@7;)
                end
                br 5 (;@1;)
              end
              i32.const -1
              local.set 13
              br 4 (;@1;)
            end
          end
          local.get 0
          i32.const 32
          local.get 13
          local.get 14
          local.get 11
          i32.sub
          local.tee 12
          local.get 10
          local.get 10
          local.get 12
          i32.lt_s
          select
          local.tee 14
          i32.add
          local.tee 9
          local.get 15
          local.get 9
          local.get 15
          i32.gt_s
          select
          local.tee 1
          local.get 9
          local.get 8
          call $pad
          local.get 0
          local.get 17
          local.get 13
          call $out
          local.get 0
          i32.const 48
          local.get 1
          local.get 9
          local.get 8
          i32.const 65536
          i32.xor
          call $pad
          local.get 0
          i32.const 48
          local.get 14
          local.get 12
          i32.const 0
          call $pad
          local.get 0
          local.get 11
          local.get 12
          call $out
          local.get 0
          i32.const 32
          local.get 1
          local.get 9
          local.get 8
          i32.const 8192
          i32.xor
          call $pad
          br 1 (;@2;)
        end
      end
      i32.const 0
      local.set 13
    end
    local.get 7
    i32.const 80
    i32.add
    global.set 0
    local.get 13)
  (func $out (type 30) (param i32 i32 i32)
    local.get 0
    i32.load8_u
    i32.const 32
    i32.and
    i32.eqz
    if  ;; label = @1
      local.get 1
      local.get 2
      local.get 0
      call $__fwritex
      drop
    end)
  (func $getint (type 0) (param i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i32.load
    i32.load8_s
    call $isdigit
    if  ;; label = @1
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
        local.get 3
        local.get 1
        i32.const 10
        i32.mul
        i32.add
        i32.const 48
        i32.sub
        local.set 1
        local.get 2
        i32.load8_s offset=1
        call $isdigit
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $pop_arg (type 11) (param i32 i32 i32 i32)
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
                          i32.const 9
                          i32.sub
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
      call_indirect (type 6)
    end)
  (func $fmt_x (type 31) (param i64 i32 i32) (result i32)
    (local i32)
    local.get 0
    i64.eqz
    i32.eqz
    if  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.const 1
        i32.sub
        local.tee 1
        local.get 0
        i32.wrap_i64
        i32.const 15
        i32.and
        i32.const 2096
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
  (func $fmt_o (type 13) (param i64 i32) (result i32)
    (local i32)
    local.get 0
    i64.eqz
    i32.eqz
    if  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.const 1
        i32.sub
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
  (func $fmt_u (type 13) (param i64 i32) (result i32)
    (local i32 i64 i32 i32)
    block  ;; label = @1
      local.get 0
      i64.const 4294967296
      i64.lt_u
      if  ;; label = @2
        local.get 0
        local.set 3
        br 1 (;@1;)
      end
      loop  ;; label = @2
        local.get 1
        i32.const 1
        i32.sub
        local.tee 1
        local.get 0
        local.get 0
        i64.const 10
        i64.div_u
        local.tee 3
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
        local.set 2
        local.get 3
        local.set 0
        local.get 2
        br_if 0 (;@2;)
      end
    end
    local.get 3
    i32.wrap_i64
    local.tee 2
    if  ;; label = @1
      loop  ;; label = @2
        local.get 1
        i32.const 1
        i32.sub
        local.tee 1
        local.get 2
        local.get 2
        i32.const 10
        i32.div_u
        local.tee 4
        i32.const 10
        i32.mul
        i32.sub
        i32.const 48
        i32.or
        i32.store8
        local.get 2
        i32.const 9
        i32.gt_u
        local.set 5
        local.get 4
        local.set 2
        local.get 5
        br_if 0 (;@2;)
      end
    end
    local.get 1)
  (func $pad (type 32) (param i32 i32 i32 i32 i32)
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
      local.get 3
      i32.eqz
      if  ;; label = @2
        loop  ;; label = @3
          local.get 0
          local.get 5
          i32.const 256
          call $out
          local.get 2
          i32.const 256
          i32.sub
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
  (func $vfiprintf (type 1) (param i32 i32 i32) (result i32)
    local.get 0
    local.get 1
    local.get 2
    i32.const 0
    i32.const 0
    call $__vfprintf_internal)
  (func $iprintf (type 2) (param i32 i32) (result i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    local.get 1
    i32.store offset=12
    i32.const 1628
    i32.load
    local.get 0
    local.get 1
    call $vfiprintf
    local.set 1
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    local.get 1)
  (func $__lockfile (type 0) (param i32) (result i32)
    i32.const 1)
  (func $__unlockfile (type 5) (param i32)
    nop)
  (func $stackSave (type 3) (result i32)
    global.get 0)
  (func $stackRestore (type 5) (param i32)
    local.get 0
    global.set 0)
  (func $stackAlloc (type 0) (param i32) (result i32)
    (local i32)
    global.get 0
    local.get 0
    i32.sub
    i32.const -16
    i32.and
    local.tee 1
    global.set 0
    local.get 1)
  (func $dynCall_jiji (type 33) (param $fptr i32) (param $0 i32) (param $1 i64) (param $2 i32) (result i64)
    local.get $0
    local.get $1
    local.get $2
    local.get $fptr
    call_indirect (type 9))
  (func $legalstub$dynCall_jiji (type 8) (param i32 i32 i32 i32 i32) (result i32)
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
    local.tee 5
    i64.const 32
    i64.shr_u
    i32.wrap_i64
    call $setTempRet0
    local.get 5
    i32.wrap_i64)
  (func $legalfunc$__wasi_fd_seek (type 34) (param i32 i64 i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.wrap_i64
    local.get 1
    i64.const 32
    i64.shr_u
    i32.wrap_i64
    local.get 2
    local.get 3
    call $legalimport$__wasi_fd_seek)
  (table (;0;) 7 7 funcref)
  (memory (;0;) 256 256)
  (global (;0;) (mut i32) (i32.const 5248160))
  (export "memory" (memory 0))
  (export "__wasm_call_ctors" (func $__wasm_call_ctors))
  (export "main" (func $main))
  (export "__indirect_function_table" (table 0))
  (export "__errno_location" (func $__errno_location))
  (export "stackSave" (func $stackSave))
  (export "stackRestore" (func $stackRestore))
  (export "stackAlloc" (func $stackAlloc))
  (export "dynCall_jiji" (func $legalstub$dynCall_jiji))
  (elem (;0;) (i32.const 1) $__stdio_close $__stdio_read $__stdio_seek $__emscripten_stdout_close $__stdio_write $__emscripten_stdout_seek)
  (data (;0;) (i32.const 1024) "infinity\00-+   0X0x\00%u\00nan\00%d\00(null)\00@\08")
  (data (;1;) (i32.const 1072) "\d1t\9e\00W\9d\bd*\80pR\0f\ff\ff>'\0a\00\00\00d\00\00\00\e8\03\00\00\10'\00\00\a0\86\01\00@B\0f\00\80\96\98\00\00\e1\f5\05\18\00\00\005\00\00\00q\00\00\00k\ff\ff\ff\ce\fb\ff\ff\92\bf\ff\ff\00\00\00\00\00\00\00\00\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\00\01\02\03\04\05\06\07\08\09\ff\ff\ff\ff\ff\ff\ff\0a\0b\0c\0d\0e\0f\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f !\22#\ff\ff\ff\ff\ff\ff\0a\0b\0c\0d\0e\0f\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f !\22#\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\00\01\02\04\07\03\06\05\00\00\00\00\00\00\00\02\00\00\c0\03\00\00\c0\04\00\00\c0\05\00\00\c0\06\00\00\c0\07\00\00\c0\08\00\00\c0\09\00\00\c0\0a\00\00\c0\0b\00\00\c0\0c\00\00\c0\0d\00\00\c0\0e\00\00\c0\0f\00\00\c0\10\00\00\c0\11\00\00\c0\12\00\00\c0\13\00\00\c0\14\00\00\c0\15\00\00\c0\16\00\00\c0\17\00\00\c0\18\00\00\c0\19\00\00\c0\1a\00\00\c0\1b\00\00\c0\1c\00\00\c0\1d\00\00\c0\1e\00\00\c0\1f\00\00\c0\00\00\00\b3\01\00\00\c3\02\00\00\c3\03\00\00\c3\04\00\00\c3\05\00\00\c3\06\00\00\c3\07\00\00\c3\08\00\00\c3\09\00\00\c3\0a\00\00\c3\0b\00\00\c3\0c\00\00\c3\0d\00\00\d3\0e\00\00\c3\0f\00\00\c3\00\00\0c\bb\01\00\0c\c3\02\00\0c\c3\03\00\0c\c3\04\00\0c\d3\b8\09\00\00\11\00\0a\00\11\11\11\00\00\00\00\05\00\00\00\00\00\00\09\00\00\00\00\0b\00\00\00\00\00\00\00\00\11\00\0f\0a\11\11\11\03\0a\07\00\01\00\09\0b\0b\00\00\09\06\0b\00\00\0b\00\06\11\00\00\00\11\11\11")
  (data (;2;) (i32.const 1713) "\0b\00\00\00\00\00\00\00\00\11\00\0a\0a\11\11\11\00\0a\00\00\02\00\09\0b\00\00\00\09\00\0b\00\00\0b")
  (data (;3;) (i32.const 1771) "\0c")
  (data (;4;) (i32.const 1783) "\0c\00\00\00\00\0c\00\00\00\00\09\0c\00\00\00\00\00\0c\00\00\0c")
  (data (;5;) (i32.const 1829) "\0e")
  (data (;6;) (i32.const 1841) "\0d\00\00\00\04\0d\00\00\00\00\09\0e\00\00\00\00\00\0e\00\00\0e")
  (data (;7;) (i32.const 1887) "\10")
  (data (;8;) (i32.const 1899) "\0f\00\00\00\00\0f\00\00\00\00\09\10\00\00\00\00\00\10\00\00\10\00\00\12\00\00\00\12\12\12")
  (data (;9;) (i32.const 1954) "\12\00\00\00\12\12\12\00\00\00\00\00\00\09")
  (data (;10;) (i32.const 2003) "\0b")
  (data (;11;) (i32.const 2015) "\0a\00\00\00\00\0a\00\00\00\00\09\0b\00\00\00\00\00\0b\00\00\0b")
  (data (;12;) (i32.const 2061) "\0c")
  (data (;13;) (i32.const 2073) "\0c\00\00\00\00\0c\00\00\00\00\09\0c\00\00\00\00\00\0c\00\00\0c\00\000123456789ABCDEF")
  (data (;14;) (i32.const 2112) "\09")
  (data (;15;) (i32.const 2124) "\01")
  (data (;16;) (i32.const 2144) "\02\00\00\00\00\00\00\00\03\00\00\00X\0a\00\00\00\04")
  (data (;17;) (i32.const 2188) "\ff\ff\ff\ff")
  (data (;18;) (i32.const 2428) "\84\0e")
  (data (;19;) (i32.const 2484) "\a0\14P\00\05")
  (data (;20;) (i32.const 2500) "\04")
  (data (;21;) (i32.const 2524) "\05\00\00\00\06\00\00\00\98\10\00\00\00\04")
  (data (;22;) (i32.const 2548) "\01")
  (data (;23;) (i32.const 2563) "\0a\ff\ff\ff\ff"))
