(module
  (type (;0;) (func (param i32 i64 i64 i64)))
  (type (;1;) (func (param i32 i64 i64)))
  (type (;2;) (func))
  (type (;3;) (func (result i64)))
  (type (;4;) (func (param i64 i64)))
  (type (;5;) (func (param i32 i32)))
  (type (;6;) (func (result i32)))
  (type (;7;) (func (param i32 i32) (result i32)))
  (type (;8;) (func (param i32 i32 i32) (result i32)))
  (type (;9;) (func (param i64)))
  (type (;10;) (func (param i64 i64 i64 i64) (result i32)))
  (type (;11;) (func (param i32 i64 i32 i32)))
  (type (;12;) (func (param i64 i64 i64 i64 i32 i32) (result i32)))
  (type (;13;) (func (param i32)))
  (type (;14;) (func (param i64 i64 i64)))
  (type (;15;) (func (param i32 i32 i64 i32)))
  (type (;16;) (func (param i32 i32 i32 i32)))
  (type (;17;) (func (param i32 i64 i32) (result i32)))
  (type (;18;) (func (param i32) (result i32)))
  (import "env" "abort" (func (;0;) (type 2)))
  (import "env" "action_data_size" (func (;1;) (type 6)))
  (import "env" "current_receiver" (func (;2;) (type 3)))
  (import "env" "current_time" (func (;3;) (type 3)))
  (import "env" "db_find_i64" (func (;4;) (type 10)))
  (import "env" "db_get_i64" (func (;5;) (type 8)))
  (import "env" "db_store_i64" (func (;6;) (type 12)))
  (import "env" "db_update_i64" (func (;7;) (type 11)))
  (import "env" "eosio_assert" (func (;8;) (type 5)))
  (import "env" "memcpy" (func (;9;) (type 8)))
  (import "env" "read_action_data" (func (;10;) (type 7)))
  (import "env" "require_auth" (func (;11;) (type 9)))
  (import "env" "require_auth2" (func (;12;) (type 4)))
  (func (;13;) (type 7) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    i32.const 32
    call 38
    i32.eqz)
  (func (;14;) (type 7) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    i32.const 32
    call 38
    i32.eqz)
  (func (;15;) (type 7) (param i32 i32) (result i32)
    get_local 0
    get_local 1
    i32.const 32
    call 38
    i32.const 0
    i32.ne)
  (func (;16;) (type 6) (result i32)
    call 3
    i64.const 1000000
    i64.div_u
    i32.wrap/i64)
  (func (;17;) (type 13) (param i32)
    get_local 0
    i64.load
    get_local 0
    i64.load offset=8
    call 12)
  (func (;18;) (type 14) (param i64 i64 i64)
    (local i32 i32 i32 i32 i64 i64 i64 i64 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 80
    i32.sub
    tee_local 11
    i32.store offset=4
    i64.const 0
    set_local 8
    i64.const 59
    set_local 7
    i32.const 16
    set_local 6
    i64.const 0
    set_local 9
    loop  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                get_local 8
                i64.const 6
                i64.gt_u
                br_if 0 (;@6;)
                get_local 6
                i32.load8_s
                tee_local 3
                i32.const -97
                i32.add
                i32.const 255
                i32.and
                i32.const 25
                i32.gt_u
                br_if 1 (;@5;)
                get_local 3
                i32.const 165
                i32.add
                set_local 3
                br 2 (;@4;)
              end
              i64.const 0
              set_local 10
              get_local 8
              i64.const 11
              i64.le_u
              br_if 2 (;@3;)
              br 3 (;@2;)
            end
            get_local 3
            i32.const 208
            i32.add
            i32.const 0
            get_local 3
            i32.const -49
            i32.add
            i32.const 255
            i32.and
            i32.const 5
            i32.lt_u
            select
            set_local 3
          end
          get_local 3
          i64.extend_u/i32
          i64.const 56
          i64.shl
          i64.const 56
          i64.shr_s
          set_local 10
        end
        get_local 10
        i64.const 31
        i64.and
        get_local 7
        i64.const 4294967295
        i64.and
        i64.shl
        set_local 10
      end
      get_local 6
      i32.const 1
      i32.add
      set_local 6
      get_local 8
      i64.const 1
      i64.add
      set_local 8
      get_local 10
      get_local 9
      i64.or
      set_local 9
      get_local 7
      i64.const -5
      i64.add
      tee_local 7
      i64.const -6
      i64.ne
      br_if 0 (;@1;)
    end
    block  ;; label = @1
      get_local 9
      get_local 2
      i64.ne
      br_if 0 (;@1;)
      i64.const 0
      set_local 8
      i64.const 59
      set_local 7
      i32.const 32
      set_local 6
      i64.const 0
      set_local 9
      loop  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  get_local 8
                  i64.const 4
                  i64.gt_u
                  br_if 0 (;@7;)
                  get_local 6
                  i32.load8_s
                  tee_local 3
                  i32.const -97
                  i32.add
                  i32.const 255
                  i32.and
                  i32.const 25
                  i32.gt_u
                  br_if 1 (;@6;)
                  get_local 3
                  i32.const 165
                  i32.add
                  set_local 3
                  br 2 (;@5;)
                end
                i64.const 0
                set_local 10
                get_local 8
                i64.const 11
                i64.le_u
                br_if 2 (;@4;)
                br 3 (;@3;)
              end
              get_local 3
              i32.const 208
              i32.add
              i32.const 0
              get_local 3
              i32.const -49
              i32.add
              i32.const 255
              i32.and
              i32.const 5
              i32.lt_u
              select
              set_local 3
            end
            get_local 3
            i64.extend_u/i32
            i64.const 56
            i64.shl
            i64.const 56
            i64.shr_s
            set_local 10
          end
          get_local 10
          i64.const 31
          i64.and
          get_local 7
          i64.const 4294967295
          i64.and
          i64.shl
          set_local 10
        end
        get_local 6
        i32.const 1
        i32.add
        set_local 6
        get_local 8
        i64.const 1
        i64.add
        set_local 8
        get_local 10
        get_local 9
        i64.or
        set_local 9
        get_local 7
        i64.const -5
        i64.add
        tee_local 7
        i64.const -6
        i64.ne
        br_if 0 (;@2;)
      end
      get_local 9
      get_local 1
      i64.eq
      i32.const 48
      call 8
    end
    block  ;; label = @1
      block  ;; label = @2
        get_local 1
        get_local 0
        i64.eq
        br_if 0 (;@2;)
        i64.const 0
        set_local 8
        i64.const 59
        set_local 7
        i32.const 16
        set_local 6
        i64.const 0
        set_local 9
        loop  ;; label = @3
          block  ;; label = @4
            block  ;; label = @5
              block  ;; label = @6
                block  ;; label = @7
                  block  ;; label = @8
                    get_local 8
                    i64.const 6
                    i64.gt_u
                    br_if 0 (;@8;)
                    get_local 6
                    i32.load8_s
                    tee_local 3
                    i32.const -97
                    i32.add
                    i32.const 255
                    i32.and
                    i32.const 25
                    i32.gt_u
                    br_if 1 (;@7;)
                    get_local 3
                    i32.const 165
                    i32.add
                    set_local 3
                    br 2 (;@6;)
                  end
                  i64.const 0
                  set_local 10
                  get_local 8
                  i64.const 11
                  i64.le_u
                  br_if 2 (;@5;)
                  br 3 (;@4;)
                end
                get_local 3
                i32.const 208
                i32.add
                i32.const 0
                get_local 3
                i32.const -49
                i32.add
                i32.const 255
                i32.and
                i32.const 5
                i32.lt_u
                select
                set_local 3
              end
              get_local 3
              i64.extend_u/i32
              i64.const 56
              i64.shl
              i64.const 56
              i64.shr_s
              set_local 10
            end
            get_local 10
            i64.const 31
            i64.and
            get_local 7
            i64.const 4294967295
            i64.and
            i64.shl
            set_local 10
          end
          get_local 6
          i32.const 1
          i32.add
          set_local 6
          get_local 8
          i64.const 1
          i64.add
          set_local 8
          get_local 10
          get_local 9
          i64.or
          set_local 9
          get_local 7
          i64.const -5
          i64.add
          tee_local 7
          i64.const -6
          i64.ne
          br_if 0 (;@3;)
        end
        get_local 9
        get_local 2
        i64.ne
        br_if 1 (;@1;)
      end
      get_local 11
      i32.const 48
      i32.add
      get_local 0
      i64.store
      get_local 11
      i32.const 56
      i32.add
      i64.const -1
      i64.store
      get_local 11
      i32.const 64
      i32.add
      i64.const 0
      i64.store
      get_local 11
      i32.const 72
      i32.add
      i32.const 0
      i32.store
      get_local 11
      get_local 0
      i64.store offset=40
      get_local 11
      get_local 0
      i64.store offset=32
      block  ;; label = @2
        block  ;; label = @3
          get_local 2
          i64.const 8516769789752901632
          i64.eq
          br_if 0 (;@3;)
          get_local 2
          i64.const -3617168760277827584
          i64.ne
          br_if 1 (;@2;)
          get_local 11
          i32.const 0
          i32.store offset=28
          get_local 11
          i32.const 1
          i32.store offset=24
          get_local 11
          get_local 11
          i64.load offset=24
          i64.store align=4
          get_local 11
          i32.const 32
          i32.add
          get_local 11
          call 20
          drop
          br 1 (;@2;)
        end
        get_local 11
        i32.const 0
        i32.store offset=20
        get_local 11
        i32.const 2
        i32.store offset=16
        get_local 11
        get_local 11
        i64.load offset=16
        i64.store offset=8 align=4
        get_local 11
        i32.const 32
        i32.add
        get_local 11
        i32.const 8
        i32.add
        call 22
        drop
      end
      get_local 11
      i32.const 64
      i32.add
      i32.load
      tee_local 4
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        block  ;; label = @3
          get_local 11
          i32.const 68
          i32.add
          tee_local 5
          i32.load
          tee_local 6
          get_local 4
          i32.eq
          br_if 0 (;@3;)
          loop  ;; label = @4
            get_local 6
            i32.const -24
            i32.add
            tee_local 6
            i32.load
            set_local 3
            get_local 6
            i32.const 0
            i32.store
            block  ;; label = @5
              get_local 3
              i32.eqz
              br_if 0 (;@5;)
              get_local 3
              call 36
            end
            get_local 4
            get_local 6
            i32.ne
            br_if 0 (;@4;)
          end
          get_local 11
          i32.const 64
          i32.add
          i32.load
          set_local 6
          br 1 (;@2;)
        end
        get_local 4
        set_local 6
      end
      get_local 5
      get_local 4
      i32.store
      get_local 6
      call 36
    end
    i32.const 0
    get_local 11
    i32.const 80
    i32.add
    i32.store offset=4)
  (func (;19;) (type 0) (param i32 i64 i64 i64)
    (local i32 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    tee_local 6
    i32.store offset=4
    get_local 6
    get_local 3
    i64.store offset=8
    get_local 1
    call 11
    get_local 0
    i32.const 8
    i32.add
    tee_local 4
    get_local 1
    i32.const 560
    call 29
    tee_local 5
    i64.load offset=8
    get_local 3
    i64.ge_u
    i32.const 592
    call 8
    get_local 6
    get_local 6
    i32.const 8
    i32.add
    i32.store
    get_local 4
    get_local 5
    get_local 1
    get_local 6
    call 30
    get_local 0
    get_local 1
    get_local 2
    get_local 6
    i64.load offset=8
    call 23
    i32.const 0
    get_local 6
    i32.const 16
    i32.add
    i32.store offset=4)
  (func (;20;) (type 7) (param i32 i32) (result i32)
    (local i32 i64 i64 i64 i32 i32 i32 i32 i32)
    i32.const 0
    i32.load offset=4
    i32.const 32
    i32.sub
    tee_local 8
    set_local 10
    i32.const 0
    get_local 8
    i32.store offset=4
    get_local 1
    i32.load offset=4
    set_local 2
    get_local 1
    i32.load
    set_local 9
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            call 1
            tee_local 1
            i32.eqz
            br_if 0 (;@4;)
            get_local 1
            i32.const 513
            i32.lt_u
            br_if 1 (;@3;)
            get_local 1
            call 31
            set_local 8
            br 2 (;@2;)
          end
          i32.const 0
          set_local 8
          br 2 (;@1;)
        end
        i32.const 0
        get_local 8
        get_local 1
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        tee_local 8
        i32.store offset=4
      end
      get_local 8
      get_local 1
      call 10
      drop
    end
    get_local 10
    i64.const 0
    i64.store offset=16
    get_local 10
    i64.const 0
    i64.store offset=8
    get_local 10
    i64.const 0
    i64.store offset=24
    get_local 1
    i32.const 7
    i32.gt_u
    i32.const 112
    call 8
    get_local 10
    i32.const 8
    i32.add
    get_local 8
    i32.const 8
    call 9
    drop
    get_local 1
    i32.const -8
    i32.and
    tee_local 6
    i32.const 8
    i32.ne
    i32.const 112
    call 8
    get_local 10
    i32.const 8
    i32.add
    i32.const 8
    i32.add
    tee_local 7
    get_local 8
    i32.const 8
    i32.add
    i32.const 8
    call 9
    drop
    get_local 6
    i32.const 16
    i32.ne
    i32.const 112
    call 8
    get_local 10
    i32.const 8
    i32.add
    i32.const 16
    i32.add
    tee_local 6
    get_local 8
    i32.const 16
    i32.add
    i32.const 8
    call 9
    drop
    block  ;; label = @1
      get_local 1
      i32.const 513
      i32.lt_u
      br_if 0 (;@1;)
      get_local 8
      call 34
    end
    get_local 0
    get_local 2
    i32.const 1
    i32.shr_s
    i32.add
    set_local 1
    get_local 6
    i64.load
    set_local 5
    get_local 7
    i64.load
    set_local 4
    get_local 10
    i64.load offset=8
    set_local 3
    block  ;; label = @1
      get_local 2
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      get_local 1
      i32.load
      get_local 9
      i32.add
      i32.load
      set_local 9
    end
    get_local 1
    get_local 3
    get_local 4
    get_local 5
    get_local 9
    call_indirect (type 0)
    i32.const 0
    get_local 10
    i32.const 32
    i32.add
    i32.store offset=4
    i32.const 1)
  (func (;21;) (type 1) (param i32 i64 i64)
    get_local 0
    i64.load
    call 11
    get_local 0
    get_local 0
    i64.load
    get_local 1
    get_local 2
    call 23)
  (func (;22;) (type 7) (param i32 i32) (result i32)
    (local i32 i64 i64 i32 i32 i32 i32)
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    tee_local 6
    set_local 8
    i32.const 0
    get_local 6
    i32.store offset=4
    get_local 1
    i32.load offset=4
    set_local 2
    get_local 1
    i32.load
    set_local 7
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            call 1
            tee_local 1
            i32.eqz
            br_if 0 (;@4;)
            get_local 1
            i32.const 513
            i32.lt_u
            br_if 1 (;@3;)
            get_local 1
            call 31
            set_local 6
            br 2 (;@2;)
          end
          i32.const 0
          set_local 6
          br 2 (;@1;)
        end
        i32.const 0
        get_local 6
        get_local 1
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        tee_local 6
        i32.store offset=4
      end
      get_local 6
      get_local 1
      call 10
      drop
    end
    get_local 8
    i64.const 0
    i64.store offset=8
    get_local 8
    i64.const 0
    i64.store
    get_local 1
    i32.const 7
    i32.gt_u
    i32.const 112
    call 8
    get_local 8
    get_local 6
    i32.const 8
    call 9
    drop
    get_local 1
    i32.const -8
    i32.and
    i32.const 8
    i32.ne
    i32.const 112
    call 8
    get_local 8
    i32.const 8
    i32.add
    tee_local 5
    get_local 6
    i32.const 8
    i32.add
    i32.const 8
    call 9
    drop
    block  ;; label = @1
      get_local 1
      i32.const 513
      i32.lt_u
      br_if 0 (;@1;)
      get_local 6
      call 34
    end
    get_local 0
    get_local 2
    i32.const 1
    i32.shr_s
    i32.add
    set_local 1
    get_local 5
    i64.load
    set_local 4
    get_local 8
    i64.load
    set_local 3
    block  ;; label = @1
      get_local 2
      i32.const 1
      i32.and
      i32.eqz
      br_if 0 (;@1;)
      get_local 1
      i32.load
      get_local 7
      i32.add
      i32.load
      set_local 7
    end
    get_local 1
    get_local 3
    get_local 4
    get_local 7
    call_indirect (type 1)
    i32.const 0
    get_local 8
    i32.const 16
    i32.add
    i32.store offset=4
    i32.const 1)
  (func (;23;) (type 0) (param i32 i64 i64 i64)
    (local i32 i32 i32 i32 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 32
    i32.sub
    tee_local 9
    i32.store offset=4
    get_local 9
    get_local 2
    i64.store offset=24
    get_local 9
    get_local 3
    i64.store offset=16
    block  ;; label = @1
      get_local 0
      i32.const 36
      i32.add
      i32.load
      tee_local 8
      get_local 0
      i32.const 32
      i32.add
      i32.load
      tee_local 4
      i32.eq
      br_if 0 (;@1;)
      get_local 8
      i32.const -24
      i32.add
      set_local 7
      i32.const 0
      get_local 4
      i32.sub
      set_local 5
      loop  ;; label = @2
        get_local 7
        i32.load
        i64.load
        get_local 2
        i64.eq
        br_if 1 (;@1;)
        get_local 7
        set_local 8
        get_local 7
        i32.const -24
        i32.add
        tee_local 6
        set_local 7
        get_local 6
        get_local 5
        i32.add
        i32.const -24
        i32.ne
        br_if 0 (;@2;)
      end
    end
    get_local 0
    i32.const 8
    i32.add
    set_local 7
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 8
            get_local 4
            i32.eq
            br_if 0 (;@4;)
            get_local 8
            i32.const -24
            i32.add
            i32.load
            tee_local 6
            i32.load offset=16
            get_local 7
            i32.eq
            i32.const 128
            call 8
            get_local 6
            br_if 1 (;@3;)
            br 2 (;@2;)
          end
          get_local 0
          i32.const 8
          i32.add
          i64.load
          get_local 0
          i32.const 16
          i32.add
          i64.load
          i64.const 3607749779137757184
          get_local 2
          call 4
          tee_local 6
          i32.const 0
          i32.lt_s
          br_if 1 (;@2;)
          get_local 7
          get_local 6
          call 24
          tee_local 6
          i32.load offset=16
          get_local 7
          i32.eq
          i32.const 128
          call 8
        end
        get_local 9
        get_local 9
        i32.const 16
        i32.add
        i32.store offset=8
        i32.const 1
        i32.const 192
        call 8
        get_local 7
        get_local 6
        i64.const 0
        get_local 9
        i32.const 8
        i32.add
        call 26
        br 1 (;@1;)
      end
      get_local 9
      get_local 9
      i32.const 16
      i32.add
      i32.store offset=12
      get_local 9
      get_local 9
      i32.const 24
      i32.add
      i32.store offset=8
      get_local 9
      get_local 7
      get_local 1
      get_local 9
      i32.const 8
      i32.add
      call 25
    end
    i32.const 0
    get_local 9
    i32.const 32
    i32.add
    i32.store offset=4)
  (func (;24;) (type 7) (param i32 i32) (result i32)
    (local i32 i32 i32 i64 i32 i32 i32 i32)
    i32.const 0
    i32.load offset=4
    i32.const 32
    i32.sub
    tee_local 9
    set_local 8
    i32.const 0
    get_local 9
    i32.store offset=4
    block  ;; label = @1
      get_local 0
      i32.const 28
      i32.add
      i32.load
      tee_local 7
      get_local 0
      i32.load offset=24
      tee_local 2
      i32.eq
      br_if 0 (;@1;)
      i32.const 0
      get_local 2
      i32.sub
      set_local 3
      get_local 7
      i32.const -24
      i32.add
      set_local 6
      loop  ;; label = @2
        get_local 6
        i32.const 16
        i32.add
        i32.load
        get_local 1
        i32.eq
        br_if 1 (;@1;)
        get_local 6
        set_local 7
        get_local 6
        i32.const -24
        i32.add
        tee_local 4
        set_local 6
        get_local 4
        get_local 3
        i32.add
        i32.const -24
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      block  ;; label = @2
        get_local 7
        get_local 2
        i32.eq
        br_if 0 (;@2;)
        get_local 7
        i32.const -24
        i32.add
        i32.load
        set_local 6
        br 1 (;@1;)
      end
      get_local 1
      i32.const 0
      i32.const 0
      call 5
      tee_local 4
      i32.const 31
      i32.shr_u
      i32.const 1
      i32.xor
      i32.const 528
      call 8
      block  ;; label = @2
        block  ;; label = @3
          get_local 4
          i32.const 512
          i32.le_u
          br_if 0 (;@3;)
          get_local 1
          get_local 4
          call 31
          tee_local 7
          get_local 4
          call 5
          drop
          get_local 7
          call 34
          br 1 (;@2;)
        end
        i32.const 0
        get_local 9
        get_local 4
        i32.const 15
        i32.add
        i32.const -16
        i32.and
        i32.sub
        tee_local 7
        i32.store offset=4
        get_local 1
        get_local 7
        get_local 4
        call 5
        drop
      end
      i32.const 32
      call 35
      tee_local 6
      get_local 0
      i32.store offset=16
      get_local 4
      i32.const 7
      i32.gt_u
      i32.const 112
      call 8
      get_local 6
      get_local 7
      i32.const 8
      call 9
      drop
      get_local 4
      i32.const -8
      i32.and
      i32.const 8
      i32.ne
      i32.const 112
      call 8
      get_local 6
      i32.const 8
      i32.add
      get_local 7
      i32.const 8
      i32.add
      i32.const 8
      call 9
      drop
      get_local 6
      get_local 1
      i32.store offset=20
      get_local 8
      get_local 6
      i32.store offset=24
      get_local 8
      get_local 6
      i64.load
      tee_local 5
      i64.store offset=16
      get_local 8
      get_local 6
      i32.load offset=20
      tee_local 7
      i32.store offset=12
      block  ;; label = @2
        block  ;; label = @3
          get_local 0
          i32.const 28
          i32.add
          tee_local 1
          i32.load
          tee_local 4
          get_local 0
          i32.const 32
          i32.add
          i32.load
          i32.ge_u
          br_if 0 (;@3;)
          get_local 4
          get_local 5
          i64.store offset=8
          get_local 4
          get_local 7
          i32.store offset=16
          get_local 8
          i32.const 0
          i32.store offset=24
          get_local 4
          get_local 6
          i32.store
          get_local 1
          get_local 4
          i32.const 24
          i32.add
          i32.store
          br 1 (;@2;)
        end
        get_local 0
        i32.const 24
        i32.add
        get_local 8
        i32.const 24
        i32.add
        get_local 8
        i32.const 16
        i32.add
        get_local 8
        i32.const 12
        i32.add
        call 28
      end
      get_local 8
      i32.load offset=24
      set_local 4
      get_local 8
      i32.const 0
      i32.store offset=24
      get_local 4
      i32.eqz
      br_if 0 (;@1;)
      get_local 4
      call 36
    end
    i32.const 0
    get_local 8
    i32.const 32
    i32.add
    i32.store offset=4
    get_local 6)
  (func (;25;) (type 15) (param i32 i32 i64 i32)
    (local i32 i32 i32 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 48
    i32.sub
    tee_local 7
    i32.store offset=4
    get_local 7
    get_local 2
    i64.store offset=40
    get_local 1
    i64.load
    call 2
    i64.eq
    i32.const 464
    call 8
    get_local 7
    get_local 3
    i32.store offset=20
    get_local 7
    get_local 1
    i32.store offset=16
    get_local 7
    get_local 7
    i32.const 40
    i32.add
    i32.store offset=24
    i32.const 32
    call 35
    tee_local 3
    get_local 1
    get_local 7
    i32.const 16
    i32.add
    call 27
    drop
    get_local 7
    get_local 3
    i32.store offset=32
    get_local 7
    get_local 3
    i64.load
    tee_local 2
    i64.store offset=16
    get_local 7
    get_local 3
    i32.load offset=20
    tee_local 4
    i32.store offset=12
    block  ;; label = @1
      block  ;; label = @2
        get_local 1
        i32.const 28
        i32.add
        tee_local 6
        i32.load
        tee_local 5
        get_local 1
        i32.const 32
        i32.add
        i32.load
        i32.ge_u
        br_if 0 (;@2;)
        get_local 5
        get_local 2
        i64.store offset=8
        get_local 5
        get_local 4
        i32.store offset=16
        get_local 7
        i32.const 0
        i32.store offset=32
        get_local 5
        get_local 3
        i32.store
        get_local 6
        get_local 5
        i32.const 24
        i32.add
        i32.store
        br 1 (;@1;)
      end
      get_local 1
      i32.const 24
      i32.add
      get_local 7
      i32.const 32
      i32.add
      get_local 7
      i32.const 16
      i32.add
      get_local 7
      i32.const 12
      i32.add
      call 28
    end
    get_local 0
    get_local 3
    i32.store offset=4
    get_local 0
    get_local 1
    i32.store
    get_local 7
    i32.load offset=32
    set_local 1
    get_local 7
    i32.const 0
    i32.store offset=32
    block  ;; label = @1
      get_local 1
      i32.eqz
      br_if 0 (;@1;)
      get_local 1
      call 36
    end
    i32.const 0
    get_local 7
    i32.const 48
    i32.add
    i32.store offset=4)
  (func (;26;) (type 15) (param i32 i32 i64 i32)
    (local i64 i64 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    tee_local 6
    i32.store offset=4
    get_local 1
    i32.load offset=16
    get_local 0
    i32.eq
    i32.const 240
    call 8
    get_local 0
    i64.load
    call 2
    i64.eq
    i32.const 288
    call 8
    get_local 1
    get_local 1
    i64.load offset=8
    get_local 3
    i32.load
    i64.load
    i64.add
    tee_local 5
    i64.store offset=8
    get_local 1
    i64.load
    set_local 4
    get_local 5
    get_local 3
    i32.load
    i64.load
    i64.ge_u
    i32.const 352
    call 8
    get_local 4
    get_local 1
    i64.load
    i64.eq
    i32.const 384
    call 8
    i32.const 1
    i32.const 448
    call 8
    get_local 6
    get_local 1
    i32.const 8
    call 9
    drop
    i32.const 1
    i32.const 448
    call 8
    get_local 6
    i32.const 8
    i32.or
    get_local 1
    i32.const 8
    i32.add
    i32.const 8
    call 9
    drop
    get_local 1
    i32.load offset=20
    get_local 2
    get_local 6
    i32.const 16
    call 7
    block  ;; label = @1
      get_local 4
      get_local 0
      i64.load offset=16
      i64.lt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const 16
      i32.add
      i64.const -2
      get_local 4
      i64.const 1
      i64.add
      get_local 4
      i64.const -3
      i64.gt_u
      select
      i64.store
    end
    i32.const 0
    get_local 6
    i32.const 16
    i32.add
    i32.store offset=4)
  (func (;27;) (type 8) (param i32 i32 i32) (result i32)
    (local i64 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    tee_local 4
    i32.store offset=4
    get_local 0
    get_local 1
    i32.store offset=16
    get_local 0
    get_local 2
    i32.load offset=4
    tee_local 1
    i32.load
    i64.load
    i64.store
    get_local 0
    get_local 1
    i32.load offset=4
    i64.load
    i64.store offset=8
    get_local 2
    i32.load
    set_local 1
    i32.const 1
    i32.const 448
    call 8
    get_local 4
    get_local 0
    i32.const 8
    call 9
    drop
    i32.const 1
    i32.const 448
    call 8
    get_local 4
    i32.const 8
    i32.or
    get_local 0
    i32.const 8
    i32.add
    i32.const 8
    call 9
    drop
    get_local 0
    get_local 1
    i64.load offset=8
    i64.const 3607749779137757184
    get_local 2
    i32.load offset=8
    i64.load
    get_local 0
    i64.load
    tee_local 3
    get_local 4
    i32.const 16
    call 6
    i32.store offset=20
    block  ;; label = @1
      get_local 3
      get_local 1
      i64.load offset=16
      i64.lt_u
      br_if 0 (;@1;)
      get_local 1
      i32.const 16
      i32.add
      i64.const -2
      get_local 3
      i64.const 1
      i64.add
      get_local 3
      i64.const -3
      i64.gt_u
      select
      i64.store
    end
    i32.const 0
    get_local 4
    i32.const 16
    i32.add
    i32.store offset=4
    get_local 0)
  (func (;28;) (type 16) (param i32 i32 i32 i32)
    (local i32 i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.load offset=4
        get_local 0
        i32.load
        tee_local 6
        i32.sub
        i32.const 24
        i32.div_s
        tee_local 4
        i32.const 1
        i32.add
        tee_local 5
        i32.const 178956971
        i32.ge_u
        br_if 0 (;@2;)
        i32.const 178956970
        set_local 7
        block  ;; label = @3
          block  ;; label = @4
            get_local 0
            i32.load offset=8
            get_local 6
            i32.sub
            i32.const 24
            i32.div_s
            tee_local 6
            i32.const 89478484
            i32.gt_u
            br_if 0 (;@4;)
            get_local 5
            get_local 6
            i32.const 1
            i32.shl
            tee_local 7
            get_local 7
            get_local 5
            i32.lt_u
            select
            tee_local 7
            i32.eqz
            br_if 1 (;@3;)
          end
          get_local 7
          i32.const 24
          i32.mul
          call 35
          set_local 6
          br 2 (;@1;)
        end
        i32.const 0
        set_local 7
        i32.const 0
        set_local 6
        br 1 (;@1;)
      end
      get_local 0
      call 37
      unreachable
    end
    get_local 1
    i32.load
    set_local 5
    get_local 1
    i32.const 0
    i32.store
    get_local 6
    get_local 4
    i32.const 24
    i32.mul
    i32.add
    tee_local 1
    get_local 5
    i32.store
    get_local 1
    get_local 2
    i64.load
    i64.store offset=8
    get_local 1
    get_local 3
    i32.load
    i32.store offset=16
    get_local 6
    get_local 7
    i32.const 24
    i32.mul
    i32.add
    set_local 4
    get_local 1
    i32.const 24
    i32.add
    set_local 5
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.const 4
        i32.add
        i32.load
        tee_local 6
        get_local 0
        i32.load
        tee_local 7
        i32.eq
        br_if 0 (;@2;)
        loop  ;; label = @3
          get_local 6
          i32.const -24
          i32.add
          tee_local 2
          i32.load
          set_local 3
          get_local 2
          i32.const 0
          i32.store
          get_local 1
          i32.const -24
          i32.add
          get_local 3
          i32.store
          get_local 1
          i32.const -8
          i32.add
          get_local 6
          i32.const -8
          i32.add
          i32.load
          i32.store
          get_local 1
          i32.const -12
          i32.add
          get_local 6
          i32.const -12
          i32.add
          i32.load
          i32.store
          get_local 1
          i32.const -16
          i32.add
          get_local 6
          i32.const -16
          i32.add
          i32.load
          i32.store
          get_local 1
          i32.const -24
          i32.add
          set_local 1
          get_local 2
          set_local 6
          get_local 7
          get_local 2
          i32.ne
          br_if 0 (;@3;)
        end
        get_local 0
        i32.const 4
        i32.add
        i32.load
        set_local 7
        get_local 0
        i32.load
        set_local 6
        br 1 (;@1;)
      end
      get_local 7
      set_local 6
    end
    get_local 0
    get_local 1
    i32.store
    get_local 0
    i32.const 4
    i32.add
    get_local 5
    i32.store
    get_local 0
    i32.const 8
    i32.add
    get_local 4
    i32.store
    block  ;; label = @1
      get_local 7
      get_local 6
      i32.eq
      br_if 0 (;@1;)
      loop  ;; label = @2
        get_local 7
        i32.const -24
        i32.add
        tee_local 7
        i32.load
        set_local 1
        get_local 7
        i32.const 0
        i32.store
        block  ;; label = @3
          get_local 1
          i32.eqz
          br_if 0 (;@3;)
          get_local 1
          call 36
        end
        get_local 6
        get_local 7
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      get_local 6
      i32.eqz
      br_if 0 (;@1;)
      get_local 6
      call 36
    end)
  (func (;29;) (type 17) (param i32 i64 i32) (result i32)
    (local i32 i32 i32 i32 i32)
    block  ;; label = @1
      get_local 0
      i32.const 28
      i32.add
      i32.load
      tee_local 7
      get_local 0
      i32.load offset=24
      tee_local 3
      i32.eq
      br_if 0 (;@1;)
      get_local 7
      i32.const -24
      i32.add
      set_local 6
      i32.const 0
      get_local 3
      i32.sub
      set_local 4
      loop  ;; label = @2
        get_local 6
        i32.load
        i64.load
        get_local 1
        i64.eq
        br_if 1 (;@1;)
        get_local 6
        set_local 7
        get_local 6
        i32.const -24
        i32.add
        tee_local 5
        set_local 6
        get_local 5
        get_local 4
        i32.add
        i32.const -24
        i32.ne
        br_if 0 (;@2;)
      end
    end
    block  ;; label = @1
      block  ;; label = @2
        get_local 7
        get_local 3
        i32.eq
        br_if 0 (;@2;)
        get_local 7
        i32.const -24
        i32.add
        i32.load
        tee_local 6
        i32.load offset=16
        get_local 0
        i32.eq
        i32.const 128
        call 8
        br 1 (;@1;)
      end
      i32.const 0
      set_local 6
      get_local 0
      i64.load
      get_local 0
      i64.load offset=8
      i64.const 3607749779137757184
      get_local 1
      call 4
      tee_local 5
      i32.const 0
      i32.lt_s
      br_if 0 (;@1;)
      get_local 0
      get_local 5
      call 24
      tee_local 6
      i32.load offset=16
      get_local 0
      i32.eq
      i32.const 128
      call 8
    end
    get_local 6
    i32.const 0
    i32.ne
    get_local 2
    call 8
    get_local 6)
  (func (;30;) (type 15) (param i32 i32 i64 i32)
    (local i64 i32)
    i32.const 0
    i32.const 0
    i32.load offset=4
    i32.const 16
    i32.sub
    tee_local 5
    i32.store offset=4
    get_local 1
    i32.load offset=16
    get_local 0
    i32.eq
    i32.const 240
    call 8
    get_local 0
    i64.load
    call 2
    i64.eq
    i32.const 288
    call 8
    get_local 1
    get_local 1
    i64.load offset=8
    get_local 3
    i32.load
    i64.load
    i64.sub
    i64.store offset=8
    get_local 1
    i64.load
    set_local 4
    i32.const 1
    i32.const 384
    call 8
    i32.const 1
    i32.const 448
    call 8
    get_local 5
    get_local 1
    i32.const 8
    call 9
    drop
    i32.const 1
    i32.const 448
    call 8
    get_local 5
    i32.const 8
    i32.or
    get_local 1
    i32.const 8
    i32.add
    i32.const 8
    call 9
    drop
    get_local 1
    i32.load offset=20
    get_local 2
    get_local 5
    i32.const 16
    call 7
    block  ;; label = @1
      get_local 4
      get_local 0
      i64.load offset=16
      i64.lt_u
      br_if 0 (;@1;)
      get_local 0
      i32.const 16
      i32.add
      i64.const -2
      get_local 4
      i64.const 1
      i64.add
      get_local 4
      i64.const -3
      i64.gt_u
      select
      i64.store
    end
    i32.const 0
    get_local 5
    i32.const 16
    i32.add
    i32.store offset=4)
  (func (;31;) (type 18) (param i32) (result i32)
    i32.const 612
    get_local 0
    call 32)
  (func (;32;) (type 7) (param i32 i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32 i32)
    block  ;; label = @1
      get_local 1
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        get_local 0
        i32.load offset=8384
        tee_local 13
        br_if 0 (;@2;)
        i32.const 16
        set_local 13
        get_local 0
        i32.const 8384
        i32.add
        i32.const 16
        i32.store
      end
      get_local 1
      i32.const 8
      i32.add
      get_local 1
      i32.const 4
      i32.add
      i32.const 7
      i32.and
      tee_local 2
      i32.sub
      get_local 1
      get_local 2
      select
      set_local 2
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 0
            i32.load offset=8388
            tee_local 10
            get_local 13
            i32.ge_u
            br_if 0 (;@4;)
            get_local 0
            get_local 10
            i32.const 12
            i32.mul
            i32.add
            i32.const 8192
            i32.add
            set_local 1
            block  ;; label = @5
              get_local 10
              br_if 0 (;@5;)
              get_local 0
              i32.const 8196
              i32.add
              tee_local 13
              i32.load
              br_if 0 (;@5;)
              get_local 1
              i32.const 8192
              i32.store
              get_local 13
              get_local 0
              i32.store
            end
            get_local 2
            i32.const 4
            i32.add
            set_local 10
            loop  ;; label = @5
              block  ;; label = @6
                get_local 1
                i32.load offset=8
                tee_local 13
                get_local 10
                i32.add
                get_local 1
                i32.load
                i32.gt_u
                br_if 0 (;@6;)
                get_local 1
                i32.load offset=4
                get_local 13
                i32.add
                tee_local 13
                get_local 13
                i32.load
                i32.const -2147483648
                i32.and
                get_local 2
                i32.or
                i32.store
                get_local 1
                i32.const 8
                i32.add
                tee_local 1
                get_local 1
                i32.load
                get_local 10
                i32.add
                i32.store
                get_local 13
                get_local 13
                i32.load
                i32.const -2147483648
                i32.or
                i32.store
                get_local 13
                i32.const 4
                i32.add
                tee_local 1
                br_if 3 (;@3;)
              end
              get_local 0
              call 33
              tee_local 1
              br_if 0 (;@5;)
            end
          end
          i32.const 2147483644
          get_local 2
          i32.sub
          set_local 4
          get_local 0
          i32.const 8392
          i32.add
          set_local 11
          get_local 0
          i32.const 8384
          i32.add
          set_local 12
          get_local 0
          i32.load offset=8392
          tee_local 3
          set_local 13
          loop  ;; label = @4
            get_local 0
            get_local 13
            i32.const 12
            i32.mul
            i32.add
            tee_local 1
            i32.const 8200
            i32.add
            i32.load
            get_local 1
            i32.const 8192
            i32.add
            tee_local 5
            i32.load
            i32.eq
            i32.const 9008
            call 8
            get_local 1
            i32.const 8196
            i32.add
            i32.load
            tee_local 6
            i32.const 4
            i32.add
            set_local 13
            loop  ;; label = @5
              get_local 6
              get_local 5
              i32.load
              i32.add
              set_local 7
              get_local 13
              i32.const -4
              i32.add
              tee_local 8
              i32.load
              tee_local 9
              i32.const 2147483647
              i32.and
              set_local 1
              block  ;; label = @6
                get_local 9
                i32.const 0
                i32.lt_s
                br_if 0 (;@6;)
                block  ;; label = @7
                  get_local 1
                  get_local 2
                  i32.ge_u
                  br_if 0 (;@7;)
                  loop  ;; label = @8
                    get_local 13
                    get_local 1
                    i32.add
                    tee_local 10
                    get_local 7
                    i32.ge_u
                    br_if 1 (;@7;)
                    get_local 10
                    i32.load
                    tee_local 10
                    i32.const 0
                    i32.lt_s
                    br_if 1 (;@7;)
                    get_local 1
                    get_local 10
                    i32.const 2147483647
                    i32.and
                    i32.add
                    i32.const 4
                    i32.add
                    tee_local 1
                    get_local 2
                    i32.lt_u
                    br_if 0 (;@8;)
                  end
                end
                get_local 8
                get_local 1
                get_local 2
                get_local 1
                get_local 2
                i32.lt_u
                select
                get_local 9
                i32.const -2147483648
                i32.and
                i32.or
                i32.store
                block  ;; label = @7
                  get_local 1
                  get_local 2
                  i32.le_u
                  br_if 0 (;@7;)
                  get_local 13
                  get_local 2
                  i32.add
                  get_local 4
                  get_local 1
                  i32.add
                  i32.const 2147483647
                  i32.and
                  i32.store
                end
                get_local 1
                get_local 2
                i32.ge_u
                br_if 4 (;@2;)
              end
              get_local 13
              get_local 1
              i32.add
              i32.const 4
              i32.add
              tee_local 13
              get_local 7
              i32.lt_u
              br_if 0 (;@5;)
            end
            i32.const 0
            set_local 1
            get_local 11
            i32.const 0
            get_local 11
            i32.load
            i32.const 1
            i32.add
            tee_local 13
            get_local 13
            get_local 12
            i32.load
            i32.eq
            select
            tee_local 13
            i32.store
            get_local 13
            get_local 3
            i32.ne
            br_if 0 (;@4;)
          end
        end
        get_local 1
        return
      end
      get_local 8
      get_local 8
      i32.load
      i32.const -2147483648
      i32.or
      i32.store
      get_local 13
      return
    end
    i32.const 0)
  (func (;33;) (type 18) (param i32) (result i32)
    (local i32 i32 i32 i32 i32 i32 i32 i32)
    get_local 0
    i32.load offset=8388
    set_local 1
    block  ;; label = @1
      block  ;; label = @2
        i32.const 0
        i32.load8_u offset=9094
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=9096
        set_local 7
        br 1 (;@1;)
      end
      memory.size
      set_local 7
      i32.const 0
      i32.const 1
      i32.store8 offset=9094
      i32.const 0
      get_local 7
      i32.const 16
      i32.shl
      tee_local 7
      i32.store offset=9096
    end
    get_local 7
    set_local 3
    block  ;; label = @1
      block  ;; label = @2
        block  ;; label = @3
          block  ;; label = @4
            get_local 7
            i32.const 65535
            i32.add
            i32.const 16
            i32.shr_u
            tee_local 2
            memory.size
            tee_local 8
            i32.le_u
            br_if 0 (;@4;)
            get_local 2
            get_local 8
            i32.sub
            memory.grow
            drop
            i32.const 0
            set_local 8
            get_local 2
            memory.size
            i32.ne
            br_if 1 (;@3;)
            i32.const 0
            i32.load offset=9096
            set_local 3
          end
          i32.const 0
          set_local 8
          i32.const 0
          get_local 3
          i32.store offset=9096
          get_local 7
          i32.const 0
          i32.lt_s
          br_if 0 (;@3;)
          get_local 0
          get_local 1
          i32.const 12
          i32.mul
          i32.add
          set_local 2
          get_local 7
          i32.const 65536
          i32.const 131072
          get_local 7
          i32.const 65535
          i32.and
          tee_local 8
          i32.const 64513
          i32.lt_u
          tee_local 6
          select
          i32.add
          get_local 8
          get_local 7
          i32.const 131071
          i32.and
          get_local 6
          select
          i32.sub
          get_local 7
          i32.sub
          set_local 7
          block  ;; label = @4
            i32.const 0
            i32.load8_u offset=9094
            br_if 0 (;@4;)
            memory.size
            set_local 3
            i32.const 0
            i32.const 1
            i32.store8 offset=9094
            i32.const 0
            get_local 3
            i32.const 16
            i32.shl
            tee_local 3
            i32.store offset=9096
          end
          get_local 2
          i32.const 8192
          i32.add
          set_local 2
          get_local 7
          i32.const 0
          i32.lt_s
          br_if 1 (;@2;)
          get_local 3
          set_local 6
          block  ;; label = @4
            get_local 7
            i32.const 7
            i32.add
            i32.const -8
            i32.and
            tee_local 5
            get_local 3
            i32.add
            i32.const 65535
            i32.add
            i32.const 16
            i32.shr_u
            tee_local 8
            memory.size
            tee_local 4
            i32.le_u
            br_if 0 (;@4;)
            get_local 8
            get_local 4
            i32.sub
            memory.grow
            drop
            get_local 8
            memory.size
            i32.ne
            br_if 2 (;@2;)
            i32.const 0
            i32.load offset=9096
            set_local 6
          end
          i32.const 0
          get_local 6
          get_local 5
          i32.add
          i32.store offset=9096
          get_local 3
          i32.const -1
          i32.eq
          br_if 1 (;@2;)
          get_local 0
          get_local 1
          i32.const 12
          i32.mul
          i32.add
          tee_local 1
          i32.const 8196
          i32.add
          i32.load
          tee_local 6
          get_local 2
          i32.load
          tee_local 8
          i32.add
          get_local 3
          i32.eq
          br_if 2 (;@1;)
          block  ;; label = @4
            get_local 8
            get_local 1
            i32.const 8200
            i32.add
            tee_local 5
            i32.load
            tee_local 1
            i32.eq
            br_if 0 (;@4;)
            get_local 6
            get_local 1
            i32.add
            tee_local 6
            get_local 6
            i32.load
            i32.const -2147483648
            i32.and
            i32.const -4
            get_local 1
            i32.sub
            get_local 8
            i32.add
            i32.or
            i32.store
            get_local 5
            get_local 2
            i32.load
            i32.store
            get_local 6
            get_local 6
            i32.load
            i32.const 2147483647
            i32.and
            i32.store
          end
          get_local 0
          i32.const 8388
          i32.add
          tee_local 2
          get_local 2
          i32.load
          i32.const 1
          i32.add
          tee_local 2
          i32.store
          get_local 0
          get_local 2
          i32.const 12
          i32.mul
          i32.add
          tee_local 0
          i32.const 8196
          i32.add
          get_local 3
          i32.store
          get_local 0
          i32.const 8192
          i32.add
          tee_local 8
          get_local 7
          i32.store
        end
        get_local 8
        return
      end
      block  ;; label = @2
        get_local 2
        i32.load
        tee_local 8
        get_local 0
        get_local 1
        i32.const 12
        i32.mul
        i32.add
        tee_local 3
        i32.const 8200
        i32.add
        tee_local 1
        i32.load
        tee_local 7
        i32.eq
        br_if 0 (;@2;)
        get_local 3
        i32.const 8196
        i32.add
        i32.load
        get_local 7
        i32.add
        tee_local 3
        get_local 3
        i32.load
        i32.const -2147483648
        i32.and
        i32.const -4
        get_local 7
        i32.sub
        get_local 8
        i32.add
        i32.or
        i32.store
        get_local 1
        get_local 2
        i32.load
        i32.store
        get_local 3
        get_local 3
        i32.load
        i32.const 2147483647
        i32.and
        i32.store
      end
      get_local 0
      get_local 0
      i32.const 8388
      i32.add
      tee_local 7
      i32.load
      i32.const 1
      i32.add
      tee_local 3
      i32.store offset=8384
      get_local 7
      get_local 3
      i32.store
      i32.const 0
      return
    end
    get_local 2
    get_local 8
    get_local 7
    i32.add
    i32.store
    get_local 2)
  (func (;34;) (type 13) (param i32)
    (local i32 i32 i32)
    block  ;; label = @1
      block  ;; label = @2
        get_local 0
        i32.eqz
        br_if 0 (;@2;)
        i32.const 0
        i32.load offset=8996
        tee_local 2
        i32.const 1
        i32.lt_s
        br_if 0 (;@2;)
        i32.const 8804
        set_local 3
        get_local 2
        i32.const 12
        i32.mul
        i32.const 8804
        i32.add
        set_local 1
        loop  ;; label = @3
          get_local 3
          i32.const 4
          i32.add
          i32.load
          tee_local 2
          i32.eqz
          br_if 1 (;@2;)
          block  ;; label = @4
            get_local 2
            i32.const 4
            i32.add
            get_local 0
            i32.gt_u
            br_if 0 (;@4;)
            get_local 2
            get_local 3
            i32.load
            i32.add
            get_local 0
            i32.gt_u
            br_if 3 (;@1;)
          end
          get_local 3
          i32.const 12
          i32.add
          tee_local 3
          get_local 1
          i32.lt_u
          br_if 0 (;@3;)
        end
      end
      return
    end
    get_local 0
    i32.const -4
    i32.add
    tee_local 3
    get_local 3
    i32.load
    i32.const 2147483647
    i32.and
    i32.store)
  (func (;35;) (type 18) (param i32) (result i32)
    (local i32 i32)
    block  ;; label = @1
      get_local 0
      i32.const 1
      get_local 0
      select
      tee_local 1
      call 31
      tee_local 0
      br_if 0 (;@1;)
      loop  ;; label = @2
        i32.const 0
        set_local 0
        i32.const 0
        i32.load offset=9100
        tee_local 2
        i32.eqz
        br_if 1 (;@1;)
        get_local 2
        call_indirect (type 2)
        get_local 1
        call 31
        tee_local 0
        i32.eqz
        br_if 0 (;@2;)
      end
    end
    get_local 0)
  (func (;36;) (type 13) (param i32)
    block  ;; label = @1
      get_local 0
      i32.eqz
      br_if 0 (;@1;)
      get_local 0
      call 34
    end)
  (func (;37;) (type 13) (param i32)
    call 0
    unreachable)
  (func (;38;) (type 8) (param i32 i32 i32) (result i32)
    (local i32 i32 i32)
    i32.const 0
    set_local 5
    block  ;; label = @1
      get_local 2
      i32.eqz
      br_if 0 (;@1;)
      block  ;; label = @2
        loop  ;; label = @3
          get_local 0
          i32.load8_u
          tee_local 3
          get_local 1
          i32.load8_u
          tee_local 4
          i32.ne
          br_if 1 (;@2;)
          get_local 1
          i32.const 1
          i32.add
          set_local 1
          get_local 0
          i32.const 1
          i32.add
          set_local 0
          get_local 2
          i32.const -1
          i32.add
          tee_local 2
          br_if 0 (;@3;)
          br 2 (;@1;)
        end
      end
      get_local 3
      get_local 4
      i32.sub
      set_local 5
    end
    get_local 5)
  (func (;39;) (type 2)
    unreachable)
  (table (;0;) 3 3 anyfunc)
  (memory (;0;) 1)
  (export "memory" (memory 0))
  (export "_ZeqRK11checksum256S1_" (func 13))
  (export "_ZeqRK11checksum160S1_" (func 14))
  (export "_ZneRK11checksum160S1_" (func 15))
  (export "now" (func 16))
  (export "_ZN5eosio12require_authERKNS_16permission_levelE" (func 17))
  (export "apply" (func 18))
  (export "malloc" (func 31))
  (export "free" (func 34))
  (export "memcmp" (func 38))
  (elem (i32.const 0) 39 19 21)
  (data (i32.const 4) "\90c\00\00")
  (data (i32.const 16) "onerror\00")
  (data (i32.const 32) "eosio\00")
  (data (i32.const 48) "onerror action's are only valid from the \22eosio\22 system account\00")
  (data (i32.const 112) "read\00")
  (data (i32.const 128) "object passed to iterator_to is not in multi_index\00")
  (data (i32.const 192) "cannot pass end iterator to modify\00")
  (data (i32.const 240) "object passed to modify is not in multi_index\00")
  (data (i32.const 288) "cannot modify objects in table of another contract\00")
  (data (i32.const 352) "overflow detected\00")
  (data (i32.const 384) "updater cannot change primary key when modifying an object\00")
  (data (i32.const 448) "write\00")
  (data (i32.const 464) "cannot create objects in table of another contract\00")
  (data (i32.const 528) "error reading iterator\00")
  (data (i32.const 560) "unable to find key\00")
  (data (i32.const 592) "overdrawn balance\00")
  (data (i32.const 9008) "malloc_from_freed was designed to only be called after _heap was completely allocated\00"))
