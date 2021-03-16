(module
  (type (;0;) (func (result i32)))
  (type (;1;) (func (param i32 i32)))
  (type (;2;) (func (param i32 i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32) (result i32)))
  (type (;4;) (func (param i64)))
  (type (;5;) (func (param i32)))
  (type (;6;) (func (param i32 i64)))
  (type (;7;) (func))
  (type (;8;) (func (param i64 i64 i64)))
  (type (;9;) (func (param i32) (result i32)))
  (type (;10;) (func (param i64 i64)))
  (import "env" "action_data_size" (func (;0;) (type 0)))
  (import "env" "eosio_assert" (func (;1;) (type 1)))
  (import "env" "memset" (func (;2;) (type 2)))
  (import "env" "read_action_data" (func (;3;) (type 3)))
  (import "env" "memcpy" (func (;4;) (type 2)))
  (import "env" "require_auth" (func (;5;) (type 4)))
  (import "env" "prints" (func (;6;) (type 5)))
  (import "env" "printn" (func (;7;) (type 4)))
  (import "env" "eosio_assert_code" (func (;8;) (type 6)))
  (func (;9;) (type 7)
    call 12)
  (func (;10;) (type 8) (param i64 i64 i64)
    call 9
    local.get 0
    local.get 1
    i64.eq
    if  ;; label = @1
      i64.const 7746191359077253120
      local.get 2
      i64.eq
      if  ;; label = @2
        local.get 0
        local.get 1
        call 14
      else
        local.get 0
        i64.const 6138663577826885632
        i64.ne
        if  ;; label = @3
          i32.const 0
          i64.const 8000000000000000000
          call 8
        end
      end
    else
      i64.const 6138663577826885632
      local.get 1
      i64.eq
      if  ;; label = @2
        i64.const -6569208335818555392
        local.get 2
        i64.eq
        if  ;; label = @3
          i32.const 0
          i64.const 8000000000000000001
          call 8
        end
      end
    end
    i32.const 0
    call 13)
  (func (;11;) (type 9) (param i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.eqz
            br_if 0 (;@4;)
            i32.const 0
            i32.const 0
            i32.load offset=8204
            local.get 0
            i32.const 16
            i32.shr_u
            local.tee 1
            i32.add
            local.tee 2
            i32.store offset=8204
            i32.const 0
            i32.const 0
            i32.load offset=8196
            local.tee 3
            local.get 0
            i32.add
            i32.const 7
            i32.add
            i32.const -8
            i32.and
            local.tee 0
            i32.store offset=8196
            local.get 2
            i32.const 16
            i32.shl
            local.get 0
            i32.le_u
            br_if 1 (;@3;)
            local.get 1
            memory.grow
            i32.const -1
            i32.eq
            br_if 2 (;@2;)
            br 3 (;@1;)
          end
          i32.const 0
          return
        end
        i32.const 0
        local.get 2
        i32.const 1
        i32.add
        i32.store offset=8204
        local.get 1
        i32.const 1
        i32.add
        memory.grow
        i32.const -1
        i32.ne
        br_if 1 (;@1;)
      end
      i32.const 0
      i32.const 8208
      call 1
      local.get 3
      return
    end
    local.get 3)
  (func (;12;) (type 7)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 0
    i32.const 0
    i32.store offset=12
    i32.const 0
    local.get 0
    i32.load offset=12
    i32.load
    i32.const 7
    i32.add
    i32.const -8
    i32.and
    local.tee 0
    i32.store offset=8196
    i32.const 0
    local.get 0
    i32.store offset=8192
    i32.const 0
    memory.size
    i32.store offset=8204)
  (func (;13;) (type 5) (param i32))
  (func (;14;) (type 10) (param i64 i64)
    (local i32 i32 i32 i32 i64)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    local.set 3
    local.get 2
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              call 0
              local.tee 4
              i32.eqz
              br_if 0 (;@5;)
              local.get 4
              i32.const 512
              i32.lt_u
              br_if 1 (;@4;)
              local.get 4
              call 11
              local.set 2
              br 2 (;@3;)
            end
            local.get 3
            i64.const 0
            i64.store offset=8
            i32.const 0
            local.set 2
            local.get 3
            i32.const 8
            i32.add
            local.set 5
            br 2 (;@2;)
          end
          local.get 2
          local.get 4
          i32.const 15
          i32.add
          i32.const -16
          i32.and
          i32.sub
          local.tee 2
          global.set 0
        end
        local.get 2
        local.get 4
        call 3
        drop
        local.get 3
        i64.const 0
        i64.store offset=8
        local.get 3
        i32.const 8
        i32.add
        local.set 5
        local.get 4
        i32.const 7
        i32.gt_u
        br_if 1 (;@1;)
      end
      i32.const 0
      i32.const 8241
      call 1
    end
    local.get 5
    local.get 2
    i32.const 8
    call 4
    drop
    local.get 3
    i64.load offset=8
    local.tee 6
    call 5
    i32.const 8233
    call 6
    local.get 6
    call 7
    local.get 3
    i32.const 16
    i32.add
    global.set 0)
  (table (;0;) 1 1 funcref)
  (memory (;0;) 1)
  (global (;0;) (mut i32) (i32.const 8192))
  (global (;1;) i32 (i32.const 8246))
  (global (;2;) i32 (i32.const 8246))
  (export "apply" (func 10))
  (data (;0;) (i32.const 8208) "failed to allocate pages\00Hello, \00")
  (data (;1;) (i32.const 8241) "read\00")
  (data (;2;) (i32.const 0) "8 \00\00"))
