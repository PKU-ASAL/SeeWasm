(module
  (type (;0;) (func (param i32 i64 i32)))
  (type (;1;) (func (param i32 i64 i64 i32 i32)))
  (type (;2;) (func (param i32 i64 i32 i32)))
  (type (;3;) (func))
  (type (;4;) (func (result i64)))
  (type (;5;) (func (param i64 i64)))
  (type (;6;) (func (param i64)))
  (type (;7;) (func (param i32 i32)))
  (type (;8;) (func (param i64 i64 i64 i64) (result i32)))
  (type (;9;) (func (param i64 i64 i64 i64 i32 i32) (result i32)))
  (type (;10;) (func (param i32 i32 i32) (result i32)))
  (type (;11;) (func (param i64) (result i32)))
  (type (;12;) (func (param i32)))
  (type (;13;) (func (result i32)))
  (type (;14;) (func (param i32 i32) (result i32)))
  (type (;15;) (func (param i32) (result i32)))
  (type (;16;) (func (param i32 i32 i32 i32)))
  (type (;17;) (func (param i32 i64 i32 i64)))
  (type (;18;) (func (param i64 i64 i32 i32)))
  (type (;19;) (func (param i32 i64 i32) (result i32)))
  (type (;20;) (func (param i64 i64 i64)))
  (import "env" "abort" (func (;0;) (type 3)))
  (import "env" "action_data_size" (func (;1;) (type 13)))
  (import "env" "current_receiver" (func (;2;) (type 4)))
  (import "env" "current_time" (func (;3;) (type 4)))
  (import "env" "db_find_i64" (func (;4;) (type 8)))
  (import "env" "db_get_i64" (func (;5;) (type 10)))
  (import "env" "db_remove_i64" (func (;6;) (type 12)))
  (import "env" "db_store_i64" (func (;7;) (type 9)))
  (import "env" "db_update_i64" (func (;8;) (type 2)))
  (import "env" "eosio_assert" (func (;9;) (type 7)))
  (import "env" "is_account" (func (;10;) (type 11)))
  (import "env" "memcpy" (func (;11;) (type 10)))
  (import "env" "read_action_data" (func (;12;) (type 14)))
  (import "env" "require_auth" (func (;13;) (type 6)))
  (import "env" "require_auth2" (func (;14;) (type 5)))
  (import "env" "require_recipient" (func (;15;) (type 6)))
  (import "env" "send_inline" (func (;16;) (type 7)))
  (func (;17;) (type 14) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.const 32
    call 59
    i32.eqz)
  (func (;18;) (type 14) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.const 32
    call 59
    i32.eqz)
  (func (;19;) (type 14) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    i32.const 32
    call 59
    i32.const 0
    i32.ne)
  (func (;20;) (type 13) (result i32)
    call 3
    i64.const 1000000
    i64.div_u
    i32.wrap_i64)
  (func (;21;) (type 12) (param i32)
    local.get 0
    i64.load
    local.get 0
    i64.load offset=8
    call 14)
  (func (;22;) (type 0) (param i32 i64 i32)
    (local i64 i64 i64 i32 i64 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 128
    i32.sub
    local.tee 9
    i32.store offset=4
    local.get 0
    i64.load
    call 13
    i32.const 0
    local.set 8
    local.get 2
    i64.load offset=8
    local.tee 3
    i64.const 8
    i64.shr_u
    local.tee 4
    local.set 7
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 7
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 7
            i64.const 8
            i64.shr_u
            local.tee 7
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 7
              i64.const 8
              i64.shr_u
              local.tee 7
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 8
              i32.const 1
              i32.add
              local.tee 8
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 6
          local.get 8
          i32.const 1
          i32.add
          local.tee 8
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 6
    end
    local.get 6
    i32.const 16
    call 9
    i32.const 0
    local.set 6
    block  ;; label = @1
      local.get 2
      i64.load
      local.tee 5
      i64.const 4611686018427387903
      i64.add
      i64.const 9223372036854775806
      i64.gt_u
      br_if 0 (;@1;)
      i32.const 0
      local.set 8
      local.get 4
      local.set 7
      block  ;; label = @2
        loop  ;; label = @3
          local.get 7
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 7
            i64.const 8
            i64.shr_u
            local.tee 7
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 7
              i64.const 8
              i64.shr_u
              local.tee 7
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 8
              i32.const 1
              i32.add
              local.tee 8
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 6
          local.get 8
          i32.const 1
          i32.add
          local.tee 8
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 6
    end
    local.get 6
    i32.const 48
    call 9
    local.get 5
    i64.const 0
    i64.gt_s
    i32.const 64
    call 9
    local.get 9
    i32.const 8
    i32.add
    i32.const 32
    i32.add
    i32.const 0
    i32.store
    local.get 9
    i64.const -1
    i64.store offset=24
    local.get 9
    i64.const 0
    i64.store offset=32
    local.get 9
    local.get 0
    i64.load
    local.tee 7
    i64.store offset=8
    local.get 9
    local.get 4
    i64.store offset=16
    block  ;; label = @1
      block  ;; label = @2
        local.get 7
        local.get 4
        i64.const -4157508551318700032
        local.get 4
        call 4
        local.tee 8
        i32.const 0
        i32.lt_s
        br_if 0 (;@2;)
        local.get 9
        i32.const 8
        i32.add
        local.get 8
        call 23
        i32.load offset=40
        local.get 9
        i32.const 8
        i32.add
        i32.eq
        i32.const 96
        call 9
        i32.const 0
        local.set 8
        br 1 (;@1;)
      end
      i32.const 1
      local.set 8
    end
    local.get 8
    i32.const 160
    call 9
    local.get 0
    i64.load
    local.set 4
    local.get 9
    i64.load offset=8
    call 2
    i64.eq
    i32.const 208
    call 9
    i32.const 56
    call 53
    local.tee 8
    call 24
    drop
    local.get 8
    local.get 9
    i32.const 8
    i32.add
    i32.store offset=40
    local.get 8
    local.get 3
    i64.store offset=8
    local.get 8
    i32.const 28
    i32.add
    local.get 2
    i32.const 12
    i32.add
    i32.load
    i32.store
    local.get 8
    i32.const 24
    i32.add
    local.get 2
    i32.const 8
    i32.add
    i32.load
    i32.store
    local.get 8
    i32.const 20
    i32.add
    local.get 2
    i32.const 4
    i32.add
    i32.load
    i32.store
    local.get 8
    local.get 2
    i32.load
    i32.store offset=16
    local.get 8
    local.get 1
    i64.store offset=32
    local.get 9
    local.get 9
    i32.const 48
    i32.add
    i32.const 40
    i32.add
    i32.store offset=96
    local.get 9
    local.get 9
    i32.const 48
    i32.add
    i32.store offset=92
    local.get 9
    local.get 9
    i32.const 48
    i32.add
    i32.store offset=88
    local.get 9
    local.get 9
    i32.const 88
    i32.add
    i32.store offset=104
    local.get 9
    local.get 8
    i32.const 16
    i32.add
    i32.store offset=116
    local.get 9
    local.get 8
    i32.store offset=112
    local.get 9
    local.get 8
    i32.const 32
    i32.add
    i32.store offset=120
    local.get 9
    i32.const 112
    i32.add
    local.get 9
    i32.const 104
    i32.add
    call 25
    local.get 8
    local.get 9
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    i64.load
    i64.const -4157508551318700032
    local.get 4
    local.get 8
    i64.load offset=8
    i64.const 8
    i64.shr_u
    local.tee 7
    local.get 9
    i32.const 48
    i32.add
    i32.const 40
    call 7
    local.tee 6
    i32.store offset=44
    block  ;; label = @1
      local.get 7
      local.get 9
      i32.const 8
      i32.add
      i32.const 16
      i32.add
      local.tee 2
      i64.load
      i64.lt_u
      br_if 0 (;@1;)
      local.get 2
      local.get 7
      i64.const 1
      i64.add
      i64.store
    end
    local.get 9
    local.get 8
    i32.store offset=112
    local.get 9
    local.get 8
    i32.const 8
    i32.add
    i64.load
    i64.const 8
    i64.shr_u
    local.tee 7
    i64.store offset=48
    local.get 9
    local.get 6
    i32.store offset=88
    block  ;; label = @1
      block  ;; label = @2
        local.get 9
        i32.const 8
        i32.add
        i32.const 28
        i32.add
        i32.load
        local.tee 2
        local.get 9
        i32.const 40
        i32.add
        i32.load
        i32.ge_u
        br_if 0 (;@2;)
        local.get 2
        local.get 7
        i64.store offset=8
        local.get 2
        local.get 6
        i32.store offset=16
        local.get 9
        i32.const 0
        i32.store offset=112
        local.get 2
        local.get 8
        i32.store
        local.get 9
        i32.const 36
        i32.add
        local.get 2
        i32.const 24
        i32.add
        i32.store
        br 1 (;@1;)
      end
      local.get 9
      i32.const 32
      i32.add
      local.get 9
      i32.const 112
      i32.add
      local.get 9
      i32.const 48
      i32.add
      local.get 9
      i32.const 88
      i32.add
      call 26
    end
    local.get 9
    i32.load offset=112
    local.set 8
    local.get 9
    i32.const 0
    i32.store offset=112
    block  ;; label = @1
      local.get 8
      i32.eqz
      br_if 0 (;@1;)
      local.get 8
      call 54
    end
    block  ;; label = @1
      local.get 9
      i32.load offset=32
      local.tee 6
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 9
          i32.const 36
          i32.add
          local.tee 0
          i32.load
          local.tee 8
          local.get 6
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 8
            i32.const -24
            i32.add
            local.tee 8
            i32.load
            local.set 2
            local.get 8
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 2
              i32.eqz
              br_if 0 (;@5;)
              local.get 2
              call 54
            end
            local.get 6
            local.get 8
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 9
          i32.const 32
          i32.add
          i32.load
          local.set 8
          br 1 (;@2;)
        end
        local.get 6
        local.set 8
      end
      local.get 0
      local.get 6
      i32.store
      local.get 8
      call 54
    end
    i32.const 0
    local.get 9
    i32.const 128
    i32.add
    i32.store offset=4)
  (func (;23;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i32 i64 i32 i32 i32 i32)
    i32.const 0
    i32.load offset=4
    i32.const 48
    i32.sub
    local.tee 9
    local.set 8
    i32.const 0
    local.get 9
    i32.store offset=4
    block  ;; label = @1
      local.get 0
      i32.const 28
      i32.add
      i32.load
      local.tee 7
      local.get 0
      i32.load offset=24
      local.tee 2
      i32.eq
      br_if 0 (;@1;)
      i32.const 0
      local.get 2
      i32.sub
      local.set 3
      local.get 7
      i32.const -24
      i32.add
      local.set 6
      loop  ;; label = @2
        local.get 6
        i32.const 16
        i32.add
        i32.load
        local.get 1
        i32.eq
        br_if 1 (;@1;)
        local.get 6
        local.set 7
        local.get 6
        i32.const -24
        i32.add
        local.tee 4
        local.set 6
        local.get 4
        local.get 3
        i32.add
        i32.const -24
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 7
        local.get 2
        i32.eq
        br_if 0 (;@2;)
        local.get 7
        i32.const -24
        i32.add
        i32.load
        local.set 6
        br 1 (;@1;)
      end
      local.get 1
      i32.const 0
      i32.const 0
      call 5
      local.tee 6
      i32.const 31
      i32.shr_u
      i32.const 1
      i32.xor
      i32.const 352
      call 9
      block  ;; label = @2
        block  ;; label = @3
          local.get 6
          i32.const 513
          i32.lt_u
          br_if 0 (;@3;)
          local.get 6
          call 60
          local.set 4
          br 1 (;@2;)
        end
        i32.const 0
        local.get 9
        local.get 6
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        local.tee 4
        i32.store offset=4
      end
      local.get 1
      local.get 4
      local.get 6
      call 5
      drop
      local.get 8
      local.get 4
      i32.store offset=12
      local.get 8
      local.get 4
      i32.store offset=8
      local.get 8
      local.get 4
      local.get 6
      i32.add
      i32.store offset=16
      block  ;; label = @2
        local.get 6
        i32.const 513
        i32.lt_u
        br_if 0 (;@2;)
        local.get 4
        call 63
      end
      i32.const 56
      call 53
      local.tee 6
      call 24
      drop
      local.get 6
      local.get 0
      i32.store offset=40
      local.get 8
      local.get 8
      i32.const 8
      i32.add
      i32.store offset=24
      local.get 8
      local.get 6
      i32.const 16
      i32.add
      i32.store offset=36
      local.get 8
      local.get 6
      i32.store offset=32
      local.get 8
      local.get 6
      i32.const 32
      i32.add
      i32.store offset=40
      local.get 8
      i32.const 32
      i32.add
      local.get 8
      i32.const 24
      i32.add
      call 27
      local.get 6
      local.get 1
      i32.store offset=44
      local.get 8
      local.get 6
      i32.store offset=24
      local.get 8
      local.get 6
      i64.load offset=8
      i64.const 8
      i64.shr_u
      local.tee 5
      i64.store offset=32
      local.get 8
      local.get 6
      i32.load offset=44
      local.tee 7
      i32.store offset=4
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 28
          i32.add
          local.tee 1
          i32.load
          local.tee 4
          local.get 0
          i32.const 32
          i32.add
          i32.load
          i32.ge_u
          br_if 0 (;@3;)
          local.get 4
          local.get 5
          i64.store offset=8
          local.get 4
          local.get 7
          i32.store offset=16
          local.get 8
          i32.const 0
          i32.store offset=24
          local.get 4
          local.get 6
          i32.store
          local.get 1
          local.get 4
          i32.const 24
          i32.add
          i32.store
          br 1 (;@2;)
        end
        local.get 0
        i32.const 24
        i32.add
        local.get 8
        i32.const 24
        i32.add
        local.get 8
        i32.const 32
        i32.add
        local.get 8
        i32.const 4
        i32.add
        call 26
      end
      local.get 8
      i32.load offset=24
      local.set 4
      local.get 8
      i32.const 0
      i32.store offset=24
      local.get 4
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      call 54
    end
    i32.const 0
    local.get 8
    i32.const 48
    i32.add
    i32.store offset=4
    local.get 6)
  (func (;24;) (type 15) (param i32) (result i32)
    (local i64 i32 i32)
    local.get 0
    i64.const 1398362884
    i64.store offset=8
    local.get 0
    i64.const 0
    i64.store
    i32.const 1
    i32.const 288
    call 9
    local.get 0
    i64.load offset=8
    i64.const 8
    i64.shr_u
    local.set 1
    i32.const 0
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 1
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 1
            i64.const 8
            i64.shr_u
            local.tee 1
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 1
              i64.const 8
              i64.shr_u
              local.tee 1
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 2
              i32.const 1
              i32.add
              local.tee 2
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 3
          local.get 2
          i32.const 1
          i32.add
          local.tee 2
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 3
    end
    local.get 3
    i32.const 16
    call 9
    local.get 0
    i32.const 24
    i32.add
    local.tee 2
    i64.const 1398362884
    i64.store
    local.get 0
    i64.const 0
    i64.store offset=16
    i32.const 1
    i32.const 288
    call 9
    local.get 2
    i64.load
    i64.const 8
    i64.shr_u
    local.set 1
    i32.const 0
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 1
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 1
            i64.const 8
            i64.shr_u
            local.tee 1
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 1
              i64.const 8
              i64.shr_u
              local.tee 1
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 2
              i32.const 1
              i32.add
              local.tee 2
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 3
          local.get 2
          i32.const 1
          i32.add
          local.tee 2
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 3
    end
    local.get 3
    i32.const 16
    call 9
    local.get 0)
  (func (;25;) (type 7) (param i32 i32)
    (local i32 i32 i32)
    local.get 0
    i32.load
    local.set 3
    local.get 1
    i32.load
    local.tee 2
    i32.load offset=8
    local.get 2
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 2
    i32.load offset=4
    local.get 3
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 4
    i32.store offset=4
    local.get 2
    i32.load offset=8
    local.get 4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 2
    i32.load offset=4
    local.get 3
    i32.const 8
    i32.add
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=4
    local.set 3
    local.get 1
    i32.load
    local.tee 2
    i32.load offset=8
    local.get 2
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 2
    i32.load offset=4
    local.get 3
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 4
    i32.store offset=4
    local.get 2
    i32.load offset=8
    local.get 4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 2
    i32.load offset=4
    local.get 3
    i32.const 8
    i32.add
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=8
    local.set 0
    local.get 1
    i32.load
    local.tee 2
    i32.load offset=8
    local.get 2
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 2
    i32.load offset=4
    local.get 0
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4)
  (func (;26;) (type 16) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 6
        i32.sub
        i32.const 24
        i32.div_s
        local.tee 4
        i32.const 1
        i32.add
        local.tee 5
        i32.const 178956971
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 178956970
        local.set 7
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load offset=8
            local.get 6
            i32.sub
            i32.const 24
            i32.div_s
            local.tee 6
            i32.const 89478484
            i32.gt_u
            br_if 0 (;@4;)
            local.get 5
            local.get 6
            i32.const 1
            i32.shl
            local.tee 7
            local.get 7
            local.get 5
            i32.lt_u
            select
            local.tee 7
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 7
          i32.const 24
          i32.mul
          call 53
          local.set 6
          br 2 (;@1;)
        end
        i32.const 0
        local.set 7
        i32.const 0
        local.set 6
        br 1 (;@1;)
      end
      local.get 0
      call 57
      unreachable
    end
    local.get 1
    i32.load
    local.set 5
    local.get 1
    i32.const 0
    i32.store
    local.get 6
    local.get 4
    i32.const 24
    i32.mul
    i32.add
    local.tee 1
    local.get 5
    i32.store
    local.get 1
    local.get 2
    i64.load
    i64.store offset=8
    local.get 1
    local.get 3
    i32.load
    i32.store offset=16
    local.get 6
    local.get 7
    i32.const 24
    i32.mul
    i32.add
    local.set 4
    local.get 1
    i32.const 24
    i32.add
    local.set 5
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.tee 6
        local.get 0
        i32.load
        local.tee 7
        i32.eq
        br_if 0 (;@2;)
        loop  ;; label = @3
          local.get 6
          i32.const -24
          i32.add
          local.tee 2
          i32.load
          local.set 3
          local.get 2
          i32.const 0
          i32.store
          local.get 1
          i32.const -24
          i32.add
          local.get 3
          i32.store
          local.get 1
          i32.const -8
          i32.add
          local.get 6
          i32.const -8
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const -12
          i32.add
          local.get 6
          i32.const -12
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const -16
          i32.add
          local.get 6
          i32.const -16
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const -24
          i32.add
          local.set 1
          local.get 2
          local.set 6
          local.get 7
          local.get 2
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 7
        local.get 0
        i32.load
        local.set 6
        br 1 (;@1;)
      end
      local.get 7
      local.set 6
    end
    local.get 0
    local.get 1
    i32.store
    local.get 0
    i32.const 4
    i32.add
    local.get 5
    i32.store
    local.get 0
    i32.const 8
    i32.add
    local.get 4
    i32.store
    block  ;; label = @1
      local.get 7
      local.get 6
      i32.eq
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 7
        i32.const -24
        i32.add
        local.tee 7
        i32.load
        local.set 1
        local.get 7
        i32.const 0
        i32.store
        block  ;; label = @3
          local.get 1
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          call 54
        end
        local.get 6
        local.get 7
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 6
      i32.eqz
      br_if 0 (;@1;)
      local.get 6
      call 54
    end)
  (func (;27;) (type 7) (param i32 i32)
    (local i32 i32 i32)
    local.get 0
    i32.load
    local.set 3
    local.get 1
    i32.load
    local.tee 2
    i32.load offset=8
    local.get 2
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 3
    local.get 2
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 4
    i32.store offset=4
    local.get 2
    i32.load offset=8
    local.get 4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 3
    i32.const 8
    i32.add
    local.get 2
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=4
    local.set 3
    local.get 1
    i32.load
    local.tee 2
    i32.load offset=8
    local.get 2
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 3
    local.get 2
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 4
    i32.store offset=4
    local.get 2
    i32.load offset=8
    local.get 4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 3
    i32.const 8
    i32.add
    local.get 2
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=8
    local.set 0
    local.get 1
    i32.load
    local.tee 2
    i32.load offset=8
    local.get 2
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 0
    local.get 2
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 2
    local.get 2
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4)
  (func (;28;) (type 2) (param i32 i64 i32 i32)
    (local i32 i64 i64 i32 i64 i32 i32 i64 i64 i64 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 224
    i32.sub
    local.tee 14
    i32.store offset=4
    i32.const 0
    local.set 9
    local.get 2
    i64.load offset=8
    local.tee 11
    i64.const 8
    i64.shr_u
    local.tee 13
    local.set 8
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 8
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 8
            i64.const 8
            i64.shr_u
            local.tee 8
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 8
              i64.const 8
              i64.shr_u
              local.tee 8
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 9
              i32.const 1
              i32.add
              local.tee 9
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 7
          local.get 9
          i32.const 1
          i32.add
          local.tee 9
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 7
    end
    local.get 7
    i32.const 16
    call 9
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.load8_u
        local.tee 9
        i32.const 1
        i32.and
        br_if 0 (;@2;)
        local.get 9
        i32.const 1
        i32.shr_u
        local.set 9
        br 1 (;@1;)
      end
      local.get 3
      i32.load offset=4
      local.set 9
    end
    local.get 9
    i32.const 257
    i32.lt_u
    i32.const 400
    call 9
    i32.const 0
    local.set 10
    local.get 14
    i32.const 88
    i32.add
    i32.const 32
    i32.add
    i32.const 0
    i32.store
    local.get 14
    i64.const -1
    i64.store offset=104
    local.get 14
    i64.const 0
    i64.store offset=112
    local.get 14
    local.get 0
    i64.load
    local.tee 8
    i64.store offset=88
    local.get 14
    local.get 13
    i64.store offset=96
    i32.const 0
    local.set 7
    block  ;; label = @1
      local.get 8
      local.get 13
      i64.const -4157508551318700032
      local.get 13
      call 4
      local.tee 9
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 14
      i32.const 88
      i32.add
      local.get 9
      call 23
      local.tee 7
      i32.load offset=40
      local.get 14
      i32.const 88
      i32.add
      i32.eq
      i32.const 96
      call 9
    end
    local.get 7
    i32.const 0
    i32.ne
    i32.const 432
    call 9
    local.get 7
    i64.load offset=32
    call 13
    local.get 7
    i32.const 32
    i32.add
    local.set 4
    block  ;; label = @1
      local.get 2
      i64.load
      local.tee 8
      i64.const 4611686018427387903
      i64.add
      i64.const 9223372036854775806
      i64.gt_u
      br_if 0 (;@1;)
      i32.const 0
      local.set 9
      block  ;; label = @2
        loop  ;; label = @3
          local.get 13
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 13
            i64.const 8
            i64.shr_u
            local.tee 13
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 13
              i64.const 8
              i64.shr_u
              local.tee 13
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 9
              i32.const 1
              i32.add
              local.tee 9
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 10
          local.get 9
          i32.const 1
          i32.add
          local.tee 9
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 10
    end
    local.get 10
    i32.const 496
    call 9
    local.get 8
    i64.const 0
    i64.gt_s
    i32.const 528
    call 9
    local.get 11
    local.get 7
    i64.load offset=8
    i64.eq
    i32.const 560
    call 9
    local.get 8
    local.get 7
    i64.load offset=16
    local.get 7
    i64.load
    i64.sub
    i64.le_s
    i32.const 592
    call 9
    local.get 7
    i32.load offset=40
    local.get 14
    i32.const 88
    i32.add
    i32.eq
    i32.const 640
    call 9
    local.get 14
    i64.load offset=88
    call 2
    i64.eq
    i32.const 688
    call 9
    local.get 11
    local.get 7
    i64.load offset=8
    local.tee 13
    i64.eq
    i32.const 752
    call 9
    local.get 7
    local.get 7
    i64.load
    local.get 8
    i64.add
    local.tee 8
    i64.store
    local.get 8
    i64.const -4611686018427387904
    i64.gt_s
    i32.const 800
    call 9
    local.get 7
    i64.load
    i64.const 4611686018427387904
    i64.lt_s
    i32.const 832
    call 9
    local.get 13
    i64.const 8
    i64.shr_u
    local.tee 8
    local.get 7
    i64.load offset=8
    i64.const 8
    i64.shr_u
    i64.eq
    i32.const 864
    call 9
    local.get 14
    local.get 14
    i32.const 128
    i32.add
    i32.const 40
    i32.add
    i32.store offset=192
    local.get 14
    local.get 14
    i32.const 128
    i32.add
    i32.store offset=188
    local.get 14
    local.get 14
    i32.const 128
    i32.add
    i32.store offset=184
    local.get 14
    local.get 14
    i32.const 184
    i32.add
    i32.store offset=200
    local.get 14
    local.get 7
    i32.const 16
    i32.add
    i32.store offset=212
    local.get 14
    local.get 7
    i32.store offset=208
    local.get 14
    local.get 4
    i32.store offset=216
    local.get 14
    i32.const 208
    i32.add
    local.get 14
    i32.const 200
    i32.add
    call 25
    local.get 7
    i32.load offset=44
    i64.const 0
    local.get 14
    i32.const 128
    i32.add
    i32.const 40
    call 8
    block  ;; label = @1
      local.get 8
      local.get 14
      i32.const 88
      i32.add
      i32.const 16
      i32.add
      local.tee 9
      i64.load
      i64.lt_u
      br_if 0 (;@1;)
      local.get 9
      local.get 8
      i64.const 1
      i64.add
      i64.store
    end
    local.get 14
    i32.const 72
    i32.add
    i32.const 12
    i32.add
    local.tee 9
    local.get 2
    i32.const 12
    i32.add
    i32.load
    i32.store
    local.get 14
    i32.const 72
    i32.add
    i32.const 8
    i32.add
    local.tee 7
    local.get 2
    i32.const 8
    i32.add
    i32.load
    i32.store
    local.get 14
    local.get 2
    i32.const 4
    i32.add
    i32.load
    i32.store offset=76
    local.get 14
    local.get 2
    i32.load
    i32.store offset=72
    local.get 4
    i64.load
    local.set 8
    local.get 14
    i32.const 8
    i32.add
    i32.const 12
    i32.add
    local.get 9
    i32.load
    i32.store
    local.get 14
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get 7
    i32.load
    i32.store
    local.get 14
    local.get 14
    i32.load offset=76
    i32.store offset=12
    local.get 14
    local.get 14
    i32.load offset=72
    i32.store offset=8
    local.get 0
    local.get 8
    local.get 14
    i32.const 8
    i32.add
    local.get 8
    call 29
    block  ;; label = @1
      local.get 4
      i64.load
      local.tee 5
      local.get 1
      i64.eq
      br_if 0 (;@1;)
      local.get 0
      i64.load
      local.set 6
      i64.const 0
      local.set 8
      i64.const 59
      local.set 11
      i32.const 928
      local.set 9
      i64.const 0
      local.set 12
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 8
                  i64.const 5
                  i64.gt_u
                  br_if 0 (;@7;)
                  local.get 9
                  i32.load8_s
                  local.tee 7
                  i32.const -97
                  i32.add
                  i32.const 255
                  i32.and
                  i32.const 25
                  i32.gt_u
                  br_if 1 (;@6;)
                  local.get 7
                  i32.const 165
                  i32.add
                  local.set 7
                  br 2 (;@5;)
                end
                i64.const 0
                local.set 13
                local.get 8
                i64.const 11
                i64.le_u
                br_if 2 (;@4;)
                br 3 (;@3;)
              end
              local.get 7
              i32.const 208
              i32.add
              i32.const 0
              local.get 7
              i32.const -49
              i32.add
              i32.const 255
              i32.and
              i32.const 5
              i32.lt_u
              select
              local.set 7
            end
            local.get 7
            i64.extend_i32_u
            i64.const 56
            i64.shl
            i64.const 56
            i64.shr_s
            local.set 13
          end
          local.get 13
          i64.const 31
          i64.and
          local.get 11
          i64.const 4294967295
          i64.and
          i64.shl
          local.set 13
        end
        local.get 9
        i32.const 1
        i32.add
        local.set 9
        local.get 8
        i64.const 1
        i64.add
        local.set 8
        local.get 13
        local.get 12
        i64.or
        local.set 12
        local.get 11
        i64.const -5
        i64.add
        local.tee 11
        i64.const -6
        i64.ne
        br_if 0 (;@2;)
      end
      local.get 14
      i32.const 52
      i32.add
      local.get 2
      i32.const 12
      i32.add
      i32.load
      i32.store
      local.get 14
      i32.const 24
      i32.add
      i32.const 24
      i32.add
      local.tee 7
      local.get 2
      i32.const 8
      i32.add
      i32.load
      i32.store
      local.get 14
      i32.const 44
      i32.add
      local.get 2
      i32.const 4
      i32.add
      i32.load
      i32.store
      local.get 14
      local.get 1
      i64.store offset=32
      local.get 14
      local.get 5
      i64.store offset=24
      local.get 14
      local.get 2
      i32.load
      i32.store offset=40
      local.get 14
      i32.const 56
      i32.add
      local.get 3
      call 58
      drop
      i32.const 16
      call 53
      local.tee 9
      local.get 5
      i64.store
      local.get 9
      local.get 12
      i64.store offset=8
      local.get 14
      local.get 9
      i32.store offset=208
      local.get 14
      local.get 9
      i32.const 16
      i32.add
      local.tee 9
      i32.store offset=216
      local.get 14
      local.get 9
      i32.store offset=212
      local.get 14
      local.get 14
      i64.load offset=24
      i64.store offset=128
      local.get 14
      local.get 14
      i64.load offset=32
      i64.store offset=136
      local.get 14
      i32.const 128
      i32.add
      i32.const 24
      i32.add
      local.get 7
      i64.load
      i64.store
      local.get 14
      local.get 14
      i64.load offset=40
      i64.store offset=144
      local.get 14
      i32.const 128
      i32.add
      i32.const 40
      i32.add
      local.tee 7
      local.get 14
      i32.const 24
      i32.add
      i32.const 40
      i32.add
      local.tee 9
      i32.load
      i32.store
      local.get 14
      local.get 14
      i64.load offset=56
      i64.store offset=160
      local.get 14
      i32.const 0
      i32.store offset=56
      local.get 14
      i32.const 60
      i32.add
      i32.const 0
      i32.store
      local.get 9
      i32.const 0
      i32.store
      local.get 6
      i64.const -3617168760277827584
      local.get 14
      i32.const 208
      i32.add
      local.get 14
      i32.const 128
      i32.add
      call 30
      block  ;; label = @2
        local.get 14
        i32.load8_u offset=160
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 7
        i32.load
        call 54
      end
      block  ;; label = @2
        local.get 14
        i32.load offset=208
        local.tee 9
        i32.eqz
        br_if 0 (;@2;)
        local.get 14
        local.get 9
        i32.store offset=212
        local.get 9
        call 54
      end
      local.get 14
      i32.const 56
      i32.add
      i32.load8_u
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 14
      i32.const 64
      i32.add
      i32.load
      call 54
    end
    block  ;; label = @1
      local.get 14
      i32.load offset=112
      local.tee 2
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 14
          i32.const 116
          i32.add
          local.tee 10
          i32.load
          local.tee 9
          local.get 2
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 9
            i32.const -24
            i32.add
            local.tee 9
            i32.load
            local.set 7
            local.get 9
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 7
              i32.eqz
              br_if 0 (;@5;)
              local.get 7
              call 54
            end
            local.get 2
            local.get 9
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 14
          i32.const 112
          i32.add
          i32.load
          local.set 9
          br 1 (;@2;)
        end
        local.get 2
        local.set 9
      end
      local.get 10
      local.get 2
      i32.store
      local.get 9
      call 54
    end
    i32.const 0
    local.get 14
    i32.const 224
    i32.add
    i32.store offset=4)
  (func (;29;) (type 17) (param i32 i64 i32 i64)
    (local i64 i32 i64 i32 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 80
    i32.sub
    local.tee 9
    i32.store offset=4
    i32.const 0
    local.set 8
    local.get 9
    i32.const 8
    i32.add
    i32.const 32
    i32.add
    i32.const 0
    i32.store
    local.get 9
    i64.const -1
    i64.store offset=24
    local.get 9
    i64.const 0
    i64.store offset=32
    local.get 9
    local.get 0
    i64.load
    local.tee 6
    i64.store offset=8
    local.get 9
    local.get 1
    i64.store offset=16
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 6
            local.get 1
            i64.const 3607749779137757184
            local.get 2
            i64.load offset=8
            local.tee 4
            i64.const 8
            i64.shr_u
            call 4
            local.tee 0
            i32.const 0
            i32.lt_s
            br_if 0 (;@4;)
            local.get 9
            i32.const 8
            i32.add
            local.get 0
            call 37
            local.tee 8
            i32.load offset=16
            local.get 9
            i32.const 8
            i32.add
            i32.eq
            i32.const 96
            call 9
            i32.const 1
            i32.const 944
            call 9
            local.get 8
            i32.load offset=16
            local.get 9
            i32.const 8
            i32.add
            i32.eq
            i32.const 640
            call 9
            local.get 9
            i64.load offset=8
            call 2
            i64.eq
            i32.const 688
            call 9
            local.get 4
            local.get 8
            i64.load offset=8
            local.tee 1
            i64.eq
            i32.const 752
            call 9
            local.get 8
            local.get 8
            i64.load
            local.get 2
            i64.load
            i64.add
            local.tee 6
            i64.store
            local.get 6
            i64.const -4611686018427387904
            i64.gt_s
            i32.const 800
            call 9
            local.get 8
            i64.load
            i64.const 4611686018427387904
            i64.lt_s
            i32.const 832
            call 9
            local.get 1
            i64.const 8
            i64.shr_u
            local.tee 1
            local.get 8
            i64.load offset=8
            i64.const 8
            i64.shr_u
            i64.eq
            i32.const 864
            call 9
            i32.const 1
            i32.const 272
            call 9
            local.get 9
            i32.const 64
            i32.add
            local.get 8
            i32.const 8
            call 11
            drop
            i32.const 1
            i32.const 272
            call 9
            local.get 9
            i32.const 64
            i32.add
            i32.const 8
            i32.or
            local.get 8
            i32.const 8
            i32.add
            i32.const 8
            call 11
            drop
            local.get 8
            i32.load offset=20
            i64.const 0
            local.get 9
            i32.const 64
            i32.add
            i32.const 16
            call 8
            local.get 1
            local.get 9
            i32.const 8
            i32.add
            i32.const 16
            i32.add
            local.tee 8
            i64.load
            i64.lt_u
            br_if 1 (;@3;)
            local.get 8
            local.get 1
            i64.const 1
            i64.add
            i64.store
            local.get 9
            i32.load offset=32
            local.tee 2
            br_if 2 (;@2;)
            br 3 (;@1;)
          end
          local.get 9
          i64.load offset=8
          call 2
          i64.eq
          i32.const 208
          call 9
          i32.const 32
          call 53
          local.tee 0
          i64.const 1398362884
          i64.store offset=8
          local.get 0
          i64.const 0
          i64.store
          i32.const 1
          i32.const 288
          call 9
          local.get 0
          i32.const 8
          i32.add
          local.set 5
          i64.const 5462355
          local.set 1
          block  ;; label = @4
            loop  ;; label = @5
              i32.const 0
              local.set 7
              local.get 1
              i32.wrap_i64
              i32.const 24
              i32.shl
              i32.const -1073741825
              i32.add
              i32.const 452984830
              i32.gt_u
              br_if 1 (;@4;)
              block  ;; label = @6
                local.get 1
                i64.const 8
                i64.shr_u
                local.tee 1
                i64.const 255
                i64.and
                i64.const 0
                i64.ne
                br_if 0 (;@6;)
                loop  ;; label = @7
                  local.get 1
                  i64.const 8
                  i64.shr_u
                  local.tee 1
                  i64.const 255
                  i64.and
                  i64.const 0
                  i64.ne
                  br_if 3 (;@4;)
                  local.get 8
                  i32.const 1
                  i32.add
                  local.tee 8
                  i32.const 7
                  i32.lt_s
                  br_if 0 (;@7;)
                end
              end
              i32.const 1
              local.set 7
              local.get 8
              i32.const 1
              i32.add
              local.tee 8
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          local.get 7
          i32.const 16
          call 9
          local.get 0
          local.get 9
          i32.const 8
          i32.add
          i32.store offset=16
          local.get 0
          i32.const 8
          i32.add
          local.tee 8
          local.get 2
          i32.const 8
          i32.add
          i64.load
          i64.store
          local.get 0
          local.get 2
          i64.load
          i64.store
          i32.const 1
          i32.const 272
          call 9
          local.get 9
          i32.const 64
          i32.add
          local.get 0
          i32.const 8
          call 11
          drop
          i32.const 1
          i32.const 272
          call 9
          local.get 9
          i32.const 64
          i32.add
          i32.const 8
          i32.or
          local.get 5
          i32.const 8
          call 11
          drop
          local.get 0
          local.get 9
          i32.const 8
          i32.add
          i32.const 8
          i32.add
          i64.load
          i64.const 3607749779137757184
          local.get 3
          local.get 8
          i64.load
          i64.const 8
          i64.shr_u
          local.tee 1
          local.get 9
          i32.const 64
          i32.add
          i32.const 16
          call 7
          local.tee 2
          i32.store offset=20
          block  ;; label = @4
            local.get 1
            local.get 9
            i32.const 8
            i32.add
            i32.const 16
            i32.add
            local.tee 7
            i64.load
            i64.lt_u
            br_if 0 (;@4;)
            local.get 7
            local.get 1
            i64.const 1
            i64.add
            i64.store
          end
          local.get 9
          local.get 0
          i32.store offset=56
          local.get 9
          local.get 8
          i64.load
          i64.const 8
          i64.shr_u
          local.tee 1
          i64.store offset=64
          local.get 9
          local.get 2
          i32.store offset=52
          block  ;; label = @4
            block  ;; label = @5
              local.get 9
              i32.const 36
              i32.add
              local.tee 7
              i32.load
              local.tee 8
              local.get 9
              i32.const 40
              i32.add
              i32.load
              i32.ge_u
              br_if 0 (;@5;)
              local.get 8
              local.get 1
              i64.store offset=8
              local.get 8
              local.get 2
              i32.store offset=16
              local.get 9
              i32.const 0
              i32.store offset=56
              local.get 8
              local.get 0
              i32.store
              local.get 7
              local.get 8
              i32.const 24
              i32.add
              i32.store
              br 1 (;@4;)
            end
            local.get 9
            i32.const 32
            i32.add
            local.get 9
            i32.const 56
            i32.add
            local.get 9
            i32.const 64
            i32.add
            local.get 9
            i32.const 52
            i32.add
            call 38
          end
          local.get 9
          i32.load offset=56
          local.set 8
          local.get 9
          i32.const 0
          i32.store offset=56
          local.get 8
          i32.eqz
          br_if 0 (;@3;)
          local.get 8
          call 54
        end
        local.get 9
        i32.load offset=32
        local.tee 2
        i32.eqz
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 9
          i32.const 36
          i32.add
          local.tee 7
          i32.load
          local.tee 8
          local.get 2
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 8
            i32.const -24
            i32.add
            local.tee 8
            i32.load
            local.set 0
            local.get 8
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 0
              i32.eqz
              br_if 0 (;@5;)
              local.get 0
              call 54
            end
            local.get 2
            local.get 8
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 9
          i32.const 32
          i32.add
          i32.load
          local.set 8
          br 1 (;@2;)
        end
        local.get 2
        local.set 8
      end
      local.get 7
      local.get 2
      i32.store
      local.get 8
      call 54
    end
    i32.const 0
    local.get 9
    i32.const 80
    i32.add
    i32.store offset=4)
  (func (;30;) (type 18) (param i64 i64 i32 i32)
    (local i32 i32 i32 i32 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 96
    i32.sub
    local.tee 9
    i32.store offset=4
    local.get 9
    i32.const 0
    i32.store offset=16
    local.get 9
    i64.const 0
    i64.store offset=8
    i32.const 0
    local.set 6
    i32.const 0
    local.set 7
    i32.const 0
    local.set 8
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.load offset=4
        local.get 2
        i32.load
        i32.sub
        local.tee 4
        i32.const 4
        i32.shr_s
        local.tee 5
        i32.eqz
        br_if 0 (;@2;)
        local.get 5
        i32.const 268435456
        i32.ge_u
        br_if 1 (;@1;)
        local.get 9
        i32.const 16
        i32.add
        local.get 4
        call 53
        local.tee 8
        local.get 5
        i32.const 4
        i32.shl
        i32.add
        local.tee 6
        i32.store
        local.get 9
        local.get 8
        i32.store offset=8
        local.get 9
        local.get 8
        i32.store offset=12
        block  ;; label = @3
          local.get 2
          i32.const 4
          i32.add
          i32.load
          local.get 2
          i32.load
          local.tee 7
          i32.sub
          local.tee 2
          i32.const 1
          i32.lt_s
          br_if 0 (;@3;)
          local.get 8
          local.get 7
          local.get 2
          call 11
          drop
          local.get 9
          local.get 8
          local.get 2
          i32.add
          local.tee 7
          i32.store offset=12
          br 1 (;@2;)
        end
        local.get 8
        local.set 7
      end
      local.get 9
      i32.const 44
      i32.add
      local.get 7
      i32.store
      local.get 9
      local.get 1
      i64.store offset=32
      local.get 9
      i32.const 16
      i32.add
      i32.const 0
      i32.store
      local.get 9
      i32.const 48
      i32.add
      local.get 6
      i32.store
      local.get 9
      local.get 0
      i64.store offset=24
      local.get 9
      local.get 8
      i32.store offset=40
      local.get 9
      i64.const 0
      i64.store offset=8
      local.get 9
      i32.const 0
      i32.store offset=52
      local.get 9
      i32.const 24
      i32.add
      i32.const 32
      i32.add
      i32.const 0
      i32.store
      local.get 9
      i32.const 24
      i32.add
      i32.const 36
      i32.add
      i32.const 0
      i32.store
      local.get 3
      i32.const 36
      i32.add
      i32.load
      local.get 3
      i32.load8_u offset=32
      local.tee 8
      i32.const 1
      i32.shr_u
      local.get 8
      i32.const 1
      i32.and
      select
      local.tee 2
      i32.const 32
      i32.add
      local.set 8
      local.get 2
      i64.extend_i32_u
      local.set 0
      local.get 9
      i32.const 52
      i32.add
      local.set 2
      loop  ;; label = @2
        local.get 8
        i32.const 1
        i32.add
        local.set 8
        local.get 0
        i64.const 7
        i64.shr_u
        local.tee 0
        i64.const 0
        i64.ne
        br_if 0 (;@2;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 8
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          local.get 8
          call 31
          local.get 9
          i32.const 56
          i32.add
          i32.load
          local.set 2
          local.get 9
          i32.const 52
          i32.add
          i32.load
          local.set 8
          br 1 (;@2;)
        end
        i32.const 0
        local.set 2
        i32.const 0
        local.set 8
      end
      local.get 9
      local.get 8
      i32.store offset=84
      local.get 9
      local.get 8
      i32.store offset=80
      local.get 9
      local.get 2
      i32.store offset=88
      local.get 9
      local.get 9
      i32.const 80
      i32.add
      i32.store offset=64
      local.get 9
      local.get 3
      i32.store offset=72
      local.get 9
      i32.const 72
      i32.add
      local.get 9
      i32.const 64
      i32.add
      call 32
      local.get 9
      i32.const 80
      i32.add
      local.get 9
      i32.const 24
      i32.add
      call 33
      local.get 9
      i32.load offset=80
      local.tee 8
      local.get 9
      i32.load offset=84
      local.get 8
      i32.sub
      call 16
      block  ;; label = @2
        local.get 9
        i32.load offset=80
        local.tee 8
        i32.eqz
        br_if 0 (;@2;)
        local.get 9
        local.get 8
        i32.store offset=84
        local.get 8
        call 54
      end
      block  ;; label = @2
        local.get 9
        i32.load offset=52
        local.tee 8
        i32.eqz
        br_if 0 (;@2;)
        local.get 9
        i32.const 56
        i32.add
        local.get 8
        i32.store
        local.get 8
        call 54
      end
      block  ;; label = @2
        local.get 9
        i32.load offset=40
        local.tee 8
        i32.eqz
        br_if 0 (;@2;)
        local.get 9
        i32.const 44
        i32.add
        local.get 8
        i32.store
        local.get 8
        call 54
      end
      block  ;; label = @2
        local.get 9
        i32.load offset=8
        local.tee 8
        i32.eqz
        br_if 0 (;@2;)
        local.get 9
        local.get 8
        i32.store offset=12
        local.get 8
        call 54
      end
      i32.const 0
      local.get 9
      i32.const 96
      i32.add
      i32.store offset=4
      return
    end
    local.get 9
    i32.const 8
    i32.add
    call 57
    unreachable)
  (func (;31;) (type 7) (param i32 i32)
    (local i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.load offset=8
              local.tee 2
              local.get 0
              i32.load offset=4
              local.tee 6
              i32.sub
              local.get 1
              i32.ge_u
              br_if 0 (;@5;)
              local.get 6
              local.get 0
              i32.load
              local.tee 5
              i32.sub
              local.tee 3
              local.get 1
              i32.add
              local.tee 4
              i32.const -1
              i32.le_s
              br_if 2 (;@3;)
              i32.const 2147483647
              local.set 6
              block  ;; label = @6
                local.get 2
                local.get 5
                i32.sub
                local.tee 2
                i32.const 1073741822
                i32.gt_u
                br_if 0 (;@6;)
                local.get 4
                local.get 2
                i32.const 1
                i32.shl
                local.tee 6
                local.get 6
                local.get 4
                i32.lt_u
                select
                local.tee 6
                i32.eqz
                br_if 2 (;@4;)
              end
              local.get 6
              call 53
              local.set 2
              br 3 (;@2;)
            end
            local.get 0
            i32.const 4
            i32.add
            local.set 0
            loop  ;; label = @5
              local.get 6
              i32.const 0
              i32.store8
              local.get 0
              local.get 0
              i32.load
              i32.const 1
              i32.add
              local.tee 6
              i32.store
              local.get 1
              i32.const -1
              i32.add
              local.tee 1
              br_if 0 (;@5;)
              br 4 (;@1;)
            end
          end
          i32.const 0
          local.set 6
          i32.const 0
          local.set 2
          br 1 (;@2;)
        end
        local.get 0
        call 57
        unreachable
      end
      local.get 2
      local.get 6
      i32.add
      local.set 4
      local.get 2
      local.get 3
      i32.add
      local.tee 5
      local.set 6
      loop  ;; label = @2
        local.get 6
        i32.const 0
        i32.store8
        local.get 6
        i32.const 1
        i32.add
        local.set 6
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        br_if 0 (;@2;)
      end
      local.get 5
      local.get 0
      i32.const 4
      i32.add
      local.tee 3
      i32.load
      local.get 0
      i32.load
      local.tee 1
      i32.sub
      local.tee 2
      i32.sub
      local.set 5
      block  ;; label = @2
        local.get 2
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 5
        local.get 1
        local.get 2
        call 11
        drop
        local.get 0
        i32.load
        local.set 1
      end
      local.get 0
      local.get 5
      i32.store
      local.get 3
      local.get 6
      i32.store
      local.get 0
      i32.const 8
      i32.add
      local.get 4
      i32.store
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      call 54
      return
    end)
  (func (;32;) (type 7) (param i32 i32)
    (local i32 i32)
    local.get 0
    i32.load
    local.set 2
    local.get 1
    i32.load
    local.tee 3
    i32.load offset=8
    local.get 3
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 3
    i32.load offset=4
    local.get 2
    i32.const 8
    call 11
    drop
    local.get 3
    local.get 3
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load
    local.set 0
    local.get 1
    i32.load
    local.tee 3
    i32.load offset=8
    local.get 3
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 3
    i32.load offset=4
    local.get 0
    i32.const 8
    i32.add
    i32.const 8
    call 11
    drop
    local.get 3
    local.get 3
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.tee 3
    i32.load offset=8
    local.get 3
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 3
    i32.load offset=4
    local.get 0
    i32.const 16
    i32.add
    i32.const 8
    call 11
    drop
    local.get 3
    local.get 3
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 2
    i32.store offset=4
    local.get 3
    i32.load offset=8
    local.get 2
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 3
    i32.load offset=4
    local.get 0
    i32.const 24
    i32.add
    i32.const 8
    call 11
    drop
    local.get 3
    local.get 3
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.get 0
    i32.const 32
    i32.add
    call 36
    drop)
  (func (;33;) (type 7) (param i32 i32)
    (local i32 i32 i32 i32 i64 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    local.tee 8
    i32.store offset=4
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    i64.const 0
    i64.store align=4
    i32.const 16
    local.set 5
    local.get 1
    i32.const 16
    i32.add
    local.set 2
    local.get 1
    i32.const 20
    i32.add
    i32.load
    local.tee 7
    local.get 1
    i32.load offset=16
    local.tee 3
    i32.sub
    local.tee 4
    i32.const 4
    i32.shr_s
    i64.extend_i32_u
    local.set 6
    loop  ;; label = @1
      local.get 5
      i32.const 1
      i32.add
      local.set 5
      local.get 6
      i64.const 7
      i64.shr_u
      local.tee 6
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      local.get 3
      local.get 7
      i32.eq
      br_if 0 (;@1;)
      local.get 4
      i32.const -16
      i32.and
      local.get 5
      i32.add
      local.set 5
    end
    local.get 1
    i32.load offset=28
    local.tee 7
    local.get 5
    i32.sub
    local.get 1
    i32.const 32
    i32.add
    i32.load
    local.tee 3
    i32.sub
    local.set 5
    local.get 1
    i32.const 28
    i32.add
    local.set 4
    local.get 3
    local.get 7
    i32.sub
    i64.extend_i32_u
    local.set 6
    loop  ;; label = @1
      local.get 5
      i32.const -1
      i32.add
      local.set 5
      local.get 6
      i64.const 7
      i64.shr_u
      local.tee 6
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
    end
    i32.const 0
    local.set 7
    block  ;; label = @1
      block  ;; label = @2
        local.get 5
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 0
        local.get 5
        i32.sub
        call 31
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 7
        local.get 0
        i32.load
        local.set 5
        br 1 (;@1;)
      end
      i32.const 0
      local.set 5
    end
    local.get 8
    local.get 5
    i32.store
    local.get 8
    local.get 7
    i32.store offset=8
    local.get 7
    local.get 5
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 5
    local.get 1
    i32.const 8
    call 11
    drop
    local.get 7
    local.get 5
    i32.const 8
    i32.add
    local.tee 0
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 272
    call 9
    local.get 0
    local.get 1
    i32.const 8
    i32.add
    i32.const 8
    call 11
    drop
    local.get 8
    local.get 5
    i32.const 16
    i32.add
    i32.store offset=4
    local.get 8
    local.get 2
    call 34
    local.get 4
    call 35
    drop
    i32.const 0
    local.get 8
    i32.const 16
    i32.add
    i32.store offset=4)
  (func (;34;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i64 i32 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    local.tee 7
    i32.store offset=4
    local.get 1
    i32.load offset=4
    local.get 1
    i32.load
    i32.sub
    i32.const 4
    i32.shr_s
    i64.extend_i32_u
    local.set 4
    local.get 0
    i32.load offset=4
    local.set 5
    local.get 0
    i32.const 8
    i32.add
    local.set 2
    loop  ;; label = @1
      local.get 4
      i32.wrap_i64
      local.set 3
      local.get 7
      local.get 4
      i64.const 7
      i64.shr_u
      local.tee 4
      i64.const 0
      i64.ne
      local.tee 6
      i32.const 7
      i32.shl
      local.get 3
      i32.const 127
      i32.and
      i32.or
      i32.store8 offset=15
      local.get 2
      i32.load
      local.get 5
      i32.sub
      i32.const 0
      i32.gt_s
      i32.const 272
      call 9
      local.get 0
      i32.const 4
      i32.add
      local.tee 3
      i32.load
      local.get 7
      i32.const 15
      i32.add
      i32.const 1
      call 11
      drop
      local.get 3
      local.get 3
      i32.load
      i32.const 1
      i32.add
      local.tee 5
      i32.store
      local.get 6
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      local.get 1
      i32.load
      local.tee 6
      local.get 1
      i32.const 4
      i32.add
      i32.load
      local.tee 1
      i32.eq
      br_if 0 (;@1;)
      local.get 0
      i32.const 4
      i32.add
      local.set 3
      loop  ;; label = @2
        local.get 0
        i32.const 8
        i32.add
        local.tee 2
        i32.load
        local.get 5
        i32.sub
        i32.const 7
        i32.gt_s
        i32.const 272
        call 9
        local.get 3
        i32.load
        local.get 6
        i32.const 8
        call 11
        drop
        local.get 3
        local.get 3
        i32.load
        i32.const 8
        i32.add
        local.tee 5
        i32.store
        local.get 2
        i32.load
        local.get 5
        i32.sub
        i32.const 7
        i32.gt_s
        i32.const 272
        call 9
        local.get 3
        i32.load
        local.get 6
        i32.const 8
        i32.add
        i32.const 8
        call 11
        drop
        local.get 3
        local.get 3
        i32.load
        i32.const 8
        i32.add
        local.tee 5
        i32.store
        local.get 6
        i32.const 16
        i32.add
        local.tee 6
        local.get 1
        i32.ne
        br_if 0 (;@2;)
      end
    end
    i32.const 0
    local.get 7
    i32.const 16
    i32.add
    i32.store offset=4
    local.get 0)
  (func (;35;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i64 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    local.tee 8
    i32.store offset=4
    local.get 1
    i32.load offset=4
    local.get 1
    i32.load
    i32.sub
    i64.extend_i32_u
    local.set 7
    local.get 0
    i32.load offset=4
    local.set 6
    local.get 0
    i32.const 8
    i32.add
    local.set 4
    local.get 0
    i32.const 4
    i32.add
    local.set 5
    loop  ;; label = @1
      local.get 7
      i32.wrap_i64
      local.set 2
      local.get 8
      local.get 7
      i64.const 7
      i64.shr_u
      local.tee 7
      i64.const 0
      i64.ne
      local.tee 3
      i32.const 7
      i32.shl
      local.get 2
      i32.const 127
      i32.and
      i32.or
      i32.store8 offset=15
      local.get 4
      i32.load
      local.get 6
      i32.sub
      i32.const 0
      i32.gt_s
      i32.const 272
      call 9
      local.get 5
      i32.load
      local.get 8
      i32.const 15
      i32.add
      i32.const 1
      call 11
      drop
      local.get 5
      local.get 5
      i32.load
      i32.const 1
      i32.add
      local.tee 6
      i32.store
      local.get 3
      br_if 0 (;@1;)
    end
    local.get 0
    i32.const 8
    i32.add
    i32.load
    local.get 6
    i32.sub
    local.get 1
    i32.const 4
    i32.add
    i32.load
    local.get 1
    i32.load
    local.tee 2
    i32.sub
    local.tee 5
    i32.ge_s
    i32.const 272
    call 9
    local.get 0
    i32.const 4
    i32.add
    local.tee 6
    i32.load
    local.get 2
    local.get 5
    call 11
    drop
    local.get 6
    local.get 6
    i32.load
    local.get 5
    i32.add
    i32.store
    i32.const 0
    local.get 8
    i32.const 16
    i32.add
    i32.store offset=4
    local.get 0)
  (func (;36;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i64 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    local.tee 8
    i32.store offset=4
    local.get 1
    i32.load offset=4
    local.get 1
    i32.load8_u
    local.tee 5
    i32.const 1
    i32.shr_u
    local.get 5
    i32.const 1
    i32.and
    select
    i64.extend_i32_u
    local.set 7
    local.get 0
    i32.load offset=4
    local.set 6
    local.get 0
    i32.const 8
    i32.add
    local.set 4
    local.get 0
    i32.const 4
    i32.add
    local.set 5
    loop  ;; label = @1
      local.get 7
      i32.wrap_i64
      local.set 2
      local.get 8
      local.get 7
      i64.const 7
      i64.shr_u
      local.tee 7
      i64.const 0
      i64.ne
      local.tee 3
      i32.const 7
      i32.shl
      local.get 2
      i32.const 127
      i32.and
      i32.or
      i32.store8 offset=15
      local.get 4
      i32.load
      local.get 6
      i32.sub
      i32.const 0
      i32.gt_s
      i32.const 272
      call 9
      local.get 5
      i32.load
      local.get 8
      i32.const 15
      i32.add
      i32.const 1
      call 11
      drop
      local.get 5
      local.get 5
      i32.load
      i32.const 1
      i32.add
      local.tee 6
      i32.store
      local.get 3
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      local.get 1
      i32.const 4
      i32.add
      i32.load
      local.get 1
      i32.load8_u
      local.tee 5
      i32.const 1
      i32.shr_u
      local.get 5
      i32.const 1
      i32.and
      local.tee 2
      select
      local.tee 5
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.load offset=8
      local.set 3
      local.get 0
      i32.const 8
      i32.add
      i32.load
      local.get 6
      i32.sub
      local.get 5
      i32.ge_s
      i32.const 272
      call 9
      local.get 0
      i32.const 4
      i32.add
      local.tee 6
      i32.load
      local.get 3
      local.get 1
      i32.const 1
      i32.add
      local.get 2
      select
      local.get 5
      call 11
      drop
      local.get 6
      local.get 6
      i32.load
      local.get 5
      i32.add
      i32.store
    end
    i32.const 0
    local.get 8
    i32.const 16
    i32.add
    i32.store offset=4
    local.get 0)
  (func (;37;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i64 i32 i32)
    i32.const 0
    i32.load offset=4
    i32.const 32
    i32.sub
    local.tee 10
    local.set 9
    i32.const 0
    local.get 10
    i32.store offset=4
    block  ;; label = @1
      local.get 0
      i32.const 28
      i32.add
      i32.load
      local.tee 7
      local.get 0
      i32.load offset=24
      local.tee 3
      i32.eq
      br_if 0 (;@1;)
      i32.const 0
      local.get 3
      i32.sub
      local.set 4
      local.get 7
      i32.const -24
      i32.add
      local.set 6
      loop  ;; label = @2
        local.get 6
        i32.const 16
        i32.add
        i32.load
        local.get 1
        i32.eq
        br_if 1 (;@1;)
        local.get 6
        local.set 7
        local.get 6
        i32.const -24
        i32.add
        local.tee 5
        local.set 6
        local.get 5
        local.get 4
        i32.add
        i32.const -24
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 7
        local.get 3
        i32.eq
        br_if 0 (;@2;)
        local.get 7
        i32.const -24
        i32.add
        i32.load
        local.set 5
        br 1 (;@1;)
      end
      local.get 1
      i32.const 0
      i32.const 0
      call 5
      local.tee 7
      i32.const 31
      i32.shr_u
      i32.const 1
      i32.xor
      i32.const 352
      call 9
      block  ;; label = @2
        block  ;; label = @3
          local.get 7
          i32.const 512
          i32.le_u
          br_if 0 (;@3;)
          local.get 1
          local.get 7
          call 60
          local.tee 3
          local.get 7
          call 5
          drop
          local.get 3
          call 63
          br 1 (;@2;)
        end
        i32.const 0
        local.get 10
        local.get 7
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        local.tee 3
        i32.store offset=4
        local.get 1
        local.get 3
        local.get 7
        call 5
        drop
      end
      local.get 0
      i32.const 24
      i32.add
      local.set 2
      i32.const 32
      call 53
      local.tee 5
      i64.const 1398362884
      i64.store offset=8
      local.get 5
      i64.const 0
      i64.store
      i32.const 1
      i32.const 288
      call 9
      local.get 5
      i32.const 8
      i32.add
      local.set 10
      i64.const 5462355
      local.set 8
      i32.const 0
      local.set 6
      block  ;; label = @2
        block  ;; label = @3
          loop  ;; label = @4
            local.get 8
            i32.wrap_i64
            i32.const 24
            i32.shl
            i32.const -1073741825
            i32.add
            i32.const 452984830
            i32.gt_u
            br_if 1 (;@3;)
            block  ;; label = @5
              local.get 8
              i64.const 8
              i64.shr_u
              local.tee 8
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 0 (;@5;)
              loop  ;; label = @6
                local.get 8
                i64.const 8
                i64.shr_u
                local.tee 8
                i64.const 255
                i64.and
                i64.const 0
                i64.ne
                br_if 3 (;@3;)
                local.get 6
                i32.const 1
                i32.add
                local.tee 6
                i32.const 7
                i32.lt_s
                br_if 0 (;@6;)
              end
            end
            i32.const 1
            local.set 4
            local.get 6
            i32.const 1
            i32.add
            local.tee 6
            i32.const 7
            i32.lt_s
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        i32.const 0
        local.set 4
      end
      local.get 4
      i32.const 16
      call 9
      local.get 5
      local.get 0
      i32.store offset=16
      local.get 7
      i32.const 7
      i32.gt_u
      i32.const 384
      call 9
      local.get 5
      local.get 3
      i32.const 8
      call 11
      drop
      local.get 7
      i32.const -8
      i32.and
      i32.const 8
      i32.ne
      i32.const 384
      call 9
      local.get 10
      local.get 3
      i32.const 8
      i32.add
      i32.const 8
      call 11
      drop
      local.get 5
      local.get 1
      i32.store offset=20
      local.get 9
      local.get 5
      i32.store offset=24
      local.get 9
      local.get 5
      i32.const 8
      i32.add
      i64.load
      i64.const 8
      i64.shr_u
      local.tee 8
      i64.store offset=16
      local.get 9
      local.get 5
      i32.load offset=20
      local.tee 7
      i32.store offset=12
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 28
          i32.add
          local.tee 1
          i32.load
          local.tee 6
          local.get 0
          i32.const 32
          i32.add
          i32.load
          i32.ge_u
          br_if 0 (;@3;)
          local.get 6
          local.get 8
          i64.store offset=8
          local.get 6
          local.get 7
          i32.store offset=16
          local.get 9
          i32.const 0
          i32.store offset=24
          local.get 6
          local.get 5
          i32.store
          local.get 1
          local.get 6
          i32.const 24
          i32.add
          i32.store
          br 1 (;@2;)
        end
        local.get 2
        local.get 9
        i32.const 24
        i32.add
        local.get 9
        i32.const 16
        i32.add
        local.get 9
        i32.const 12
        i32.add
        call 38
      end
      local.get 9
      i32.load offset=24
      local.set 6
      local.get 9
      i32.const 0
      i32.store offset=24
      local.get 6
      i32.eqz
      br_if 0 (;@1;)
      local.get 6
      call 54
    end
    i32.const 0
    local.get 9
    i32.const 32
    i32.add
    i32.store offset=4
    local.get 5)
  (func (;38;) (type 16) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 6
        i32.sub
        i32.const 24
        i32.div_s
        local.tee 4
        i32.const 1
        i32.add
        local.tee 5
        i32.const 178956971
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 178956970
        local.set 7
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load offset=8
            local.get 6
            i32.sub
            i32.const 24
            i32.div_s
            local.tee 6
            i32.const 89478484
            i32.gt_u
            br_if 0 (;@4;)
            local.get 5
            local.get 6
            i32.const 1
            i32.shl
            local.tee 7
            local.get 7
            local.get 5
            i32.lt_u
            select
            local.tee 7
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 7
          i32.const 24
          i32.mul
          call 53
          local.set 6
          br 2 (;@1;)
        end
        i32.const 0
        local.set 7
        i32.const 0
        local.set 6
        br 1 (;@1;)
      end
      local.get 0
      call 57
      unreachable
    end
    local.get 1
    i32.load
    local.set 5
    local.get 1
    i32.const 0
    i32.store
    local.get 6
    local.get 4
    i32.const 24
    i32.mul
    i32.add
    local.tee 1
    local.get 5
    i32.store
    local.get 1
    local.get 2
    i64.load
    i64.store offset=8
    local.get 1
    local.get 3
    i32.load
    i32.store offset=16
    local.get 6
    local.get 7
    i32.const 24
    i32.mul
    i32.add
    local.set 4
    local.get 1
    i32.const 24
    i32.add
    local.set 5
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.tee 6
        local.get 0
        i32.load
        local.tee 7
        i32.eq
        br_if 0 (;@2;)
        loop  ;; label = @3
          local.get 6
          i32.const -24
          i32.add
          local.tee 2
          i32.load
          local.set 3
          local.get 2
          i32.const 0
          i32.store
          local.get 1
          i32.const -24
          i32.add
          local.get 3
          i32.store
          local.get 1
          i32.const -8
          i32.add
          local.get 6
          i32.const -8
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const -12
          i32.add
          local.get 6
          i32.const -12
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const -16
          i32.add
          local.get 6
          i32.const -16
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const -24
          i32.add
          local.set 1
          local.get 2
          local.set 6
          local.get 7
          local.get 2
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 7
        local.get 0
        i32.load
        local.set 6
        br 1 (;@1;)
      end
      local.get 7
      local.set 6
    end
    local.get 0
    local.get 1
    i32.store
    local.get 0
    i32.const 4
    i32.add
    local.get 5
    i32.store
    local.get 0
    i32.const 8
    i32.add
    local.get 4
    i32.store
    block  ;; label = @1
      local.get 7
      local.get 6
      i32.eq
      br_if 0 (;@1;)
      loop  ;; label = @2
        local.get 7
        i32.const -24
        i32.add
        local.tee 7
        i32.load
        local.set 1
        local.get 7
        i32.const 0
        i32.store
        block  ;; label = @3
          local.get 1
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          call 54
        end
        local.get 6
        local.get 7
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 6
      i32.eqz
      br_if 0 (;@1;)
      local.get 6
      call 54
    end)
  (func (;39;) (type 1) (param i32 i64 i64 i32 i32)
    (local i64 i32 i64 i32 i64 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 112
    i32.sub
    local.tee 11
    i32.store offset=4
    local.get 1
    local.get 2
    i64.ne
    i32.const 992
    call 9
    local.get 1
    call 13
    local.get 2
    call 10
    i32.const 1024
    call 9
    local.get 3
    i64.load offset=8
    local.set 5
    i32.const 0
    local.set 8
    local.get 11
    i32.const 104
    i32.add
    i32.const 0
    i32.store
    local.get 11
    local.get 5
    i64.const 8
    i64.shr_u
    local.tee 9
    i64.store offset=80
    local.get 11
    i64.const -1
    i64.store offset=88
    local.get 11
    i64.const 0
    i64.store offset=96
    local.get 11
    local.get 0
    i64.load
    i64.store offset=72
    local.get 11
    i32.const 72
    i32.add
    local.get 9
    i32.const 1056
    call 40
    local.set 6
    local.get 1
    call 15
    local.get 2
    call 15
    block  ;; label = @1
      local.get 3
      i64.load
      local.tee 7
      i64.const 4611686018427387903
      i64.add
      i64.const 9223372036854775806
      i64.gt_u
      br_if 0 (;@1;)
      i32.const 0
      local.set 10
      block  ;; label = @2
        loop  ;; label = @3
          local.get 9
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 9
            i64.const 8
            i64.shr_u
            local.tee 9
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 9
              i64.const 8
              i64.shr_u
              local.tee 9
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 10
              i32.const 1
              i32.add
              local.tee 10
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 8
          local.get 10
          i32.const 1
          i32.add
          local.tee 10
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 8
    end
    local.get 8
    i32.const 496
    call 9
    local.get 7
    i64.const 0
    i64.gt_s
    i32.const 1088
    call 9
    local.get 5
    local.get 6
    i64.load offset=8
    i64.eq
    i32.const 560
    call 9
    block  ;; label = @1
      block  ;; label = @2
        local.get 4
        i32.load8_u
        local.tee 10
        i32.const 1
        i32.and
        br_if 0 (;@2;)
        local.get 10
        i32.const 1
        i32.shr_u
        local.set 10
        br 1 (;@1;)
      end
      local.get 4
      i32.load offset=4
      local.set 10
    end
    local.get 10
    i32.const 257
    i32.lt_u
    i32.const 400
    call 9
    local.get 11
    i32.const 56
    i32.add
    i32.const 8
    i32.add
    local.tee 10
    local.get 3
    i32.const 8
    i32.add
    local.tee 8
    i64.load
    i64.store
    local.get 3
    i64.load
    local.set 9
    local.get 11
    i32.const 24
    i32.add
    i32.const 12
    i32.add
    local.get 11
    i32.const 56
    i32.add
    i32.const 12
    i32.add
    i32.load
    i32.store
    local.get 11
    i32.const 24
    i32.add
    i32.const 8
    i32.add
    local.get 10
    i32.load
    i32.store
    local.get 11
    local.get 9
    i64.store offset=56
    local.get 11
    local.get 11
    i32.load offset=60
    i32.store offset=28
    local.get 11
    local.get 11
    i32.load offset=56
    i32.store offset=24
    local.get 0
    local.get 1
    local.get 11
    i32.const 24
    i32.add
    call 41
    local.get 11
    i32.const 40
    i32.add
    i32.const 8
    i32.add
    local.tee 10
    local.get 8
    i64.load
    i64.store
    local.get 3
    i64.load
    local.set 9
    local.get 11
    i32.const 8
    i32.add
    i32.const 12
    i32.add
    local.get 11
    i32.const 40
    i32.add
    i32.const 12
    i32.add
    i32.load
    i32.store
    local.get 11
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get 10
    i32.load
    i32.store
    local.get 11
    local.get 9
    i64.store offset=40
    local.get 11
    local.get 11
    i32.load offset=44
    i32.store offset=12
    local.get 11
    local.get 11
    i32.load offset=40
    i32.store offset=8
    local.get 0
    local.get 2
    local.get 11
    i32.const 8
    i32.add
    local.get 1
    call 29
    block  ;; label = @1
      local.get 11
      i32.load offset=96
      local.tee 8
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 11
          i32.const 100
          i32.add
          local.tee 0
          i32.load
          local.tee 10
          local.get 8
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 10
            i32.const -24
            i32.add
            local.tee 10
            i32.load
            local.set 3
            local.get 10
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 3
              i32.eqz
              br_if 0 (;@5;)
              local.get 3
              call 54
            end
            local.get 8
            local.get 10
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 11
          i32.const 96
          i32.add
          i32.load
          local.set 10
          br 1 (;@2;)
        end
        local.get 8
        local.set 10
      end
      local.get 0
      local.get 8
      i32.store
      local.get 10
      call 54
    end
    i32.const 0
    local.get 11
    i32.const 112
    i32.add
    i32.store offset=4)
  (func (;40;) (type 19) (param i32 i64 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 28
      i32.add
      i32.load
      local.tee 7
      local.get 0
      i32.load offset=24
      local.tee 3
      i32.eq
      br_if 0 (;@1;)
      local.get 7
      i32.const -24
      i32.add
      local.set 6
      i32.const 0
      local.get 3
      i32.sub
      local.set 4
      loop  ;; label = @2
        local.get 6
        i32.load
        i64.load offset=8
        i64.const 8
        i64.shr_u
        local.get 1
        i64.eq
        br_if 1 (;@1;)
        local.get 6
        local.set 7
        local.get 6
        i32.const -24
        i32.add
        local.tee 5
        local.set 6
        local.get 5
        local.get 4
        i32.add
        i32.const -24
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 7
        local.get 3
        i32.eq
        br_if 0 (;@2;)
        local.get 7
        i32.const -24
        i32.add
        i32.load
        local.tee 6
        i32.load offset=40
        local.get 0
        i32.eq
        i32.const 96
        call 9
        br 1 (;@1;)
      end
      i32.const 0
      local.set 6
      local.get 0
      i64.load
      local.get 0
      i64.load offset=8
      i64.const -4157508551318700032
      local.get 1
      call 4
      local.tee 5
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      local.get 5
      call 23
      local.tee 6
      i32.load offset=40
      local.get 0
      i32.eq
      i32.const 96
      call 9
    end
    local.get 6
    i32.const 0
    i32.ne
    local.get 2
    call 9
    local.get 6)
  (func (;41;) (type 0) (param i32 i64 i32)
    (local i64 i64 i32 i64 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 64
    i32.sub
    local.tee 8
    i32.store offset=4
    local.get 8
    i32.const 40
    i32.add
    i32.const 0
    i32.store
    local.get 8
    local.get 1
    i64.store offset=16
    local.get 8
    i64.const -1
    i64.store offset=24
    local.get 8
    i64.const 0
    i64.store offset=32
    local.get 8
    local.get 0
    i64.load
    i64.store offset=8
    local.get 8
    i32.const 8
    i32.add
    local.get 2
    i64.load offset=8
    local.tee 3
    i64.const 8
    i64.shr_u
    i32.const 1120
    call 42
    local.tee 0
    i64.load
    local.get 2
    i64.load
    local.tee 4
    i64.ge_s
    i32.const 1152
    call 9
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          local.get 0
          i64.load
          i64.ne
          br_if 0 (;@3;)
          local.get 8
          i32.const 8
          i32.add
          local.get 0
          call 43
          local.get 8
          i32.load offset=32
          local.tee 5
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        local.get 0
        i32.load offset=16
        local.get 8
        i32.const 8
        i32.add
        i32.eq
        i32.const 640
        call 9
        local.get 8
        i64.load offset=8
        call 2
        i64.eq
        i32.const 688
        call 9
        local.get 3
        local.get 0
        i64.load offset=8
        local.tee 6
        i64.eq
        i32.const 1184
        call 9
        local.get 0
        local.get 0
        i64.load
        local.get 4
        i64.sub
        local.tee 4
        i64.store
        local.get 4
        i64.const -4611686018427387904
        i64.gt_s
        i32.const 1232
        call 9
        local.get 0
        i64.load
        i64.const 4611686018427387904
        i64.lt_s
        i32.const 1264
        call 9
        local.get 6
        i64.const 8
        i64.shr_u
        local.tee 4
        local.get 0
        i64.load offset=8
        i64.const 8
        i64.shr_u
        i64.eq
        i32.const 864
        call 9
        i32.const 1
        i32.const 272
        call 9
        local.get 8
        i32.const 48
        i32.add
        local.get 0
        i32.const 8
        call 11
        drop
        i32.const 1
        i32.const 272
        call 9
        local.get 8
        i32.const 48
        i32.add
        i32.const 8
        i32.or
        local.get 0
        i32.const 8
        i32.add
        i32.const 8
        call 11
        drop
        local.get 0
        i32.load offset=20
        local.get 1
        local.get 8
        i32.const 48
        i32.add
        i32.const 16
        call 8
        block  ;; label = @3
          local.get 4
          local.get 8
          i32.const 8
          i32.add
          i32.const 16
          i32.add
          local.tee 0
          i64.load
          i64.lt_u
          br_if 0 (;@3;)
          local.get 0
          local.get 4
          i64.const 1
          i64.add
          i64.store
        end
        local.get 8
        i32.load offset=32
        local.tee 5
        i32.eqz
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 8
          i32.const 36
          i32.add
          local.tee 7
          i32.load
          local.tee 0
          local.get 5
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 0
            i32.const -24
            i32.add
            local.tee 0
            i32.load
            local.set 2
            local.get 0
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 2
              i32.eqz
              br_if 0 (;@5;)
              local.get 2
              call 54
            end
            local.get 5
            local.get 0
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 8
          i32.const 32
          i32.add
          i32.load
          local.set 0
          br 1 (;@2;)
        end
        local.get 5
        local.set 0
      end
      local.get 7
      local.get 5
      i32.store
      local.get 0
      call 54
    end
    i32.const 0
    local.get 8
    i32.const 64
    i32.add
    i32.store offset=4)
  (func (;42;) (type 19) (param i32 i64 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 28
      i32.add
      i32.load
      local.tee 7
      local.get 0
      i32.load offset=24
      local.tee 3
      i32.eq
      br_if 0 (;@1;)
      local.get 7
      i32.const -24
      i32.add
      local.set 6
      i32.const 0
      local.get 3
      i32.sub
      local.set 4
      loop  ;; label = @2
        local.get 6
        i32.load
        i64.load offset=8
        i64.const 8
        i64.shr_u
        local.get 1
        i64.eq
        br_if 1 (;@1;)
        local.get 6
        local.set 7
        local.get 6
        i32.const -24
        i32.add
        local.tee 5
        local.set 6
        local.get 5
        local.get 4
        i32.add
        i32.const -24
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 7
        local.get 3
        i32.eq
        br_if 0 (;@2;)
        local.get 7
        i32.const -24
        i32.add
        i32.load
        local.tee 6
        i32.load offset=16
        local.get 0
        i32.eq
        i32.const 96
        call 9
        br 1 (;@1;)
      end
      i32.const 0
      local.set 6
      local.get 0
      i64.load
      local.get 0
      i64.load offset=8
      i64.const 3607749779137757184
      local.get 1
      call 4
      local.tee 5
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      local.get 5
      call 37
      local.tee 6
      i32.load offset=16
      local.get 0
      i32.eq
      i32.const 96
      call 9
    end
    local.get 6
    i32.const 0
    i32.ne
    local.get 2
    call 9
    local.get 6)
  (func (;43;) (type 7) (param i32 i32)
    (local i64 i32 i32 i32 i32 i32 i32)
    local.get 1
    i32.load offset=16
    local.get 0
    i32.eq
    i32.const 1296
    call 9
    local.get 0
    i64.load
    call 2
    i64.eq
    i32.const 1344
    call 9
    block  ;; label = @1
      local.get 0
      i32.const 28
      i32.add
      local.tee 5
      i32.load
      local.tee 7
      local.get 0
      i32.load offset=24
      local.tee 3
      i32.eq
      br_if 0 (;@1;)
      local.get 1
      i64.load offset=8
      local.set 2
      i32.const 0
      local.get 3
      i32.sub
      local.set 6
      local.get 7
      i32.const -24
      i32.add
      local.set 8
      loop  ;; label = @2
        local.get 8
        i32.load
        i64.load offset=8
        local.get 2
        i64.xor
        i64.const 256
        i64.lt_u
        br_if 1 (;@1;)
        local.get 8
        local.set 7
        local.get 8
        i32.const -24
        i32.add
        local.tee 4
        local.set 8
        local.get 4
        local.get 6
        i32.add
        i32.const -24
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 7
    local.get 3
    i32.ne
    i32.const 1408
    call 9
    local.get 7
    i32.const -24
    i32.add
    local.set 8
    block  ;; label = @1
      block  ;; label = @2
        local.get 7
        local.get 5
        i32.load
        local.tee 4
        i32.eq
        br_if 0 (;@2;)
        i32.const 0
        local.get 4
        i32.sub
        local.set 3
        local.get 8
        local.set 7
        loop  ;; label = @3
          local.get 7
          i32.const 24
          i32.add
          local.tee 8
          i32.load
          local.set 6
          local.get 8
          i32.const 0
          i32.store
          local.get 7
          i32.load
          local.set 4
          local.get 7
          local.get 6
          i32.store
          block  ;; label = @4
            local.get 4
            i32.eqz
            br_if 0 (;@4;)
            local.get 4
            call 54
          end
          local.get 7
          i32.const 16
          i32.add
          local.get 7
          i32.const 40
          i32.add
          i32.load
          i32.store
          local.get 7
          i32.const 8
          i32.add
          local.get 7
          i32.const 32
          i32.add
          i64.load
          i64.store
          local.get 8
          local.set 7
          local.get 8
          local.get 3
          i32.add
          i32.const -24
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 0
        i32.const 28
        i32.add
        i32.load
        local.tee 7
        local.get 8
        i32.eq
        br_if 1 (;@1;)
      end
      loop  ;; label = @2
        local.get 7
        i32.const -24
        i32.add
        local.tee 7
        i32.load
        local.set 4
        local.get 7
        i32.const 0
        i32.store
        block  ;; label = @3
          local.get 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          call 54
        end
        local.get 8
        local.get 7
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 0
    i32.const 28
    i32.add
    local.get 8
    i32.store
    local.get 1
    i32.load offset=20
    call 6)
  (func (;44;) (type 20) (param i64 i64 i64)
    (local i32 i32 i64 i64 i64 i64 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 64
    i32.sub
    local.tee 9
    i32.store offset=4
    i64.const 0
    local.set 6
    i64.const 59
    local.set 5
    i32.const 1472
    local.set 4
    i64.const 0
    local.set 7
    loop  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 6
                i64.const 6
                i64.gt_u
                br_if 0 (;@6;)
                local.get 4
                i32.load8_s
                local.tee 3
                i32.const -97
                i32.add
                i32.const 255
                i32.and
                i32.const 25
                i32.gt_u
                br_if 1 (;@5;)
                local.get 3
                i32.const 165
                i32.add
                local.set 3
                br 2 (;@4;)
              end
              i64.const 0
              local.set 8
              local.get 6
              i64.const 11
              i64.le_u
              br_if 2 (;@3;)
              br 3 (;@2;)
            end
            local.get 3
            i32.const 208
            i32.add
            i32.const 0
            local.get 3
            i32.const -49
            i32.add
            i32.const 255
            i32.and
            i32.const 5
            i32.lt_u
            select
            local.set 3
          end
          local.get 3
          i64.extend_i32_u
          i64.const 56
          i64.shl
          i64.const 56
          i64.shr_s
          local.set 8
        end
        local.get 8
        i64.const 31
        i64.and
        local.get 5
        i64.const 4294967295
        i64.and
        i64.shl
        local.set 8
      end
      local.get 4
      i32.const 1
      i32.add
      local.set 4
      local.get 6
      i64.const 1
      i64.add
      local.set 6
      local.get 8
      local.get 7
      i64.or
      local.set 7
      local.get 5
      i64.const -5
      i64.add
      local.tee 5
      i64.const -6
      i64.ne
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      local.get 7
      local.get 2
      i64.ne
      br_if 0 (;@1;)
      i64.const 0
      local.set 6
      i64.const 59
      local.set 5
      i32.const 1488
      local.set 4
      i64.const 0
      local.set 7
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 6
                  i64.const 4
                  i64.gt_u
                  br_if 0 (;@7;)
                  local.get 4
                  i32.load8_s
                  local.tee 3
                  i32.const -97
                  i32.add
                  i32.const 255
                  i32.and
                  i32.const 25
                  i32.gt_u
                  br_if 1 (;@6;)
                  local.get 3
                  i32.const 165
                  i32.add
                  local.set 3
                  br 2 (;@5;)
                end
                i64.const 0
                local.set 8
                local.get 6
                i64.const 11
                i64.le_u
                br_if 2 (;@4;)
                br 3 (;@3;)
              end
              local.get 3
              i32.const 208
              i32.add
              i32.const 0
              local.get 3
              i32.const -49
              i32.add
              i32.const 255
              i32.and
              i32.const 5
              i32.lt_u
              select
              local.set 3
            end
            local.get 3
            i64.extend_i32_u
            i64.const 56
            i64.shl
            i64.const 56
            i64.shr_s
            local.set 8
          end
          local.get 8
          i64.const 31
          i64.and
          local.get 5
          i64.const 4294967295
          i64.and
          i64.shl
          local.set 8
        end
        local.get 4
        i32.const 1
        i32.add
        local.set 4
        local.get 6
        i64.const 1
        i64.add
        local.set 6
        local.get 8
        local.get 7
        i64.or
        local.set 7
        local.get 5
        i64.const -5
        i64.add
        local.tee 5
        i64.const -6
        i64.ne
        br_if 0 (;@2;)
      end
      local.get 7
      local.get 1
      i64.eq
      i32.const 1504
      call 9
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        local.get 0
        i64.eq
        br_if 0 (;@2;)
        i64.const 0
        local.set 6
        i64.const 59
        local.set 5
        i32.const 1472
        local.set 4
        i64.const 0
        local.set 7
        loop  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 6
                    i64.const 6
                    i64.gt_u
                    br_if 0 (;@8;)
                    local.get 4
                    i32.load8_s
                    local.tee 3
                    i32.const -97
                    i32.add
                    i32.const 255
                    i32.and
                    i32.const 25
                    i32.gt_u
                    br_if 1 (;@7;)
                    local.get 3
                    i32.const 165
                    i32.add
                    local.set 3
                    br 2 (;@6;)
                  end
                  i64.const 0
                  local.set 8
                  local.get 6
                  i64.const 11
                  i64.le_u
                  br_if 2 (;@5;)
                  br 3 (;@4;)
                end
                local.get 3
                i32.const 208
                i32.add
                i32.const 0
                local.get 3
                i32.const -49
                i32.add
                i32.const 255
                i32.and
                i32.const 5
                i32.lt_u
                select
                local.set 3
              end
              local.get 3
              i64.extend_i32_u
              i64.const 56
              i64.shl
              i64.const 56
              i64.shr_s
              local.set 8
            end
            local.get 8
            i64.const 31
            i64.and
            local.get 5
            i64.const 4294967295
            i64.and
            i64.shl
            local.set 8
          end
          local.get 4
          i32.const 1
          i32.add
          local.set 4
          local.get 6
          i64.const 1
          i64.add
          local.set 6
          local.get 8
          local.get 7
          i64.or
          local.set 7
          local.get 5
          i64.const -5
          i64.add
          local.tee 5
          i64.const -6
          i64.ne
          br_if 0 (;@3;)
        end
        local.get 7
        local.get 2
        i64.ne
        br_if 1 (;@1;)
      end
      local.get 9
      local.get 0
      i64.store offset=56
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i64.const -3617168760277827584
          i64.eq
          br_if 0 (;@3;)
          local.get 2
          i64.const 8516769789752901632
          i64.eq
          br_if 1 (;@2;)
          local.get 2
          i64.const 5031766152489992192
          i64.ne
          br_if 2 (;@1;)
          local.get 9
          i32.const 0
          i32.store offset=52
          local.get 9
          i32.const 1
          i32.store offset=48
          local.get 9
          local.get 9
          i64.load offset=48
          i64.store offset=8 align=4
          local.get 9
          i32.const 56
          i32.add
          local.get 9
          i32.const 8
          i32.add
          call 45
          drop
          br 2 (;@1;)
        end
        local.get 9
        i32.const 0
        i32.store offset=36
        local.get 9
        i32.const 2
        i32.store offset=32
        local.get 9
        local.get 9
        i64.load offset=32
        i64.store offset=24 align=4
        local.get 9
        i32.const 56
        i32.add
        local.get 9
        i32.const 24
        i32.add
        call 47
        drop
        br 1 (;@1;)
      end
      local.get 9
      i32.const 0
      i32.store offset=44
      local.get 9
      i32.const 3
      i32.store offset=40
      local.get 9
      local.get 9
      i64.load offset=40
      i64.store offset=16 align=4
      local.get 9
      i32.const 56
      i32.add
      local.get 9
      i32.const 16
      i32.add
      call 46
      drop
    end
    i32.const 0
    local.get 9
    i32.const 64
    i32.add
    i32.store offset=4)
  (func (;45;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i64 i32 i64 i32 i32 i32)
    i32.const 0
    i32.load offset=4
    i32.const 96
    i32.sub
    local.tee 7
    local.set 9
    i32.const 0
    local.get 7
    i32.store offset=4
    local.get 1
    i32.load offset=4
    local.set 2
    local.get 1
    i32.load
    local.set 8
    i32.const 0
    local.set 1
    i32.const 0
    local.set 5
    block  ;; label = @1
      call 1
      local.tee 3
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const 513
          i32.lt_u
          br_if 0 (;@3;)
          local.get 3
          call 60
          local.set 5
          br 1 (;@2;)
        end
        i32.const 0
        local.get 7
        local.get 3
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        local.tee 5
        i32.store offset=4
      end
      local.get 5
      local.get 3
      call 12
      drop
    end
    local.get 9
    i32.const 40
    i32.add
    i64.const 1398362884
    i64.store
    local.get 9
    i64.const 0
    i64.store offset=32
    local.get 9
    i64.const 0
    i64.store offset=24
    i32.const 1
    i32.const 288
    call 9
    i64.const 5462355
    local.set 6
    block  ;; label = @1
      loop  ;; label = @2
        i32.const 0
        local.set 7
        local.get 6
        i32.wrap_i64
        i32.const 24
        i32.shl
        i32.const -1073741825
        i32.add
        i32.const 452984830
        i32.gt_u
        br_if 1 (;@1;)
        block  ;; label = @3
          local.get 6
          i64.const 8
          i64.shr_u
          local.tee 6
          i64.const 255
          i64.and
          i64.const 0
          i64.ne
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 6
            i64.const 8
            i64.shr_u
            local.tee 6
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 3 (;@1;)
            local.get 1
            i32.const 1
            i32.add
            local.tee 1
            i32.const 7
            i32.lt_s
            br_if 0 (;@4;)
          end
        end
        i32.const 1
        local.set 7
        local.get 1
        i32.const 1
        i32.add
        local.tee 1
        i32.const 7
        i32.lt_s
        br_if 0 (;@2;)
      end
    end
    local.get 7
    i32.const 16
    call 9
    local.get 3
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 9
    i32.const 24
    i32.add
    local.get 5
    i32.const 8
    call 11
    drop
    local.get 3
    i32.const -8
    i32.and
    local.tee 7
    i32.const 8
    i32.ne
    i32.const 384
    call 9
    local.get 9
    i32.const 24
    i32.add
    i32.const 8
    i32.add
    local.tee 1
    local.get 5
    i32.const 8
    i32.add
    i32.const 8
    call 11
    drop
    local.get 7
    i32.const 16
    i32.ne
    i32.const 384
    call 9
    local.get 9
    i32.const 24
    i32.add
    i32.const 16
    i32.add
    local.get 5
    i32.const 16
    i32.add
    i32.const 8
    call 11
    drop
    block  ;; label = @1
      local.get 3
      i32.const 513
      i32.lt_u
      br_if 0 (;@1;)
      local.get 5
      call 63
    end
    local.get 9
    i32.const 48
    i32.add
    i32.const 8
    i32.add
    local.tee 7
    local.get 1
    i32.const 8
    i32.add
    i64.load
    i64.store
    local.get 9
    i64.load offset=24
    local.set 6
    local.get 9
    local.get 1
    i64.load
    i64.store offset=48
    local.get 9
    i32.const 64
    i32.add
    i32.const 8
    i32.add
    local.get 7
    i64.load
    i64.store
    local.get 9
    local.get 9
    i64.load offset=48
    i64.store offset=64
    local.get 0
    local.get 2
    i32.const 1
    i32.shr_s
    i32.add
    local.set 1
    block  ;; label = @1
      local.get 2
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.load
      local.get 8
      i32.add
      i32.load
      local.set 8
    end
    local.get 9
    i32.const 80
    i32.add
    i32.const 8
    i32.add
    local.get 9
    i32.const 64
    i32.add
    i32.const 8
    i32.add
    i64.load
    local.tee 4
    i64.store
    local.get 9
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get 4
    i64.store
    local.get 9
    local.get 9
    i64.load offset=64
    local.tee 4
    i64.store offset=80
    local.get 9
    local.get 4
    i64.store offset=8
    local.get 1
    local.get 6
    local.get 9
    i32.const 8
    i32.add
    local.get 8
    call_indirect (type 0)
    i32.const 0
    local.get 9
    i32.const 96
    i32.add
    i32.store offset=4
    i32.const 1)
  (func (;46;) (type 14) (param i32 i32) (result i32)
    (local i32 i64 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 80
    i32.sub
    local.tee 4
    i32.store offset=4
    local.get 4
    local.tee 5
    local.get 0
    i32.store offset=60
    local.get 5
    local.get 1
    i32.load
    i32.store offset=48
    local.get 5
    local.get 1
    i32.load offset=4
    i32.store offset=52
    i32.const 0
    local.set 1
    i32.const 0
    local.set 0
    block  ;; label = @1
      call 1
      local.tee 2
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.const 513
          i32.lt_u
          br_if 0 (;@3;)
          local.get 2
          call 60
          local.set 0
          br 1 (;@2;)
        end
        i32.const 0
        local.get 4
        local.get 2
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        local.tee 0
        i32.store offset=4
      end
      local.get 0
      local.get 2
      call 12
      drop
    end
    local.get 5
    i32.const 24
    i32.add
    i64.const 1398362884
    i64.store
    local.get 5
    i64.const 0
    i64.store offset=16
    local.get 5
    i64.const 0
    i64.store offset=8
    i32.const 1
    i32.const 288
    call 9
    i64.const 5462355
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 3
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 3
            i64.const 8
            i64.shr_u
            local.tee 3
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 3
              i64.const 8
              i64.shr_u
              local.tee 3
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 1
              i32.const 1
              i32.add
              local.tee 1
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 4
          local.get 1
          i32.const 1
          i32.add
          local.tee 1
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 4
    end
    local.get 4
    i32.const 16
    call 9
    local.get 5
    i32.const 40
    i32.add
    i32.const 0
    i32.store
    local.get 5
    i64.const 0
    i64.store offset=32
    local.get 5
    local.get 0
    i32.store offset=64
    local.get 5
    local.get 0
    local.get 2
    i32.add
    local.tee 1
    i32.store offset=72
    local.get 2
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 5
    i32.const 8
    i32.add
    local.get 0
    i32.const 8
    call 11
    drop
    local.get 1
    local.get 0
    i32.const 8
    i32.add
    local.tee 4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 5
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.get 4
    i32.const 8
    call 11
    drop
    local.get 1
    local.get 0
    i32.const 16
    i32.add
    local.tee 4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 5
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    local.get 4
    i32.const 8
    call 11
    drop
    local.get 5
    local.get 0
    i32.const 24
    i32.add
    i32.store offset=68
    local.get 5
    i32.const 64
    i32.add
    local.get 5
    i32.const 8
    i32.add
    i32.const 24
    i32.add
    call 50
    drop
    block  ;; label = @1
      local.get 2
      i32.const 513
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      call 63
    end
    local.get 5
    local.get 5
    i32.const 48
    i32.add
    i32.store offset=68
    local.get 5
    local.get 5
    i32.const 60
    i32.add
    i32.store offset=64
    local.get 5
    i32.const 64
    i32.add
    local.get 5
    i32.const 8
    i32.add
    call 52
    block  ;; label = @1
      local.get 5
      i32.load8_u offset=32
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 5
      i32.const 40
      i32.add
      i32.load
      call 54
    end
    i32.const 0
    local.get 5
    i32.const 80
    i32.add
    i32.store offset=4
    i32.const 1)
  (func (;47;) (type 14) (param i32 i32) (result i32)
    (local i32 i64 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 96
    i32.sub
    local.tee 4
    i32.store offset=4
    local.get 4
    local.tee 5
    local.get 0
    i32.store offset=60
    local.get 5
    local.get 1
    i32.load
    i32.store offset=48
    local.get 5
    local.get 1
    i32.load offset=4
    i32.store offset=52
    i32.const 0
    local.set 1
    i32.const 0
    local.set 0
    block  ;; label = @1
      call 1
      local.tee 2
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.const 513
          i32.lt_u
          br_if 0 (;@3;)
          local.get 2
          call 60
          local.set 0
          br 1 (;@2;)
        end
        i32.const 0
        local.get 4
        local.get 2
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        local.tee 0
        i32.store offset=4
      end
      local.get 0
      local.get 2
      call 12
      drop
    end
    local.get 5
    i32.const 24
    i32.add
    i64.const 1398362884
    i64.store
    local.get 5
    i64.const 0
    i64.store offset=8
    local.get 5
    i64.const 0
    i64.store
    local.get 5
    i64.const 0
    i64.store offset=16
    i32.const 1
    i32.const 288
    call 9
    i64.const 5462355
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        loop  ;; label = @3
          local.get 3
          i32.wrap_i64
          i32.const 24
          i32.shl
          i32.const -1073741825
          i32.add
          i32.const 452984830
          i32.gt_u
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 3
            i64.const 8
            i64.shr_u
            local.tee 3
            i64.const 255
            i64.and
            i64.const 0
            i64.ne
            br_if 0 (;@4;)
            loop  ;; label = @5
              local.get 3
              i64.const 8
              i64.shr_u
              local.tee 3
              i64.const 255
              i64.and
              i64.const 0
              i64.ne
              br_if 3 (;@2;)
              local.get 1
              i32.const 1
              i32.add
              local.tee 1
              i32.const 7
              i32.lt_s
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 4
          local.get 1
          i32.const 1
          i32.add
          local.tee 1
          i32.const 7
          i32.lt_s
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i32.const 0
      local.set 4
    end
    local.get 4
    i32.const 16
    call 9
    local.get 5
    i32.const 40
    i32.add
    i32.const 0
    i32.store
    local.get 5
    i64.const 0
    i64.store offset=32
    local.get 5
    local.get 0
    i32.store offset=68
    local.get 5
    local.get 0
    i32.store offset=64
    local.get 5
    local.get 0
    local.get 2
    i32.add
    i32.store offset=72
    local.get 5
    local.get 5
    i32.const 64
    i32.add
    i32.store offset=80
    local.get 5
    local.get 5
    i32.store offset=88
    local.get 5
    i32.const 88
    i32.add
    local.get 5
    i32.const 80
    i32.add
    call 48
    block  ;; label = @1
      local.get 2
      i32.const 513
      i32.lt_u
      br_if 0 (;@1;)
      local.get 0
      call 63
    end
    local.get 5
    local.get 5
    i32.const 48
    i32.add
    i32.store offset=68
    local.get 5
    local.get 5
    i32.const 60
    i32.add
    i32.store offset=64
    local.get 5
    i32.const 64
    i32.add
    local.get 5
    call 49
    block  ;; label = @1
      local.get 5
      i32.load8_u offset=32
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 5
      i32.const 40
      i32.add
      i32.load
      call 54
    end
    i32.const 0
    local.get 5
    i32.const 96
    i32.add
    i32.store offset=4
    i32.const 1)
  (func (;48;) (type 7) (param i32 i32)
    (local i32 i32)
    local.get 0
    i32.load
    local.set 2
    local.get 1
    i32.load
    local.tee 3
    i32.load offset=8
    local.get 3
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 2
    local.get 3
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 3
    local.get 3
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load
    local.set 0
    local.get 1
    i32.load
    local.tee 3
    i32.load offset=8
    local.get 3
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 0
    i32.const 8
    i32.add
    local.get 3
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 3
    local.get 3
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.tee 3
    i32.load offset=8
    local.get 3
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 0
    i32.const 16
    i32.add
    local.get 3
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 3
    local.get 3
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 2
    i32.store offset=4
    local.get 3
    i32.load offset=8
    local.get 2
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 384
    call 9
    local.get 0
    i32.const 24
    i32.add
    local.get 3
    i32.load offset=4
    i32.const 8
    call 11
    drop
    local.get 3
    local.get 3
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.get 0
    i32.const 32
    i32.add
    call 50
    drop)
  (func (;49;) (type 7) (param i32 i32)
    (local i64 i64 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 96
    i32.sub
    local.tee 5
    i32.store offset=4
    local.get 5
    i32.const 44
    i32.add
    local.get 1
    i32.const 28
    i32.add
    i32.load
    i32.store
    local.get 5
    i32.const 32
    i32.add
    i32.const 8
    i32.add
    local.tee 4
    local.get 1
    i32.const 24
    i32.add
    i32.load
    i32.store
    local.get 5
    local.get 1
    i32.load offset=16
    i32.store offset=32
    local.get 5
    local.get 1
    i32.const 20
    i32.add
    i32.load
    i32.store offset=36
    local.get 1
    i64.load offset=8
    local.set 3
    local.get 1
    i64.load
    local.set 2
    local.get 5
    i32.const 16
    i32.add
    local.get 1
    i32.const 32
    i32.add
    call 58
    drop
    local.get 5
    i32.const 48
    i32.add
    i32.const 8
    i32.add
    local.get 4
    i64.load
    i64.store
    local.get 5
    local.get 5
    i64.load offset=32
    i64.store offset=48
    local.get 0
    i32.load
    i32.load
    local.get 0
    i32.load offset=4
    local.tee 1
    i32.load offset=4
    local.tee 4
    i32.const 1
    i32.shr_s
    i32.add
    local.set 0
    local.get 1
    i32.load
    local.set 1
    block  ;; label = @1
      local.get 4
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load
      local.get 1
      i32.add
      i32.load
      local.set 1
    end
    local.get 5
    i32.const 80
    i32.add
    i32.const 8
    i32.add
    local.tee 4
    local.get 5
    i32.const 48
    i32.add
    i32.const 8
    i32.add
    i64.load
    i64.store
    local.get 5
    local.get 5
    i64.load offset=48
    i64.store offset=80
    local.get 5
    i32.const 64
    i32.add
    local.get 5
    i32.const 16
    i32.add
    call 58
    drop
    local.get 5
    i32.const 8
    i32.add
    local.get 4
    i64.load
    i64.store
    local.get 5
    local.get 5
    i64.load offset=80
    i64.store
    local.get 0
    local.get 2
    local.get 3
    local.get 5
    local.get 5
    i32.const 64
    i32.add
    local.get 1
    call_indirect (type 1)
    block  ;; label = @1
      local.get 5
      i32.load8_u offset=64
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 5
      i32.load offset=72
      call 54
    end
    block  ;; label = @1
      local.get 5
      i32.load8_u offset=16
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 5
      i32.load offset=24
      call 54
    end
    i32.const 0
    local.get 5
    i32.const 96
    i32.add
    i32.store offset=4)
  (func (;50;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 32
    i32.sub
    local.tee 7
    i32.store offset=4
    local.get 7
    i32.const 0
    i32.store offset=24
    local.get 7
    i64.const 0
    i64.store offset=16
    local.get 0
    local.get 7
    i32.const 16
    i32.add
    call 51
    drop
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 7
                      i32.load offset=20
                      local.tee 5
                      local.get 7
                      i32.load offset=16
                      local.tee 4
                      i32.ne
                      br_if 0 (;@9;)
                      local.get 1
                      i32.load8_u
                      i32.const 1
                      i32.and
                      br_if 1 (;@8;)
                      local.get 1
                      i32.const 0
                      i32.store16
                      local.get 1
                      i32.const 8
                      i32.add
                      local.set 4
                      br 2 (;@7;)
                    end
                    local.get 7
                    i32.const 8
                    i32.add
                    i32.const 0
                    i32.store
                    local.get 7
                    i64.const 0
                    i64.store
                    local.get 5
                    local.get 4
                    i32.sub
                    local.tee 2
                    i32.const -16
                    i32.ge_u
                    br_if 7 (;@1;)
                    local.get 2
                    i32.const 11
                    i32.ge_u
                    br_if 2 (;@6;)
                    local.get 7
                    local.get 2
                    i32.const 1
                    i32.shl
                    i32.store8
                    local.get 7
                    i32.const 1
                    i32.or
                    local.set 6
                    local.get 2
                    br_if 3 (;@5;)
                    br 4 (;@4;)
                  end
                  local.get 1
                  i32.load offset=8
                  i32.const 0
                  i32.store8
                  local.get 1
                  i32.const 0
                  i32.store offset=4
                  local.get 1
                  i32.const 8
                  i32.add
                  local.set 4
                end
                local.get 1
                i32.const 0
                call 56
                local.get 4
                i32.const 0
                i32.store
                local.get 1
                i64.const 0
                i64.store align=4
                local.get 7
                i32.load offset=16
                local.tee 4
                br_if 3 (;@3;)
                br 4 (;@2;)
              end
              local.get 2
              i32.const 16
              i32.add
              i32.const -16
              i32.and
              local.tee 5
              call 53
              local.set 6
              local.get 7
              local.get 5
              i32.const 1
              i32.or
              i32.store
              local.get 7
              local.get 6
              i32.store offset=8
              local.get 7
              local.get 2
              i32.store offset=4
            end
            local.get 2
            local.set 3
            local.get 6
            local.set 5
            loop  ;; label = @5
              local.get 5
              local.get 4
              i32.load8_u
              i32.store8
              local.get 5
              i32.const 1
              i32.add
              local.set 5
              local.get 4
              i32.const 1
              i32.add
              local.set 4
              local.get 3
              i32.const -1
              i32.add
              local.tee 3
              br_if 0 (;@5;)
            end
            local.get 6
            local.get 2
            i32.add
            local.set 6
          end
          local.get 6
          i32.const 0
          i32.store8
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              i32.load8_u
              i32.const 1
              i32.and
              br_if 0 (;@5;)
              local.get 1
              i32.const 0
              i32.store16
              br 1 (;@4;)
            end
            local.get 1
            i32.load offset=8
            i32.const 0
            i32.store8
            local.get 1
            i32.const 0
            i32.store offset=4
          end
          local.get 1
          i32.const 0
          call 56
          local.get 1
          i32.const 8
          i32.add
          local.get 7
          i32.const 8
          i32.add
          i32.load
          i32.store
          local.get 1
          local.get 7
          i64.load
          i64.store align=4
          local.get 7
          i32.load offset=16
          local.tee 4
          i32.eqz
          br_if 1 (;@2;)
        end
        local.get 7
        local.get 4
        i32.store offset=20
        local.get 4
        call 54
      end
      i32.const 0
      local.get 7
      i32.const 32
      i32.add
      i32.store offset=4
      local.get 0
      return
    end
    local.get 7
    call 55
    unreachable)
  (func (;51;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i64 i32)
    local.get 0
    i32.load offset=4
    local.set 5
    i32.const 0
    local.set 7
    i64.const 0
    local.set 6
    local.get 0
    i32.const 8
    i32.add
    local.set 2
    local.get 0
    i32.const 4
    i32.add
    local.set 3
    loop  ;; label = @1
      local.get 5
      local.get 2
      i32.load
      i32.lt_u
      i32.const 1568
      call 9
      local.get 3
      i32.load
      local.tee 5
      i32.load8_u
      local.set 4
      local.get 3
      local.get 5
      i32.const 1
      i32.add
      local.tee 5
      i32.store
      local.get 4
      i32.const 127
      i32.and
      local.get 7
      i32.const 255
      i32.and
      local.tee 7
      i32.shl
      i64.extend_i32_u
      local.get 6
      i64.or
      local.set 6
      local.get 7
      i32.const 7
      i32.add
      local.set 7
      local.get 4
      i32.const 7
      i32.shr_u
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 6
        i32.wrap_i64
        local.tee 3
        local.get 1
        i32.load offset=4
        local.tee 7
        local.get 1
        i32.load
        local.tee 4
        i32.sub
        local.tee 2
        i32.le_u
        br_if 0 (;@2;)
        local.get 1
        local.get 3
        local.get 2
        i32.sub
        call 31
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 5
        local.get 1
        i32.const 4
        i32.add
        i32.load
        local.set 7
        local.get 1
        i32.load
        local.set 4
        br 1 (;@1;)
      end
      local.get 3
      local.get 2
      i32.ge_u
      br_if 0 (;@1;)
      local.get 1
      i32.const 4
      i32.add
      local.get 4
      local.get 3
      i32.add
      local.tee 7
      i32.store
    end
    local.get 0
    i32.const 8
    i32.add
    i32.load
    local.get 5
    i32.sub
    local.get 7
    local.get 4
    i32.sub
    local.tee 5
    i32.ge_u
    i32.const 384
    call 9
    local.get 4
    local.get 0
    i32.const 4
    i32.add
    local.tee 7
    i32.load
    local.get 5
    call 11
    drop
    local.get 7
    local.get 7
    i32.load
    local.get 5
    i32.add
    i32.store
    local.get 0)
  (func (;52;) (type 7) (param i32 i32)
    (local i64 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 96
    i32.sub
    local.tee 4
    i32.store offset=4
    local.get 4
    i32.const 32
    i32.add
    i32.const 12
    i32.add
    local.get 1
    i32.const 20
    i32.add
    i32.load
    i32.store
    local.get 4
    i32.const 32
    i32.add
    i32.const 8
    i32.add
    local.tee 3
    local.get 1
    i32.const 16
    i32.add
    i32.load
    i32.store
    local.get 4
    local.get 1
    i32.load offset=8
    i32.store offset=32
    local.get 4
    local.get 1
    i32.const 12
    i32.add
    i32.load
    i32.store offset=36
    local.get 1
    i64.load
    local.set 2
    local.get 4
    i32.const 16
    i32.add
    local.get 1
    i32.const 24
    i32.add
    call 58
    drop
    local.get 4
    i32.const 48
    i32.add
    i32.const 8
    i32.add
    local.get 3
    i64.load
    i64.store
    local.get 4
    local.get 4
    i64.load offset=32
    i64.store offset=48
    local.get 0
    i32.load
    i32.load
    local.get 0
    i32.load offset=4
    local.tee 1
    i32.load offset=4
    local.tee 3
    i32.const 1
    i32.shr_s
    i32.add
    local.set 0
    local.get 1
    i32.load
    local.set 1
    block  ;; label = @1
      local.get 3
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      i32.load
      local.get 1
      i32.add
      i32.load
      local.set 1
    end
    local.get 4
    i32.const 80
    i32.add
    i32.const 8
    i32.add
    local.tee 3
    local.get 4
    i32.const 48
    i32.add
    i32.const 8
    i32.add
    i64.load
    i64.store
    local.get 4
    local.get 4
    i64.load offset=48
    i64.store offset=80
    local.get 4
    i32.const 64
    i32.add
    local.get 4
    i32.const 16
    i32.add
    call 58
    drop
    local.get 4
    i32.const 8
    i32.add
    local.get 3
    i64.load
    i64.store
    local.get 4
    local.get 4
    i64.load offset=80
    i64.store
    local.get 0
    local.get 2
    local.get 4
    local.get 4
    i32.const 64
    i32.add
    local.get 1
    call_indirect (type 2)
    block  ;; label = @1
      local.get 4
      i32.load8_u offset=64
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      i32.load offset=72
      call 54
    end
    block  ;; label = @1
      local.get 4
      i32.load8_u offset=16
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      i32.load offset=24
      call 54
    end
    i32.const 0
    local.get 4
    i32.const 96
    i32.add
    i32.store offset=4)
  (func (;53;) (type 15) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 1
      local.get 0
      select
      local.tee 1
      call 60
      local.tee 0
      br_if 0 (;@1;)
      loop  ;; label = @2
        i32.const 0
        local.set 0
        i32.const 0
        i32.load offset=1572
        local.tee 2
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        call_indirect (type 3)
        local.get 1
        call 60
        local.tee 0
        i32.eqz
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func (;54;) (type 12) (param i32)
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      call 63
    end)
  (func (;55;) (type 12) (param i32)
    call 0
    unreachable)
  (func (;56;) (type 7) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.const -16
      i32.ge_u
      br_if 0 (;@1;)
      i32.const 10
      local.set 2
      block  ;; label = @2
        local.get 0
        i32.load8_u
        local.tee 5
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.load
        local.tee 5
        i32.const -2
        i32.and
        i32.const -1
        i32.add
        local.set 2
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 5
          i32.const 1
          i32.and
          br_if 0 (;@3;)
          local.get 5
          i32.const 254
          i32.and
          i32.const 1
          i32.shr_u
          local.set 3
          br 1 (;@2;)
        end
        local.get 0
        i32.load offset=4
        local.set 3
      end
      i32.const 10
      local.set 4
      block  ;; label = @2
        local.get 3
        local.get 1
        local.get 3
        local.get 1
        i32.gt_u
        select
        local.tee 1
        i32.const 11
        i32.lt_u
        br_if 0 (;@2;)
        local.get 1
        i32.const 16
        i32.add
        i32.const -16
        i32.and
        i32.const -1
        i32.add
        local.set 4
      end
      block  ;; label = @2
        local.get 4
        local.get 2
        i32.eq
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 4
            i32.const 10
            i32.ne
            br_if 0 (;@4;)
            i32.const 1
            local.set 6
            local.get 0
            i32.const 1
            i32.add
            local.set 1
            local.get 0
            i32.load offset=8
            local.set 2
            i32.const 0
            local.set 7
            br 1 (;@3;)
          end
          local.get 4
          i32.const 1
          i32.add
          call 53
          local.set 1
          block  ;; label = @4
            local.get 4
            local.get 2
            i32.gt_u
            br_if 0 (;@4;)
            local.get 1
            i32.eqz
            br_if 2 (;@2;)
          end
          block  ;; label = @4
            local.get 0
            i32.load8_u
            local.tee 5
            i32.const 1
            i32.and
            br_if 0 (;@4;)
            i32.const 1
            local.set 7
            local.get 0
            i32.const 1
            i32.add
            local.set 2
            i32.const 0
            local.set 6
            br 1 (;@3;)
          end
          local.get 0
          i32.load offset=8
          local.set 2
          i32.const 1
          local.set 6
          i32.const 1
          local.set 7
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 5
            i32.const 1
            i32.and
            br_if 0 (;@4;)
            local.get 5
            i32.const 254
            i32.and
            i32.const 1
            i32.shr_u
            local.set 5
            br 1 (;@3;)
          end
          local.get 0
          i32.load offset=4
          local.set 5
        end
        block  ;; label = @3
          local.get 5
          i32.const 1
          i32.add
          local.tee 5
          i32.eqz
          br_if 0 (;@3;)
          local.get 1
          local.get 2
          local.get 5
          call 11
          drop
        end
        block  ;; label = @3
          local.get 6
          i32.eqz
          br_if 0 (;@3;)
          local.get 2
          call 54
        end
        block  ;; label = @3
          local.get 7
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          local.get 3
          i32.store offset=4
          local.get 0
          local.get 1
          i32.store offset=8
          local.get 0
          local.get 4
          i32.const 1
          i32.add
          i32.const 1
          i32.or
          i32.store
          return
        end
        local.get 0
        local.get 3
        i32.const 1
        i32.shl
        i32.store8
      end
      return
    end
    call 0
    unreachable)
  (func (;57;) (type 12) (param i32)
    call 0
    unreachable)
  (func (;58;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i64.const 0
    i64.store align=4
    local.get 0
    i32.const 8
    i32.add
    local.tee 3
    i32.const 0
    i32.store
    block  ;; label = @1
      local.get 1
      i32.load8_u
      i32.const 1
      i32.and
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i64.load align=4
      i64.store align=4
      local.get 3
      local.get 1
      i32.const 8
      i32.add
      i32.load
      i32.store
      local.get 0
      return
    end
    block  ;; label = @1
      local.get 1
      i32.load offset=4
      local.tee 3
      i32.const -16
      i32.ge_u
      br_if 0 (;@1;)
      local.get 1
      i32.load offset=8
      local.set 2
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            i32.const 11
            i32.ge_u
            br_if 0 (;@4;)
            local.get 0
            local.get 3
            i32.const 1
            i32.shl
            i32.store8
            local.get 0
            i32.const 1
            i32.add
            local.set 1
            local.get 3
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          local.get 3
          i32.const 16
          i32.add
          i32.const -16
          i32.and
          local.tee 4
          call 53
          local.set 1
          local.get 0
          local.get 4
          i32.const 1
          i32.or
          i32.store
          local.get 0
          local.get 1
          i32.store offset=8
          local.get 0
          local.get 3
          i32.store offset=4
        end
        local.get 1
        local.get 2
        local.get 3
        call 11
        drop
      end
      local.get 1
      local.get 3
      i32.add
      i32.const 0
      i32.store8
      local.get 0
      return
    end
    call 0
    unreachable)
  (func (;59;) (type 10) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    local.set 5
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          local.get 0
          i32.load8_u
          local.tee 3
          local.get 1
          i32.load8_u
          local.tee 4
          i32.ne
          br_if 1 (;@2;)
          local.get 1
          i32.const 1
          i32.add
          local.set 1
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 2
          i32.const -1
          i32.add
          local.tee 2
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      local.get 3
      local.get 4
      i32.sub
      local.set 5
    end
    local.get 5)
  (func (;60;) (type 15) (param i32) (result i32)
    i32.const 1576
    local.get 0
    call 61)
  (func (;61;) (type 14) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 0
        i32.load offset=8384
        local.tee 13
        br_if 0 (;@2;)
        i32.const 16
        local.set 13
        local.get 0
        i32.const 8384
        i32.add
        i32.const 16
        i32.store
      end
      local.get 1
      i32.const 8
      i32.add
      local.get 1
      i32.const 4
      i32.add
      i32.const 7
      i32.and
      local.tee 2
      i32.sub
      local.get 1
      local.get 2
      select
      local.set 2
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load offset=8388
            local.tee 10
            local.get 13
            i32.ge_u
            br_if 0 (;@4;)
            local.get 0
            local.get 10
            i32.const 12
            i32.mul
            i32.add
            i32.const 8192
            i32.add
            local.set 1
            block  ;; label = @5
              local.get 10
              br_if 0 (;@5;)
              local.get 0
              i32.const 8196
              i32.add
              local.tee 13
              i32.load
              br_if 0 (;@5;)
              local.get 1
              i32.const 8192
              i32.store
              local.get 13
              local.get 0
              i32.store
            end
            local.get 2
            i32.const 4
            i32.add
            local.set 10
            loop  ;; label = @5
              block  ;; label = @6
                local.get 1
                i32.load offset=8
                local.tee 13
                local.get 10
                i32.add
                local.get 1
                i32.load
                i32.gt_u
                br_if 0 (;@6;)
                local.get 1
                i32.load offset=4
                local.get 13
                i32.add
                local.tee 13
                local.get 13
                i32.load
                i32.const -2147483648
                i32.and
                local.get 2
                i32.or
                i32.store
                local.get 1
                i32.const 8
                i32.add
                local.tee 1
                local.get 1
                i32.load
                local.get 10
                i32.add
                i32.store
                local.get 13
                local.get 13
                i32.load
                i32.const -2147483648
                i32.or
                i32.store
                local.get 13
                i32.const 4
                i32.add
                local.tee 1
                br_if 3 (;@3;)
              end
              local.get 0
              call 62
              local.tee 1
              br_if 0 (;@5;)
            end
          end
          i32.const 2147483644
          local.get 2
          i32.sub
          local.set 4
          local.get 0
          i32.const 8392
          i32.add
          local.set 11
          local.get 0
          i32.const 8384
          i32.add
          local.set 12
          local.get 0
          i32.load offset=8392
          local.tee 3
          local.set 13
          loop  ;; label = @4
            local.get 0
            local.get 13
            i32.const 12
            i32.mul
            i32.add
            local.tee 1
            i32.const 8200
            i32.add
            i32.load
            local.get 1
            i32.const 8192
            i32.add
            local.tee 5
            i32.load
            i32.eq
            i32.const 9984
            call 9
            local.get 1
            i32.const 8196
            i32.add
            i32.load
            local.tee 6
            i32.const 4
            i32.add
            local.set 13
            loop  ;; label = @5
              local.get 6
              local.get 5
              i32.load
              i32.add
              local.set 7
              local.get 13
              i32.const -4
              i32.add
              local.tee 8
              i32.load
              local.tee 9
              i32.const 2147483647
              i32.and
              local.set 1
              block  ;; label = @6
                local.get 9
                i32.const 0
                i32.lt_s
                br_if 0 (;@6;)
                block  ;; label = @7
                  local.get 1
                  local.get 2
                  i32.ge_u
                  br_if 0 (;@7;)
                  loop  ;; label = @8
                    local.get 13
                    local.get 1
                    i32.add
                    local.tee 10
                    local.get 7
                    i32.ge_u
                    br_if 1 (;@7;)
                    local.get 10
                    i32.load
                    local.tee 10
                    i32.const 0
                    i32.lt_s
                    br_if 1 (;@7;)
                    local.get 1
                    local.get 10
                    i32.const 2147483647
                    i32.and
                    i32.add
                    i32.const 4
                    i32.add
                    local.tee 1
                    local.get 2
                    i32.lt_u
                    br_if 0 (;@8;)
                  end
                end
                local.get 8
                local.get 1
                local.get 2
                local.get 1
                local.get 2
                i32.lt_u
                select
                local.get 9
                i32.const -2147483648
                i32.and
                i32.or
                i32.store
                block  ;; label = @7
                  local.get 1
                  local.get 2
                  i32.le_u
                  br_if 0 (;@7;)
                  local.get 13
                  local.get 2
                  i32.add
                  local.get 4
                  local.get 1
                  i32.add
                  i32.const 2147483647
                  i32.and
                  i32.store
                end
                local.get 1
                local.get 2
                i32.ge_u
                br_if 4 (;@2;)
              end
              local.get 13
              local.get 1
              i32.add
              i32.const 4
              i32.add
              local.tee 13
              local.get 7
              i32.lt_u
              br_if 0 (;@5;)
            end
            i32.const 0
            local.set 1
            local.get 11
            i32.const 0
            local.get 11
            i32.load
            i32.const 1
            i32.add
            local.tee 13
            local.get 13
            local.get 12
            i32.load
            i32.eq
            select
            local.tee 13
            i32.store
            local.get 13
            local.get 3
            i32.ne
            br_if 0 (;@4;)
          end
        end
        local.get 1
        return
      end
      local.get 8
      local.get 8
      i32.load
      i32.const -2147483648
      i32.or
      i32.store
      local.get 13
      return
    end
    i32.const 0)
  (func (;62;) (type 15) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    local.get 0
    i32.load offset=8388
    local.set 1
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load8_u offset=10070
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=10072
        local.set 7
        br 1 (;@1;)
      end
      memory.size
      local.set 7
      i32.const 0
      i32.const 1
      i32.store8 offset=10070
      i32.const 0
      local.get 7
      i32.const 16
      i32.shl
      local.tee 7
      i32.store offset=10072
    end
    local.get 7
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 7
            i32.const 65535
            i32.add
            i32.const 16
            i32.shr_u
            local.tee 2
            memory.size
            local.tee 8
            i32.le_u
            br_if 0 (;@4;)
            local.get 2
            local.get 8
            i32.sub
            memory.grow
            drop
            i32.const 0
            local.set 8
            local.get 2
            memory.size
            i32.ne
            br_if 1 (;@3;)
            i32.const 0
            i32.load offset=10072
            local.set 3
          end
          i32.const 0
          local.set 8
          i32.const 0
          local.get 3
          i32.store offset=10072
          local.get 7
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          local.get 0
          local.get 1
          i32.const 12
          i32.mul
          i32.add
          local.set 2
          local.get 7
          i32.const 65536
          i32.const 131072
          local.get 7
          i32.const 65535
          i32.and
          local.tee 8
          i32.const 64513
          i32.lt_u
          local.tee 6
          select
          i32.add
          local.get 8
          local.get 7
          i32.const 131071
          i32.and
          local.get 6
          select
          i32.sub
          local.get 7
          i32.sub
          local.set 7
          block  ;; label = @4
            i32.const 0
            i32.load8_u offset=10070
            br_if 0 (;@4;)
            memory.size
            local.set 3
            i32.const 0
            i32.const 1
            i32.store8 offset=10070
            i32.const 0
            local.get 3
            i32.const 16
            i32.shl
            local.tee 3
            i32.store offset=10072
          end
          local.get 2
          i32.const 8192
          i32.add
          local.set 2
          local.get 7
          i32.const 0
          i32.lt_s
          br_if 1 (;@2;)
          local.get 3
          local.set 6
          block  ;; label = @4
            local.get 7
            i32.const 7
            i32.add
            i32.const -8
            i32.and
            local.tee 5
            local.get 3
            i32.add
            i32.const 65535
            i32.add
            i32.const 16
            i32.shr_u
            local.tee 8
            memory.size
            local.tee 4
            i32.le_u
            br_if 0 (;@4;)
            local.get 8
            local.get 4
            i32.sub
            memory.grow
            drop
            local.get 8
            memory.size
            i32.ne
            br_if 2 (;@2;)
            i32.const 0
            i32.load offset=10072
            local.set 6
          end
          i32.const 0
          local.get 6
          local.get 5
          i32.add
          i32.store offset=10072
          local.get 3
          i32.const -1
          i32.eq
          br_if 1 (;@2;)
          local.get 0
          local.get 1
          i32.const 12
          i32.mul
          i32.add
          local.tee 1
          i32.const 8196
          i32.add
          i32.load
          local.tee 6
          local.get 2
          i32.load
          local.tee 8
          i32.add
          local.get 3
          i32.eq
          br_if 2 (;@1;)
          block  ;; label = @4
            local.get 8
            local.get 1
            i32.const 8200
            i32.add
            local.tee 5
            i32.load
            local.tee 1
            i32.eq
            br_if 0 (;@4;)
            local.get 6
            local.get 1
            i32.add
            local.tee 6
            local.get 6
            i32.load
            i32.const -2147483648
            i32.and
            i32.const -4
            local.get 1
            i32.sub
            local.get 8
            i32.add
            i32.or
            i32.store
            local.get 5
            local.get 2
            i32.load
            i32.store
            local.get 6
            local.get 6
            i32.load
            i32.const 2147483647
            i32.and
            i32.store
          end
          local.get 0
          i32.const 8388
          i32.add
          local.tee 2
          local.get 2
          i32.load
          i32.const 1
          i32.add
          local.tee 2
          i32.store
          local.get 0
          local.get 2
          i32.const 12
          i32.mul
          i32.add
          local.tee 0
          i32.const 8196
          i32.add
          local.get 3
          i32.store
          local.get 0
          i32.const 8192
          i32.add
          local.tee 8
          local.get 7
          i32.store
        end
        local.get 8
        return
      end
      block  ;; label = @2
        local.get 2
        i32.load
        local.tee 8
        local.get 0
        local.get 1
        i32.const 12
        i32.mul
        i32.add
        local.tee 3
        i32.const 8200
        i32.add
        local.tee 1
        i32.load
        local.tee 7
        i32.eq
        br_if 0 (;@2;)
        local.get 3
        i32.const 8196
        i32.add
        i32.load
        local.get 7
        i32.add
        local.tee 3
        local.get 3
        i32.load
        i32.const -2147483648
        i32.and
        i32.const -4
        local.get 7
        i32.sub
        local.get 8
        i32.add
        i32.or
        i32.store
        local.get 1
        local.get 2
        i32.load
        i32.store
        local.get 3
        local.get 3
        i32.load
        i32.const 2147483647
        i32.and
        i32.store
      end
      local.get 0
      local.get 0
      i32.const 8388
      i32.add
      local.tee 7
      i32.load
      i32.const 1
      i32.add
      local.tee 3
      i32.store offset=8384
      local.get 7
      local.get 3
      i32.store
      i32.const 0
      return
    end
    local.get 2
    local.get 8
    local.get 7
    i32.add
    i32.store
    local.get 2)
  (func (;63;) (type 12) (param i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=9960
        local.tee 2
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        i32.const 9768
        local.set 3
        local.get 2
        i32.const 12
        i32.mul
        i32.const 9768
        i32.add
        local.set 1
        loop  ;; label = @3
          local.get 3
          i32.const 4
          i32.add
          i32.load
          local.tee 2
          i32.eqz
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 2
            i32.const 4
            i32.add
            local.get 0
            i32.gt_u
            br_if 0 (;@4;)
            local.get 2
            local.get 3
            i32.load
            i32.add
            local.get 0
            i32.gt_u
            br_if 3 (;@1;)
          end
          local.get 3
          i32.const 12
          i32.add
          local.tee 3
          local.get 1
          i32.lt_u
          br_if 0 (;@3;)
        end
      end
      return
    end
    local.get 0
    i32.const -4
    i32.add
    local.tee 3
    local.get 3
    i32.load
    i32.const 2147483647
    i32.and
    i32.store)
  (func (;64;) (type 3)
    unreachable)
  (table (;0;) 4 4 funcref)
  (memory (;0;) 1)
  (export "memory" (memory 0))
  (export "_ZeqRK11checksum256S1_" (func 17))
  (export "_ZeqRK11checksum160S1_" (func 18))
  (export "_ZneRK11checksum160S1_" (func 19))
  (export "now" (func 20))
  (export "_ZN5eosio12require_authERKNS_16permission_levelE" (func 21))
  (export "_ZN5eosio5token6createEyNS_5assetE" (func 22))
  (export "_ZN5eosio5token5issueEyNS_5assetENSt3__112basic_stringIcNS2_11char_traitsIcEENS2_9allocatorIcEEEE" (func 28))
  (export "_ZN5eosio5token11add_balanceEyNS_5assetEy" (func 29))
  (export "_ZN5eosio5token8transferEyyNS_5assetENSt3__112basic_stringIcNS2_11char_traitsIcEENS2_9allocatorIcEEEE" (func 39))
  (export "_ZN5eosio5token11sub_balanceEyNS_5assetE" (func 41))
  (export "apply" (func 44))
  (export "memcmp" (func 59))
  (export "malloc" (func 60))
  (export "free" (func 63))
  (elem (;0;) (i32.const 0) 64 22 39 28)
  (data (;0;) (i32.const 4) "`O\00\00")
  (data (;1;) (i32.const 16) "invalid symbol name\00")
  (data (;2;) (i32.const 48) "invalid supply\00")
  (data (;3;) (i32.const 64) "max-supply must be positive\00")
  (data (;4;) (i32.const 96) "object passed to iterator_to is not in multi_index\00")
  (data (;5;) (i32.const 160) "token with symbol already exists\00")
  (data (;6;) (i32.const 208) "cannot create objects in table of another contract\00")
  (data (;7;) (i32.const 272) "write\00")
  (data (;8;) (i32.const 288) "magnitude of asset amount must be less than 2^62\00")
  (data (;9;) (i32.const 352) "error reading iterator\00")
  (data (;10;) (i32.const 384) "read\00")
  (data (;11;) (i32.const 400) "memo has more than 256 bytes\00")
  (data (;12;) (i32.const 432) "token with symbol does not exist, create token before issue\00")
  (data (;13;) (i32.const 496) "invalid quantity\00")
  (data (;14;) (i32.const 528) "must issue positive quantity\00")
  (data (;15;) (i32.const 560) "symbol precision mismatch\00")
  (data (;16;) (i32.const 592) "quantity exceeds available supply\00")
  (data (;17;) (i32.const 640) "object passed to modify is not in multi_index\00")
  (data (;18;) (i32.const 688) "cannot modify objects in table of another contract\00")
  (data (;19;) (i32.const 752) "attempt to add asset with different symbol\00")
  (data (;20;) (i32.const 800) "addition underflow\00")
  (data (;21;) (i32.const 832) "addition overflow\00")
  (data (;22;) (i32.const 864) "updater cannot change primary key when modifying an object\00")
  (data (;23;) (i32.const 928) "active\00")
  (data (;24;) (i32.const 944) "cannot pass end iterator to modify\00")
  (data (;25;) (i32.const 992) "cannot transfer to self\00")
  (data (;26;) (i32.const 1024) "to account does not exist\00")
  (data (;27;) (i32.const 1056) "unable to find key\00")
  (data (;28;) (i32.const 1088) "must transfer positive quantity\00")
  (data (;29;) (i32.const 1120) "no balance object found\00")
  (data (;30;) (i32.const 1152) "overdrawn balance\00")
  (data (;31;) (i32.const 1184) "attempt to subtract asset with different symbol\00")
  (data (;32;) (i32.const 1232) "subtraction underflow\00")
  (data (;33;) (i32.const 1264) "subtraction overflow\00")
  (data (;34;) (i32.const 1296) "object passed to erase is not in multi_index\00")
  (data (;35;) (i32.const 1344) "cannot erase objects in table of another contract\00")
  (data (;36;) (i32.const 1408) "attempt to remove object that was not in multi_index\00")
  (data (;37;) (i32.const 1472) "onerror\00")
  (data (;38;) (i32.const 1488) "eosio\00")
  (data (;39;) (i32.const 1504) "onerror action's are only valid from the \22eosio\22 system account\00")
  (data (;40;) (i32.const 1568) "get\00")
  (data (;41;) (i32.const 9984) "malloc_from_freed was designed to only be called after _heap was completely allocated\00"))
