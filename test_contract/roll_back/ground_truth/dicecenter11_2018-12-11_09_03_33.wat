(module
  (type (;0;) (func (param i32 i32)))
  (type (;1;) (func))
  (type (;2;) (func (param i32 i32 i32) (result i32)))
  (type (;3;) (func (param i32 i32 i32)))
  (type (;4;) (func (result i32)))
  (type (;5;) (func (param i32 i32) (result i32)))
  (type (;6;) (func (result i64)))
  (type (;7;) (func (param i64)))
  (type (;8;) (func (param i64 i64 i64 i64) (result i32)))
  (type (;9;) (func (param i32)))
  (type (;10;) (func (param i64 i64 i64 i32 i64) (result i32)))
  (type (;11;) (func (param i64 i64 i64 i32 i32) (result i32)))
  (type (;12;) (func (param i64 i64 i64 i64 i32 i32) (result i32)))
  (type (;13;) (func (param i64 i64 i64 i64 i32) (result i32)))
  (type (;14;) (func (param i32 i64 i64 i64 i64)))
  (type (;15;) (func (param i64 i64) (result i32)))
  (type (;16;) (func (param i32 f64)))
  (type (;17;) (func (param i32 f32)))
  (type (;18;) (func (param i64 i64) (result f64)))
  (type (;19;) (func (param i64 i64) (result f32)))
  (type (;20;) (func (param i64 i64 i64)))
  (type (;21;) (func (param i32 i32 i32 i32 i32)))
  (type (;22;) (func (param i64 i64 i32) (result i32)))
  (type (;23;) (func (param i32 i32 i32 i32)))
  (type (;24;) (func (param i32 i32 i64)))
  (type (;25;) (func (param i32 i32 i64 i32)))
  (type (;26;) (func (param i32) (result i32)))
  (type (;27;) (func (param i32 i64 i32) (result i32)))
  (type (;28;) (func (param i32 i32 i32 i32 i32) (result i32)))
  (type (;29;) (func (param i32 i32 i32 i32 i32 i32 i32 i32)))
  (type (;30;) (func (param i32 i32 i32 i32 i32 i32 i32)))
  (type (;31;) (func (param i32 i64)))
  (type (;32;) (func (param i32 i32 i32 i64) (result i64)))
  (import "env" "memcpy" (func (;0;) (type 2)))
  (import "env" "eosio_assert" (func (;1;) (type 0)))
  (import "env" "memset" (func (;2;) (type 2)))
  (import "env" "memmove" (func (;3;) (type 2)))
  (import "env" "ripemd160" (func (;4;) (type 3)))
  (import "env" "action_data_size" (func (;5;) (type 4)))
  (import "env" "read_action_data" (func (;6;) (type 5)))
  (import "env" "current_time" (func (;7;) (type 6)))
  (import "env" "send_inline" (func (;8;) (type 0)))
  (import "env" "require_auth" (func (;9;) (type 7)))
  (import "env" "db_lowerbound_i64" (func (;10;) (type 8)))
  (import "env" "db_next_i64" (func (;11;) (type 5)))
  (import "env" "transaction_size" (func (;12;) (type 4)))
  (import "env" "read_transaction" (func (;13;) (type 5)))
  (import "env" "sha256" (func (;14;) (type 3)))
  (import "env" "db_find_i64" (func (;15;) (type 8)))
  (import "env" "db_get_i64" (func (;16;) (type 2)))
  (import "env" "current_receiver" (func (;17;) (type 6)))
  (import "env" "db_remove_i64" (func (;18;) (type 9)))
  (import "env" "db_idx64_find_primary" (func (;19;) (type 10)))
  (import "env" "db_idx64_remove" (func (;20;) (type 9)))
  (import "env" "db_idx64_upperbound" (func (;21;) (type 11)))
  (import "env" "db_idx64_lowerbound" (func (;22;) (type 11)))
  (import "env" "db_idx64_next" (func (;23;) (type 5)))
  (import "env" "db_store_i64" (func (;24;) (type 12)))
  (import "env" "db_idx64_store" (func (;25;) (type 13)))
  (import "env" "abort" (func (;26;) (type 1)))
  (import "env" "prints_l" (func (;27;) (type 0)))
  (import "env" "__unordtf2" (func (;28;) (type 8)))
  (import "env" "__eqtf2" (func (;29;) (type 8)))
  (import "env" "__multf3" (func (;30;) (type 14)))
  (import "env" "__addtf3" (func (;31;) (type 14)))
  (import "env" "__subtf3" (func (;32;) (type 14)))
  (import "env" "__netf2" (func (;33;) (type 8)))
  (import "env" "__fixunstfsi" (func (;34;) (type 15)))
  (import "env" "__floatunsitf" (func (;35;) (type 0)))
  (import "env" "__fixtfsi" (func (;36;) (type 15)))
  (import "env" "__floatsitf" (func (;37;) (type 0)))
  (import "env" "__extenddftf2" (func (;38;) (type 16)))
  (import "env" "__extendsftf2" (func (;39;) (type 17)))
  (import "env" "__divtf3" (func (;40;) (type 14)))
  (import "env" "__letf2" (func (;41;) (type 8)))
  (import "env" "__trunctfdf2" (func (;42;) (type 18)))
  (import "env" "__getf2" (func (;43;) (type 8)))
  (import "env" "__trunctfsf2" (func (;44;) (type 19)))
  (import "env" "set_blockchain_parameters_packed" (func (;45;) (type 0)))
  (import "env" "get_blockchain_parameters_packed" (func (;46;) (type 5)))
  (func (;47;) (type 1))
  (func (;48;) (type 20) (param i64 i64 i64)
    (local i32 i32 i32 i32 i32)
    global.get 0
    i32.const 176
    i32.sub
    local.tee 3
    global.set 0
    call 47
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 1
              i64.const 6138663591592764928
              i64.eq
              br_if 0 (;@5;)
              local.get 1
              i64.const 6138663577826885632
              i64.ne
              br_if 1 (;@4;)
              local.get 2
              i64.const -6569208335818555392
              i64.ne
              br_if 1 (;@4;)
              local.get 3
              i32.const 96
              i32.add
              call 49
              local.get 3
              i32.load offset=112
              local.tee 4
              i32.eqz
              br_if 4 (;@1;)
              local.get 3
              i32.const 116
              i32.add
              local.get 4
              i32.store
              local.get 4
              call 88
              br 4 (;@1;)
            end
            local.get 2
            i64.const -3617168760277827584
            i64.ne
            br_if 0 (;@4;)
            local.get 3
            i32.const 120
            i32.add
            i32.const 0
            i32.store
            local.get 3
            i32.const 136
            i32.add
            local.get 0
            i64.store
            local.get 3
            i32.const 144
            i32.add
            i64.const -1
            i64.store
            local.get 3
            i32.const 152
            i32.add
            i64.const 0
            i64.store
            local.get 3
            i32.const 160
            i32.add
            i32.const 0
            i32.store
            local.get 3
            i32.const 164
            i32.add
            i32.const 0
            i32.store8
            local.get 3
            i64.const 6138663591592764928
            i64.store offset=104
            local.get 3
            local.get 0
            i64.store offset=96
            local.get 3
            i64.const 0
            i64.store offset=112
            local.get 3
            local.get 0
            i64.store offset=128
            local.get 3
            i32.const 48
            i32.add
            call 50
            block  ;; label = @5
              local.get 3
              i64.load offset=48
              local.get 0
              i64.eq
              br_if 0 (;@5;)
              local.get 3
              i64.load offset=56
              local.get 0
              i64.ne
              br_if 0 (;@5;)
              local.get 3
              i32.const 96
              i32.add
              local.get 3
              i32.const 48
              i32.add
              local.get 3
              i32.const 56
              i32.add
              local.get 3
              i32.const 64
              i32.add
              local.get 3
              i32.const 80
              i32.add
              call 51
            end
            block  ;; label = @5
              local.get 3
              i32.load8_u offset=80
              i32.const 1
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              local.get 3
              i32.const 88
              i32.add
              i32.load
              call 88
            end
            local.get 3
            i32.const 152
            i32.add
            i32.load
            local.tee 5
            i32.eqz
            br_if 3 (;@1;)
            local.get 3
            i32.const 156
            i32.add
            local.tee 6
            i32.load
            local.tee 4
            local.get 5
            i32.eq
            br_if 1 (;@3;)
            loop  ;; label = @5
              local.get 4
              i32.const -24
              i32.add
              local.tee 4
              i32.load
              local.set 7
              local.get 4
              i32.const 0
              i32.store
              block  ;; label = @6
                local.get 7
                i32.eqz
                br_if 0 (;@6;)
                block  ;; label = @7
                  local.get 7
                  i32.load8_u offset=80
                  i32.const 1
                  i32.and
                  i32.eqz
                  br_if 0 (;@7;)
                  local.get 7
                  i32.const 88
                  i32.add
                  i32.load
                  call 88
                end
                local.get 7
                call 88
              end
              local.get 5
              local.get 4
              i32.ne
              br_if 0 (;@5;)
            end
            local.get 3
            i32.const 152
            i32.add
            i32.load
            local.set 4
            br 2 (;@2;)
          end
          local.get 1
          local.get 0
          i64.ne
          br_if 2 (;@1;)
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              i64.const -4997502814317805568
              i64.eq
              br_if 0 (;@5;)
              local.get 2
              i64.const -4997502823608877056
              i64.eq
              br_if 1 (;@4;)
              local.get 2
              i64.const -5003315193367756800
              i64.ne
              br_if 4 (;@1;)
              local.get 3
              i32.const 0
              i32.store offset=44
              local.get 3
              i32.const 1
              i32.store offset=40
              local.get 3
              local.get 3
              i64.load offset=40
              i64.store
              local.get 1
              local.get 1
              local.get 3
              call 53
              drop
              br 4 (;@1;)
            end
            local.get 3
            i32.const 0
            i32.store offset=28
            local.get 3
            i32.const 2
            i32.store offset=24
            local.get 3
            local.get 3
            i64.load offset=24
            i64.store offset=16
            local.get 1
            local.get 1
            local.get 3
            i32.const 16
            i32.add
            call 55
            drop
            br 3 (;@1;)
          end
          local.get 3
          i32.const 0
          i32.store offset=36
          local.get 3
          i32.const 3
          i32.store offset=32
          local.get 3
          local.get 3
          i64.load offset=32
          i64.store offset=8
          local.get 1
          local.get 1
          local.get 3
          i32.const 8
          i32.add
          call 57
          drop
          br 2 (;@1;)
        end
        local.get 5
        local.set 4
      end
      local.get 6
      local.get 5
      i32.store
      local.get 4
      call 88
    end
    i32.const 0
    call 115
    local.get 3
    i32.const 176
    i32.add
    global.set 0)
  (func (;49;) (type 9) (param i32)
    (local i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 1
    local.set 2
    local.get 1
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        call 5
        local.tee 3
        i32.const 513
        i32.lt_u
        br_if 0 (;@2;)
        local.get 3
        call 127
        local.set 1
        br 1 (;@1;)
      end
      local.get 1
      local.get 3
      i32.const 15
      i32.add
      i32.const -16
      i32.and
      i32.sub
      local.tee 1
      global.set 0
    end
    local.get 1
    local.get 3
    call 6
    drop
    local.get 0
    i32.const 24
    i32.add
    i32.const 0
    i32.store
    local.get 0
    i64.const 0
    i64.store offset=16 align=4
    local.get 2
    local.get 1
    local.get 3
    i32.add
    i32.store offset=8
    local.get 2
    local.get 1
    i32.store
    local.get 3
    i32.const 15
    i32.gt_u
    i32.const 8429
    call 1
    local.get 0
    local.get 1
    i32.const 16
    call 0
    drop
    local.get 2
    local.get 1
    i32.const 16
    i32.add
    i32.store offset=4
    local.get 2
    local.get 0
    i32.const 16
    i32.add
    call 58
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;50;) (type 9) (param i32)
    (local i32 i32 i32)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 1
    local.set 2
    local.get 1
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        call 5
        local.tee 3
        i32.const 513
        i32.lt_u
        br_if 0 (;@2;)
        local.get 3
        call 127
        local.set 1
        br 1 (;@1;)
      end
      local.get 1
      local.get 3
      i32.const 15
      i32.add
      i32.const -16
      i32.and
      i32.sub
      local.tee 1
      global.set 0
    end
    local.get 1
    local.get 3
    call 6
    drop
    local.get 0
    i64.const 0
    i64.store offset=8
    local.get 0
    i64.const 0
    i64.store
    local.get 0
    i64.const 0
    i64.store offset=16
    local.get 0
    i32.const 24
    i32.add
    i64.const 0
    i64.store
    local.get 0
    i64.const 0
    i64.store offset=32 align=4
    local.get 0
    i32.const 40
    i32.add
    i32.const 0
    i32.store
    local.get 2
    local.get 1
    i32.store offset=12
    local.get 2
    local.get 1
    i32.store offset=8
    local.get 2
    local.get 1
    local.get 3
    i32.add
    i32.store offset=16
    local.get 2
    local.get 2
    i32.const 8
    i32.add
    i32.store offset=24
    local.get 2
    local.get 0
    i32.const 8
    i32.add
    i32.store offset=36
    local.get 2
    local.get 0
    i32.store offset=32
    local.get 2
    local.get 0
    i32.const 16
    i32.add
    i32.store offset=40
    local.get 2
    local.get 0
    i32.const 32
    i32.add
    i32.store offset=44
    local.get 2
    i32.const 32
    i32.add
    local.get 2
    i32.const 24
    i32.add
    call 59
    local.get 2
    i32.const 48
    i32.add
    global.set 0)
  (func (;51;) (type 21) (param i32 i32 i32 i32 i32)
    (local i32 i64 i32 i64 i32 i32 i32 i32 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i64 i32 i32 f64)
    global.get 0
    i32.const 304
    i32.sub
    local.tee 5
    global.set 0
    block  ;; label = @1
      local.get 1
      i64.load
      local.get 0
      i64.load
      local.tee 6
      i64.eq
      br_if 0 (;@1;)
      local.get 2
      i64.load
      local.get 6
      i64.ne
      br_if 0 (;@1;)
      block  ;; label = @2
        i32.const 8328
        call 124
        local.tee 7
        local.get 4
        i32.load offset=4
        local.get 4
        i32.load8_u
        local.tee 2
        i32.const 1
        i32.shr_u
        local.get 2
        i32.const 1
        i32.and
        select
        i32.ne
        br_if 0 (;@2;)
        local.get 4
        i32.const 0
        i32.const -1
        i32.const 8328
        local.get 7
        call 105
        i32.eqz
        br_if 1 (;@1;)
      end
      local.get 5
      i32.const 224
      i32.add
      call 60
      local.get 0
      local.get 5
      i32.const 208
      i32.add
      local.get 4
      call 95
      local.tee 4
      local.get 5
      i32.const 268
      i32.add
      local.get 5
      i32.const 264
      i32.add
      call 61
      block  ;; label = @2
        local.get 4
        i32.load8_u
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 4
        i32.load offset=8
        call 88
      end
      local.get 3
      i64.load offset=8
      i64.const 1397703940
      i64.eq
      i32.const 8657
      call 1
      i32.const 0
      local.set 2
      block  ;; label = @2
        local.get 3
        i64.load
        i64.const 4611686018427387903
        i64.add
        i64.const 9223372036854775806
        i64.gt_u
        br_if 0 (;@2;)
        local.get 3
        i32.const 8
        i32.add
        i64.load
        i64.const 8
        i64.shr_u
        local.set 6
        i32.const 0
        local.set 4
        block  ;; label = @3
          loop  ;; label = @4
            local.get 6
            i32.wrap_i64
            i32.const 24
            i32.shl
            i32.const -1073741825
            i32.add
            i32.const 452984830
            i32.gt_u
            br_if 1 (;@3;)
            local.get 6
            i64.const 8
            i64.shr_u
            local.set 8
            block  ;; label = @5
              local.get 6
              i64.const 65280
              i64.and
              i64.const 0
              i64.eq
              br_if 0 (;@5;)
              local.get 8
              local.set 6
              i32.const 1
              local.set 2
              local.get 4
              local.tee 7
              i32.const 1
              i32.add
              local.set 4
              local.get 7
              i32.const 6
              i32.lt_s
              br_if 1 (;@4;)
              br 3 (;@2;)
            end
            local.get 8
            local.set 6
            loop  ;; label = @5
              local.get 6
              i64.const 65280
              i64.and
              i64.const 0
              i64.ne
              br_if 2 (;@3;)
              local.get 6
              i64.const 8
              i64.shr_u
              local.set 6
              local.get 4
              i32.const 6
              i32.lt_s
              local.set 2
              local.get 4
              i32.const 1
              i32.add
              local.tee 7
              local.set 4
              local.get 2
              br_if 0 (;@5;)
            end
            i32.const 1
            local.set 2
            local.get 7
            i32.const 1
            i32.add
            local.set 4
            local.get 7
            i32.const 6
            i32.lt_s
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        i32.const 0
        local.set 2
      end
      local.get 2
      i32.const 8680
      call 1
      local.get 3
      i64.load
      i64.const 999
      i64.gt_s
      i32.const 8697
      call 1
      local.get 0
      call 62
      local.get 5
      i32.const 152
      i32.add
      i64.const 0
      i64.store
      local.get 5
      i32.const 168
      i32.add
      i64.const 0
      i64.store
      local.get 5
      i32.const 192
      i32.add
      i32.const 0
      i32.store
      local.get 5
      i32.const 104
      i32.add
      i32.const 32
      i32.add
      local.get 3
      i32.const 8
      i32.add
      i64.load
      i64.store
      local.get 5
      i64.const 0
      i64.store offset=144
      local.get 5
      i64.const 0
      i64.store offset=160
      local.get 5
      i64.const 0
      i64.store offset=184
      local.get 5
      local.get 1
      i64.load
      i64.store offset=120
      local.get 5
      local.get 3
      i64.load
      i64.store offset=128
      local.get 5
      local.get 5
      i64.load8_u offset=225
      i64.const 16
      i64.shl
      local.get 5
      i32.load8_u offset=224
      local.tee 4
      i64.extend_i32_u
      i64.const 24
      i64.shl
      i64.or
      local.get 5
      i64.load8_u offset=226
      i64.const 8
      i64.shl
      i64.or
      local.get 5
      i64.load8_u offset=227
      i64.or
      i64.store offset=112
      local.get 5
      local.get 5
      i32.load offset=268
      i32.store offset=176
      local.get 5
      i32.const 0
      i32.store offset=24
      local.get 5
      i64.const 0
      i64.store offset=16
      local.get 5
      i32.const 16
      i32.add
      local.get 4
      i32.const 4
      i32.shr_u
      i32.const 8192
      i32.add
      i32.load8_s
      call 102
      local.get 5
      i32.const 16
      i32.add
      local.get 4
      i32.const 15
      i32.and
      i32.const 8192
      i32.add
      i32.load8_s
      call 102
      local.get 5
      i32.const 176
      i32.add
      local.set 9
      local.get 5
      i32.const 128
      i32.add
      local.set 10
      local.get 5
      i32.const 120
      i32.add
      local.set 11
      local.get 5
      i32.const 104
      i32.add
      i32.const 8
      i32.add
      local.set 12
      i32.const 1
      local.set 4
      loop  ;; label = @2
        local.get 5
        i32.const 16
        i32.add
        local.get 5
        i32.const 224
        i32.add
        local.get 4
        i32.add
        i32.load8_u
        local.tee 2
        i32.const 4
        i32.shr_u
        i32.const 8192
        i32.add
        i32.load8_s
        call 102
        local.get 5
        i32.const 16
        i32.add
        local.get 2
        i32.const 15
        i32.and
        i32.const 8192
        i32.add
        i32.load8_s
        call 102
        local.get 4
        i32.const 1
        i32.add
        local.tee 4
        i32.const 32
        i32.ne
        br_if 0 (;@2;)
      end
      local.get 5
      i32.const 184
      i32.add
      local.set 3
      block  ;; label = @2
        block  ;; label = @3
          local.get 5
          i32.load8_u offset=184
          i32.const 1
          i32.and
          br_if 0 (;@3;)
          local.get 3
          i32.const 0
          i32.store16
          br 1 (;@2;)
        end
        local.get 5
        i32.const 192
        i32.add
        i32.load
        i32.const 0
        i32.store8
        local.get 5
        i32.const 188
        i32.add
        i32.const 0
        i32.store
      end
      local.get 3
      i32.const 0
      call 99
      local.get 3
      i32.const 8
      i32.add
      local.get 5
      i32.const 16
      i32.add
      i32.const 8
      i32.add
      local.tee 4
      i32.load
      i32.store
      local.get 3
      local.get 5
      i64.load offset=16
      i64.store align=4
      call 7
      local.set 6
      local.get 5
      local.get 5
      i32.load offset=264
      i32.store offset=104
      local.get 5
      local.get 6
      i64.const 1000000
      i64.div_u
      i64.const 4294967295
      i64.and
      i64.store offset=200
      local.get 5
      i32.const 16
      i32.add
      local.get 0
      local.get 1
      i64.load
      call 63
      local.get 5
      i32.const 168
      i32.add
      local.get 4
      i64.load
      i64.store
      local.get 5
      local.get 5
      i64.load offset=16
      i64.store offset=160
      local.get 5
      i64.load8_u offset=254
      local.set 6
      local.get 5
      i64.load8_u offset=255
      local.set 8
      local.get 5
      i64.load8_u offset=253
      local.set 13
      local.get 5
      i64.load8_u offset=252
      local.set 14
      local.get 5
      i64.load8_u offset=250
      local.set 15
      local.get 5
      i64.load8_u offset=251
      local.set 16
      local.get 5
      i64.load8_u offset=249
      local.set 17
      local.get 5
      i64.load8_u offset=248
      local.set 18
      local.get 5
      i64.load8_u offset=246
      local.set 19
      local.get 5
      i64.load8_u offset=247
      local.set 20
      local.get 5
      i64.load8_u offset=245
      local.set 21
      local.get 5
      i64.load8_u offset=244
      local.set 22
      local.get 5
      i64.load8_u offset=242
      local.set 23
      local.get 5
      i64.load8_u offset=243
      local.set 24
      local.get 5
      i64.load8_u offset=241
      local.set 25
      local.get 5
      i64.load8_u offset=240
      local.set 26
      local.get 5
      i64.load8_u offset=238
      local.set 27
      local.get 5
      i64.load8_u offset=239
      local.set 28
      local.get 5
      i64.load8_u offset=237
      local.set 29
      local.get 5
      i64.load8_u offset=236
      local.set 30
      local.get 5
      i64.load8_u offset=234
      local.set 31
      local.get 5
      i64.load8_u offset=235
      local.set 32
      local.get 5
      i64.load8_u offset=233
      local.set 33
      local.get 5
      i64.load8_u offset=232
      local.set 34
      local.get 5
      i64.load8_u offset=230
      local.set 35
      local.get 5
      i64.load8_u offset=231
      local.set 36
      local.get 5
      i64.load8_u offset=226
      local.set 37
      local.get 5
      i64.load8_u offset=227
      local.set 38
      local.get 5
      i64.load8_u offset=225
      local.set 39
      local.get 5
      i64.load8_u offset=224
      local.set 40
      local.get 5
      i64.load8_u offset=229
      local.set 41
      local.get 5
      i64.load8_u offset=228
      local.set 42
      i32.const 1
      i32.const 8921
      call 1
      local.get 8
      local.get 13
      i64.const 16
      i64.shl
      local.get 14
      i64.const 24
      i64.shl
      i64.or
      i64.or
      local.get 6
      i64.const 8
      i64.shl
      i64.or
      local.get 16
      local.get 17
      i64.const 16
      i64.shl
      local.get 18
      i64.const 24
      i64.shl
      i64.or
      i64.or
      local.get 15
      i64.const 8
      i64.shl
      i64.or
      local.get 20
      local.get 21
      i64.const 16
      i64.shl
      local.get 22
      i64.const 24
      i64.shl
      i64.or
      i64.or
      local.get 19
      i64.const 8
      i64.shl
      i64.or
      local.get 24
      local.get 25
      i64.const 16
      i64.shl
      local.get 26
      i64.const 24
      i64.shl
      i64.or
      i64.or
      local.get 23
      i64.const 8
      i64.shl
      i64.or
      local.get 28
      local.get 29
      i64.const 16
      i64.shl
      local.get 30
      i64.const 24
      i64.shl
      i64.or
      i64.or
      local.get 27
      i64.const 8
      i64.shl
      i64.or
      local.get 32
      local.get 33
      i64.const 16
      i64.shl
      local.get 34
      i64.const 24
      i64.shl
      i64.or
      i64.or
      local.get 31
      i64.const 8
      i64.shl
      i64.or
      local.get 36
      local.get 41
      i64.const 16
      i64.shl
      local.get 42
      i64.const 24
      i64.shl
      i64.or
      local.get 38
      local.get 39
      i64.const 16
      i64.shl
      local.get 40
      i64.const 24
      i64.shl
      i64.or
      i64.or
      local.get 37
      i64.const 8
      i64.shl
      i64.or
      i64.const 6
      i64.rem_u
      i64.const 32
      i64.shl
      i64.or
      i64.or
      local.get 35
      i64.const 8
      i64.shl
      i64.or
      i64.const 6
      i64.rem_u
      i64.const 32
      i64.shl
      i64.or
      i64.const 6
      i64.rem_u
      i64.const 32
      i64.shl
      i64.or
      i64.const 6
      i64.rem_u
      i64.const 32
      i64.shl
      i64.or
      i64.const 6
      i64.rem_u
      i64.const 32
      i64.shl
      i64.or
      i64.const 6
      i64.rem_u
      i64.const 32
      i64.shl
      i64.or
      i64.const 6
      i64.rem_u
      i64.const 32
      i64.shl
      i64.or
      i64.const 6
      i64.rem_u
      i32.wrap_i64
      i32.const 1
      i32.add
      local.set 1
      local.get 5
      i32.const 160
      i32.add
      local.set 43
      local.get 5
      i32.const 200
      i32.add
      local.set 44
      i64.const 5459781
      local.set 6
      i32.const 0
      local.set 4
      block  ;; label = @2
        block  ;; label = @3
          loop  ;; label = @4
            local.get 6
            i32.wrap_i64
            i32.const 24
            i32.shl
            i32.const -1073741825
            i32.add
            i32.const 452984830
            i32.gt_u
            br_if 1 (;@3;)
            local.get 6
            i64.const 8
            i64.shr_u
            local.set 8
            block  ;; label = @5
              local.get 6
              i64.const 65280
              i64.and
              i64.const 0
              i64.eq
              br_if 0 (;@5;)
              local.get 8
              local.set 6
              i32.const 1
              local.set 2
              local.get 4
              local.tee 7
              i32.const 1
              i32.add
              local.set 4
              local.get 7
              i32.const 6
              i32.lt_s
              br_if 1 (;@4;)
              br 3 (;@2;)
            end
            local.get 8
            local.set 6
            loop  ;; label = @5
              local.get 6
              i64.const 65280
              i64.and
              i64.const 0
              i64.ne
              br_if 2 (;@3;)
              local.get 6
              i64.const 8
              i64.shr_u
              local.set 6
              local.get 4
              i32.const 6
              i32.lt_s
              local.set 2
              local.get 4
              i32.const 1
              i32.add
              local.tee 7
              local.set 4
              local.get 2
              br_if 0 (;@5;)
            end
            i32.const 1
            local.set 2
            local.get 7
            i32.const 1
            i32.add
            local.set 4
            local.get 7
            i32.const 6
            i32.lt_s
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        i32.const 0
        local.set 2
      end
      local.get 2
      i32.const 8970
      call 1
      i64.const 1397703940
      local.set 8
      i64.const 0
      local.set 13
      block  ;; label = @2
        local.get 1
        local.get 5
        i32.const 176
        i32.add
        i32.load
        local.tee 4
        i32.ge_u
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 4
            i32.const 2
            i32.shl
            i32.const 8984
            i32.add
            f32.load
            f64.promote_f32
            local.get 5
            i32.const 128
            i32.add
            i64.load
            f64.convert_i64_s
            f64.mul
            local.tee 45
            f64.abs
            f64.const 0x1p+63 (;=9.22337e+18;)
            f64.lt
            br_if 0 (;@4;)
            i64.const -9223372036854775808
            local.set 13
            br 1 (;@3;)
          end
          local.get 45
          i64.trunc_f64_s
          local.set 13
        end
        local.get 5
        i32.const 136
        i32.add
        i64.load
        local.set 8
        local.get 13
        i64.const 4611686018427387903
        i64.add
        i64.const 9223372036854775807
        i64.lt_u
        i32.const 8921
        call 1
        local.get 8
        i64.const 8
        i64.shr_u
        local.set 6
        i32.const 0
        local.set 4
        block  ;; label = @3
          block  ;; label = @4
            loop  ;; label = @5
              local.get 6
              i32.wrap_i64
              i32.const 24
              i32.shl
              i32.const -1073741825
              i32.add
              i32.const 452984830
              i32.gt_u
              br_if 1 (;@4;)
              local.get 6
              i64.const 8
              i64.shr_u
              local.set 14
              block  ;; label = @6
                local.get 6
                i64.const 65280
                i64.and
                i64.const 0
                i64.eq
                br_if 0 (;@6;)
                local.get 14
                local.set 6
                i32.const 1
                local.set 2
                local.get 4
                local.tee 7
                i32.const 1
                i32.add
                local.set 4
                local.get 7
                i32.const 6
                i32.lt_s
                br_if 1 (;@5;)
                br 3 (;@3;)
              end
              local.get 14
              local.set 6
              loop  ;; label = @6
                local.get 6
                i64.const 65280
                i64.and
                i64.const 0
                i64.ne
                br_if 2 (;@4;)
                local.get 6
                i64.const 8
                i64.shr_u
                local.set 6
                local.get 4
                i32.const 6
                i32.lt_s
                local.set 2
                local.get 4
                i32.const 1
                i32.add
                local.tee 7
                local.set 4
                local.get 2
                br_if 0 (;@6;)
              end
              i32.const 1
              local.set 2
              local.get 7
              i32.const 1
              i32.add
              local.set 4
              local.get 7
              i32.const 6
              i32.lt_s
              br_if 0 (;@5;)
              br 2 (;@3;)
            end
          end
          i32.const 0
          local.set 2
        end
        local.get 2
        i32.const 8970
        call 1
        local.get 0
        i64.load
        local.set 6
        local.get 5
        local.get 0
        local.get 5
        i32.const 104
        i32.add
        call 64
        local.get 5
        i32.const 16
        i32.add
        i32.const 24
        i32.add
        local.get 8
        i64.store
        local.get 5
        i32.const 56
        i32.add
        local.get 5
        i32.const 8
        i32.add
        local.tee 4
        i32.load
        i32.store
        local.get 4
        i32.const 0
        i32.store
        local.get 5
        local.get 13
        i64.store offset=32
        local.get 5
        i64.const 6138663591592764928
        i64.store offset=64
        local.get 5
        i64.const -3617168760277827584
        i64.store offset=72
        local.get 5
        local.get 0
        i64.load
        i64.store offset=16
        local.get 5
        local.get 5
        i32.const 104
        i32.add
        i32.const 16
        i32.add
        i64.load
        i64.store offset=24
        local.get 5
        local.get 5
        i64.load
        i64.store offset=48
        local.get 5
        i64.const 0
        i64.store
        i32.const 16
        call 86
        local.tee 4
        local.get 6
        i64.store
        local.get 4
        i64.const 3617214756542218240
        i64.store offset=8
        local.get 5
        i32.const 64
        i32.add
        i32.const 36
        i32.add
        i32.const 0
        i32.store
        local.get 5
        i32.const 64
        i32.add
        i32.const 24
        i32.add
        local.get 4
        i32.const 16
        i32.add
        local.tee 2
        i32.store
        local.get 5
        i32.const 84
        i32.add
        local.get 2
        i32.store
        local.get 5
        local.get 4
        i32.store offset=80
        local.get 5
        i64.const 0
        i64.store offset=92 align=4
        local.get 5
        i32.const 16
        i32.add
        i32.const 36
        i32.add
        i32.load
        local.get 5
        i32.load8_u offset=48
        local.tee 4
        i32.const 1
        i32.shr_u
        local.get 4
        i32.const 1
        i32.and
        select
        local.tee 2
        i32.const 32
        i32.add
        local.set 4
        local.get 2
        i64.extend_i32_u
        local.set 6
        local.get 5
        i32.const 92
        i32.add
        local.set 2
        loop  ;; label = @3
          local.get 4
          i32.const 1
          i32.add
          local.set 4
          local.get 6
          i64.const 7
          i64.shr_u
          local.tee 6
          i64.const 0
          i64.ne
          br_if 0 (;@3;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 4
            i32.eqz
            br_if 0 (;@4;)
            local.get 2
            local.get 4
            call 65
            local.get 5
            i32.const 96
            i32.add
            i32.load
            local.set 2
            local.get 5
            i32.const 92
            i32.add
            i32.load
            local.set 4
            br 1 (;@3;)
          end
          i32.const 0
          local.set 2
          i32.const 0
          local.set 4
        end
        local.get 5
        local.get 4
        i32.store offset=292
        local.get 5
        local.get 4
        i32.store offset=288
        local.get 5
        local.get 2
        i32.store offset=296
        local.get 5
        local.get 5
        i32.const 288
        i32.add
        i32.store offset=272
        local.get 5
        local.get 5
        i32.const 16
        i32.add
        i32.store offset=280
        local.get 5
        i32.const 280
        i32.add
        local.get 5
        i32.const 272
        i32.add
        call 66
        local.get 5
        i32.const 288
        i32.add
        local.get 5
        i32.const 64
        i32.add
        call 67
        local.get 5
        i32.load offset=288
        local.tee 4
        local.get 5
        i32.load offset=292
        local.get 4
        i32.sub
        call 8
        block  ;; label = @3
          local.get 5
          i32.load offset=288
          local.tee 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 5
          local.get 4
          i32.store offset=292
          local.get 4
          call 88
        end
        block  ;; label = @3
          local.get 5
          i32.load offset=92
          local.tee 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 5
          i32.const 96
          i32.add
          local.get 4
          i32.store
          local.get 4
          call 88
        end
        block  ;; label = @3
          local.get 5
          i32.load offset=80
          local.tee 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 5
          i32.const 84
          i32.add
          local.get 4
          i32.store
          local.get 4
          call 88
        end
        block  ;; label = @3
          local.get 5
          i32.const 48
          i32.add
          i32.load8_u
          i32.const 1
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 5
          i32.const 56
          i32.add
          i32.load
          call 88
        end
        local.get 5
        i32.load8_u
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 5
        i32.const 8
        i32.add
        i32.load
        call 88
      end
      local.get 5
      i32.const 144
      i32.add
      local.get 13
      i64.store
      local.get 5
      i32.const 152
      i32.add
      local.get 8
      i64.store
      local.get 5
      local.get 1
      i32.store offset=180
      local.get 8
      local.get 5
      i32.const 168
      i32.add
      i64.load
      i64.eq
      i32.const 9091
      call 1
      local.get 5
      i32.const 160
      i32.add
      local.tee 4
      local.get 4
      i64.load
      local.get 13
      i64.add
      local.tee 6
      i64.store
      local.get 6
      i64.const -4611686018427387904
      i64.gt_s
      i32.const 9134
      call 1
      local.get 4
      i64.load
      i64.const 4611686018427387904
      i64.lt_s
      i32.const 9153
      call 1
      local.get 0
      i64.load
      local.set 6
      local.get 5
      local.get 5
      i32.const 104
      i32.add
      i32.store offset=64
      local.get 5
      i32.const 16
      i32.add
      local.get 0
      i32.const 32
      i32.add
      local.get 6
      local.get 5
      i32.const 64
      i32.add
      call 68
      local.get 5
      i64.const -5003315193367756800
      i64.store offset=72
      local.get 5
      local.get 0
      i64.load
      local.tee 6
      i64.store offset=64
      i32.const 16
      call 86
      local.tee 4
      local.get 6
      i64.store
      local.get 4
      i64.const 3617214756542218240
      i64.store offset=8
      local.get 5
      i32.const 100
      i32.add
      i32.const 0
      i32.store
      local.get 5
      i32.const 88
      i32.add
      local.get 4
      i32.const 16
      i32.add
      local.tee 2
      i32.store
      local.get 5
      i32.const 84
      i32.add
      local.get 2
      i32.store
      local.get 5
      local.get 4
      i32.store offset=80
      local.get 5
      i64.const 0
      i64.store offset=92 align=4
      local.get 5
      i32.const 104
      i32.add
      i32.const 84
      i32.add
      i32.load
      local.get 5
      i32.const 184
      i32.add
      i32.load8_u
      local.tee 4
      i32.const 1
      i32.shr_u
      local.get 4
      i32.const 1
      i32.and
      select
      local.tee 2
      i32.const 84
      i32.add
      local.set 4
      local.get 2
      i64.extend_i32_u
      local.set 6
      local.get 5
      i32.const 92
      i32.add
      local.set 7
      local.get 5
      i32.const 180
      i32.add
      local.set 2
      loop  ;; label = @2
        local.get 4
        i32.const 1
        i32.add
        local.set 4
        local.get 6
        i64.const 7
        i64.shr_u
        local.tee 6
        i64.const 0
        i64.ne
        br_if 0 (;@2;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 7
          local.get 4
          call 65
          local.get 5
          i32.const 96
          i32.add
          i32.load
          local.set 7
          local.get 5
          i32.const 92
          i32.add
          i32.load
          local.set 4
          br 1 (;@2;)
        end
        i32.const 0
        local.set 7
        i32.const 0
        local.set 4
      end
      local.get 5
      local.get 4
      i32.store offset=292
      local.get 5
      local.get 4
      i32.store offset=288
      local.get 5
      local.get 7
      i32.store offset=296
      local.get 5
      local.get 5
      i32.const 288
      i32.add
      i32.store
      local.get 5
      local.get 12
      i32.store offset=20
      local.get 5
      local.get 11
      i32.store offset=24
      local.get 5
      local.get 10
      i32.store offset=28
      local.get 5
      local.get 5
      i32.const 144
      i32.add
      i32.store offset=32
      local.get 5
      local.get 43
      i32.store offset=36
      local.get 5
      local.get 9
      i32.store offset=40
      local.get 5
      local.get 2
      i32.store offset=44
      local.get 5
      local.get 3
      i32.store offset=48
      local.get 5
      local.get 44
      i32.store offset=52
      local.get 5
      local.get 5
      i32.const 104
      i32.add
      i32.store offset=16
      local.get 5
      i32.const 16
      i32.add
      local.get 5
      call 69
      local.get 5
      i32.const 16
      i32.add
      local.get 5
      i32.const 64
      i32.add
      call 67
      local.get 5
      i32.load offset=16
      local.tee 4
      local.get 5
      i32.load offset=20
      local.get 4
      i32.sub
      call 8
      block  ;; label = @2
        local.get 5
        i32.load offset=16
        local.tee 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 5
        local.get 4
        i32.store offset=20
        local.get 4
        call 88
      end
      block  ;; label = @2
        local.get 5
        i32.load offset=92
        local.tee 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 5
        i32.const 96
        i32.add
        local.get 4
        i32.store
        local.get 4
        call 88
      end
      block  ;; label = @2
        local.get 5
        i32.load offset=80
        local.tee 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 5
        i32.const 84
        i32.add
        local.get 4
        i32.store
        local.get 4
        call 88
      end
      local.get 5
      i32.const 184
      i32.add
      i32.load8_u
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 5
      i32.const 192
      i32.add
      i32.load
      call 88
    end
    local.get 5
    i32.const 304
    i32.add
    global.set 0)
  (func (;52;) (type 0) (param i32 i32)
    local.get 0
    i64.load
    call 9)
  (func (;53;) (type 22) (param i64 i64 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i64)
    global.get 0
    i32.const 352
    i32.sub
    local.tee 3
    local.set 4
    local.get 3
    global.set 0
    local.get 2
    i32.load offset=4
    local.set 5
    local.get 2
    i32.load
    local.set 6
    i32.const 0
    local.set 2
    block  ;; label = @1
      call 5
      local.tee 7
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 7
          i32.const 513
          i32.lt_u
          br_if 0 (;@3;)
          local.get 7
          call 127
          local.set 2
          br 1 (;@2;)
        end
        local.get 3
        local.get 7
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        local.tee 2
        global.set 0
      end
      local.get 2
      local.get 7
      call 6
      drop
    end
    local.get 4
    i32.const 112
    i32.add
    i32.const 0
    i32.const 104
    call 2
    drop
    local.get 4
    i32.const 144
    i32.add
    i64.const 0
    i64.store
    local.get 4
    i32.const 112
    i32.add
    i32.const 48
    i32.add
    i64.const 0
    i64.store
    local.get 4
    i32.const 112
    i32.add
    i32.const 64
    i32.add
    i64.const 0
    i64.store
    local.get 4
    i32.const 200
    i32.add
    i32.const 0
    i32.store
    local.get 4
    i64.const 0
    i64.store offset=136
    local.get 4
    i64.const 0
    i64.store offset=128
    local.get 4
    i64.const 0
    i64.store offset=152
    local.get 4
    i64.const 0
    i64.store offset=168
    local.get 4
    i64.const 0
    i64.store offset=192
    local.get 4
    local.get 2
    i32.store offset=100
    local.get 4
    local.get 2
    i32.store offset=96
    local.get 4
    local.get 2
    local.get 7
    i32.add
    i32.store offset=104
    local.get 4
    local.get 4
    i32.const 96
    i32.add
    i32.store offset=24
    local.get 4
    local.get 4
    i32.const 112
    i32.add
    i32.const 8
    i32.add
    i32.store offset=252
    local.get 4
    local.get 4
    i32.const 128
    i32.add
    i32.store offset=256
    local.get 4
    local.get 4
    i32.const 112
    i32.add
    i32.const 24
    i32.add
    i32.store offset=260
    local.get 4
    local.get 4
    i32.const 112
    i32.add
    i32.const 40
    i32.add
    i32.store offset=264
    local.get 4
    local.get 4
    i32.const 112
    i32.add
    i32.const 56
    i32.add
    i32.store offset=268
    local.get 4
    local.get 4
    i32.const 184
    i32.add
    i32.store offset=272
    local.get 4
    local.get 4
    i32.const 188
    i32.add
    i32.store offset=276
    local.get 4
    local.get 4
    i32.const 208
    i32.add
    i32.store offset=284
    local.get 4
    local.get 4
    i32.const 112
    i32.add
    i32.store offset=248
    local.get 4
    local.get 4
    i32.const 112
    i32.add
    i32.const 80
    i32.add
    local.tee 3
    i32.store offset=280
    local.get 4
    i32.const 248
    i32.add
    local.get 4
    i32.const 24
    i32.add
    call 70
    local.get 4
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    local.tee 8
    local.get 4
    i32.load offset=104
    i32.store
    local.get 4
    local.get 4
    i64.load offset=96
    i64.store offset=8
    local.get 4
    i32.const 216
    i32.add
    i32.const 8
    i32.add
    local.get 8
    i32.load
    local.tee 8
    i32.store
    local.get 4
    i32.const 232
    i32.add
    i32.const 8
    i32.add
    local.tee 9
    local.get 8
    i32.store
    local.get 4
    local.get 4
    i64.load offset=8
    local.tee 10
    i64.store offset=232
    local.get 4
    local.get 10
    i64.store offset=216
    local.get 4
    i32.const 248
    i32.add
    i32.const 8
    i32.add
    local.get 9
    i32.load
    local.tee 8
    i32.store
    local.get 4
    i32.const 24
    i32.add
    i32.const 24
    i32.add
    local.get 8
    i32.store
    local.get 4
    local.get 0
    i64.store offset=24
    local.get 4
    local.get 1
    i64.store offset=32
    local.get 4
    local.get 4
    i64.load offset=232
    local.tee 1
    i64.store offset=40
    local.get 4
    local.get 1
    i64.store offset=248
    local.get 4
    i32.const 24
    i32.add
    i32.const 40
    i32.add
    local.get 0
    i64.store
    local.get 4
    i32.const 24
    i32.add
    i32.const 48
    i32.add
    i64.const -1
    i64.store
    local.get 4
    i32.const 24
    i32.add
    i32.const 56
    i32.add
    i64.const 0
    i64.store
    local.get 4
    i32.const 24
    i32.add
    i32.const 64
    i32.add
    i32.const 0
    i32.store
    local.get 4
    i32.const 92
    i32.add
    i32.const 0
    i32.store8
    local.get 4
    local.get 0
    i64.store offset=56
    local.get 4
    i32.const 248
    i32.add
    local.get 4
    i32.const 112
    i32.add
    i32.const 80
    call 0
    drop
    local.get 4
    i32.const 248
    i32.add
    i32.const 80
    i32.add
    local.get 3
    call 95
    local.set 8
    local.get 4
    local.get 4
    i64.load offset=208
    i64.store offset=344
    local.get 4
    i32.const 24
    i32.add
    local.get 5
    i32.const 1
    i32.shr_s
    i32.add
    local.set 3
    block  ;; label = @1
      local.get 5
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 3
      i32.load
      local.get 6
      i32.add
      i32.load
      local.set 6
    end
    local.get 3
    local.get 4
    i32.const 248
    i32.add
    local.get 6
    call_indirect (type 0)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 8
              i32.load8_u
              i32.const 1
              i32.and
              br_if 0 (;@5;)
              local.get 7
              i32.const 513
              i32.ge_u
              br_if 1 (;@4;)
              br 2 (;@3;)
            end
            local.get 4
            i32.const 336
            i32.add
            i32.load
            call 88
            local.get 7
            i32.const 513
            i32.lt_u
            br_if 1 (;@3;)
          end
          local.get 2
          call 130
          local.get 4
          i32.const 80
          i32.add
          i32.load
          local.tee 5
          i32.eqz
          br_if 2 (;@1;)
          br 1 (;@2;)
        end
        local.get 4
        i32.const 80
        i32.add
        i32.load
        local.tee 5
        i32.eqz
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          i32.const 84
          i32.add
          local.tee 6
          i32.load
          local.tee 2
          local.get 5
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 2
            i32.const -24
            i32.add
            local.tee 2
            i32.load
            local.set 7
            local.get 2
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 7
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 7
                i32.load8_u offset=80
                i32.const 1
                i32.and
                i32.eqz
                br_if 0 (;@6;)
                local.get 7
                i32.const 88
                i32.add
                i32.load
                call 88
              end
              local.get 7
              call 88
            end
            local.get 5
            local.get 2
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 4
          i32.const 80
          i32.add
          i32.load
          local.set 2
          br 1 (;@2;)
        end
        local.get 5
        local.set 2
      end
      local.get 6
      local.get 5
      i32.store
      local.get 2
      call 88
    end
    block  ;; label = @1
      local.get 4
      i32.const 192
      i32.add
      i32.load8_u
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      i32.const 200
      i32.add
      i32.load
      call 88
    end
    local.get 4
    i32.const 352
    i32.add
    global.set 0
    i32.const 1)
  (func (;54;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i64.load
    call 9
    block  ;; label = @1
      local.get 0
      i64.load offset=32
      local.get 0
      i32.const 40
      i32.add
      i64.load
      i64.const 4229443000054317056
      i64.const 0
      call 10
      local.tee 3
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      i32.const 32
      i32.add
      local.tee 4
      local.get 3
      call 73
      local.set 0
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      i32.const 1
      local.get 1
      i32.sub
      local.set 5
      loop  ;; label = @2
        local.get 5
        local.set 3
        i32.const 0
        local.set 1
        local.get 0
        i32.const 0
        i32.ne
        local.tee 5
        i32.const 8740
        call 1
        local.get 5
        i32.const 8774
        call 1
        block  ;; label = @3
          local.get 0
          i32.load offset=108
          local.get 2
          i32.const 8
          i32.add
          call 11
          local.tee 5
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          local.get 4
          local.get 5
          call 73
          local.set 1
        end
        local.get 4
        local.get 0
        call 72
        local.get 1
        i32.eqz
        br_if 1 (;@1;)
        local.get 3
        i32.const 1
        i32.add
        local.set 5
        local.get 1
        local.set 0
        local.get 3
        br_if 0 (;@2;)
      end
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;55;) (type 22) (param i64 i64 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 80
    i32.sub
    local.tee 3
    local.set 4
    local.get 3
    global.set 0
    local.get 2
    i32.load offset=4
    local.set 5
    local.get 2
    i32.load
    local.set 6
    i32.const 0
    local.set 2
    block  ;; label = @1
      call 5
      local.tee 7
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 7
          i32.const 513
          i32.lt_u
          br_if 0 (;@3;)
          local.get 7
          call 127
          local.set 2
          br 1 (;@2;)
        end
        local.get 3
        local.get 7
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        local.tee 2
        global.set 0
      end
      local.get 2
      local.get 7
      call 6
      drop
    end
    local.get 4
    i32.const 0
    i32.store offset=72
    local.get 7
    i32.const 3
    i32.gt_u
    i32.const 8429
    call 1
    local.get 4
    i32.const 72
    i32.add
    local.get 2
    i32.const 4
    call 0
    drop
    local.get 4
    i32.const 20
    i32.add
    local.get 2
    i32.const 4
    i32.add
    i32.store
    local.get 4
    i32.const 24
    i32.add
    local.get 2
    local.get 7
    i32.add
    i32.store
    local.get 4
    i32.const 40
    i32.add
    local.get 0
    i64.store
    local.get 4
    i32.const 48
    i32.add
    i64.const -1
    i64.store
    local.get 4
    i32.const 56
    i32.add
    i64.const 0
    i64.store
    local.get 4
    i32.const 64
    i32.add
    i32.const 0
    i32.store
    local.get 4
    i32.const 68
    i32.add
    i32.const 0
    i32.store8
    local.get 4
    local.get 1
    i64.store offset=8
    local.get 4
    local.get 0
    i64.store
    local.get 4
    local.get 2
    i32.store offset=16
    local.get 4
    local.get 0
    i64.store offset=32
    local.get 4
    local.get 5
    i32.const 1
    i32.shr_s
    i32.add
    local.set 3
    local.get 4
    i32.load offset=72
    local.set 8
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 5
              i32.const 1
              i32.and
              br_if 0 (;@5;)
              local.get 3
              local.get 8
              local.get 6
              call_indirect (type 0)
              local.get 7
              i32.const 513
              i32.ge_u
              br_if 1 (;@4;)
              br 2 (;@3;)
            end
            local.get 3
            local.get 8
            local.get 3
            i32.load
            local.get 6
            i32.add
            i32.load
            call_indirect (type 0)
            local.get 7
            i32.const 513
            i32.lt_u
            br_if 1 (;@3;)
          end
          local.get 2
          call 130
          local.get 4
          i32.const 56
          i32.add
          i32.load
          local.tee 5
          i32.eqz
          br_if 2 (;@1;)
          br 1 (;@2;)
        end
        local.get 4
        i32.const 56
        i32.add
        i32.load
        local.tee 5
        i32.eqz
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          i32.const 60
          i32.add
          local.tee 3
          i32.load
          local.tee 2
          local.get 5
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 2
            i32.const -24
            i32.add
            local.tee 2
            i32.load
            local.set 7
            local.get 2
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 7
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 7
                i32.load8_u offset=80
                i32.const 1
                i32.and
                i32.eqz
                br_if 0 (;@6;)
                local.get 7
                i32.const 88
                i32.add
                i32.load
                call 88
              end
              local.get 7
              call 88
            end
            local.get 5
            local.get 2
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 4
          i32.const 56
          i32.add
          i32.load
          local.set 2
          br 1 (;@2;)
        end
        local.get 5
        local.set 2
      end
      local.get 3
      local.get 5
      i32.store
      local.get 2
      call 88
    end
    local.get 4
    i32.const 80
    i32.add
    global.set 0
    i32.const 1)
  (func (;56;) (type 0) (param i32 i32)
    (local i32)
    global.get 0
    i32.const 112
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i64.load
    call 9
    local.get 2
    i32.const 8
    i32.add
    local.get 0
    local.get 1
    call 71
    local.get 0
    i32.const 32
    i32.add
    local.get 2
    i32.const 8
    i32.add
    call 72
    block  ;; label = @1
      local.get 2
      i32.load8_u offset=88
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      i32.const 96
      i32.add
      i32.load
      call 88
    end
    local.get 2
    i32.const 112
    i32.add
    global.set 0)
  (func (;57;) (type 22) (param i64 i64 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    global.get 0
    i32.const 96
    i32.sub
    local.tee 3
    local.set 4
    local.get 3
    global.set 0
    local.get 2
    i32.load offset=4
    local.set 5
    local.get 2
    i32.load
    local.set 6
    i32.const 0
    local.set 2
    block  ;; label = @1
      call 5
      local.tee 7
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 7
          i32.const 513
          i32.lt_u
          br_if 0 (;@3;)
          local.get 7
          call 127
          local.set 2
          br 1 (;@2;)
        end
        local.get 3
        local.get 7
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        local.tee 2
        global.set 0
      end
      local.get 2
      local.get 7
      call 6
      drop
    end
    local.get 4
    i64.const 0
    i64.store offset=80
    local.get 7
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 4
    i32.const 80
    i32.add
    local.get 2
    i32.const 8
    call 0
    drop
    local.get 4
    i32.const 28
    i32.add
    local.get 2
    i32.const 8
    i32.add
    i32.store
    local.get 4
    i32.const 32
    i32.add
    local.get 2
    local.get 7
    i32.add
    i32.store
    local.get 4
    i32.const 48
    i32.add
    local.get 0
    i64.store
    local.get 4
    i32.const 56
    i32.add
    i64.const -1
    i64.store
    local.get 4
    i32.const 64
    i32.add
    i64.const 0
    i64.store
    local.get 4
    i32.const 72
    i32.add
    i32.const 0
    i32.store
    local.get 4
    i32.const 76
    i32.add
    i32.const 0
    i32.store8
    local.get 4
    local.get 1
    i64.store offset=16
    local.get 4
    local.get 0
    i64.store offset=8
    local.get 4
    local.get 2
    i32.store offset=24
    local.get 4
    local.get 0
    i64.store offset=40
    local.get 4
    local.get 4
    i64.load offset=80
    i64.store offset=88
    local.get 4
    i32.const 8
    i32.add
    local.get 5
    i32.const 1
    i32.shr_s
    i32.add
    local.set 3
    block  ;; label = @1
      local.get 5
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 3
      i32.load
      local.get 6
      i32.add
      i32.load
      local.set 6
    end
    local.get 3
    local.get 4
    i32.const 88
    i32.add
    local.get 6
    call_indirect (type 0)
    block  ;; label = @1
      local.get 7
      i32.const 513
      i32.lt_u
      br_if 0 (;@1;)
      local.get 2
      call 130
    end
    block  ;; label = @1
      local.get 4
      i32.const 64
      i32.add
      i32.load
      local.tee 5
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          i32.const 68
          i32.add
          local.tee 6
          i32.load
          local.tee 2
          local.get 5
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 2
            i32.const -24
            i32.add
            local.tee 2
            i32.load
            local.set 7
            local.get 2
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 7
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 7
                i32.load8_u offset=80
                i32.const 1
                i32.and
                i32.eqz
                br_if 0 (;@6;)
                local.get 7
                i32.const 88
                i32.add
                i32.load
                call 88
              end
              local.get 7
              call 88
            end
            local.get 5
            local.get 2
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 4
          i32.const 64
          i32.add
          i32.load
          local.set 2
          br 1 (;@2;)
        end
        local.get 5
        local.set 2
      end
      local.get 6
      local.get 5
      i32.store
      local.get 2
      call 88
    end
    local.get 4
    i32.const 96
    i32.add
    global.set 0
    i32.const 1)
  (func (;58;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i64 i32 i32 i32)
    local.get 0
    i32.load offset=4
    local.set 2
    i32.const 0
    local.set 3
    i64.const 0
    local.set 4
    local.get 0
    i32.const 8
    i32.add
    local.set 5
    local.get 0
    i32.const 4
    i32.add
    local.set 6
    loop  ;; label = @1
      local.get 2
      local.get 5
      i32.load
      i32.lt_u
      i32.const 8434
      call 1
      local.get 6
      i32.load
      local.tee 2
      i32.load8_u
      local.set 7
      local.get 6
      local.get 2
      i32.const 1
      i32.add
      local.tee 2
      i32.store
      local.get 4
      local.get 7
      i32.const 127
      i32.and
      local.get 3
      i32.const 255
      i32.and
      local.tee 3
      i32.shl
      i64.extend_i32_u
      i64.or
      local.set 4
      local.get 3
      i32.const 7
      i32.add
      local.set 3
      local.get 7
      i32.const 128
      i32.and
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load offset=4
        local.tee 3
        local.get 1
        i32.load
        local.tee 7
        i32.sub
        local.tee 5
        local.get 4
        i32.wrap_i64
        local.tee 6
        i32.ge_u
        br_if 0 (;@2;)
        local.get 1
        local.get 6
        local.get 5
        i32.sub
        call 65
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 2
        local.get 1
        i32.const 4
        i32.add
        i32.load
        local.set 3
        local.get 1
        i32.load
        local.set 7
        br 1 (;@1;)
      end
      local.get 5
      local.get 6
      i32.le_u
      br_if 0 (;@1;)
      local.get 1
      i32.const 4
      i32.add
      local.get 7
      local.get 6
      i32.add
      local.tee 3
      i32.store
    end
    local.get 0
    i32.const 8
    i32.add
    i32.load
    local.get 2
    i32.sub
    local.get 3
    local.get 7
    i32.sub
    local.tee 2
    i32.ge_u
    i32.const 8429
    call 1
    local.get 7
    local.get 0
    i32.const 4
    i32.add
    local.tee 3
    i32.load
    local.get 2
    call 0
    drop
    local.get 3
    local.get 3
    i32.load
    local.get 2
    i32.add
    i32.store
    local.get 0)
  (func (;59;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i32.load
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=4
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=8
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 5
    i32.store offset=4
    local.get 2
    i64.const 0
    i64.store offset=8
    local.get 4
    i32.load offset=8
    local.get 5
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 2
    i32.const 8
    i32.add
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 3
    local.get 2
    i64.load offset=8
    i64.store offset=8
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.get 0
    i32.load offset=12
    call 79
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;60;) (type 9) (param i32)
    (local i32 i32 i32 i32)
    global.get 0
    local.set 1
    local.get 0
    i64.const 0
    i64.store
    local.get 0
    i32.const 24
    i32.add
    i64.const 0
    i64.store
    local.get 0
    i32.const 16
    i32.add
    i64.const 0
    i64.store
    local.get 0
    i32.const 8
    i32.add
    i64.const 0
    i64.store
    local.get 1
    call 12
    local.tee 2
    i32.const 15
    i32.add
    i32.const -16
    i32.and
    i32.sub
    local.tee 3
    global.set 0
    local.get 2
    local.get 3
    local.get 2
    call 13
    local.tee 4
    i32.eq
    i32.const 8304
    call 1
    local.get 3
    local.get 4
    local.get 0
    call 14
    local.get 1
    global.set 0)
  (func (;61;) (type 23) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 4
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 1
                i32.load8_u
                local.tee 5
                i32.const 1
                i32.and
                br_if 0 (;@6;)
                local.get 1
                i32.const 1
                i32.add
                local.tee 6
                local.get 5
                i32.const 1
                i32.shr_u
                local.tee 5
                i32.add
                local.set 7
                local.get 5
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
              local.get 1
              i32.load offset=8
              local.tee 6
              local.get 1
              i32.load offset=4
              local.tee 5
              i32.add
              local.set 7
              local.get 5
              i32.eqz
              br_if 1 (;@4;)
            end
            loop  ;; label = @5
              local.get 6
              i32.load8_u
              call 113
              br_if 1 (;@4;)
              local.get 6
              i32.const 1
              i32.add
              local.set 6
              local.get 5
              i32.const -1
              i32.add
              local.tee 5
              br_if 0 (;@5;)
            end
            local.get 7
            local.set 6
            i32.const 1
            local.set 5
            local.get 1
            i32.load8_u
            local.tee 8
            i32.const 1
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          block  ;; label = @4
            local.get 6
            local.get 7
            i32.eq
            br_if 0 (;@4;)
            local.get 6
            i32.const 1
            i32.add
            local.tee 5
            local.get 7
            i32.eq
            br_if 0 (;@4;)
            loop  ;; label = @5
              block  ;; label = @6
                local.get 5
                i32.load8_u
                call 113
                i32.eqz
                br_if 0 (;@6;)
                local.get 7
                local.get 5
                i32.const 1
                i32.add
                local.tee 5
                i32.ne
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
              local.get 6
              local.get 5
              i32.load8_u
              i32.store8
              local.get 6
              i32.const 1
              i32.add
              local.set 6
              local.get 7
              local.get 5
              i32.const 1
              i32.add
              local.tee 5
              i32.ne
              br_if 0 (;@5;)
            end
          end
          i32.const 1
          local.set 5
          local.get 1
          i32.load8_u
          local.tee 8
          i32.const 1
          i32.and
          br_if 1 (;@2;)
        end
        local.get 1
        local.get 5
        i32.add
        local.tee 7
        local.get 8
        local.get 5
        i32.shr_u
        i32.add
        local.set 5
        br 1 (;@1;)
      end
      local.get 1
      i32.load offset=8
      local.tee 7
      local.get 1
      i32.load offset=4
      i32.add
      local.set 5
    end
    local.get 1
    local.get 6
    local.get 7
    i32.sub
    local.get 5
    local.get 6
    i32.sub
    call 104
    drop
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.load8_u
        local.tee 6
        i32.const 1
        i32.and
        br_if 0 (;@2;)
        local.get 6
        i32.const 1
        i32.shr_u
        local.set 6
        local.get 1
        i32.const 1
        i32.add
        local.set 9
        br 1 (;@1;)
      end
      local.get 1
      i32.load offset=4
      local.set 6
      local.get 1
      i32.load offset=8
      local.set 9
    end
    i32.const 0
    local.set 7
    block  ;; label = @1
      i32.const 8586
      call 124
      local.tee 5
      i32.eqz
      br_if 0 (;@1;)
      local.get 9
      local.get 6
      i32.add
      local.set 8
      block  ;; label = @2
        block  ;; label = @3
          local.get 6
          local.get 5
          i32.lt_s
          br_if 0 (;@3;)
          local.get 9
          local.set 7
          loop  ;; label = @4
            local.get 6
            local.get 5
            i32.sub
            i32.const 1
            i32.add
            local.tee 6
            i32.eqz
            br_if 1 (;@3;)
            local.get 7
            i32.const 120
            local.get 6
            call 122
            local.tee 6
            i32.eqz
            br_if 1 (;@3;)
            local.get 6
            i32.const 8586
            local.get 5
            call 123
            i32.eqz
            br_if 2 (;@2;)
            local.get 8
            local.get 6
            i32.const 1
            i32.add
            local.tee 7
            i32.sub
            local.tee 6
            local.get 5
            i32.ge_s
            br_if 0 (;@4;)
          end
        end
        local.get 8
        local.set 6
      end
      i32.const -1
      local.get 6
      local.get 9
      i32.sub
      local.get 6
      local.get 8
      i32.eq
      select
      local.set 7
    end
    local.get 7
    i32.const -1
    i32.ne
    i32.const 8588
    call 1
    local.get 2
    local.get 4
    local.get 1
    i32.const 0
    local.get 7
    local.get 1
    call 96
    local.tee 6
    i32.const 0
    i32.const 10
    call 106
    i32.store
    block  ;; label = @1
      local.get 4
      i32.load8_u
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 6
      i32.load offset=8
      call 88
    end
    local.get 3
    local.get 4
    local.get 1
    local.get 7
    i32.const 1
    i32.add
    i32.const -1
    local.get 1
    call 96
    local.tee 6
    i32.const 0
    i32.const 10
    call 106
    i32.store
    block  ;; label = @1
      local.get 4
      i32.load8_u
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      local.get 6
      i32.load offset=8
      call 88
    end
    local.get 2
    i32.load
    i32.const -2
    i32.add
    i32.const 5
    i32.lt_u
    i32.const 8606
    call 1
    local.get 3
    i32.load
    local.tee 6
    i32.const 1
    i32.eq
    local.get 6
    i32.const 10
    i32.eq
    i32.or
    i32.const 8640
    call 1
    local.get 4
    i32.const 16
    i32.add
    global.set 0)
  (func (;62;) (type 9) (param i32)
    (local i32 i64 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 1
    global.set 0
    call 7
    local.set 2
    local.get 1
    local.get 0
    i32.const 32
    i32.add
    i32.store offset=16
    local.get 1
    local.get 2
    i64.const 1000000
    i64.div_u
    i64.const 4294967236
    i64.add
    i64.const 4294967295
    i64.and
    i64.store offset=24
    local.get 1
    i32.const 8
    i32.add
    local.get 1
    i32.const 16
    i32.add
    local.get 1
    i32.const 24
    i32.add
    call 74
    local.get 1
    i64.const 0
    i64.store offset=24
    local.get 1
    local.get 1
    i32.const 16
    i32.add
    local.get 1
    i32.const 24
    i32.add
    call 75
    block  ;; label = @1
      local.get 1
      i32.load offset=4
      local.get 1
      i32.load offset=12
      i32.eq
      br_if 0 (;@1;)
      local.get 1
      i64.load
      local.set 2
      i32.const 1
      local.set 0
      loop  ;; label = @2
        local.get 1
        local.get 2
        i64.store offset=24
        local.get 2
        i64.const 32
        i64.shr_u
        i32.wrap_i64
        local.tee 3
        i32.const 0
        i32.ne
        i32.const 8740
        call 1
        local.get 1
        i32.const 24
        i32.add
        call 76
        drop
        local.get 1
        i32.load offset=16
        local.get 3
        call 72
        local.get 1
        local.get 1
        i64.load offset=24
        local.tee 2
        i64.store
        local.get 0
        i32.const 4
        i32.gt_u
        br_if 1 (;@1;)
        local.get 0
        i32.const 1
        i32.add
        local.set 0
        local.get 1
        i32.load offset=12
        local.get 2
        i64.const 32
        i64.shr_u
        i32.wrap_i64
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 1
    i32.const 32
    i32.add
    global.set 0)
  (func (;63;) (type 24) (param i32 i32 i64)
    (local i32 i32 i64 i32 i32)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 3
    global.set 0
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            i32.const 8300
            call 124
            local.tee 4
            i32.const 8
            i32.lt_u
            br_if 0 (;@4;)
            i32.const 0
            i32.const 8823
            call 1
            br 1 (;@3;)
          end
          local.get 4
          i32.eqz
          br_if 1 (;@2;)
        end
        i64.const 0
        local.set 5
        loop  ;; label = @3
          block  ;; label = @4
            local.get 4
            i32.const 8299
            i32.add
            i32.load8_u
            local.tee 6
            i32.const -65
            i32.add
            i32.const 255
            i32.and
            i32.const 26
            i32.lt_u
            br_if 0 (;@4;)
            i32.const 0
            i32.const 8868
            call 1
          end
          local.get 5
          i64.const 8
          i64.shl
          local.get 6
          i64.extend_i32_u
          i64.const 56
          i64.shl
          i64.const 56
          i64.shr_s
          i64.or
          local.set 5
          local.get 4
          i32.const -1
          i32.add
          local.tee 4
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      i64.const 0
      local.set 5
    end
    local.get 3
    i32.const 40
    i32.add
    i32.const 0
    i32.store
    local.get 3
    local.get 2
    i64.store offset=16
    local.get 3
    i64.const 6138663591592764928
    i64.store offset=8
    local.get 3
    i64.const -1
    i64.store offset=24
    local.get 3
    i64.const 0
    i64.store offset=32
    local.get 0
    local.get 3
    i32.const 8
    i32.add
    local.get 5
    i32.const 8804
    call 77
    local.tee 4
    i64.load
    i64.store
    local.get 0
    i32.const 8
    i32.add
    local.get 4
    i32.const 8
    i32.add
    i64.load
    i64.store
    block  ;; label = @1
      local.get 3
      i32.load offset=32
      local.tee 0
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const 36
          i32.add
          local.tee 7
          i32.load
          local.tee 4
          local.get 0
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            local.get 4
            i32.const -24
            i32.add
            local.tee 4
            i32.load
            local.set 6
            local.get 4
            i32.const 0
            i32.store
            block  ;; label = @5
              local.get 6
              i32.eqz
              br_if 0 (;@5;)
              local.get 6
              call 88
            end
            local.get 0
            local.get 4
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 3
          i32.const 32
          i32.add
          i32.load
          local.set 4
          br 1 (;@2;)
        end
        local.get 0
        local.set 4
      end
      local.get 7
      local.get 0
      i32.store
      local.get 4
      call 88
    end
    local.get 3
    i32.const 48
    i32.add
    global.set 0)
  (func (;64;) (type 3) (param i32 i32 i32)
    (local i32 i32 i32 i32 i64)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 3
    global.set 0
    local.get 0
    i64.const 0
    i64.store align=4
    local.get 0
    i32.const 8
    i32.add
    i32.const 0
    i32.store
    block  ;; label = @1
      i32.const 9012
      call 124
      local.tee 4
      i32.const -16
      i32.ge_u
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 4
            i32.const 11
            i32.ge_u
            br_if 0 (;@4;)
            local.get 0
            local.get 4
            i32.const 1
            i32.shl
            i32.store8
            local.get 0
            i32.const 1
            i32.add
            local.set 5
            local.get 4
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          local.get 4
          i32.const 16
          i32.add
          i32.const -16
          i32.and
          local.tee 6
          call 86
          local.set 5
          local.get 0
          local.get 6
          i32.const 1
          i32.or
          i32.store
          local.get 0
          local.get 5
          i32.store offset=8
          local.get 0
          local.get 4
          i32.store offset=4
        end
        local.get 5
        i32.const 9012
        local.get 4
        call 0
        drop
      end
      i32.const 0
      local.set 6
      local.get 5
      local.get 4
      i32.add
      i32.const 0
      i32.store8
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              i64.load offset=16
              local.tee 7
              i64.const 0
              i64.eq
              br_if 0 (;@5;)
              i32.const 0
              i32.load offset=9048
              local.set 5
              block  ;; label = @6
                loop  ;; label = @7
                  local.get 3
                  i32.const 19
                  i32.add
                  local.get 6
                  local.tee 4
                  i32.add
                  local.get 5
                  local.get 7
                  i64.const -576460752303423488
                  i64.and
                  i64.const 60
                  i64.const 59
                  local.get 4
                  i32.const 12
                  i32.eq
                  select
                  i64.shr_u
                  i32.wrap_i64
                  i32.add
                  i32.load8_u
                  i32.store8
                  local.get 4
                  i32.const 1
                  i32.add
                  local.set 6
                  local.get 4
                  i32.const 11
                  i32.gt_u
                  br_if 1 (;@6;)
                  local.get 7
                  i64.const 5
                  i64.shl
                  local.tee 7
                  i64.const 0
                  i64.ne
                  br_if 0 (;@7;)
                end
              end
              local.get 3
              i32.const 8
              i32.add
              i32.const 0
              i32.store
              local.get 3
              i64.const 0
              i64.store
              local.get 6
              i32.const 11
              i32.ge_u
              br_if 1 (;@4;)
              local.get 3
              local.get 6
              i32.const 1
              i32.shl
              i32.store8
              local.get 3
              i32.const 1
              i32.or
              local.set 5
              br 2 (;@3;)
            end
            local.get 3
            i32.const 8
            i32.add
            i32.const 0
            i32.store
            local.get 3
            i64.const 0
            i64.store
            local.get 3
            i32.const 0
            i32.store8
            local.get 3
            i32.const 1
            i32.or
            local.tee 4
            local.set 6
            br 2 (;@2;)
          end
          local.get 6
          i32.const 16
          i32.add
          i32.const -16
          i32.and
          local.tee 2
          call 86
          local.set 5
          local.get 3
          local.get 2
          i32.const 1
          i32.or
          i32.store
          local.get 3
          local.get 5
          i32.store offset=8
          local.get 3
          local.get 6
          i32.store offset=4
        end
        local.get 4
        i32.const 1
        i32.add
        local.set 2
        i32.const 0
        local.set 4
        loop  ;; label = @3
          local.get 5
          local.get 4
          i32.add
          local.get 3
          i32.const 19
          i32.add
          local.get 4
          i32.add
          i32.load8_u
          i32.store8
          local.get 2
          local.get 4
          i32.const 1
          i32.add
          local.tee 4
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 5
        local.get 6
        i32.add
        local.set 6
        local.get 3
        i32.const 1
        i32.or
        local.set 4
      end
      local.get 6
      i32.const 0
      i32.store8
      local.get 0
      local.get 3
      i32.load offset=8
      local.get 4
      local.get 3
      i32.load8_u
      local.tee 6
      i32.const 1
      i32.and
      local.tee 5
      select
      local.get 3
      i32.load offset=4
      local.get 6
      i32.const 1
      i32.shr_u
      local.get 5
      select
      call 103
      drop
      local.get 0
      i32.const 9022
      call 101
      drop
      block  ;; label = @2
        local.get 3
        i32.load8_u
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        i32.const 8
        i32.add
        i32.load
        call 88
      end
      local.get 3
      i32.const 32
      i32.add
      global.set 0
      return
    end
    local.get 0
    call 94
    unreachable)
  (func (;65;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32)
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
              local.tee 3
              i32.sub
              local.get 1
              i32.ge_u
              br_if 0 (;@5;)
              local.get 3
              local.get 0
              i32.load
              local.tee 4
              i32.sub
              local.tee 5
              local.get 1
              i32.add
              local.tee 6
              i32.const -1
              i32.le_s
              br_if 2 (;@3;)
              i32.const 2147483647
              local.set 7
              block  ;; label = @6
                local.get 2
                local.get 4
                i32.sub
                local.tee 2
                i32.const 1073741822
                i32.gt_u
                br_if 0 (;@6;)
                local.get 6
                local.get 2
                i32.const 1
                i32.shl
                local.tee 2
                local.get 2
                local.get 6
                i32.lt_u
                select
                local.tee 7
                i32.eqz
                br_if 2 (;@4;)
              end
              local.get 7
              call 86
              local.set 2
              br 3 (;@2;)
            end
            local.get 0
            i32.const 4
            i32.add
            local.set 0
            loop  ;; label = @5
              local.get 3
              i32.const 0
              i32.store8
              local.get 0
              local.get 0
              i32.load
              i32.const 1
              i32.add
              local.tee 3
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
          local.set 7
          i32.const 0
          local.set 2
          br 1 (;@2;)
        end
        local.get 0
        call 112
        unreachable
      end
      local.get 2
      local.get 7
      i32.add
      local.set 7
      local.get 3
      local.get 1
      i32.add
      local.get 4
      i32.sub
      local.set 4
      local.get 2
      local.get 5
      i32.add
      local.tee 5
      local.set 3
      loop  ;; label = @2
        local.get 3
        i32.const 0
        i32.store8
        local.get 3
        i32.const 1
        i32.add
        local.set 3
        local.get 1
        i32.const -1
        i32.add
        local.tee 1
        br_if 0 (;@2;)
      end
      local.get 2
      local.get 4
      i32.add
      local.set 4
      local.get 5
      local.get 0
      i32.const 4
      i32.add
      local.tee 6
      i32.load
      local.get 0
      i32.load
      local.tee 1
      i32.sub
      local.tee 3
      i32.sub
      local.set 2
      block  ;; label = @2
        local.get 3
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        local.get 2
        local.get 1
        local.get 3
        call 0
        drop
        local.get 0
        i32.load
        local.set 1
      end
      local.get 0
      local.get 2
      i32.store
      local.get 6
      local.get 4
      i32.store
      local.get 0
      i32.const 8
      i32.add
      local.get 7
      i32.store
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      call 88
      return
    end)
  (func (;66;) (type 0) (param i32 i32)
    (local i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i32.load
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load
    local.set 0
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 0
    i32.const 8
    i32.add
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 0
    i32.const 16
    i32.add
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 3
    i32.store offset=4
    local.get 2
    local.get 0
    i32.const 24
    i32.add
    i64.load
    i64.store offset=8
    local.get 4
    i32.load offset=8
    local.get 3
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 2
    i32.const 8
    i32.add
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.get 0
    i32.const 32
    i32.add
    call 85
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;67;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i64)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    i64.const 0
    i64.store align=4
    i32.const 16
    local.set 3
    local.get 1
    i32.const 16
    i32.add
    local.set 4
    local.get 1
    i32.const 20
    i32.add
    i32.load
    local.tee 5
    local.get 1
    i32.load offset=16
    local.tee 6
    i32.sub
    local.tee 7
    i32.const 4
    i32.shr_s
    i64.extend_i32_u
    local.set 8
    loop  ;; label = @1
      local.get 3
      i32.const 1
      i32.add
      local.set 3
      local.get 8
      i64.const 7
      i64.shr_u
      local.tee 8
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      local.get 6
      local.get 5
      i32.eq
      br_if 0 (;@1;)
      local.get 7
      i32.const -16
      i32.and
      local.get 3
      i32.add
      local.set 3
    end
    local.get 1
    i32.load offset=28
    local.tee 5
    local.get 3
    i32.sub
    local.get 1
    i32.const 32
    i32.add
    i32.load
    local.tee 6
    i32.sub
    local.set 3
    local.get 1
    i32.const 28
    i32.add
    local.set 7
    local.get 6
    local.get 5
    i32.sub
    i64.extend_i32_u
    local.set 8
    loop  ;; label = @1
      local.get 3
      i32.const -1
      i32.add
      local.set 3
      local.get 8
      i64.const 7
      i64.shr_u
      local.tee 8
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
    end
    i32.const 0
    local.set 5
    block  ;; label = @1
      block  ;; label = @2
        local.get 3
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 0
        local.get 3
        i32.sub
        call 65
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 5
        local.get 0
        i32.load
        local.set 3
        br 1 (;@1;)
      end
      i32.const 0
      local.set 3
    end
    local.get 2
    local.get 3
    i32.store
    local.get 2
    local.get 5
    i32.store offset=8
    local.get 5
    local.get 3
    i32.sub
    local.tee 0
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 3
    local.get 1
    i32.const 8
    call 0
    drop
    local.get 0
    i32.const -8
    i32.add
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 3
    i32.const 8
    i32.add
    local.get 1
    i32.const 8
    i32.add
    i32.const 8
    call 0
    drop
    local.get 2
    local.get 3
    i32.const 16
    i32.add
    i32.store offset=4
    local.get 2
    local.get 4
    call 82
    local.get 7
    call 83
    drop
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;68;) (type 25) (param i32 i32 i64 i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 48
    i32.sub
    local.tee 4
    global.set 0
    local.get 4
    local.get 2
    i64.store offset=40
    local.get 1
    i64.load
    call 17
    i64.eq
    i32.const 9171
    call 1
    local.get 4
    local.get 3
    i32.store offset=20
    local.get 4
    local.get 1
    i32.store offset=16
    local.get 4
    local.get 4
    i32.const 40
    i32.add
    i32.store offset=24
    i32.const 120
    call 86
    local.tee 3
    i64.const 0
    i64.store offset=24
    local.get 3
    i64.const 0
    i64.store offset=16
    local.get 3
    i64.const 0
    i64.store offset=32
    local.get 3
    i64.const 0
    i64.store offset=40
    local.get 3
    i64.const 0
    i64.store offset=48
    local.get 3
    i64.const 0
    i64.store offset=56
    local.get 3
    i64.const 0
    i64.store offset=64
    local.get 3
    i64.const 0
    i64.store offset=80 align=4
    local.get 3
    i32.const 0
    i32.store offset=88
    local.get 3
    local.get 1
    i32.store offset=104
    local.get 4
    i32.const 16
    i32.add
    local.get 3
    call 84
    local.get 4
    local.get 3
    i32.store offset=32
    local.get 4
    local.get 3
    i64.load offset=8
    local.tee 2
    i64.store offset=16
    local.get 4
    local.get 3
    i32.load offset=108
    local.tee 5
    i32.store offset=12
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 28
        i32.add
        local.tee 6
        i32.load
        local.tee 7
        local.get 1
        i32.const 32
        i32.add
        i32.load
        i32.ge_u
        br_if 0 (;@2;)
        local.get 7
        local.get 2
        i64.store offset=8
        local.get 7
        local.get 5
        i32.store offset=16
        local.get 4
        i32.const 0
        i32.store offset=32
        local.get 7
        local.get 3
        i32.store
        local.get 6
        local.get 7
        i32.const 24
        i32.add
        i32.store
        br 1 (;@1;)
      end
      local.get 1
      i32.const 24
      i32.add
      local.get 4
      i32.const 32
      i32.add
      local.get 4
      i32.const 16
      i32.add
      local.get 4
      i32.const 12
      i32.add
      call 78
    end
    local.get 0
    local.get 3
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store
    local.get 4
    i32.load offset=32
    local.set 3
    local.get 4
    i32.const 0
    i32.store offset=32
    block  ;; label = @1
      local.get 3
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 3
        i32.load8_u offset=80
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 3
        i32.const 88
        i32.add
        i32.load
        call 88
      end
      local.get 3
      call 88
    end
    local.get 4
    i32.const 48
    i32.add
    global.set 0)
  (func (;69;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i32.load
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 3
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 4
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 4
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=4
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=8
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=12
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 5
    i32.store offset=4
    local.get 2
    local.get 3
    i64.load offset=8
    i64.store offset=8
    local.get 4
    i32.load offset=8
    local.get 5
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 2
    i32.const 8
    i32.add
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=16
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 5
    i32.store offset=4
    local.get 2
    local.get 3
    i64.load offset=8
    i64.store offset=8
    local.get 4
    i32.load offset=8
    local.get 5
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 2
    i32.const 8
    i32.add
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=20
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 5
    i32.store offset=4
    local.get 2
    local.get 3
    i64.load offset=8
    i64.store offset=8
    local.get 4
    i32.load offset=8
    local.get 5
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 2
    i32.const 8
    i32.add
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=24
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 3
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 4
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 4
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=28
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 3
    i32.gt_s
    i32.const 9085
    call 1
    local.get 4
    i32.load offset=4
    local.get 3
    i32.const 4
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 4
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.get 0
    i32.load offset=32
    call 85
    drop
    local.get 0
    i32.load offset=36
    local.set 4
    local.get 1
    i32.load
    local.tee 0
    i32.load offset=8
    local.get 0
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_s
    i32.const 9085
    call 1
    local.get 0
    i32.load offset=4
    local.get 4
    i32.const 8
    call 0
    drop
    local.get 0
    local.get 0
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;70;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 0
    i32.load
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 3
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 4
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 4
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=4
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=8
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=12
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 5
    i32.store offset=4
    local.get 2
    i64.const 0
    i64.store offset=8
    local.get 4
    i32.load offset=8
    local.get 5
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 2
    i32.const 8
    i32.add
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 3
    local.get 2
    i64.load offset=8
    i64.store offset=8
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=16
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 5
    i32.store offset=4
    local.get 2
    i64.const 0
    i64.store offset=8
    local.get 4
    i32.load offset=8
    local.get 5
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 2
    i32.const 8
    i32.add
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 3
    local.get 2
    i64.load offset=8
    i64.store offset=8
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=20
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    local.tee 5
    i32.store offset=4
    local.get 2
    i64.const 0
    i64.store offset=8
    local.get 4
    i32.load offset=8
    local.get 5
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 2
    i32.const 8
    i32.add
    local.get 4
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 3
    local.get 2
    i64.load offset=8
    i64.store offset=8
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=24
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 3
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 4
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 4
    i32.add
    i32.store offset=4
    local.get 0
    i32.load offset=28
    local.set 3
    local.get 1
    i32.load
    local.tee 4
    i32.load offset=8
    local.get 4
    i32.load offset=4
    i32.sub
    i32.const 3
    i32.gt_u
    i32.const 8429
    call 1
    local.get 3
    local.get 4
    i32.load offset=4
    i32.const 4
    call 0
    drop
    local.get 4
    local.get 4
    i32.load offset=4
    i32.const 4
    i32.add
    i32.store offset=4
    local.get 1
    i32.load
    local.get 0
    i32.load offset=32
    call 79
    drop
    local.get 0
    i32.load offset=36
    local.set 4
    local.get 1
    i32.load
    local.tee 0
    i32.load offset=8
    local.get 0
    i32.load offset=4
    i32.sub
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 4
    local.get 0
    i32.load offset=4
    i32.const 8
    call 0
    drop
    local.get 0
    local.get 0
    i32.load offset=4
    i32.const 8
    i32.add
    i32.store offset=4
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;71;) (type 3) (param i32 i32 i32)
    (local i32 i64 i32 i32 i32)
    local.get 1
    i32.const 32
    i32.add
    local.set 3
    local.get 2
    i64.load
    local.set 4
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 56
        i32.add
        i32.load
        local.tee 5
        local.get 1
        i32.const 60
        i32.add
        i32.load
        local.tee 6
        i32.eq
        br_if 0 (;@2;)
        block  ;; label = @3
          loop  ;; label = @4
            local.get 6
            i32.const -24
            i32.add
            local.tee 2
            i32.load
            local.tee 7
            i64.load offset=8
            local.get 4
            i64.eq
            br_if 1 (;@3;)
            local.get 2
            local.set 6
            local.get 5
            local.get 2
            i32.ne
            br_if 0 (;@4;)
            br 2 (;@2;)
          end
        end
        local.get 5
        local.get 6
        i32.eq
        br_if 0 (;@2;)
        local.get 7
        i32.load offset=104
        local.get 3
        i32.eq
        i32.const 8355
        call 1
        br 1 (;@1;)
      end
      i32.const 0
      local.set 7
      local.get 3
      i64.load
      local.get 1
      i32.const 40
      i32.add
      i64.load
      i64.const 4229443000054317056
      local.get 4
      call 15
      local.tee 2
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 3
      local.get 2
      call 73
      local.tee 7
      i32.load offset=104
      local.get 3
      i32.eq
      i32.const 8355
      call 1
    end
    local.get 7
    i32.const 0
    i32.ne
    i32.const 8341
    call 1
    local.get 0
    local.get 7
    i32.const 80
    call 0
    local.tee 2
    i32.const 80
    i32.add
    local.get 7
    i32.const 80
    i32.add
    call 95
    drop
    local.get 2
    local.get 7
    i64.load offset=96
    i64.store offset=96)
  (func (;72;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32 i32 i64 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 1
    i32.load offset=104
    local.get 0
    i32.eq
    i32.const 8438
    call 1
    local.get 0
    i64.load
    call 17
    i64.eq
    i32.const 8483
    call 1
    local.get 0
    i32.load offset=24
    local.tee 3
    local.set 4
    block  ;; label = @1
      local.get 3
      local.get 0
      i32.const 28
      i32.add
      local.tee 5
      i32.load
      local.tee 6
      i32.eq
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 6
        i32.const -24
        i32.add
        i32.load
        i64.load offset=8
        local.get 1
        i64.load offset=8
        local.tee 7
        i64.ne
        br_if 0 (;@2;)
        local.get 6
        local.set 4
        br 1 (;@1;)
      end
      local.get 3
      i32.const 24
      i32.add
      local.set 8
      block  ;; label = @2
        loop  ;; label = @3
          local.get 8
          local.get 6
          i32.eq
          br_if 1 (;@2;)
          local.get 6
          i32.const -48
          i32.add
          local.set 9
          local.get 6
          i32.const -24
          i32.add
          local.tee 4
          local.set 6
          local.get 9
          i32.load
          i64.load offset=8
          local.get 7
          i64.ne
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      local.get 3
      local.set 4
    end
    local.get 4
    local.get 3
    i32.ne
    i32.const 8533
    call 1
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 4
          local.get 5
          i32.load
          local.tee 3
          i32.eq
          br_if 0 (;@3;)
          local.get 4
          local.set 6
          loop  ;; label = @4
            local.get 6
            i32.load
            local.set 9
            local.get 6
            i32.const 0
            i32.store
            local.get 6
            i32.const -24
            i32.add
            local.tee 8
            i32.load
            local.set 4
            local.get 8
            local.get 9
            i32.store
            block  ;; label = @5
              local.get 4
              i32.eqz
              br_if 0 (;@5;)
              block  ;; label = @6
                local.get 4
                i32.load8_u offset=80
                i32.const 1
                i32.and
                i32.eqz
                br_if 0 (;@6;)
                local.get 4
                i32.const 88
                i32.add
                i32.load
                call 88
              end
              local.get 4
              call 88
            end
            local.get 6
            i32.const -8
            i32.add
            local.get 6
            i32.const 16
            i32.add
            i32.load
            i32.store
            local.get 6
            i32.const -16
            i32.add
            local.get 6
            i32.const 8
            i32.add
            i64.load
            i64.store
            local.get 3
            local.get 6
            i32.const 24
            i32.add
            local.tee 6
            i32.ne
            br_if 0 (;@4;)
          end
          local.get 6
          i32.const -24
          i32.add
          local.set 9
          local.get 0
          i32.const 28
          i32.add
          i32.load
          local.tee 4
          i32.const 24
          i32.add
          local.get 6
          i32.ne
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        local.get 4
        i32.const -24
        i32.add
        local.set 9
      end
      loop  ;; label = @2
        local.get 4
        i32.const -24
        i32.add
        local.tee 4
        i32.load
        local.set 6
        local.get 4
        i32.const 0
        i32.store
        block  ;; label = @3
          local.get 6
          i32.eqz
          br_if 0 (;@3;)
          block  ;; label = @4
            local.get 6
            i32.load8_u offset=80
            i32.const 1
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            local.get 6
            i32.const 88
            i32.add
            i32.load
            call 88
          end
          local.get 6
          call 88
        end
        local.get 9
        local.get 4
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 0
    i32.const 28
    i32.add
    local.get 9
    i32.store
    local.get 1
    i32.load offset=108
    call 18
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 112
        i32.add
        i32.load
        local.tee 6
        i32.const -1
        i32.gt_s
        br_if 0 (;@2;)
        local.get 0
        i64.load
        local.get 0
        i64.load offset=8
        i64.const 4229443000054317056
        local.get 2
        i32.const 8
        i32.add
        local.get 1
        i32.const 8
        i32.add
        i64.load
        call 19
        local.tee 6
        i32.const 0
        i32.lt_s
        br_if 1 (;@1;)
      end
      local.get 6
      call 20
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 0)
  (func (;73;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i64 i32 i32)
    global.get 0
    i32.const 80
    i32.sub
    local.tee 2
    local.set 3
    local.get 2
    global.set 0
    block  ;; label = @1
      local.get 0
      i32.load offset=24
      local.tee 4
      local.get 0
      i32.const 28
      i32.add
      i32.load
      local.tee 5
      i32.eq
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          local.get 5
          i32.const -8
          i32.add
          i32.load
          local.get 1
          i32.eq
          br_if 1 (;@2;)
          local.get 4
          local.get 5
          i32.const -24
          i32.add
          local.tee 5
          i32.ne
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      local.get 4
      local.get 5
      i32.eq
      br_if 0 (;@1;)
      local.get 5
      i32.const -24
      i32.add
      i32.load
      local.set 5
      local.get 3
      i32.const 80
      i32.add
      global.set 0
      local.get 5
      return
    end
    local.get 1
    i32.const 0
    i32.const 0
    call 16
    local.tee 4
    i32.const 31
    i32.shr_u
    i32.const 1
    i32.xor
    i32.const 8406
    call 1
    block  ;; label = @1
      block  ;; label = @2
        local.get 4
        i32.const 513
        i32.lt_u
        br_if 0 (;@2;)
        local.get 4
        call 127
        local.set 2
        br 1 (;@1;)
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
    local.get 1
    local.get 2
    local.get 4
    call 16
    drop
    local.get 3
    local.get 2
    i32.store offset=20
    local.get 3
    local.get 2
    i32.store offset=16
    local.get 3
    local.get 2
    local.get 4
    i32.add
    i32.store offset=24
    i32.const 120
    call 86
    local.tee 5
    i64.const 0
    i64.store offset=24
    local.get 5
    i64.const 0
    i64.store offset=16
    local.get 5
    i64.const 0
    i64.store offset=32
    local.get 5
    i64.const 0
    i64.store offset=40
    local.get 5
    i64.const 0
    i64.store offset=48
    local.get 5
    i64.const 0
    i64.store offset=56
    local.get 5
    i64.const 0
    i64.store offset=64
    local.get 5
    i64.const 0
    i64.store offset=80 align=4
    local.get 5
    i32.const 0
    i32.store offset=88
    local.get 5
    local.get 0
    i32.store offset=104
    local.get 3
    local.get 3
    i32.const 16
    i32.add
    i32.store offset=32
    local.get 3
    local.get 5
    i32.const 8
    i32.add
    i32.store offset=44
    local.get 3
    local.get 5
    i32.store offset=40
    local.get 3
    local.get 5
    i32.const 16
    i32.add
    i32.store offset=48
    local.get 3
    local.get 5
    i32.const 24
    i32.add
    i32.store offset=52
    local.get 3
    local.get 5
    i32.const 40
    i32.add
    i32.store offset=56
    local.get 3
    local.get 5
    i32.const 56
    i32.add
    i32.store offset=60
    local.get 3
    local.get 5
    i32.const 72
    i32.add
    i32.store offset=64
    local.get 3
    local.get 5
    i32.const 76
    i32.add
    i32.store offset=68
    local.get 3
    local.get 5
    i32.const 80
    i32.add
    i32.store offset=72
    local.get 3
    local.get 5
    i32.const 96
    i32.add
    i32.store offset=76
    local.get 3
    i32.const 40
    i32.add
    local.get 3
    i32.const 32
    i32.add
    call 70
    local.get 5
    i32.const -1
    i32.store offset=112
    local.get 5
    local.get 1
    i32.store offset=108
    local.get 3
    local.get 5
    i32.store offset=32
    local.get 3
    local.get 5
    i64.load offset=8
    local.tee 6
    i64.store offset=40
    local.get 3
    local.get 1
    i32.store offset=12
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 28
          i32.add
          local.tee 7
          i32.load
          local.tee 8
          local.get 0
          i32.const 32
          i32.add
          i32.load
          i32.ge_u
          br_if 0 (;@3;)
          local.get 8
          local.get 6
          i64.store offset=8
          local.get 8
          local.get 1
          i32.store offset=16
          local.get 3
          i32.const 0
          i32.store offset=32
          local.get 8
          local.get 5
          i32.store
          local.get 7
          local.get 8
          i32.const 24
          i32.add
          i32.store
          local.get 4
          i32.const 513
          i32.ge_u
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        local.get 0
        i32.const 24
        i32.add
        local.get 3
        i32.const 32
        i32.add
        local.get 3
        i32.const 40
        i32.add
        local.get 3
        i32.const 12
        i32.add
        call 78
        local.get 4
        i32.const 513
        i32.lt_u
        br_if 1 (;@1;)
      end
      local.get 2
      call 130
    end
    local.get 3
    i32.load offset=32
    local.set 1
    local.get 3
    i32.const 0
    i32.store offset=32
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 1
        i32.load8_u offset=80
        i32.const 1
        i32.and
        i32.eqz
        br_if 0 (;@2;)
        local.get 1
        i32.const 88
        i32.add
        i32.load
        call 88
      end
      local.get 1
      call 88
    end
    local.get 3
    i32.const 80
    i32.add
    global.set 0
    local.get 5)
  (func (;74;) (type 3) (param i32 i32 i32)
    (local i32 i32 i32 i64 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    local.get 3
    i64.const 0
    i64.store offset=8
    local.get 3
    local.get 2
    i64.load
    i64.store
    i32.const 0
    local.set 4
    block  ;; label = @1
      local.get 1
      i32.load
      local.tee 2
      i64.load
      local.get 2
      i64.load offset=8
      i64.const 4229443000054317056
      local.get 3
      local.get 3
      i32.const 8
      i32.add
      call 21
      local.tee 5
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 3
      i64.load offset=8
      local.set 6
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.load
          local.tee 7
          i32.load offset=24
          local.tee 8
          local.get 7
          i32.const 28
          i32.add
          i32.load
          local.tee 9
          i32.eq
          br_if 0 (;@3;)
          block  ;; label = @4
            loop  ;; label = @5
              local.get 9
              i32.const -24
              i32.add
              local.tee 2
              i32.load
              local.tee 4
              i64.load offset=8
              local.get 6
              i64.eq
              br_if 1 (;@4;)
              local.get 2
              local.set 9
              local.get 8
              local.get 2
              i32.ne
              br_if 0 (;@5;)
              br 2 (;@3;)
            end
          end
          local.get 8
          local.get 9
          i32.eq
          br_if 0 (;@3;)
          local.get 4
          i32.load offset=104
          local.get 7
          i32.eq
          i32.const 8355
          call 1
          br 1 (;@2;)
        end
        local.get 7
        local.get 7
        i64.load
        local.get 7
        i64.load offset=8
        i64.const 4229443000054317056
        local.get 6
        call 15
        call 73
        local.tee 4
        i32.load offset=104
        local.get 7
        i32.eq
        i32.const 8355
        call 1
      end
      local.get 4
      i32.const 112
      i32.add
      local.get 5
      i32.store
    end
    local.get 0
    local.get 4
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store
    local.get 3
    i32.const 16
    i32.add
    global.set 0)
  (func (;75;) (type 3) (param i32 i32 i32)
    (local i32 i32 i32 i64 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    local.get 3
    i64.const 0
    i64.store offset=8
    local.get 3
    local.get 2
    i64.load
    i64.store
    i32.const 0
    local.set 4
    block  ;; label = @1
      local.get 1
      i32.load
      local.tee 2
      i64.load
      local.get 2
      i64.load offset=8
      i64.const 4229443000054317056
      local.get 3
      local.get 3
      i32.const 8
      i32.add
      call 22
      local.tee 5
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 3
      i64.load offset=8
      local.set 6
      block  ;; label = @2
        block  ;; label = @3
          local.get 1
          i32.load
          local.tee 7
          i32.load offset=24
          local.tee 8
          local.get 7
          i32.const 28
          i32.add
          i32.load
          local.tee 9
          i32.eq
          br_if 0 (;@3;)
          block  ;; label = @4
            loop  ;; label = @5
              local.get 9
              i32.const -24
              i32.add
              local.tee 2
              i32.load
              local.tee 4
              i64.load offset=8
              local.get 6
              i64.eq
              br_if 1 (;@4;)
              local.get 2
              local.set 9
              local.get 8
              local.get 2
              i32.ne
              br_if 0 (;@5;)
              br 2 (;@3;)
            end
          end
          local.get 8
          local.get 9
          i32.eq
          br_if 0 (;@3;)
          local.get 4
          i32.load offset=104
          local.get 7
          i32.eq
          i32.const 8355
          call 1
          br 1 (;@2;)
        end
        local.get 7
        local.get 7
        i64.load
        local.get 7
        i64.load offset=8
        i64.const 4229443000054317056
        local.get 6
        call 15
        call 73
        local.tee 4
        i32.load offset=104
        local.get 7
        i32.eq
        i32.const 8355
        call 1
      end
      local.get 4
      i32.const 112
      i32.add
      local.get 5
      i32.store
    end
    local.get 0
    local.get 4
    i32.store offset=4
    local.get 0
    local.get 1
    i32.store
    local.get 3
    i32.const 16
    i32.add
    global.set 0)
  (func (;76;) (type 26) (param i32) (result i32)
    (local i32 i32 i32 i32 i64 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 1
    global.set 0
    local.get 0
    i32.load offset=4
    i32.const 0
    i32.ne
    i32.const 8774
    call 1
    block  ;; label = @1
      local.get 0
      i32.load offset=4
      local.tee 2
      i32.load offset=112
      local.tee 3
      i32.const -1
      i32.ne
      br_if 0 (;@1;)
      local.get 0
      i32.load
      i32.load
      local.tee 3
      i64.load
      local.get 3
      i64.load offset=8
      i64.const 4229443000054317056
      local.get 1
      i32.const 8
      i32.add
      local.get 2
      i64.load offset=8
      call 19
      local.set 3
      local.get 0
      i32.const 4
      i32.add
      i32.load
      local.get 3
      i32.store offset=112
    end
    local.get 1
    i64.const 0
    i64.store offset=8
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            local.get 1
            i32.const 8
            i32.add
            call 23
            local.tee 4
            i32.const -1
            i32.le_s
            br_if 0 (;@4;)
            local.get 1
            i64.load offset=8
            local.set 5
            local.get 0
            i32.load
            i32.load
            local.tee 6
            i32.load offset=24
            local.tee 7
            local.get 6
            i32.const 28
            i32.add
            i32.load
            local.tee 2
            i32.eq
            br_if 2 (;@2;)
            loop  ;; label = @5
              local.get 2
              i32.const -24
              i32.add
              local.tee 3
              i32.load
              local.tee 8
              i64.load offset=8
              local.get 5
              i64.eq
              br_if 2 (;@3;)
              local.get 3
              local.set 2
              local.get 7
              local.get 3
              i32.ne
              br_if 0 (;@5;)
              br 3 (;@2;)
            end
          end
          local.get 0
          i32.const 4
          i32.add
          i32.const 0
          i32.store
          local.get 1
          i32.const 16
          i32.add
          global.set 0
          local.get 0
          return
        end
        local.get 7
        local.get 2
        i32.eq
        br_if 0 (;@2;)
        local.get 8
        i32.load offset=104
        local.get 6
        i32.eq
        i32.const 8355
        call 1
        br 1 (;@1;)
      end
      local.get 6
      local.get 6
      i64.load
      local.get 6
      i64.load offset=8
      i64.const 4229443000054317056
      local.get 5
      call 15
      call 73
      local.tee 8
      i32.load offset=104
      local.get 6
      i32.eq
      i32.const 8355
      call 1
    end
    local.get 0
    i32.const 4
    i32.add
    local.get 8
    i32.store
    local.get 8
    i32.const 112
    i32.add
    local.get 4
    i32.store
    local.get 1
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func (;77;) (type 27) (param i32 i64 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      local.get 0
      i32.load offset=24
      local.tee 3
      local.get 0
      i32.const 28
      i32.add
      i32.load
      local.tee 4
      i32.eq
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          local.get 4
          i32.const -24
          i32.add
          local.tee 5
          i32.load
          local.tee 6
          i64.load offset=8
          i64.const 8
          i64.shr_u
          local.get 1
          i64.eq
          br_if 1 (;@2;)
          local.get 5
          local.set 4
          local.get 3
          local.get 5
          i32.ne
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      local.get 3
      local.get 4
      i32.eq
      br_if 0 (;@1;)
      local.get 6
      i32.load offset=16
      local.get 0
      i32.eq
      i32.const 8355
      call 1
      local.get 6
      i32.const 0
      i32.ne
      local.get 2
      call 1
      local.get 6
      return
    end
    i32.const 0
    local.set 5
    block  ;; label = @1
      local.get 0
      i64.load
      local.get 0
      i64.load offset=8
      i64.const 3607749779137757184
      local.get 1
      call 15
      local.tee 4
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      local.get 0
      local.get 4
      call 80
      local.tee 5
      i32.load offset=16
      local.get 0
      i32.eq
      i32.const 8355
      call 1
    end
    local.get 5
    i32.const 0
    i32.ne
    local.get 2
    call 1
    local.get 5)
  (func (;78;) (type 23) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 4
        i32.sub
        i32.const 24
        i32.div_s
        local.tee 5
        i32.const 1
        i32.add
        local.tee 6
        i32.const 178956971
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 178956970
        local.set 7
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load offset=8
            local.get 4
            i32.sub
            i32.const 24
            i32.div_s
            local.tee 4
            i32.const 89478484
            i32.gt_u
            br_if 0 (;@4;)
            local.get 6
            local.get 4
            i32.const 1
            i32.shl
            local.tee 7
            local.get 7
            local.get 6
            i32.lt_u
            select
            local.tee 7
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 7
          i32.const 24
          i32.mul
          call 86
          local.set 4
          br 2 (;@1;)
        end
        i32.const 0
        local.set 7
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      local.get 0
      call 112
      unreachable
    end
    local.get 1
    i32.load
    local.set 6
    local.get 1
    i32.const 0
    i32.store
    local.get 4
    local.get 5
    i32.const 24
    i32.mul
    local.tee 8
    i32.add
    local.tee 1
    local.get 6
    i32.store
    local.get 1
    local.get 2
    i64.load
    i64.store offset=8
    local.get 1
    local.get 3
    i32.load
    i32.store offset=16
    local.get 4
    local.get 7
    i32.const 24
    i32.mul
    i32.add
    local.set 5
    local.get 1
    i32.const 24
    i32.add
    local.set 6
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.tee 2
        local.get 0
        i32.load
        local.tee 7
        i32.eq
        br_if 0 (;@2;)
        local.get 4
        local.get 8
        i32.add
        i32.const -24
        i32.add
        local.set 1
        loop  ;; label = @3
          local.get 2
          i32.const -24
          i32.add
          local.tee 4
          i32.load
          local.set 3
          local.get 4
          i32.const 0
          i32.store
          local.get 1
          local.get 3
          i32.store
          local.get 1
          i32.const 16
          i32.add
          local.get 2
          i32.const -8
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const 8
          i32.add
          local.get 2
          i32.const -16
          i32.add
          i64.load
          i64.store
          local.get 1
          i32.const -24
          i32.add
          local.set 1
          local.get 4
          local.set 2
          local.get 7
          local.get 4
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 1
        i32.const 24
        i32.add
        local.set 1
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 7
        local.get 0
        i32.load
        local.set 2
        br 1 (;@1;)
      end
      local.get 7
      local.set 2
    end
    local.get 0
    local.get 1
    i32.store
    local.get 0
    i32.const 4
    i32.add
    local.get 6
    i32.store
    local.get 0
    i32.const 8
    i32.add
    local.get 5
    i32.store
    block  ;; label = @1
      local.get 7
      local.get 2
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
          block  ;; label = @4
            local.get 1
            i32.load8_u offset=80
            i32.const 1
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            i32.const 88
            i32.add
            i32.load
            call 88
          end
          local.get 1
          call 88
        end
        local.get 2
        local.get 7
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      call 88
    end)
  (func (;79;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 2
    global.set 0
    local.get 2
    i32.const 0
    i32.store offset=24
    local.get 2
    i64.const 0
    i64.store offset=16
    local.get 0
    local.get 2
    i32.const 16
    i32.add
    call 58
    drop
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 2
                    i32.load offset=20
                    local.get 2
                    i32.load offset=16
                    local.tee 3
                    i32.sub
                    local.tee 4
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 2
                    i32.const 8
                    i32.add
                    i32.const 0
                    i32.store
                    local.get 2
                    i64.const 0
                    i64.store
                    local.get 4
                    i32.const -16
                    i32.ge_u
                    br_if 5 (;@3;)
                    local.get 4
                    i32.const 10
                    i32.gt_u
                    br_if 1 (;@7;)
                    local.get 2
                    local.get 4
                    i32.const 1
                    i32.shl
                    i32.store8
                    local.get 2
                    i32.const 1
                    i32.or
                    local.set 5
                    br 2 (;@6;)
                  end
                  local.get 1
                  i32.load8_u
                  i32.const 1
                  i32.and
                  br_if 2 (;@5;)
                  local.get 1
                  i32.const 0
                  i32.store16
                  local.get 1
                  i32.const 8
                  i32.add
                  local.set 3
                  br 3 (;@4;)
                end
                local.get 4
                i32.const 16
                i32.add
                i32.const -16
                i32.and
                local.tee 6
                call 86
                local.set 5
                local.get 2
                local.get 6
                i32.const 1
                i32.or
                i32.store
                local.get 2
                local.get 5
                i32.store offset=8
                local.get 2
                local.get 4
                i32.store offset=4
              end
              local.get 4
              local.set 7
              local.get 5
              local.set 6
              loop  ;; label = @6
                local.get 6
                local.get 3
                i32.load8_u
                i32.store8
                local.get 6
                i32.const 1
                i32.add
                local.set 6
                local.get 3
                i32.const 1
                i32.add
                local.set 3
                local.get 7
                i32.const -1
                i32.add
                local.tee 7
                br_if 0 (;@6;)
              end
              local.get 5
              local.get 4
              i32.add
              i32.const 0
              i32.store8
              block  ;; label = @6
                block  ;; label = @7
                  local.get 1
                  i32.load8_u
                  i32.const 1
                  i32.and
                  br_if 0 (;@7;)
                  local.get 1
                  i32.const 0
                  i32.store16
                  br 1 (;@6;)
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
              call 99
              local.get 1
              i32.const 8
              i32.add
              local.get 2
              i32.const 8
              i32.add
              i32.load
              i32.store
              local.get 1
              local.get 2
              i64.load
              i64.store align=4
              local.get 2
              i32.load offset=16
              local.tee 3
              i32.eqz
              br_if 4 (;@1;)
              br 3 (;@2;)
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
            local.set 3
          end
          local.get 1
          i32.const 0
          call 99
          local.get 3
          i32.const 0
          i32.store
          local.get 1
          i64.const 0
          i64.store align=4
          local.get 2
          i32.load offset=16
          local.tee 3
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        local.get 2
        call 94
        unreachable
      end
      local.get 2
      local.get 3
      i32.store offset=20
      local.get 3
      call 88
    end
    local.get 2
    i32.const 32
    i32.add
    global.set 0
    local.get 0)
  (func (;80;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i64 i32 i32)
    global.get 0
    i32.const 32
    i32.sub
    local.tee 2
    local.set 3
    local.get 2
    global.set 0
    block  ;; label = @1
      local.get 0
      i32.load offset=24
      local.tee 4
      local.get 0
      i32.const 28
      i32.add
      i32.load
      local.tee 5
      i32.eq
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          local.get 5
          i32.const -8
          i32.add
          i32.load
          local.get 1
          i32.eq
          br_if 1 (;@2;)
          local.get 4
          local.get 5
          i32.const -24
          i32.add
          local.tee 5
          i32.ne
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      local.get 4
      local.get 5
      i32.eq
      br_if 0 (;@1;)
      local.get 5
      i32.const -24
      i32.add
      i32.load
      local.set 5
      local.get 3
      i32.const 32
      i32.add
      global.set 0
      local.get 5
      return
    end
    local.get 1
    i32.const 0
    i32.const 0
    call 16
    local.tee 4
    i32.const 31
    i32.shr_u
    i32.const 1
    i32.xor
    i32.const 8406
    call 1
    block  ;; label = @1
      block  ;; label = @2
        local.get 4
        i32.const 513
        i32.lt_u
        br_if 0 (;@2;)
        local.get 4
        call 127
        local.set 2
        br 1 (;@1;)
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
    local.get 1
    local.get 2
    local.get 4
    call 16
    drop
    i32.const 32
    call 86
    local.tee 5
    i64.const 0
    i64.store offset=8
    local.get 5
    i64.const 0
    i64.store
    local.get 5
    local.get 0
    i32.store offset=16
    local.get 4
    i32.const 7
    i32.gt_u
    i32.const 8429
    call 1
    local.get 5
    local.get 2
    i32.const 8
    call 0
    drop
    local.get 3
    i64.const 0
    i64.store offset=24
    local.get 4
    i32.const -8
    i32.and
    i32.const 8
    i32.ne
    i32.const 8429
    call 1
    local.get 3
    i32.const 24
    i32.add
    local.get 2
    i32.const 8
    i32.add
    i32.const 8
    call 0
    drop
    local.get 5
    local.get 3
    i64.load offset=24
    local.tee 6
    i64.store offset=8
    local.get 5
    local.get 1
    i32.store offset=20
    local.get 3
    local.get 5
    i32.store offset=16
    local.get 3
    local.get 6
    i64.const 8
    i64.shr_u
    local.tee 6
    i64.store offset=24
    local.get 3
    local.get 1
    i32.store offset=12
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 28
          i32.add
          local.tee 7
          i32.load
          local.tee 8
          local.get 0
          i32.const 32
          i32.add
          i32.load
          i32.ge_u
          br_if 0 (;@3;)
          local.get 8
          local.get 6
          i64.store offset=8
          local.get 8
          local.get 1
          i32.store offset=16
          local.get 3
          i32.const 0
          i32.store offset=16
          local.get 8
          local.get 5
          i32.store
          local.get 7
          local.get 8
          i32.const 24
          i32.add
          i32.store
          local.get 4
          i32.const 513
          i32.ge_u
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        local.get 0
        i32.const 24
        i32.add
        local.get 3
        i32.const 16
        i32.add
        local.get 3
        i32.const 24
        i32.add
        local.get 3
        i32.const 12
        i32.add
        call 81
        local.get 4
        i32.const 513
        i32.lt_u
        br_if 1 (;@1;)
      end
      local.get 2
      call 130
    end
    local.get 3
    i32.load offset=16
    local.set 1
    local.get 3
    i32.const 0
    i32.store offset=16
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      call 88
    end
    local.get 3
    i32.const 32
    i32.add
    global.set 0
    local.get 5)
  (func (;81;) (type 23) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.load offset=4
        local.get 0
        i32.load
        local.tee 4
        i32.sub
        i32.const 24
        i32.div_s
        local.tee 5
        i32.const 1
        i32.add
        local.tee 6
        i32.const 178956971
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 178956970
        local.set 7
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load offset=8
            local.get 4
            i32.sub
            i32.const 24
            i32.div_s
            local.tee 4
            i32.const 89478484
            i32.gt_u
            br_if 0 (;@4;)
            local.get 6
            local.get 4
            i32.const 1
            i32.shl
            local.tee 7
            local.get 7
            local.get 6
            i32.lt_u
            select
            local.tee 7
            i32.eqz
            br_if 1 (;@3;)
          end
          local.get 7
          i32.const 24
          i32.mul
          call 86
          local.set 4
          br 2 (;@1;)
        end
        i32.const 0
        local.set 7
        i32.const 0
        local.set 4
        br 1 (;@1;)
      end
      local.get 0
      call 112
      unreachable
    end
    local.get 1
    i32.load
    local.set 6
    local.get 1
    i32.const 0
    i32.store
    local.get 4
    local.get 5
    i32.const 24
    i32.mul
    local.tee 8
    i32.add
    local.tee 1
    local.get 6
    i32.store
    local.get 1
    local.get 2
    i64.load
    i64.store offset=8
    local.get 1
    local.get 3
    i32.load
    i32.store offset=16
    local.get 4
    local.get 7
    i32.const 24
    i32.mul
    i32.add
    local.set 5
    local.get 1
    i32.const 24
    i32.add
    local.set 6
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.tee 2
        local.get 0
        i32.load
        local.tee 7
        i32.eq
        br_if 0 (;@2;)
        local.get 4
        local.get 8
        i32.add
        i32.const -24
        i32.add
        local.set 1
        loop  ;; label = @3
          local.get 2
          i32.const -24
          i32.add
          local.tee 4
          i32.load
          local.set 3
          local.get 4
          i32.const 0
          i32.store
          local.get 1
          local.get 3
          i32.store
          local.get 1
          i32.const 16
          i32.add
          local.get 2
          i32.const -8
          i32.add
          i32.load
          i32.store
          local.get 1
          i32.const 8
          i32.add
          local.get 2
          i32.const -16
          i32.add
          i64.load
          i64.store
          local.get 1
          i32.const -24
          i32.add
          local.set 1
          local.get 4
          local.set 2
          local.get 7
          local.get 4
          i32.ne
          br_if 0 (;@3;)
        end
        local.get 1
        i32.const 24
        i32.add
        local.set 1
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 7
        local.get 0
        i32.load
        local.set 2
        br 1 (;@1;)
      end
      local.get 7
      local.set 2
    end
    local.get 0
    local.get 1
    i32.store
    local.get 0
    i32.const 4
    i32.add
    local.get 6
    i32.store
    local.get 0
    i32.const 8
    i32.add
    local.get 5
    i32.store
    block  ;; label = @1
      local.get 7
      local.get 2
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
          call 88
        end
        local.get 2
        local.get 7
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      local.get 2
      i32.eqz
      br_if 0 (;@1;)
      local.get 2
      call 88
    end)
  (func (;82;) (type 5) (param i32 i32) (result i32)
    (local i32 i64 i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 1
    i32.load offset=4
    local.get 1
    i32.load
    i32.sub
    i32.const 4
    i32.shr_s
    i64.extend_i32_u
    local.set 3
    local.get 0
    i32.load offset=4
    local.set 4
    local.get 0
    i32.const 8
    i32.add
    local.set 5
    loop  ;; label = @1
      local.get 3
      i32.wrap_i64
      local.set 6
      local.get 2
      local.get 3
      i64.const 7
      i64.shr_u
      local.tee 3
      i64.const 0
      i64.ne
      local.tee 7
      i32.const 7
      i32.shl
      local.get 6
      i32.const 127
      i32.and
      i32.or
      i32.store8 offset=15
      local.get 5
      i32.load
      local.get 4
      i32.sub
      i32.const 0
      i32.gt_s
      i32.const 9085
      call 1
      local.get 0
      i32.const 4
      i32.add
      local.tee 6
      i32.load
      local.get 2
      i32.const 15
      i32.add
      i32.const 1
      call 0
      drop
      local.get 6
      local.get 6
      i32.load
      i32.const 1
      i32.add
      local.tee 4
      i32.store
      local.get 7
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      local.get 1
      i32.load
      local.tee 7
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
      local.set 6
      loop  ;; label = @2
        local.get 0
        i32.const 8
        i32.add
        local.tee 5
        i32.load
        local.get 4
        i32.sub
        i32.const 7
        i32.gt_s
        i32.const 9085
        call 1
        local.get 6
        i32.load
        local.get 7
        i32.const 8
        call 0
        drop
        local.get 6
        local.get 6
        i32.load
        i32.const 8
        i32.add
        local.tee 4
        i32.store
        local.get 5
        i32.load
        local.get 4
        i32.sub
        i32.const 7
        i32.gt_s
        i32.const 9085
        call 1
        local.get 6
        i32.load
        local.get 7
        i32.const 8
        i32.add
        i32.const 8
        call 0
        drop
        local.get 6
        local.get 6
        i32.load
        i32.const 8
        i32.add
        local.tee 4
        i32.store
        local.get 7
        i32.const 16
        i32.add
        local.tee 7
        local.get 1
        i32.ne
        br_if 0 (;@2;)
      end
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func (;83;) (type 5) (param i32 i32) (result i32)
    (local i32 i64 i32 i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 1
    i32.load offset=4
    local.get 1
    i32.load
    i32.sub
    i64.extend_i32_u
    local.set 3
    local.get 0
    i32.load offset=4
    local.set 4
    local.get 0
    i32.const 8
    i32.add
    local.set 5
    local.get 0
    i32.const 4
    i32.add
    local.set 6
    loop  ;; label = @1
      local.get 3
      i32.wrap_i64
      local.set 7
      local.get 2
      local.get 3
      i64.const 7
      i64.shr_u
      local.tee 3
      i64.const 0
      i64.ne
      local.tee 8
      i32.const 7
      i32.shl
      local.get 7
      i32.const 127
      i32.and
      i32.or
      i32.store8 offset=15
      local.get 5
      i32.load
      local.get 4
      i32.sub
      i32.const 0
      i32.gt_s
      i32.const 9085
      call 1
      local.get 6
      i32.load
      local.get 2
      i32.const 15
      i32.add
      i32.const 1
      call 0
      drop
      local.get 6
      local.get 6
      i32.load
      i32.const 1
      i32.add
      local.tee 4
      i32.store
      local.get 8
      br_if 0 (;@1;)
    end
    local.get 0
    i32.const 8
    i32.add
    i32.load
    local.get 4
    i32.sub
    local.get 1
    i32.const 4
    i32.add
    i32.load
    local.get 1
    i32.load
    local.tee 7
    i32.sub
    local.tee 6
    i32.ge_s
    i32.const 9085
    call 1
    local.get 0
    i32.const 4
    i32.add
    local.tee 4
    i32.load
    local.get 7
    local.get 6
    call 0
    drop
    local.get 4
    local.get 4
    i32.load
    local.get 6
    i32.add
    i32.store
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func (;84;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i64 i32 i32 i32 i32 i32 i32 i32 i64 i64)
    global.get 0
    i32.const 64
    i32.sub
    local.tee 2
    local.set 3
    local.get 2
    global.set 0
    local.get 1
    local.get 0
    i32.load offset=4
    local.tee 4
    i32.load
    local.tee 5
    i64.load offset=8
    i64.store offset=8
    local.get 1
    local.get 5
    i64.load offset=16
    i64.store offset=16
    local.get 0
    i32.load
    local.set 6
    local.get 1
    i32.const 32
    i32.add
    local.get 5
    i32.const 32
    i32.add
    i64.load
    i64.store
    local.get 1
    local.get 5
    i64.load offset=24
    i64.store offset=24
    local.get 1
    local.get 4
    i32.load
    local.tee 5
    i64.load offset=40
    i64.store offset=40
    local.get 1
    i32.const 48
    i32.add
    local.get 5
    i32.const 48
    i32.add
    i64.load
    i64.store
    local.get 1
    local.get 4
    i32.load
    local.tee 5
    i32.load offset=72
    i32.store offset=72
    local.get 1
    local.get 5
    i32.load
    i32.store
    local.get 1
    local.get 5
    i32.load offset=76
    i32.store offset=76
    local.get 1
    i32.const 80
    i32.add
    local.tee 7
    local.get 5
    i32.const 80
    i32.add
    call 97
    drop
    local.get 1
    local.get 4
    i32.load
    local.tee 4
    i64.load offset=96
    i64.store offset=96
    local.get 1
    local.get 4
    i64.load offset=56
    i64.store offset=56
    local.get 1
    i32.const 64
    i32.add
    local.get 4
    i32.const 64
    i32.add
    i64.load
    i64.store
    local.get 1
    i32.const 84
    i32.add
    i32.load
    local.get 1
    i32.load8_u offset=80
    local.tee 4
    i32.const 1
    i32.shr_u
    local.get 4
    i32.const 1
    i32.and
    select
    local.tee 5
    i32.const 84
    i32.add
    local.set 4
    local.get 5
    i64.extend_i32_u
    local.set 8
    local.get 1
    i32.const 56
    i32.add
    local.set 9
    local.get 1
    i32.const 96
    i32.add
    local.set 10
    local.get 1
    i32.const 76
    i32.add
    local.set 11
    local.get 1
    i32.const 72
    i32.add
    local.set 12
    local.get 1
    i32.const 40
    i32.add
    local.set 13
    local.get 1
    i32.const 24
    i32.add
    local.set 14
    local.get 1
    i32.const 8
    i32.add
    local.set 15
    loop  ;; label = @1
      local.get 4
      i32.const 1
      i32.add
      local.set 4
      local.get 8
      i64.const 7
      i64.shr_u
      local.tee 8
      i64.const 0
      i64.ne
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      block  ;; label = @2
        local.get 4
        i32.const 513
        i32.lt_u
        br_if 0 (;@2;)
        local.get 4
        call 127
        local.set 5
        br 1 (;@1;)
      end
      local.get 2
      local.get 4
      i32.const 15
      i32.add
      i32.const -16
      i32.and
      i32.sub
      local.tee 5
      global.set 0
    end
    local.get 3
    local.get 5
    i32.store offset=4
    local.get 3
    local.get 5
    i32.store
    local.get 3
    local.get 5
    local.get 4
    i32.add
    i32.store offset=8
    local.get 3
    local.get 3
    i32.store offset=16
    local.get 3
    local.get 15
    i32.store offset=28
    local.get 3
    local.get 1
    i32.store offset=24
    local.get 3
    local.get 1
    i32.const 16
    i32.add
    i32.store offset=32
    local.get 3
    local.get 14
    i32.store offset=36
    local.get 3
    local.get 13
    i32.store offset=40
    local.get 3
    local.get 9
    i32.store offset=44
    local.get 3
    local.get 12
    i32.store offset=48
    local.get 3
    local.get 11
    i32.store offset=52
    local.get 3
    local.get 7
    i32.store offset=56
    local.get 3
    local.get 10
    i32.store offset=60
    local.get 3
    i32.const 24
    i32.add
    local.get 3
    i32.const 16
    i32.add
    call 69
    local.get 1
    local.get 6
    i64.load offset=8
    i64.const 4229443000054317056
    local.get 0
    i32.load offset=8
    i64.load
    local.get 1
    i32.const 8
    i32.add
    i64.load
    local.tee 8
    local.get 5
    local.get 4
    call 24
    i32.store offset=108
    block  ;; label = @1
      local.get 4
      i32.const 513
      i32.lt_u
      br_if 0 (;@1;)
      local.get 5
      call 130
    end
    block  ;; label = @1
      local.get 8
      local.get 6
      i64.load offset=16
      i64.lt_u
      br_if 0 (;@1;)
      local.get 6
      i32.const 16
      i32.add
      i64.const -2
      local.get 8
      i64.const 1
      i64.add
      local.get 8
      i64.const -3
      i64.gt_u
      select
      i64.store
    end
    local.get 1
    i32.const 8
    i32.add
    i64.load
    local.set 8
    local.get 6
    i32.const 8
    i32.add
    i64.load
    local.set 16
    local.get 0
    i32.const 8
    i32.add
    i32.load
    i64.load
    local.set 17
    local.get 3
    local.get 1
    i32.const 96
    i32.add
    i64.load
    i64.store offset=24
    local.get 1
    local.get 16
    i64.const 4229443000054317056
    local.get 17
    local.get 8
    local.get 3
    i32.const 24
    i32.add
    call 25
    i32.store offset=112
    local.get 3
    i32.const 64
    i32.add
    global.set 0)
  (func (;85;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i64 i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    local.get 1
    i32.load offset=4
    local.get 1
    i32.load8_u
    local.tee 3
    i32.const 1
    i32.shr_u
    local.get 3
    i32.const 1
    i32.and
    select
    i64.extend_i32_u
    local.set 4
    local.get 0
    i32.load offset=4
    local.set 5
    local.get 0
    i32.const 8
    i32.add
    local.set 6
    local.get 0
    i32.const 4
    i32.add
    local.set 3
    loop  ;; label = @1
      local.get 4
      i32.wrap_i64
      local.set 7
      local.get 2
      local.get 4
      i64.const 7
      i64.shr_u
      local.tee 4
      i64.const 0
      i64.ne
      local.tee 8
      i32.const 7
      i32.shl
      local.get 7
      i32.const 127
      i32.and
      i32.or
      i32.store8 offset=15
      local.get 6
      i32.load
      local.get 5
      i32.sub
      i32.const 0
      i32.gt_s
      i32.const 9085
      call 1
      local.get 3
      i32.load
      local.get 2
      i32.const 15
      i32.add
      i32.const 1
      call 0
      drop
      local.get 3
      local.get 3
      i32.load
      i32.const 1
      i32.add
      local.tee 5
      i32.store
      local.get 8
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      local.get 1
      i32.const 4
      i32.add
      i32.load
      local.get 1
      i32.load8_u
      local.tee 3
      i32.const 1
      i32.shr_u
      local.get 3
      i32.const 1
      i32.and
      local.tee 7
      select
      local.tee 3
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      i32.load offset=8
      local.set 8
      local.get 0
      i32.const 8
      i32.add
      i32.load
      local.get 5
      i32.sub
      local.get 3
      i32.ge_s
      i32.const 9085
      call 1
      local.get 0
      i32.const 4
      i32.add
      local.tee 5
      i32.load
      local.get 8
      local.get 1
      i32.const 1
      i32.add
      local.get 7
      select
      local.get 3
      call 0
      drop
      local.get 5
      local.get 5
      i32.load
      local.get 3
      i32.add
      i32.store
    end
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func (;86;) (type 26) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      local.get 0
      i32.const 1
      local.get 0
      select
      local.tee 1
      call 127
      local.tee 0
      br_if 0 (;@1;)
      loop  ;; label = @2
        i32.const 0
        local.set 0
        i32.const 0
        i32.load offset=9224
        local.tee 2
        i32.eqz
        br_if 1 (;@1;)
        local.get 2
        call_indirect (type 1)
        local.get 1
        call 127
        local.tee 0
        i32.eqz
        br_if 0 (;@2;)
      end
    end
    local.get 0)
  (func (;87;) (type 26) (param i32) (result i32)
    local.get 0
    call 86)
  (func (;88;) (type 9) (param i32)
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      call 130
    end)
  (func (;89;) (type 9) (param i32)
    local.get 0
    call 88)
  (func (;90;) (type 5) (param i32 i32) (result i32)
    (local i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 2
    global.set 0
    block  ;; label = @1
      local.get 2
      i32.const 12
      i32.add
      local.get 1
      i32.const 4
      local.get 1
      i32.const 4
      i32.gt_u
      select
      local.tee 1
      local.get 0
      i32.const 1
      local.get 0
      select
      local.tee 3
      call 125
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          i32.const 0
          i32.load offset=9224
          local.tee 0
          i32.eqz
          br_if 1 (;@2;)
          local.get 0
          call_indirect (type 1)
          local.get 2
          i32.const 12
          i32.add
          local.get 1
          local.get 3
          call 125
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      local.get 2
      i32.const 0
      i32.store offset=12
    end
    local.get 2
    i32.load offset=12
    local.set 0
    local.get 2
    i32.const 16
    i32.add
    global.set 0
    local.get 0)
  (func (;91;) (type 5) (param i32 i32) (result i32)
    local.get 0
    local.get 1
    call 90)
  (func (;92;) (type 0) (param i32 i32)
    block  ;; label = @1
      local.get 0
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      call 130
    end)
  (func (;93;) (type 0) (param i32 i32)
    local.get 0
    local.get 1
    call 92)
  (func (;94;) (type 9) (param i32)
    call 26
    unreachable)
  (func (;95;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    i64.const 0
    i64.store align=4
    local.get 0
    i32.const 8
    i32.add
    local.tee 2
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
      local.get 2
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
      local.tee 2
      i32.const -16
      i32.ge_u
      br_if 0 (;@1;)
      local.get 1
      i32.load offset=8
      local.set 3
      block  ;; label = @2
        block  ;; label = @3
          local.get 2
          i32.const 11
          i32.ge_u
          br_if 0 (;@3;)
          local.get 0
          local.get 2
          i32.const 1
          i32.shl
          i32.store8
          local.get 0
          i32.const 1
          i32.add
          local.set 1
          local.get 2
          br_if 1 (;@2;)
          local.get 1
          local.get 2
          i32.add
          i32.const 0
          i32.store8
          local.get 0
          return
        end
        local.get 2
        i32.const 16
        i32.add
        i32.const -16
        i32.and
        local.tee 4
        call 86
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
        local.get 2
        i32.store offset=4
      end
      local.get 1
      local.get 3
      local.get 2
      call 0
      drop
      local.get 1
      local.get 2
      i32.add
      i32.const 0
      i32.store8
      local.get 0
      return
    end
    call 26
    unreachable)
  (func (;96;) (type 28) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    local.get 0
    i64.const 0
    i64.store align=4
    local.get 0
    i32.const 8
    i32.add
    i32.const 0
    i32.store
    block  ;; label = @1
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
      local.tee 6
      select
      local.tee 5
      local.get 2
      i32.lt_u
      br_if 0 (;@1;)
      local.get 5
      local.get 2
      i32.sub
      local.tee 5
      local.get 3
      local.get 5
      local.get 3
      i32.lt_u
      select
      local.tee 3
      i32.const -16
      i32.ge_u
      br_if 0 (;@1;)
      local.get 1
      i32.load offset=8
      local.set 7
      block  ;; label = @2
        block  ;; label = @3
          local.get 3
          i32.const 11
          i32.ge_u
          br_if 0 (;@3;)
          local.get 0
          local.get 3
          i32.const 1
          i32.shl
          i32.store8
          local.get 0
          i32.const 1
          i32.add
          local.set 5
          local.get 3
          br_if 1 (;@2;)
          local.get 5
          local.get 3
          i32.add
          i32.const 0
          i32.store8
          local.get 0
          return
        end
        local.get 3
        i32.const 16
        i32.add
        i32.const -16
        i32.and
        local.tee 8
        call 86
        local.set 5
        local.get 0
        local.get 8
        i32.const 1
        i32.or
        i32.store
        local.get 0
        local.get 5
        i32.store offset=8
        local.get 0
        local.get 3
        i32.store offset=4
      end
      local.get 5
      local.get 7
      local.get 1
      i32.const 1
      i32.add
      local.get 6
      select
      local.get 2
      i32.add
      local.get 3
      call 0
      drop
      local.get 5
      local.get 3
      i32.add
      i32.const 0
      i32.store8
      local.get 0
      return
    end
    call 26
    unreachable)
  (func (;97;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            local.get 1
            i32.eq
            br_if 0 (;@4;)
            local.get 1
            i32.load offset=4
            local.get 1
            i32.load8_u
            local.tee 2
            i32.const 1
            i32.shr_u
            local.get 2
            i32.const 1
            i32.and
            local.tee 3
            select
            local.set 2
            local.get 1
            i32.const 1
            i32.add
            local.set 4
            local.get 1
            i32.load offset=8
            local.set 5
            i32.const 10
            local.set 1
            block  ;; label = @5
              local.get 0
              i32.load8_u
              local.tee 6
              i32.const 1
              i32.and
              local.tee 7
              i32.eqz
              br_if 0 (;@5;)
              local.get 0
              i32.load
              i32.const -2
              i32.and
              i32.const -1
              i32.add
              local.set 1
            end
            local.get 5
            local.get 4
            local.get 3
            select
            local.set 3
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 2
                  local.get 1
                  i32.le_u
                  br_if 0 (;@7;)
                  local.get 7
                  br_if 1 (;@6;)
                  local.get 6
                  i32.const 1
                  i32.shr_u
                  local.set 4
                  br 2 (;@5;)
                end
                local.get 7
                br_if 3 (;@3;)
                local.get 0
                i32.const 1
                i32.add
                local.set 1
                local.get 2
                br_if 4 (;@2;)
                br 5 (;@1;)
              end
              local.get 0
              i32.load offset=4
              local.set 4
            end
            local.get 0
            local.get 1
            local.get 2
            local.get 1
            i32.sub
            local.get 4
            i32.const 0
            local.get 4
            local.get 2
            local.get 3
            call 98
          end
          local.get 0
          return
        end
        local.get 0
        i32.load offset=8
        local.set 1
        local.get 2
        i32.eqz
        br_if 1 (;@1;)
      end
      local.get 1
      local.get 3
      local.get 2
      call 3
      drop
    end
    local.get 1
    local.get 2
    i32.add
    i32.const 0
    i32.store8
    block  ;; label = @1
      local.get 0
      i32.load8_u
      i32.const 1
      i32.and
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i32.const 1
      i32.shl
      i32.store8
      local.get 0
      return
    end
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 0)
  (func (;98;) (type 29) (param i32 i32 i32 i32 i32 i32 i32 i32)
    (local i32 i32 i32)
    block  ;; label = @1
      i32.const -18
      local.get 1
      i32.sub
      local.get 2
      i32.lt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load8_u
            i32.const 1
            i32.and
            br_if 0 (;@4;)
            local.get 0
            i32.const 1
            i32.add
            local.set 8
            i32.const -17
            local.set 9
            local.get 1
            i32.const 2147483622
            i32.le_u
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          local.get 0
          i32.load offset=8
          local.set 8
          i32.const -17
          local.set 9
          local.get 1
          i32.const 2147483622
          i32.gt_u
          br_if 1 (;@2;)
        end
        i32.const 11
        local.set 9
        local.get 1
        i32.const 1
        i32.shl
        local.tee 10
        local.get 2
        local.get 1
        i32.add
        local.tee 2
        local.get 2
        local.get 10
        i32.lt_u
        select
        local.tee 2
        i32.const 11
        i32.lt_u
        br_if 0 (;@2;)
        local.get 2
        i32.const 16
        i32.add
        i32.const -16
        i32.and
        local.set 9
      end
      local.get 9
      call 86
      local.set 2
      block  ;; label = @2
        local.get 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 8
        local.get 4
        call 0
        drop
      end
      block  ;; label = @2
        local.get 6
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 4
        i32.add
        local.get 7
        local.get 6
        call 0
        drop
      end
      block  ;; label = @2
        local.get 3
        local.get 5
        i32.sub
        local.tee 3
        local.get 4
        i32.sub
        local.tee 7
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 4
        i32.add
        local.get 6
        i32.add
        local.get 8
        local.get 4
        i32.add
        local.get 5
        i32.add
        local.get 7
        call 0
        drop
      end
      block  ;; label = @2
        local.get 1
        i32.const 10
        i32.eq
        br_if 0 (;@2;)
        local.get 8
        call 88
      end
      local.get 0
      local.get 2
      i32.store offset=8
      local.get 0
      local.get 9
      i32.const 1
      i32.or
      i32.store
      local.get 0
      local.get 3
      local.get 6
      i32.add
      local.tee 4
      i32.store offset=4
      local.get 2
      local.get 4
      i32.add
      i32.const 0
      i32.store8
      return
    end
    call 26
    unreachable)
  (func (;99;) (type 0) (param i32 i32)
    (local i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            i32.const -16
            i32.ge_u
            br_if 0 (;@4;)
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.load8_u
                local.tee 2
                i32.const 1
                i32.and
                br_if 0 (;@6;)
                local.get 2
                i32.const 1
                i32.shr_u
                local.set 3
                i32.const 10
                local.set 4
                br 1 (;@5;)
              end
              local.get 0
              i32.load
              local.tee 2
              i32.const -2
              i32.and
              i32.const -1
              i32.add
              local.set 4
              local.get 0
              i32.load offset=4
              local.set 3
            end
            i32.const 10
            local.set 5
            block  ;; label = @5
              local.get 3
              local.get 1
              local.get 3
              local.get 1
              i32.gt_u
              select
              local.tee 1
              i32.const 11
              i32.lt_u
              br_if 0 (;@5;)
              local.get 1
              i32.const 16
              i32.add
              i32.const -16
              i32.and
              i32.const -1
              i32.add
              local.set 5
            end
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 5
                  local.get 4
                  i32.eq
                  br_if 0 (;@7;)
                  block  ;; label = @8
                    local.get 5
                    i32.const 10
                    i32.ne
                    br_if 0 (;@8;)
                    i32.const 1
                    local.set 6
                    local.get 0
                    i32.const 1
                    i32.add
                    local.set 1
                    local.get 0
                    i32.load offset=8
                    local.set 4
                    i32.const 0
                    local.set 7
                    i32.const 1
                    local.set 8
                    local.get 2
                    i32.const 1
                    i32.and
                    br_if 3 (;@5;)
                    br 5 (;@3;)
                  end
                  local.get 5
                  i32.const 1
                  i32.add
                  call 86
                  local.set 1
                  local.get 5
                  local.get 4
                  i32.gt_u
                  br_if 1 (;@6;)
                  local.get 1
                  br_if 1 (;@6;)
                end
                return
              end
              block  ;; label = @6
                local.get 0
                i32.load8_u
                local.tee 2
                i32.const 1
                i32.and
                br_if 0 (;@6;)
                i32.const 1
                local.set 7
                local.get 0
                i32.const 1
                i32.add
                local.set 4
                i32.const 0
                local.set 6
                i32.const 1
                local.set 8
                local.get 2
                i32.const 1
                i32.and
                i32.eqz
                br_if 3 (;@3;)
                br 1 (;@5;)
              end
              local.get 0
              i32.load offset=8
              local.set 4
              i32.const 1
              local.set 6
              i32.const 1
              local.set 7
              i32.const 1
              local.set 8
              local.get 2
              i32.const 1
              i32.and
              i32.eqz
              br_if 2 (;@3;)
            end
            local.get 0
            i32.load offset=4
            i32.const 1
            i32.add
            local.tee 2
            i32.eqz
            br_if 3 (;@1;)
            br 2 (;@2;)
          end
          call 26
          unreachable
        end
        local.get 2
        i32.const 254
        i32.and
        local.get 8
        i32.shr_u
        i32.const 1
        i32.add
        local.tee 2
        i32.eqz
        br_if 1 (;@1;)
      end
      local.get 1
      local.get 4
      local.get 2
      call 0
      drop
    end
    block  ;; label = @1
      local.get 6
      i32.eqz
      br_if 0 (;@1;)
      local.get 4
      call 88
    end
    block  ;; label = @1
      local.get 7
      i32.eqz
      br_if 0 (;@1;)
      local.get 0
      local.get 3
      i32.store offset=4
      local.get 0
      local.get 1
      i32.store offset=8
      local.get 0
      local.get 5
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
    i32.store8)
  (func (;100;) (type 30) (param i32 i32 i32 i32 i32 i32 i32)
    (local i32 i32 i32)
    block  ;; label = @1
      i32.const -17
      local.get 1
      i32.sub
      local.get 2
      i32.lt_u
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load8_u
            i32.const 1
            i32.and
            br_if 0 (;@4;)
            local.get 0
            i32.const 1
            i32.add
            local.set 7
            i32.const -17
            local.set 8
            local.get 1
            i32.const 2147483622
            i32.le_u
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          local.get 0
          i32.load offset=8
          local.set 7
          i32.const -17
          local.set 8
          local.get 1
          i32.const 2147483622
          i32.gt_u
          br_if 1 (;@2;)
        end
        i32.const 11
        local.set 8
        local.get 1
        i32.const 1
        i32.shl
        local.tee 9
        local.get 2
        local.get 1
        i32.add
        local.tee 2
        local.get 2
        local.get 9
        i32.lt_u
        select
        local.tee 2
        i32.const 11
        i32.lt_u
        br_if 0 (;@2;)
        local.get 2
        i32.const 16
        i32.add
        i32.const -16
        i32.and
        local.set 8
      end
      local.get 8
      call 86
      local.set 2
      block  ;; label = @2
        local.get 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 7
        local.get 4
        call 0
        drop
      end
      block  ;; label = @2
        local.get 3
        local.get 5
        i32.sub
        local.get 4
        i32.sub
        local.tee 3
        i32.eqz
        br_if 0 (;@2;)
        local.get 2
        local.get 4
        i32.add
        local.get 6
        i32.add
        local.get 7
        local.get 4
        i32.add
        local.get 5
        i32.add
        local.get 3
        call 0
        drop
      end
      block  ;; label = @2
        local.get 1
        i32.const 10
        i32.eq
        br_if 0 (;@2;)
        local.get 7
        call 88
      end
      local.get 0
      local.get 2
      i32.store offset=8
      local.get 0
      local.get 8
      i32.const 1
      i32.or
      i32.store
      return
    end
    call 26
    unreachable)
  (func (;101;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32 i32)
    local.get 1
    call 124
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.load8_u
                local.tee 3
                i32.const 1
                i32.and
                local.tee 4
                br_if 0 (;@6;)
                i32.const 10
                local.set 5
                i32.const 10
                local.get 3
                i32.const 1
                i32.shr_u
                local.tee 3
                i32.sub
                local.get 2
                i32.lt_u
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
              local.get 0
              i32.load
              i32.const -2
              i32.and
              i32.const -1
              i32.add
              local.tee 5
              local.get 0
              i32.load offset=4
              local.tee 3
              i32.sub
              local.get 2
              i32.ge_u
              br_if 1 (;@4;)
            end
            local.get 0
            local.get 5
            local.get 3
            local.get 2
            i32.add
            local.get 5
            i32.sub
            local.get 3
            local.get 3
            i32.const 0
            local.get 2
            local.get 1
            call 98
            br 1 (;@3;)
          end
          local.get 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          br_if 1 (;@2;)
          local.get 0
          i32.const 1
          i32.add
          local.set 5
          br 2 (;@1;)
        end
        local.get 0
        return
      end
      local.get 0
      i32.load offset=8
      local.set 5
    end
    local.get 5
    local.get 3
    i32.add
    local.get 1
    local.get 2
    call 0
    drop
    local.get 3
    local.get 2
    i32.add
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.load8_u
      i32.const 1
      i32.and
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i32.const 1
      i32.shl
      i32.store8
      local.get 5
      local.get 2
      i32.add
      i32.const 0
      i32.store8
      local.get 0
      return
    end
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 5
    local.get 2
    i32.add
    i32.const 0
    i32.store8
    local.get 0)
  (func (;102;) (type 0) (param i32 i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.load8_u
                local.tee 2
                i32.const 1
                i32.and
                local.tee 3
                i32.eqz
                br_if 0 (;@6;)
                local.get 0
                i32.load offset=4
                local.tee 2
                local.get 0
                i32.load
                i32.const -2
                i32.and
                i32.const -1
                i32.add
                local.tee 4
                i32.eq
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
              i32.const 10
              local.set 4
              local.get 2
              i32.const 1
              i32.shr_u
              local.tee 2
              i32.const 10
              i32.ne
              br_if 1 (;@4;)
            end
            local.get 0
            local.get 4
            i32.const 1
            local.get 4
            local.get 4
            i32.const 0
            i32.const 0
            call 100
            local.get 0
            i32.load8_u
            i32.const 1
            i32.and
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          local.get 3
          i32.eqz
          br_if 1 (;@2;)
        end
        local.get 0
        local.get 2
        i32.const 1
        i32.add
        i32.store offset=4
        local.get 0
        i32.load offset=8
        local.set 0
        br 1 (;@1;)
      end
      local.get 0
      local.get 2
      i32.const 1
      i32.shl
      i32.const 2
      i32.add
      i32.store8
      local.get 0
      i32.const 1
      i32.add
      local.set 0
    end
    local.get 0
    local.get 2
    i32.add
    local.tee 0
    i32.const 0
    i32.store8 offset=1
    local.get 0
    local.get 1
    i32.store8)
  (func (;103;) (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.load8_u
                local.tee 3
                i32.const 1
                i32.and
                local.tee 4
                br_if 0 (;@6;)
                i32.const 10
                local.set 5
                i32.const 10
                local.get 3
                i32.const 1
                i32.shr_u
                local.tee 3
                i32.sub
                local.get 2
                i32.lt_u
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
              local.get 0
              i32.load
              i32.const -2
              i32.and
              i32.const -1
              i32.add
              local.tee 5
              local.get 0
              i32.load offset=4
              local.tee 3
              i32.sub
              local.get 2
              i32.ge_u
              br_if 1 (;@4;)
            end
            local.get 0
            local.get 5
            local.get 3
            local.get 2
            i32.add
            local.get 5
            i32.sub
            local.get 3
            local.get 3
            i32.const 0
            local.get 2
            local.get 1
            call 98
            br 1 (;@3;)
          end
          local.get 2
          i32.eqz
          br_if 0 (;@3;)
          local.get 4
          br_if 1 (;@2;)
          local.get 0
          i32.const 1
          i32.add
          local.set 5
          br 2 (;@1;)
        end
        local.get 0
        return
      end
      local.get 0
      i32.load offset=8
      local.set 5
    end
    local.get 5
    local.get 3
    i32.add
    local.get 1
    local.get 2
    call 0
    drop
    local.get 3
    local.get 2
    i32.add
    local.set 2
    block  ;; label = @1
      local.get 0
      i32.load8_u
      i32.const 1
      i32.and
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i32.const 1
      i32.shl
      i32.store8
      local.get 5
      local.get 2
      i32.add
      i32.const 0
      i32.store8
      local.get 0
      return
    end
    local.get 0
    local.get 2
    i32.store offset=4
    local.get 5
    local.get 2
    i32.add
    i32.const 0
    i32.store8
    local.get 0)
  (func (;104;) (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.load8_u
          local.tee 3
          i32.const 1
          i32.and
          local.tee 4
          br_if 0 (;@3;)
          local.get 3
          i32.const 1
          i32.shr_u
          local.tee 5
          local.get 1
          i32.ge_u
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        local.get 0
        i32.load offset=4
        local.tee 5
        local.get 1
        i32.lt_u
        br_if 1 (;@1;)
      end
      block  ;; label = @2
        local.get 2
        i32.eqz
        br_if 0 (;@2;)
        block  ;; label = @3
          block  ;; label = @4
            local.get 4
            br_if 0 (;@4;)
            local.get 0
            i32.const 1
            i32.add
            local.set 6
            br 1 (;@3;)
          end
          local.get 0
          i32.load offset=8
          local.set 6
        end
        block  ;; label = @3
          local.get 5
          local.get 1
          i32.sub
          local.tee 4
          local.get 4
          local.get 2
          local.get 4
          local.get 2
          i32.lt_u
          select
          local.tee 2
          i32.sub
          local.tee 4
          i32.eqz
          br_if 0 (;@3;)
          local.get 6
          local.get 1
          i32.add
          local.tee 1
          local.get 1
          local.get 2
          i32.add
          local.get 4
          call 3
          drop
          local.get 0
          i32.load8_u
          local.set 3
        end
        local.get 5
        local.get 2
        i32.sub
        local.set 2
        block  ;; label = @3
          block  ;; label = @4
            local.get 3
            i32.const 1
            i32.and
            br_if 0 (;@4;)
            local.get 0
            local.get 2
            i32.const 1
            i32.shl
            i32.store8
            br 1 (;@3;)
          end
          local.get 0
          local.get 2
          i32.store offset=4
        end
        local.get 6
        local.get 2
        i32.add
        i32.const 0
        i32.store8
      end
      local.get 0
      return
    end
    call 26
    unreachable)
  (func (;105;) (type 28) (param i32 i32 i32 i32 i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 0
              i32.load8_u
              local.tee 5
              i32.const 1
              i32.and
              local.tee 6
              br_if 0 (;@5;)
              local.get 5
              i32.const 1
              i32.shr_u
              local.set 5
              local.get 4
              i32.const -1
              i32.ne
              br_if 1 (;@4;)
              br 2 (;@3;)
            end
            local.get 0
            i32.load offset=4
            local.set 5
            local.get 4
            i32.const -1
            i32.eq
            br_if 1 (;@3;)
          end
          local.get 5
          local.get 1
          i32.lt_u
          br_if 0 (;@3;)
          local.get 5
          local.get 1
          i32.sub
          local.tee 5
          local.get 2
          local.get 5
          local.get 2
          i32.lt_u
          select
          local.set 2
          block  ;; label = @4
            local.get 6
            br_if 0 (;@4;)
            local.get 0
            i32.const 1
            i32.add
            local.set 0
            local.get 4
            local.get 2
            local.get 2
            local.get 4
            i32.gt_u
            local.tee 6
            select
            local.tee 5
            i32.eqz
            br_if 3 (;@1;)
            br 2 (;@2;)
          end
          local.get 0
          i32.load offset=8
          local.set 0
          local.get 4
          local.get 2
          local.get 2
          local.get 4
          i32.gt_u
          local.tee 6
          select
          local.tee 5
          br_if 1 (;@2;)
          br 2 (;@1;)
        end
        call 26
        unreachable
      end
      local.get 0
      local.get 1
      i32.add
      local.get 3
      local.get 5
      call 123
      local.tee 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      return
    end
    i32.const -1
    local.get 6
    local.get 2
    local.get 4
    i32.lt_u
    select)
  (func (;106;) (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32 i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 3
    global.set 0
    local.get 3
    i32.const 8
    i32.add
    i32.const 0
    i32.store
    local.get 3
    i64.const 0
    i64.store
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          i32.const 8209
          call 124
          local.tee 4
          i32.const -16
          i32.ge_u
          br_if 0 (;@3;)
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 4
                i32.const 11
                i32.ge_u
                br_if 0 (;@6;)
                local.get 3
                local.get 4
                i32.const 1
                i32.shl
                i32.store8
                local.get 3
                i32.const 1
                i32.or
                local.set 5
                local.get 4
                br_if 1 (;@5;)
                br 2 (;@4;)
              end
              local.get 4
              i32.const 16
              i32.add
              i32.const -16
              i32.and
              local.tee 6
              call 86
              local.set 5
              local.get 3
              local.get 6
              i32.const 1
              i32.or
              i32.store
              local.get 3
              local.get 5
              i32.store offset=8
              local.get 3
              local.get 4
              i32.store offset=4
            end
            local.get 5
            i32.const 8209
            local.get 4
            call 0
            drop
          end
          local.get 5
          local.get 4
          i32.add
          i32.const 0
          i32.store8
          local.get 3
          i32.const 0
          i32.store offset=12
          local.get 0
          i32.load offset=8
          local.set 4
          local.get 0
          i32.load8_u
          local.set 5
          call 114
          i32.load
          local.set 6
          call 114
          i32.const 0
          i32.store
          local.get 4
          local.get 0
          i32.const 1
          i32.add
          local.get 5
          i32.const 1
          i32.and
          select
          local.tee 4
          local.get 3
          i32.const 12
          i32.add
          local.get 2
          call 121
          local.set 0
          call 114
          local.tee 5
          i32.load
          local.set 2
          local.get 5
          local.get 6
          i32.store
          local.get 2
          i32.const 34
          i32.eq
          br_if 1 (;@2;)
          local.get 3
          i32.load offset=12
          local.tee 5
          local.get 4
          i32.eq
          br_if 2 (;@1;)
          block  ;; label = @4
            local.get 1
            i32.eqz
            br_if 0 (;@4;)
            local.get 1
            local.get 5
            local.get 4
            i32.sub
            i32.store
          end
          block  ;; label = @4
            local.get 3
            i32.load8_u
            i32.const 1
            i32.and
            i32.eqz
            br_if 0 (;@4;)
            local.get 3
            i32.load offset=8
            call 88
          end
          local.get 3
          i32.const 16
          i32.add
          global.set 0
          local.get 0
          return
        end
        call 26
        unreachable
      end
      local.get 3
      call 107
      unreachable
    end
    local.get 3
    call 108
    unreachable)
  (func (;107;) (type 9) (param i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 1
    global.set 0
    local.get 1
    local.get 0
    i32.const 17656
    call 109
    call 110
    unreachable)
  (func (;108;) (type 9) (param i32)
    (local i32)
    global.get 0
    i32.const 16
    i32.sub
    local.tee 1
    global.set 0
    local.get 1
    local.get 0
    i32.const 17640
    call 109
    call 111
    unreachable)
  (func (;109;) (type 3) (param i32 i32 i32)
    (local i32 i32 i32 i32 i32 i32)
    local.get 0
    i32.const 0
    i32.store offset=8
    local.get 0
    i64.const 0
    i64.store align=4
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 1
            i32.load offset=4
            local.get 1
            i32.load8_u
            local.tee 3
            i32.const 1
            i32.shr_u
            local.get 3
            i32.const 1
            i32.and
            select
            local.tee 3
            local.get 2
            call 124
            local.tee 4
            i32.add
            local.tee 5
            i32.const -16
            i32.ge_u
            br_if 0 (;@4;)
            local.get 1
            i32.load8_u
            local.set 6
            local.get 1
            i32.load offset=8
            local.set 7
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  local.get 5
                  i32.const 10
                  i32.gt_u
                  br_if 0 (;@7;)
                  local.get 0
                  local.get 3
                  i32.const 1
                  i32.shl
                  i32.store8
                  local.get 0
                  i32.const 1
                  i32.add
                  local.set 5
                  local.get 3
                  br_if 1 (;@6;)
                  br 2 (;@5;)
                end
                local.get 5
                i32.const 16
                i32.add
                i32.const -16
                i32.and
                local.tee 8
                call 86
                local.set 5
                local.get 0
                local.get 8
                i32.const 1
                i32.or
                i32.store
                local.get 0
                i32.const 8
                i32.add
                local.get 5
                i32.store
                local.get 0
                i32.const 4
                i32.add
                local.get 3
                i32.store
                local.get 3
                i32.eqz
                br_if 1 (;@5;)
              end
              local.get 5
              local.get 7
              local.get 1
              i32.const 1
              i32.add
              local.get 6
              i32.const 1
              i32.and
              select
              local.get 3
              call 0
              drop
            end
            local.get 5
            local.get 3
            i32.add
            i32.const 0
            i32.store8
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i32.load8_u
                local.tee 1
                i32.const 1
                i32.and
                local.tee 5
                br_if 0 (;@6;)
                i32.const 10
                local.set 3
                i32.const 10
                local.get 1
                i32.const 1
                i32.shr_u
                local.tee 1
                i32.sub
                local.get 4
                i32.lt_u
                br_if 1 (;@5;)
                br 3 (;@3;)
              end
              local.get 0
              i32.load
              i32.const -2
              i32.and
              i32.const -1
              i32.add
              local.tee 3
              local.get 0
              i32.const 4
              i32.add
              i32.load
              local.tee 1
              i32.sub
              local.get 4
              i32.ge_u
              br_if 2 (;@3;)
            end
            local.get 0
            local.get 3
            local.get 1
            local.get 4
            i32.add
            local.get 3
            i32.sub
            local.get 1
            local.get 1
            i32.const 0
            local.get 4
            local.get 2
            call 98
            br 2 (;@2;)
          end
          call 26
          unreachable
        end
        local.get 4
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 8
        i32.add
        i32.load
        local.get 0
        i32.const 1
        i32.add
        local.get 5
        select
        local.tee 3
        local.get 1
        i32.add
        local.get 2
        local.get 4
        call 0
        drop
        local.get 1
        local.get 4
        i32.add
        local.set 1
        local.get 0
        i32.load8_u
        i32.const 1
        i32.and
        br_if 1 (;@1;)
        local.get 0
        local.get 1
        i32.const 1
        i32.shl
        i32.store8
        local.get 3
        local.get 1
        i32.add
        i32.const 0
        i32.store8
        return
      end
      return
    end
    local.get 0
    i32.const 4
    i32.add
    local.get 1
    i32.store
    local.get 3
    local.get 1
    i32.add
    i32.const 0
    i32.store8)
  (func (;110;) (type 1)
    call 26
    unreachable)
  (func (;111;) (type 1)
    call 26
    unreachable)
  (func (;112;) (type 9) (param i32)
    call 26
    unreachable)
  (func (;113;) (type 26) (param i32) (result i32)
    local.get 0
    i32.const 32
    i32.eq
    local.get 0
    i32.const -9
    i32.add
    i32.const 5
    i32.lt_u
    i32.or)
  (func (;114;) (type 4) (result i32)
    i32.const 9228)
  (func (;115;) (type 9) (param i32))
  (func (;116;) (type 26) (param i32) (result i32)
    (local i32 i32)
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
      call_indirect (type 2)
      drop
    end
    local.get 0
    i64.const 0
    i64.store offset=16
    local.get 0
    i32.const 28
    i32.add
    i32.const 0
    i32.store
    block  ;; label = @1
      local.get 0
      i32.load
      local.tee 1
      i32.const 4
      i32.and
      br_if 0 (;@1;)
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
      i32.shr_s
      return
    end
    local.get 0
    local.get 1
    i32.const 32
    i32.or
    i32.store
    i32.const -1)
  (func (;117;) (type 26) (param i32) (result i32)
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
      call 116
      br_if 0 (;@1;)
      local.get 0
      local.get 1
      i32.const 15
      i32.add
      i32.const 1
      local.get 0
      i32.load offset=32
      call_indirect (type 2)
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
  (func (;118;) (type 31) (param i32 i64)
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
    block  ;; label = @1
      local.get 1
      i64.eqz
      br_if 0 (;@1;)
      local.get 4
      local.get 1
      i64.le_s
      br_if 0 (;@1;)
      local.get 0
      local.get 3
      local.get 1
      i32.wrap_i64
      i32.add
      i32.store offset=104
      return
    end
    local.get 0
    local.get 2
    i32.store offset=104)
  (func (;119;) (type 26) (param i32) (result i32)
    (local i64 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                local.get 0
                i64.load offset=112
                local.tee 1
                i64.eqz
                br_if 0 (;@6;)
                local.get 0
                i64.load offset=120
                local.get 1
                i64.ge_s
                br_if 1 (;@5;)
              end
              local.get 0
              call 117
              local.tee 2
              i32.const -1
              i32.le_s
              br_if 0 (;@5;)
              local.get 0
              i32.load offset=8
              local.set 3
              block  ;; label = @6
                local.get 0
                i32.const 112
                i32.add
                i64.load
                local.tee 1
                i64.const 0
                i64.eq
                br_if 0 (;@6;)
                local.get 1
                local.get 0
                i64.load offset=120
                i64.sub
                local.tee 1
                local.get 3
                local.get 0
                i32.load offset=4
                local.tee 4
                i32.sub
                i64.extend_i32_s
                i64.le_s
                br_if 2 (;@4;)
              end
              local.get 0
              local.get 3
              i32.store offset=104
              local.get 3
              i32.eqz
              br_if 2 (;@3;)
              br 3 (;@2;)
            end
            local.get 0
            i32.const 0
            i32.store offset=104
            i32.const -1
            return
          end
          local.get 0
          local.get 4
          local.get 1
          i32.wrap_i64
          i32.add
          i32.const -1
          i32.add
          i32.store offset=104
          local.get 3
          br_if 1 (;@2;)
        end
        local.get 0
        i32.const 4
        i32.add
        i32.load
        local.set 3
        br 1 (;@1;)
      end
      local.get 0
      local.get 0
      i64.load offset=120
      local.get 3
      i32.const 1
      i32.add
      local.get 0
      i32.const 4
      i32.add
      i32.load
      local.tee 3
      i32.sub
      i64.extend_i32_s
      i64.add
      i64.store offset=120
    end
    block  ;; label = @1
      local.get 2
      local.get 3
      i32.const -1
      i32.add
      local.tee 0
      i32.load8_u
      i32.eq
      br_if 0 (;@1;)
      local.get 0
      local.get 2
      i32.store8
    end
    local.get 2)
  (func (;120;) (type 32) (param i32 i32 i32 i64) (result i64)
    (local i32 i32 i32 i32 i64 i32 i64 i64 i64 i64 i32)
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
                            block  ;; label = @13
                              block  ;; label = @14
                                block  ;; label = @15
                                  block  ;; label = @16
                                    block  ;; label = @17
                                      local.get 1
                                      i32.const 36
                                      i32.gt_u
                                      br_if 0 (;@17;)
                                      local.get 1
                                      i32.const 1
                                      i32.eq
                                      br_if 0 (;@17;)
                                      local.get 0
                                      i32.const 104
                                      i32.add
                                      local.set 4
                                      local.get 0
                                      i32.const 4
                                      i32.add
                                      local.set 5
                                      loop  ;; label = @18
                                        block  ;; label = @19
                                          block  ;; label = @20
                                            local.get 5
                                            i32.load
                                            local.tee 6
                                            local.get 4
                                            i32.load
                                            i32.lt_u
                                            br_if 0 (;@20;)
                                            local.get 0
                                            call 119
                                            local.tee 6
                                            i32.const -9
                                            i32.add
                                            i32.const 5
                                            i32.ge_u
                                            br_if 1 (;@19;)
                                            br 2 (;@18;)
                                          end
                                          local.get 5
                                          local.get 6
                                          i32.const 1
                                          i32.add
                                          i32.store
                                          local.get 6
                                          i32.load8_u
                                          local.tee 6
                                          i32.const -9
                                          i32.add
                                          i32.const 5
                                          i32.lt_u
                                          br_if 1 (;@18;)
                                        end
                                        local.get 6
                                        i32.const 32
                                        i32.eq
                                        br_if 0 (;@18;)
                                      end
                                      block  ;; label = @18
                                        local.get 6
                                        i32.const 45
                                        i32.eq
                                        local.tee 5
                                        br_if 0 (;@18;)
                                        local.get 6
                                        i32.const 43
                                        i32.ne
                                        br_if 2 (;@16;)
                                      end
                                      i32.const -1
                                      i32.const 0
                                      local.get 5
                                      select
                                      local.set 7
                                      local.get 0
                                      i32.const 4
                                      i32.add
                                      local.tee 5
                                      i32.load
                                      local.tee 6
                                      local.get 0
                                      i32.const 104
                                      i32.add
                                      i32.load
                                      i32.ge_u
                                      br_if 2 (;@15;)
                                      local.get 5
                                      local.get 6
                                      i32.const 1
                                      i32.add
                                      i32.store
                                      local.get 6
                                      i32.load8_u
                                      local.set 6
                                      local.get 1
                                      i32.const 16
                                      i32.or
                                      i32.const 16
                                      i32.ne
                                      br_if 4 (;@13;)
                                      br 3 (;@14;)
                                    end
                                    call 114
                                    i32.const 22
                                    i32.store
                                    i64.const 0
                                    return
                                  end
                                  i32.const 0
                                  local.set 7
                                  local.get 1
                                  i32.const 16
                                  i32.or
                                  i32.const 16
                                  i32.eq
                                  br_if 1 (;@14;)
                                  br 2 (;@13;)
                                end
                                local.get 0
                                call 119
                                local.set 6
                                local.get 1
                                i32.const 16
                                i32.or
                                i32.const 16
                                i32.ne
                                br_if 1 (;@13;)
                              end
                              local.get 6
                              i32.const 48
                              i32.ne
                              br_if 0 (;@13;)
                              local.get 0
                              i32.const 4
                              i32.add
                              local.tee 5
                              i32.load
                              local.tee 6
                              local.get 0
                              i32.const 104
                              i32.add
                              i32.load
                              i32.ge_u
                              br_if 1 (;@12;)
                              local.get 5
                              local.get 6
                              i32.const 1
                              i32.add
                              i32.store
                              local.get 6
                              i32.load8_u
                              local.set 6
                              br 2 (;@11;)
                            end
                            local.get 1
                            i32.const 10
                            local.get 1
                            select
                            local.tee 1
                            local.get 6
                            i32.const 17681
                            i32.add
                            i32.load8_u
                            i32.gt_u
                            br_if 2 (;@10;)
                            block  ;; label = @13
                              local.get 0
                              i32.const 104
                              i32.add
                              i32.load
                              i32.eqz
                              br_if 0 (;@13;)
                              local.get 0
                              i32.const 4
                              i32.add
                              local.tee 6
                              local.get 6
                              i32.load
                              i32.const -1
                              i32.add
                              i32.store
                            end
                            local.get 0
                            i64.const 0
                            call 118
                            call 114
                            i32.const 22
                            i32.store
                            i64.const 0
                            return
                          end
                          local.get 0
                          call 119
                          local.set 6
                        end
                        block  ;; label = @11
                          local.get 6
                          i32.const 32
                          i32.or
                          i32.const 120
                          i32.ne
                          br_if 0 (;@11;)
                          local.get 0
                          i32.const 4
                          i32.add
                          local.tee 5
                          i32.load
                          local.tee 6
                          local.get 0
                          i32.const 104
                          i32.add
                          i32.load
                          i32.ge_u
                          br_if 2 (;@9;)
                          local.get 5
                          local.get 6
                          i32.const 1
                          i32.add
                          i32.store
                          local.get 6
                          i32.load8_u
                          local.set 6
                          br 3 (;@8;)
                        end
                        local.get 1
                        i32.eqz
                        br_if 3 (;@7;)
                      end
                      local.get 1
                      i32.const 10
                      i32.ne
                      br_if 3 (;@6;)
                      i64.const 0
                      local.set 8
                      local.get 6
                      i32.const -48
                      i32.add
                      local.tee 4
                      i32.const 9
                      i32.gt_u
                      br_if 7 (;@2;)
                      i32.const 0
                      local.set 5
                      local.get 0
                      i32.const 104
                      i32.add
                      local.set 9
                      local.get 0
                      i32.const 4
                      i32.add
                      local.set 2
                      block  ;; label = @10
                        loop  ;; label = @11
                          local.get 5
                          i32.const 10
                          i32.mul
                          local.set 6
                          block  ;; label = @12
                            block  ;; label = @13
                              local.get 2
                              i32.load
                              local.tee 1
                              local.get 9
                              i32.load
                              i32.ge_u
                              br_if 0 (;@13;)
                              local.get 2
                              local.get 1
                              i32.const 1
                              i32.add
                              i32.store
                              local.get 6
                              local.get 4
                              i32.add
                              local.set 5
                              local.get 1
                              i32.load8_u
                              local.tee 6
                              i32.const -48
                              i32.add
                              local.tee 4
                              i32.const 9
                              i32.le_u
                              br_if 1 (;@12;)
                              br 3 (;@10;)
                            end
                            local.get 6
                            local.get 4
                            i32.add
                            local.set 5
                            local.get 0
                            call 119
                            local.tee 6
                            i32.const -48
                            i32.add
                            local.tee 4
                            i32.const 9
                            i32.gt_u
                            br_if 2 (;@10;)
                          end
                          local.get 5
                          i32.const 429496729
                          i32.lt_u
                          br_if 0 (;@11;)
                        end
                      end
                      local.get 5
                      i64.extend_i32_u
                      local.set 8
                      local.get 4
                      i32.const 9
                      i32.gt_u
                      br_if 7 (;@2;)
                      i32.const 10
                      local.set 1
                      local.get 8
                      i64.const 10
                      i64.mul
                      local.tee 10
                      local.get 4
                      i64.extend_i32_s
                      local.tee 11
                      i64.const -1
                      i64.xor
                      i64.gt_u
                      br_if 6 (;@3;)
                      local.get 0
                      i32.const 104
                      i32.add
                      local.set 2
                      local.get 0
                      i32.const 4
                      i32.add
                      local.set 4
                      loop  ;; label = @10
                        block  ;; label = @11
                          block  ;; label = @12
                            local.get 4
                            i32.load
                            local.tee 6
                            local.get 2
                            i32.load
                            i32.ge_u
                            br_if 0 (;@12;)
                            local.get 4
                            local.get 6
                            i32.const 1
                            i32.add
                            i32.store
                            local.get 10
                            local.get 11
                            i64.add
                            local.set 8
                            local.get 6
                            i32.load8_u
                            local.tee 6
                            i32.const -48
                            i32.add
                            local.tee 5
                            i32.const 9
                            i32.le_u
                            br_if 1 (;@11;)
                            br 8 (;@4;)
                          end
                          local.get 10
                          local.get 11
                          i64.add
                          local.set 8
                          local.get 0
                          call 119
                          local.tee 6
                          i32.const -48
                          i32.add
                          local.tee 5
                          i32.const 9
                          i32.gt_u
                          br_if 7 (;@4;)
                        end
                        local.get 8
                        i64.const 1844674407370955162
                        i64.ge_u
                        br_if 6 (;@4;)
                        local.get 8
                        i64.const 10
                        i64.mul
                        local.tee 10
                        local.get 5
                        i64.extend_i32_s
                        local.tee 11
                        i64.const -1
                        i64.xor
                        i64.le_u
                        br_if 0 (;@10;)
                        br 7 (;@3;)
                      end
                    end
                    local.get 0
                    call 119
                    local.set 6
                  end
                  i32.const 16
                  local.set 1
                  local.get 6
                  i32.const 17681
                  i32.add
                  i32.load8_u
                  i32.const 16
                  i32.lt_u
                  br_if 1 (;@6;)
                  block  ;; label = @8
                    local.get 0
                    i32.const 104
                    i32.add
                    i32.load
                    local.tee 6
                    i32.eqz
                    br_if 0 (;@8;)
                    local.get 0
                    i32.const 4
                    i32.add
                    local.tee 5
                    local.get 5
                    i32.load
                    i32.const -1
                    i32.add
                    i32.store
                  end
                  local.get 2
                  i32.eqz
                  br_if 2 (;@5;)
                  i64.const 0
                  local.set 8
                  local.get 6
                  i32.eqz
                  br_if 6 (;@1;)
                  local.get 0
                  i32.const 4
                  i32.add
                  local.tee 6
                  local.get 6
                  i32.load
                  i32.const -1
                  i32.add
                  i32.store
                  i64.const 0
                  return
                end
                i32.const 8
                local.set 1
              end
              block  ;; label = @6
                local.get 1
                i32.const -1
                i32.add
                local.get 1
                i32.and
                i32.eqz
                br_if 0 (;@6;)
                i64.const 0
                local.set 8
                block  ;; label = @7
                  local.get 1
                  local.get 6
                  i32.const 17681
                  i32.add
                  i32.load8_u
                  local.tee 5
                  i32.le_u
                  br_if 0 (;@7;)
                  i32.const 0
                  local.set 4
                  local.get 0
                  i32.const 104
                  i32.add
                  local.set 9
                  local.get 0
                  i32.const 4
                  i32.add
                  local.set 2
                  block  ;; label = @8
                    loop  ;; label = @9
                      local.get 5
                      local.get 4
                      local.get 1
                      i32.mul
                      i32.add
                      local.set 4
                      block  ;; label = @10
                        block  ;; label = @11
                          local.get 2
                          i32.load
                          local.tee 6
                          local.get 9
                          i32.load
                          i32.ge_u
                          br_if 0 (;@11;)
                          local.get 2
                          local.get 6
                          i32.const 1
                          i32.add
                          i32.store
                          local.get 6
                          i32.load8_u
                          local.tee 6
                          i32.const 17681
                          i32.add
                          i32.load8_u
                          local.set 5
                          local.get 4
                          i32.const 119304646
                          i32.le_u
                          br_if 1 (;@10;)
                          br 3 (;@8;)
                        end
                        local.get 0
                        call 119
                        local.tee 6
                        i32.const 17681
                        i32.add
                        i32.load8_u
                        local.set 5
                        local.get 4
                        i32.const 119304646
                        i32.gt_u
                        br_if 2 (;@8;)
                      end
                      local.get 1
                      local.get 5
                      i32.gt_u
                      br_if 0 (;@9;)
                    end
                  end
                  local.get 4
                  i64.extend_i32_u
                  local.set 8
                end
                local.get 1
                local.get 5
                i32.le_u
                br_if 3 (;@3;)
                local.get 8
                i64.const -1
                local.get 1
                i64.extend_i32_u
                local.tee 12
                i64.div_u
                local.tee 13
                i64.gt_u
                br_if 3 (;@3;)
                local.get 0
                i32.const 104
                i32.add
                local.set 2
                local.get 0
                i32.const 4
                i32.add
                local.set 4
                loop  ;; label = @7
                  local.get 8
                  local.get 12
                  i64.mul
                  local.tee 10
                  local.get 5
                  i64.extend_i32_u
                  i64.const 255
                  i64.and
                  local.tee 11
                  i64.const -1
                  i64.xor
                  i64.gt_u
                  br_if 4 (;@3;)
                  block  ;; label = @8
                    block  ;; label = @9
                      local.get 4
                      i32.load
                      local.tee 6
                      local.get 2
                      i32.load
                      i32.ge_u
                      br_if 0 (;@9;)
                      local.get 4
                      local.get 6
                      i32.const 1
                      i32.add
                      i32.store
                      local.get 6
                      i32.load8_u
                      local.set 6
                      br 1 (;@8;)
                    end
                    local.get 0
                    call 119
                    local.set 6
                  end
                  local.get 10
                  local.get 11
                  i64.add
                  local.set 8
                  local.get 1
                  local.get 6
                  i32.const 17681
                  i32.add
                  i32.load8_u
                  local.tee 5
                  i32.le_u
                  br_if 4 (;@3;)
                  local.get 8
                  local.get 13
                  i64.le_u
                  br_if 0 (;@7;)
                  br 4 (;@3;)
                end
              end
              local.get 1
              i32.const 23
              i32.mul
              i32.const 5
              i32.shr_u
              i32.const 7
              i32.and
              i32.const 17937
              i32.add
              i32.load8_s
              local.set 9
              i64.const 0
              local.set 8
              block  ;; label = @6
                local.get 1
                local.get 6
                i32.const 17681
                i32.add
                i32.load8_u
                local.tee 5
                i32.le_u
                br_if 0 (;@6;)
                i32.const 0
                local.set 4
                local.get 0
                i32.const 104
                i32.add
                local.set 14
                local.get 0
                i32.const 4
                i32.add
                local.set 2
                block  ;; label = @7
                  loop  ;; label = @8
                    local.get 5
                    local.get 4
                    local.get 9
                    i32.shl
                    i32.or
                    local.set 4
                    block  ;; label = @9
                      block  ;; label = @10
                        local.get 2
                        i32.load
                        local.tee 6
                        local.get 14
                        i32.load
                        i32.ge_u
                        br_if 0 (;@10;)
                        local.get 2
                        local.get 6
                        i32.const 1
                        i32.add
                        i32.store
                        local.get 6
                        i32.load8_u
                        local.tee 6
                        i32.const 17681
                        i32.add
                        i32.load8_u
                        local.set 5
                        local.get 4
                        i32.const 134217727
                        i32.le_u
                        br_if 1 (;@9;)
                        br 3 (;@7;)
                      end
                      local.get 0
                      call 119
                      local.tee 6
                      i32.const 17681
                      i32.add
                      i32.load8_u
                      local.set 5
                      local.get 4
                      i32.const 134217727
                      i32.gt_u
                      br_if 2 (;@7;)
                    end
                    local.get 1
                    local.get 5
                    i32.gt_u
                    br_if 0 (;@8;)
                  end
                end
                local.get 4
                i64.extend_i32_u
                local.set 8
              end
              local.get 1
              local.get 5
              i32.le_u
              br_if 2 (;@3;)
              i64.const -1
              local.get 9
              i64.extend_i32_u
              local.tee 11
              i64.shr_u
              local.tee 12
              local.get 8
              i64.lt_u
              br_if 2 (;@3;)
              local.get 0
              i32.const 104
              i32.add
              local.set 2
              local.get 0
              i32.const 4
              i32.add
              local.set 4
              loop  ;; label = @6
                local.get 8
                local.get 11
                i64.shl
                local.set 8
                local.get 5
                i64.extend_i32_u
                i64.const 255
                i64.and
                local.set 10
                block  ;; label = @7
                  block  ;; label = @8
                    local.get 4
                    i32.load
                    local.tee 6
                    local.get 2
                    i32.load
                    i32.ge_u
                    br_if 0 (;@8;)
                    local.get 4
                    local.get 6
                    i32.const 1
                    i32.add
                    i32.store
                    local.get 6
                    i32.load8_u
                    local.set 6
                    br 1 (;@7;)
                  end
                  local.get 0
                  call 119
                  local.set 6
                end
                local.get 8
                local.get 10
                i64.or
                local.set 8
                local.get 1
                local.get 6
                i32.const 17681
                i32.add
                i32.load8_u
                local.tee 5
                i32.le_u
                br_if 3 (;@3;)
                local.get 8
                local.get 12
                i64.le_u
                br_if 0 (;@6;)
                br 3 (;@3;)
              end
            end
            local.get 0
            i64.const 0
            call 118
            i64.const 0
            return
          end
          local.get 5
          i32.const 9
          i32.gt_u
          br_if 1 (;@2;)
        end
        local.get 1
        local.get 6
        i32.const 17681
        i32.add
        i32.load8_u
        i32.le_u
        br_if 0 (;@2;)
        local.get 0
        i32.const 104
        i32.add
        local.set 4
        local.get 0
        i32.const 4
        i32.add
        local.set 5
        block  ;; label = @3
          loop  ;; label = @4
            block  ;; label = @5
              local.get 5
              i32.load
              local.tee 6
              local.get 4
              i32.load
              i32.ge_u
              br_if 0 (;@5;)
              local.get 5
              local.get 6
              i32.const 1
              i32.add
              i32.store
              local.get 1
              local.get 6
              i32.load8_u
              i32.const 17681
              i32.add
              i32.load8_u
              i32.gt_u
              br_if 1 (;@4;)
              br 2 (;@3;)
            end
            local.get 1
            local.get 0
            call 119
            i32.const 17681
            i32.add
            i32.load8_u
            i32.gt_u
            br_if 0 (;@4;)
          end
        end
        call 114
        i32.const 34
        i32.store
        local.get 7
        i32.const 0
        local.get 3
        i64.const 1
        i64.and
        i64.eqz
        select
        local.set 7
        local.get 3
        local.set 8
      end
      block  ;; label = @2
        local.get 0
        i32.const 104
        i32.add
        i32.load
        i32.eqz
        br_if 0 (;@2;)
        local.get 0
        i32.const 4
        i32.add
        local.tee 6
        local.get 6
        i32.load
        i32.const -1
        i32.add
        i32.store
      end
      block  ;; label = @2
        local.get 8
        local.get 3
        i64.lt_u
        br_if 0 (;@2;)
        block  ;; label = @3
          local.get 3
          i64.const 1
          i64.and
          i32.wrap_i64
          br_if 0 (;@3;)
          local.get 7
          br_if 0 (;@3;)
          call 114
          i32.const 34
          i32.store
          local.get 3
          i64.const -1
          i64.add
          return
        end
        local.get 8
        local.get 3
        i64.le_u
        br_if 0 (;@2;)
        call 114
        i32.const 34
        i32.store
        local.get 3
        return
      end
      local.get 8
      local.get 7
      i64.extend_i32_s
      local.tee 10
      i64.xor
      local.get 10
      i64.sub
      local.set 8
    end
    local.get 8)
  (func (;121;) (type 2) (param i32 i32 i32) (result i32)
    (local i32 i64)
    global.get 0
    i32.const 144
    i32.sub
    local.tee 3
    global.set 0
    local.get 3
    local.get 0
    i32.store offset=4
    local.get 3
    local.get 0
    i32.store offset=44
    local.get 3
    i32.const 0
    i32.store
    local.get 3
    i32.const -1
    i32.store offset=76
    local.get 3
    i32.const -1
    local.get 0
    i32.const 2147483647
    i32.add
    local.get 0
    i32.const 0
    i32.lt_s
    select
    i32.store offset=8
    local.get 3
    i64.const 0
    call 118
    local.get 3
    local.get 2
    i32.const 1
    i64.const 2147483648
    call 120
    local.set 4
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      local.get 1
      local.get 0
      local.get 3
      i32.load offset=4
      local.get 3
      i32.load offset=120
      i32.add
      local.get 3
      i32.const 8
      i32.add
      i32.load
      i32.sub
      i32.add
      i32.store
    end
    local.get 3
    i32.const 144
    i32.add
    global.set 0
    local.get 4
    i32.wrap_i64)
  (func (;122;) (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    local.get 2
    i32.const 0
    i32.ne
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              i32.eqz
              br_if 0 (;@5;)
              local.get 0
              i32.const 3
              i32.and
              i32.eqz
              br_if 0 (;@5;)
              local.get 1
              i32.const 255
              i32.and
              local.set 3
              loop  ;; label = @6
                local.get 0
                i32.load8_u
                local.get 3
                i32.eq
                br_if 2 (;@4;)
                block  ;; label = @7
                  local.get 2
                  i32.const 1
                  i32.ne
                  local.set 4
                  local.get 2
                  i32.const -1
                  i32.add
                  local.set 5
                  local.get 0
                  i32.const 1
                  i32.add
                  local.set 0
                  local.get 2
                  i32.const 1
                  i32.eq
                  br_if 0 (;@7;)
                  local.get 5
                  local.set 2
                  local.get 0
                  i32.const 3
                  i32.and
                  br_if 1 (;@6;)
                end
              end
              local.get 4
              br_if 2 (;@3;)
              br 3 (;@2;)
            end
            local.get 2
            local.set 5
            local.get 3
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          local.get 2
          local.set 5
        end
        block  ;; label = @3
          local.get 0
          i32.load8_u
          local.get 1
          i32.const 255
          i32.and
          i32.ne
          br_if 0 (;@3;)
          local.get 5
          br_if 2 (;@1;)
          br 1 (;@2;)
        end
        block  ;; label = @3
          block  ;; label = @4
            local.get 5
            i32.const 4
            i32.lt_u
            br_if 0 (;@4;)
            local.get 1
            i32.const 255
            i32.and
            i32.const 16843009
            i32.mul
            local.set 3
            loop  ;; label = @5
              local.get 0
              i32.load
              local.get 3
              i32.xor
              local.tee 2
              i32.const -1
              i32.xor
              local.get 2
              i32.const -16843009
              i32.add
              i32.and
              i32.const -2139062144
              i32.and
              br_if 2 (;@3;)
              local.get 0
              i32.const 4
              i32.add
              local.set 0
              local.get 5
              i32.const -4
              i32.add
              local.tee 5
              i32.const 3
              i32.gt_u
              br_if 0 (;@5;)
            end
          end
          local.get 5
          i32.eqz
          br_if 1 (;@2;)
        end
        local.get 1
        i32.const 255
        i32.and
        local.set 2
        loop  ;; label = @3
          local.get 0
          i32.load8_u
          local.get 2
          i32.eq
          br_if 2 (;@1;)
          local.get 0
          i32.const 1
          i32.add
          local.set 0
          local.get 5
          i32.const -1
          i32.add
          local.tee 5
          br_if 0 (;@3;)
        end
      end
      i32.const 0
      local.set 0
    end
    local.get 0)
  (func (;123;) (type 2) (param i32 i32 i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 2
        i32.eqz
        br_if 0 (;@2;)
        loop  ;; label = @3
          local.get 0
          i32.load8_u
          local.tee 3
          local.get 1
          i32.load8_u
          local.tee 4
          i32.ne
          br_if 2 (;@1;)
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
        end
      end
      i32.const 0
      return
    end
    local.get 3
    local.get 4
    i32.sub)
  (func (;124;) (type 26) (param i32) (result i32)
    (local i32 i32 i32)
    local.get 0
    local.set 1
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const 3
          i32.and
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          i32.load8_u
          i32.eqz
          br_if 1 (;@2;)
          local.get 0
          i32.const 1
          i32.add
          local.set 1
          loop  ;; label = @4
            local.get 1
            i32.const 3
            i32.and
            i32.eqz
            br_if 1 (;@3;)
            local.get 1
            i32.load8_u
            local.set 2
            local.get 1
            i32.const 1
            i32.add
            local.tee 3
            local.set 1
            local.get 2
            br_if 0 (;@4;)
          end
          local.get 3
          i32.const -1
          i32.add
          local.get 0
          i32.sub
          return
        end
        local.get 1
        i32.const -4
        i32.add
        local.set 1
        loop  ;; label = @3
          local.get 1
          i32.const 4
          i32.add
          local.tee 1
          i32.load
          local.tee 2
          i32.const -1
          i32.xor
          local.get 2
          i32.const -16843009
          i32.add
          i32.and
          i32.const -2139062144
          i32.and
          i32.eqz
          br_if 0 (;@3;)
        end
        local.get 2
        i32.const 255
        i32.and
        i32.eqz
        br_if 1 (;@1;)
        loop  ;; label = @3
          local.get 1
          i32.load8_u offset=1
          local.set 2
          local.get 1
          i32.const 1
          i32.add
          local.tee 3
          local.set 1
          local.get 2
          br_if 0 (;@3;)
        end
        local.get 3
        local.get 0
        i32.sub
        return
      end
      local.get 0
      local.get 0
      i32.sub
      return
    end
    local.get 1
    local.get 0
    i32.sub)
  (func (;125;) (type 2) (param i32 i32 i32) (result i32)
    (local i32)
    i32.const 22
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        local.get 1
        i32.const 4
        i32.lt_u
        br_if 0 (;@2;)
        local.get 1
        local.get 2
        call 126
        local.tee 1
        i32.eqz
        br_if 1 (;@1;)
        local.get 0
        local.get 1
        i32.store
        i32.const 0
        local.set 3
      end
      local.get 3
      return
    end
    call 114
    i32.load)
  (func (;126;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32)
    i32.const 0
    local.set 2
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        local.get 0
        i32.sub
        local.tee 3
        local.get 0
        i32.and
        local.get 0
        i32.ne
        br_if 0 (;@2;)
        local.get 0
        i32.const 16
        i32.gt_u
        br_if 1 (;@1;)
        local.get 1
        call 127
        return
      end
      call 114
      i32.const 22
      i32.store
      i32.const 0
      return
    end
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          local.get 0
          i32.const -1
          i32.add
          local.tee 4
          local.get 1
          i32.add
          call 127
          local.tee 0
          i32.eqz
          br_if 0 (;@3;)
          local.get 0
          local.get 4
          local.get 0
          i32.add
          local.get 3
          i32.and
          local.tee 2
          i32.eq
          br_if 1 (;@2;)
          local.get 0
          i32.const -4
          i32.add
          local.tee 3
          i32.load
          local.tee 4
          i32.const 7
          i32.and
          local.tee 1
          i32.eqz
          br_if 2 (;@1;)
          local.get 0
          local.get 4
          i32.const -8
          i32.and
          i32.add
          local.tee 4
          i32.const -8
          i32.add
          local.tee 5
          i32.load
          local.set 6
          local.get 3
          local.get 1
          local.get 2
          local.get 0
          i32.sub
          local.tee 7
          i32.or
          i32.store
          local.get 2
          i32.const -4
          i32.add
          local.get 4
          local.get 2
          i32.sub
          local.tee 3
          local.get 1
          i32.or
          i32.store
          local.get 2
          i32.const -8
          i32.add
          local.get 6
          i32.const 7
          i32.and
          local.tee 1
          local.get 7
          i32.or
          i32.store
          local.get 5
          local.get 1
          local.get 3
          i32.or
          i32.store
          local.get 0
          call 130
        end
        local.get 2
        return
      end
      local.get 0
      return
    end
    local.get 2
    i32.const -8
    i32.add
    local.get 0
    i32.const -8
    i32.add
    i32.load
    local.get 2
    local.get 0
    i32.sub
    local.tee 0
    i32.add
    i32.store
    local.get 2
    i32.const -4
    i32.add
    local.get 3
    i32.load
    local.get 0
    i32.sub
    i32.store
    local.get 2)
  (func (;127;) (type 26) (param i32) (result i32)
    i32.const 9244
    local.get 0
    call 128)
  (func (;128;) (type 5) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      local.get 1
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        local.get 0
        i32.load offset=8384
        local.tee 2
        br_if 0 (;@2;)
        i32.const 16
        local.set 2
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
      local.tee 3
      i32.sub
      local.get 1
      local.get 3
      select
      local.set 3
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 0
            i32.load offset=8388
            local.tee 4
            local.get 2
            i32.ge_u
            br_if 0 (;@4;)
            local.get 0
            local.get 4
            i32.const 12
            i32.mul
            i32.add
            i32.const 8192
            i32.add
            local.set 1
            block  ;; label = @5
              local.get 4
              br_if 0 (;@5;)
              local.get 0
              i32.const 8196
              i32.add
              local.tee 2
              i32.load
              br_if 0 (;@5;)
              local.get 1
              i32.const 8192
              i32.store
              local.get 2
              local.get 0
              i32.store
            end
            local.get 3
            i32.const 4
            i32.add
            local.set 4
            loop  ;; label = @5
              block  ;; label = @6
                local.get 1
                i32.load offset=8
                local.tee 2
                local.get 4
                i32.add
                local.get 1
                i32.load
                i32.gt_u
                br_if 0 (;@6;)
                local.get 1
                i32.load offset=4
                local.get 2
                i32.add
                local.tee 2
                local.get 2
                i32.load
                i32.const -2147483648
                i32.and
                local.get 3
                i32.or
                i32.store
                local.get 1
                i32.const 8
                i32.add
                local.tee 1
                local.get 1
                i32.load
                local.get 4
                i32.add
                i32.store
                local.get 2
                local.get 2
                i32.load
                i32.const -2147483648
                i32.or
                i32.store
                local.get 2
                i32.const 4
                i32.add
                local.tee 1
                br_if 3 (;@3;)
              end
              local.get 0
              call 129
              local.tee 1
              br_if 0 (;@5;)
            end
          end
          i32.const 2147483644
          local.get 3
          i32.sub
          local.set 5
          local.get 0
          i32.const 8392
          i32.add
          local.set 6
          local.get 0
          i32.const 8384
          i32.add
          local.set 7
          local.get 0
          i32.load offset=8392
          local.tee 8
          local.set 2
          loop  ;; label = @4
            local.get 0
            local.get 2
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
            local.tee 9
            i32.load
            i32.eq
            i32.const 8214
            call 1
            local.get 1
            i32.const 8196
            i32.add
            i32.load
            local.tee 10
            i32.const 4
            i32.add
            local.set 2
            loop  ;; label = @5
              local.get 10
              local.get 9
              i32.load
              i32.add
              local.set 11
              local.get 2
              i32.const -4
              i32.add
              local.tee 12
              i32.load
              local.tee 13
              i32.const 2147483647
              i32.and
              local.set 1
              block  ;; label = @6
                local.get 13
                i32.const 0
                i32.lt_s
                br_if 0 (;@6;)
                block  ;; label = @7
                  local.get 1
                  local.get 3
                  i32.ge_u
                  br_if 0 (;@7;)
                  loop  ;; label = @8
                    local.get 2
                    local.get 1
                    i32.add
                    local.tee 4
                    local.get 11
                    i32.ge_u
                    br_if 1 (;@7;)
                    local.get 4
                    i32.load
                    local.tee 4
                    i32.const 0
                    i32.lt_s
                    br_if 1 (;@7;)
                    local.get 1
                    local.get 4
                    i32.const 2147483647
                    i32.and
                    i32.add
                    i32.const 4
                    i32.add
                    local.tee 1
                    local.get 3
                    i32.lt_u
                    br_if 0 (;@8;)
                  end
                end
                local.get 12
                local.get 1
                local.get 3
                local.get 1
                local.get 3
                i32.lt_u
                select
                local.get 13
                i32.const -2147483648
                i32.and
                i32.or
                i32.store
                block  ;; label = @7
                  local.get 1
                  local.get 3
                  i32.le_u
                  br_if 0 (;@7;)
                  local.get 2
                  local.get 3
                  i32.add
                  local.get 5
                  local.get 1
                  i32.add
                  i32.const 2147483647
                  i32.and
                  i32.store
                end
                local.get 1
                local.get 3
                i32.ge_u
                br_if 4 (;@2;)
              end
              local.get 2
              local.get 1
              i32.add
              i32.const 4
              i32.add
              local.tee 2
              local.get 11
              i32.lt_u
              br_if 0 (;@5;)
            end
            i32.const 0
            local.set 1
            local.get 6
            i32.const 0
            local.get 6
            i32.load
            i32.const 1
            i32.add
            local.tee 2
            local.get 2
            local.get 7
            i32.load
            i32.eq
            select
            local.tee 2
            i32.store
            local.get 2
            local.get 8
            i32.ne
            br_if 0 (;@4;)
          end
        end
        local.get 1
        return
      end
      local.get 12
      local.get 12
      i32.load
      i32.const -2147483648
      i32.or
      i32.store
      local.get 2
      return
    end
    i32.const 0)
  (func (;129;) (type 26) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    local.get 0
    i32.load offset=8388
    local.set 1
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load8_u offset=9236
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=9240
        local.set 2
        br 1 (;@1;)
      end
      memory.size
      local.set 2
      i32.const 0
      i32.const 1
      i32.store8 offset=9236
      i32.const 0
      local.get 2
      i32.const 16
      i32.shl
      local.tee 2
      i32.store offset=9240
    end
    local.get 2
    local.set 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            local.get 2
            i32.const 65535
            i32.add
            i32.const 16
            i32.shr_u
            local.tee 4
            memory.size
            local.tee 5
            i32.le_u
            br_if 0 (;@4;)
            local.get 4
            local.get 5
            i32.sub
            memory.grow
            drop
            i32.const 0
            local.set 5
            local.get 4
            memory.size
            i32.ne
            br_if 1 (;@3;)
            i32.const 0
            i32.load offset=9240
            local.set 3
          end
          i32.const 0
          local.set 5
          i32.const 0
          local.get 3
          i32.store offset=9240
          local.get 2
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          local.get 1
          i32.const 12
          i32.mul
          local.set 4
          block  ;; label = @4
            block  ;; label = @5
              local.get 2
              i32.const 65535
              i32.and
              local.tee 5
              i32.const 64512
              i32.gt_u
              br_if 0 (;@5;)
              local.get 2
              i32.const 65536
              i32.add
              local.get 5
              i32.sub
              local.set 5
              br 1 (;@4;)
            end
            local.get 2
            i32.const 131072
            i32.add
            local.get 2
            i32.const 131071
            i32.and
            i32.sub
            local.set 5
          end
          local.get 0
          local.get 4
          i32.add
          local.set 4
          local.get 5
          local.get 2
          i32.sub
          local.set 2
          block  ;; label = @4
            i32.const 0
            i32.load8_u offset=9236
            br_if 0 (;@4;)
            memory.size
            local.set 3
            i32.const 0
            i32.const 1
            i32.store8 offset=9236
            i32.const 0
            local.get 3
            i32.const 16
            i32.shl
            local.tee 3
            i32.store offset=9240
          end
          local.get 4
          i32.const 8192
          i32.add
          local.set 4
          local.get 2
          i32.const 0
          i32.lt_s
          br_if 1 (;@2;)
          local.get 3
          local.set 6
          block  ;; label = @4
            local.get 2
            i32.const 7
            i32.add
            i32.const -8
            i32.and
            local.tee 7
            local.get 3
            i32.add
            i32.const 65535
            i32.add
            i32.const 16
            i32.shr_u
            local.tee 5
            memory.size
            local.tee 8
            i32.le_u
            br_if 0 (;@4;)
            local.get 5
            local.get 8
            i32.sub
            memory.grow
            drop
            local.get 5
            memory.size
            i32.ne
            br_if 2 (;@2;)
            i32.const 0
            i32.load offset=9240
            local.set 6
          end
          i32.const 0
          local.get 6
          local.get 7
          i32.add
          i32.store offset=9240
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
          local.get 4
          i32.load
          local.tee 5
          i32.add
          local.get 3
          i32.eq
          br_if 2 (;@1;)
          block  ;; label = @4
            local.get 5
            local.get 1
            i32.const 8200
            i32.add
            local.tee 7
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
            local.get 5
            i32.add
            i32.or
            i32.store
            local.get 7
            local.get 4
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
          local.tee 4
          local.get 4
          i32.load
          i32.const 1
          i32.add
          local.tee 4
          i32.store
          local.get 0
          local.get 4
          i32.const 12
          i32.mul
          i32.add
          local.tee 0
          i32.const 8192
          i32.add
          local.tee 5
          local.get 2
          i32.store
          local.get 0
          i32.const 8196
          i32.add
          local.get 3
          i32.store
        end
        local.get 5
        return
      end
      block  ;; label = @2
        local.get 4
        i32.load
        local.tee 5
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
        local.tee 2
        i32.eq
        br_if 0 (;@2;)
        local.get 3
        i32.const 8196
        i32.add
        i32.load
        local.get 2
        i32.add
        local.tee 3
        local.get 3
        i32.load
        i32.const -2147483648
        i32.and
        i32.const -4
        local.get 2
        i32.sub
        local.get 5
        i32.add
        i32.or
        i32.store
        local.get 1
        local.get 4
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
      local.tee 2
      i32.load
      i32.const 1
      i32.add
      local.tee 3
      i32.store offset=8384
      local.get 2
      local.get 3
      i32.store
      i32.const 0
      return
    end
    local.get 4
    local.get 5
    local.get 2
    i32.add
    i32.store
    local.get 4)
  (func (;130;) (type 9) (param i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        local.get 0
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=17628
        local.tee 1
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        i32.const 17436
        local.set 2
        local.get 1
        i32.const 12
        i32.mul
        i32.const 17436
        i32.add
        local.set 3
        loop  ;; label = @3
          local.get 2
          i32.const 4
          i32.add
          i32.load
          local.tee 1
          i32.eqz
          br_if 1 (;@2;)
          block  ;; label = @4
            local.get 1
            i32.const 4
            i32.add
            local.get 0
            i32.gt_u
            br_if 0 (;@4;)
            local.get 1
            local.get 2
            i32.load
            i32.add
            local.get 0
            i32.gt_u
            br_if 3 (;@1;)
          end
          local.get 2
          i32.const 12
          i32.add
          local.tee 2
          local.get 3
          i32.lt_u
          br_if 0 (;@3;)
        end
      end
      return
    end
    local.get 0
    i32.const -4
    i32.add
    local.tee 2
    local.get 2
    i32.load
    i32.const 2147483647
    i32.and
    i32.store)
  (table (;0;) 4 4 funcref)
  (memory (;0;) 1)
  (global (;0;) (mut i32) (i32.const 8192))
  (global (;1;) i32 (i32.const 17946))
  (global (;2;) i32 (i32.const 17946))
  (export "memory" (memory 0))
  (export "__heap_base" (global 1))
  (export "__data_end" (global 2))
  (export "apply" (func 48))
  (export "_Znwj" (func 86))
  (export "_ZdlPv" (func 88))
  (export "_Znaj" (func 87))
  (export "_ZdaPv" (func 89))
  (export "_ZnwjSt11align_val_t" (func 90))
  (export "_ZnajSt11align_val_t" (func 91))
  (export "_ZdlPvSt11align_val_t" (func 92))
  (export "_ZdaPvSt11align_val_t" (func 93))
  (elem (;0;) (i32.const 1) 52 54 56)
  (data (;0;) (i32.const 8192) "0123456789abcdef\00stoi\00malloc_from_freed was designed to only be called after _heap was completely allocated\00")
  (data (;1;) (i32.const 8300) "EOS\00")
  (data (;2;) (i32.const 8304) "read_transaction failed\00")
  (data (;3;) (i32.const 8328) "TransferOnly\00")
  (data (;4;) (i32.const 8341) "bet not found\00")
  (data (;5;) (i32.const 8355) "object passed to iterator_to is not in multi_index\00")
  (data (;6;) (i32.const 8406) "error reading iterator\00")
  (data (;7;) (i32.const 8429) "read\00")
  (data (;8;) (i32.const 8434) "get\00")
  (data (;9;) (i32.const 8438) "object passed to erase is not in multi_index\00")
  (data (;10;) (i32.const 8483) "cannot erase objects in table of another contract\00")
  (data (;11;) (i32.const 8533) "attempt to remove object that was not in multi_index\00")
  (data (;12;) (i32.const 8586) "x\00")
  (data (;13;) (i32.const 8588) "memo format wrong\00")
  (data (;14;) (i32.const 8606) "roll under should between 2 and 6\00")
  (data (;15;) (i32.const 8640) "dice_num 1 or 10\00")
  (data (;16;) (i32.const 8657) "only EOS token allowed\00")
  (data (;17;) (i32.const 8680) "quantity invalid\00")
  (data (;18;) (i32.const 8697) "transfer quantity must be greater than 0.1\00")
  (data (;19;) (i32.const 8740) "cannot pass end iterator to erase\00")
  (data (;20;) (i32.const 8774) "cannot increment end iterator\00")
  (data (;21;) (i32.const 8804) "unable to find key\00")
  (data (;22;) (i32.const 8823) "string is too long to be a valid symbol_code\00")
  (data (;23;) (i32.const 8868) "only uppercase letters allowed in symbol_code string\00")
  (data (;24;) (i32.const 8921) "magnitude of asset amount must be less than 2^62\00")
  (data (;25;) (i32.const 8970) "invalid symbol name\00")
  (data (;26;) (i32.const 8992) "{\14\be@\a4p=@R\b8\fe?R\b8\be?\ecQ\98?")
  (data (;27;) (i32.const 9012) " player: \00")
  (data (;28;) (i32.const 9022) " winner! - dice.center\00")
  (data (;29;) (i32.const 9048) "\5c#\00\00")
  (data (;30;) (i32.const 9052) ".12345abcdefghijklmnopqrstuvwxyz\00")
  (data (;31;) (i32.const 9085) "write\00")
  (data (;32;) (i32.const 9091) "attempt to add asset with different symbol\00")
  (data (;33;) (i32.const 9134) "addition underflow\00")
  (data (;34;) (i32.const 9153) "addition overflow\00")
  (data (;35;) (i32.const 9171) "cannot create objects in table of another contract\00")
  (data (;36;) (i32.const 17640) ": no conversion\00")
  (data (;37;) (i32.const 17656) ": out of range\00")
  (data (;38;) (i32.const 17680) "\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\00\01\02\03\04\05\06\07\08\09\ff\ff\ff\ff\ff\ff\ff\0a\0b\0c\0d\0e\0f\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f !\22#\ff\ff\ff\ff\ff\ff\0a\0b\0c\0d\0e\0f\10\11\12\13\14\15\16\17\18\19\1a\1b\1c\1d\1e\1f !\22#\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff\ff")
  (data (;39;) (i32.const 17937) "\00\01\02\04\07\03\06\05\00"))
