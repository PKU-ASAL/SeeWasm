# These functions are imported from WASI
# we will emulate their behaviors

import logging
from copy import deepcopy
from datetime import datetime

from seewasm.arch.wasm.configuration import Configuration
from seewasm.arch.wasm.exceptions import (ProcFailTermination,
                                          ProcSuccessTermination)
from seewasm.arch.wasm.lib.utils import _extract_params, _loadN, _storeN
from seewasm.arch.wasm.solver import SMTSolver
from seewasm.arch.wasm.utils import (init_file_for_file_sys,
                                     str_to_little_endian_int)
from z3 import And, BitVec, BitVecVal, Extract, is_bv, sat


class WASIImportFunction:
    """
    Emulate the behavior of import functioons.

    Basically composed of WASI import functions
    """

    def __init__(self, name, cur_func_name):
        self.name = name
        self.cur_func = cur_func_name

    def emul(self, state, param_str, return_str, data_section):
        # if the return value is dependent on the library function, we will manually contruct it
        # and jump over the process in which it append a symbol according to the signature of the function
        if self.name == 'args_sizes_get':
            arg_buf_size_addr, argc_addr = _extract_params(param_str, state)
            logging.info(
                f"\targs_sizes_get, argc_addr: {argc_addr}, arg_buf_size_addr: {arg_buf_size_addr}")

            # stored in Configurator, will be fetched by args_get
            Configuration._argc_addr = argc_addr
            Configuration._arg_buf_size_addr = arg_buf_size_addr

            # record all symbol args' len in char
            sym_args_len = []
            no_sym_args_len = []
            for i in state.args:
                if is_bv(i):
                    sym_args_len.append(i.size() // 8)
                else:
                    # these args are in string
                    no_sym_args_len.append(len(i))

            argc = len(sym_args_len) + len(no_sym_args_len)
            argv_len = sum(sym_args_len) + sum(no_sym_args_len) + argc
            Configuration._argc_arg_buf_size.append(
                [argc] + no_sym_args_len + sym_args_len)

            _storeN(state, argc_addr, argc, 4)
            _storeN(state, arg_buf_size_addr, argv_len, 4)
            state.symbolic_stack.append(BitVecVal(0, 32))

            return [state]

            # ORIGINAL IMPLEMENTATION
            # consider all possible length for symbolic argv
            # for example, if argv == 3, we will consider its value as 0, 1, 2, and 3, respectively
            # -----------------------------------------------------------------------
            # # keep all possible states
            # possible_states = []
            # # init, if all symbols are \x00
            # argc = len(no_sym_args_len)
            # argv_len = sum(no_sym_args_len) + argc
            # # store argc and argvs' len
            # Configuration._argc_arg_buf_size.append([argc] + no_sym_args_len)

            # new_state = deepcopy(state)
            # _storeN(new_state, argc_addr, argc, 4)
            # _storeN(new_state, arg_buf_size_addr, argv_len, 4)
            # new_state.symbolic_stack.append(BitVecVal(0, 32))
            # possible_states.append(new_state)

            # # traverse those possible combination for symbol args
            # for index, i in enumerate(sym_args_len):
            #     argc += 1
            #     argv_len += 1       # the trailing zero
            #     for j in range(1, i + 1):
            #         argv_len += 1
            #         # store argc and argvs' len
            #         Configuration._argc_arg_buf_size.append(
            #             [argc] + no_sym_args_len + sym_args_len[:index] + [j])

            #         # copy and store
            #         new_state = deepcopy(state)
            #         _storeN(new_state, argc_addr, argc, 4)
            #         _storeN(new_state, arg_buf_size_addr, argv_len, 4)
            #         new_state.symbolic_stack.append(BitVecVal(0, 32))
            #         possible_states.append(new_state)

            # return possible_states
            # -----------------------------------------------------------------------
        elif self.name == 'args_get':
            # this is not the complete version
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIArgsEnvs.cpp
            arg_buf_addr, argv_addr = _extract_params(param_str, state)
            logging.info(
                f"\targs_get, argv_addr: {argv_addr}, arg_buf_addr: {arg_buf_addr}")
            # retrieve argc and arg_buf_size
            argc = _loadN(state, data_section, Configuration._argc_addr, 4)
            arg_buf_size = _loadN(state, data_section,
                                  Configuration._arg_buf_size_addr, 4)
            # find each elements length
            for tuple in Configuration._argc_arg_buf_size:
                if argc == tuple[0] and arg_buf_size == sum(tuple):
                    break
            argc = tuple[0]
            arg_buf_sizes = tuple[1:]
            logging.info(
                f"\ttring to load {argc} args, with lenths as {arg_buf_sizes}")

            # emulate the official implementation
            # only keep the first argc args
            args = state.args[:argc]
            next_arg_buf_addr = arg_buf_addr
            for arg_index in range(argc):
                arg = args[arg_index]
                arg_supposed_len = arg_buf_sizes[arg_index]

                if isinstance(arg, str):
                    assert arg_supposed_len == len(
                        arg), f"the string format args are not equal, should be {arg_supposed_len} instead of {len(arg)}"
                    num_arg_bytes = len(arg) + 1
                    # insert the arg
                    _storeN(
                        state, next_arg_buf_addr,
                        str_to_little_endian_int(arg + "\x00"),
                        num_arg_bytes)

                elif is_bv(arg):
                    if arg.size() // 8 != arg_supposed_len:
                        # resize
                        arg = BitVec(
                            str(args[arg_index]),
                            arg_supposed_len * 8)
                        state.args[arg_index] = arg
                    # limit the arg can only be printable chars
                    # for i in range(arg.size() // 8, 0, -1):
                    #     the_char = Extract(i * 8 - 1, (i - 1) * 8, arg)
                    #     state.solver.add(
                    #         And(the_char >= 33, the_char <= 126))

                    state.solver.add(arg != 0)
                    num_arg_bytes = arg.size() // 8 + 1
                    # insert the arg
                    _storeN(state, next_arg_buf_addr, arg, num_arg_bytes - 1)
                    _storeN(state, next_arg_buf_addr + num_arg_bytes - 1, 0, 1)

                # insert the next_arg_buf_addr
                _storeN(state, argv_addr + 4 * arg_index,
                        next_arg_buf_addr, 4)
                # update the next_arg_buf_addr
                next_arg_buf_addr += num_arg_bytes

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'environ_sizes_get':
            env_buf_size_addr, env_count_addr = _extract_params(
                param_str, state)
            logging.info(
                f"\tenviron_sizes_get, env_count_addr: {env_count_addr}, env_buf_size_addr: {env_buf_size_addr}")

            _storeN(state, env_count_addr, 0, 4)
            _storeN(state, env_buf_size_addr, 0, 4)

            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_advise':
            # ref: https://man7.org/linux/man-pages/man2/posix_fadvise.2.html
            advice, length, offset, fd = _extract_params(param_str, state)
            logging.info(
                f"\tfd_advise, fd: {fd}, offset: {offset}, length: {length}, advice: {advice}")

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_fdstat_get':
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L717
            fd_stat_addr, fd = _extract_params(param_str, state)
            logging.info(
                f"\tfd_fdstat_get, fd: {fd}, fd_stat_addr: {fd_stat_addr}")
            # fs_filetype is 1 byte, possible 0-7
            # fs_filetype = BitVec(
            #     f'fs_filetype_{datetime.timestamp(datetime.now()):.0f}', 8)
            # TODO we temporarily to concretize the fs_filetype as 1, i.e., __WASI_FILETYPE_CHARACTER_DEVICE
            fs_filetype = 2
            _storeN(state, fd_stat_addr, fs_filetype, 1)
            # TODO the fs_filetype could be 0-7, jump over temporarily
            # state.solver.add(
            #     Or(
            #         fs_filetype == 0, fs_filetype == 1,
            #         fs_filetype == 2, fs_filetype == 3,
            #         fs_filetype == 4, fs_filetype == 5,
            #         fs_filetype == 6, fs_filetype == 7))
            # align
            _storeN(state, fd_stat_addr + 1, 0, 1)

            # fs_flags is 2 bytes, possible from {0, 1, 2, 3, 4, 5, 6, 7, 10, 11, 14, 15}
            # fs_flags = BitVec(
            #     f'fs_flags_{datetime.timestamp(datetime.now()):.0f}', 16)
            # TODO we temporarily to concretize the fs_flags as 0, i.e., no flags are set
            fs_flags = 0
            _storeN(state, fd_stat_addr + 2, fs_flags, 2)
            # TODO the fs_flags could be the following values, jump over temporarily
            # state.solver.add(
            #     Or(
            #         fs_flags == 0, fs_flags == 1,
            #         fs_flags == 2, fs_flags == 3,
            #         fs_flags == 4, fs_flags == 5,
            #         fs_flags == 6, fs_flags == 7,
            #         fs_flags == 10, fs_flags == 11,
            #         fs_flags == 14, fs_flags == 15))
            # align
            _storeN(state, fd_stat_addr + 4, 0, 4)

            # fs_rights_base and fs_rights_inheriting is 0, 8 bytes for each
            _storeN(state, fd_stat_addr + 8, 0, 8)
            _storeN(state, fd_stat_addr + 16, 0, 8)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_tell':
            # TODO, do not precisely emulate this function, just insert 0 temporarily
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L695
            offset_addr, fd = _extract_params(param_str, state)
            logging.info(
                f"\tfd_tell, fd: {fd}, offset_addr: {offset_addr}")
            fd_tell_var = BitVec(
                f"fd_tell_{datetime.timestamp(datetime.now()):.0f}", 32)
            _storeN(state, offset_addr, fd_tell_var, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_seek':
            # TODO, similar to fd_tell, do not precisely emulate this function
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L657
            new_offset_addr, whence, offset, fd = _extract_params(
                param_str, state)
            logging.info(
                f"\tfd_seek, fd: {fd}, offset: {offset}, whence: {whence}, new_offset_addr: {new_offset_addr}")
            fd_seek_var = BitVec(
                f"fd_seek_{datetime.timestamp(datetime.now()):.0f}", 32)
            _storeN(state, new_offset_addr, fd_seek_var, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_close':
            # I did not emulate the fdMap, just return the success flag here
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L322
            fd, = _extract_params(param_str, state)
            logging.info(f"\tfd_close, fd: {fd}")
            state.file_sys[f"-{fd}_{datetime.timestamp(datetime.now()):.0f}"] = state.file_sys[fd].copy(
            )
            state.file_sys[fd] = init_file_for_file_sys()

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_read':
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L554
            num_bytes_read_addr, num_iovs, iovs_addr, fd = _extract_params(
                param_str,
                state)
            logging.info(
                f"\tfd_read, fd: {fd}, iovs_addr: {iovs_addr}, num_iovs: {num_iovs}, num_bytes_read_addr: {num_bytes_read_addr}")

            if fd not in state.file_sys:
                exit(f"fd ({fd}) not in file_sys, please give more sym files")
            assert state.file_sys[fd]["status"], f"fd ({fd}) is not opened yet, can't be read"
            assert "r" in state.file_sys[fd]["flag"], f"fd ({fd})'s mode is not 'r', can't be read"

            # if there is no input chars
            # just set the num_bytes_read_addr as 0 and return 0 immediately
            if not state.file_sys[fd]["content"]:
                _storeN(state, num_bytes_read_addr, 0, 4)
                # append a 0 as return value, means success
                state.symbolic_stack.append(BitVecVal(0, 32))
                return [state]

            char_read_cnt = 0
            out_chars = []
            for i in range(num_iovs):
                # the buffer where to store data
                buffer_ptr = _loadN(state, data_section, iovs_addr + 8 * i, 4)
                # the buffer capacity
                buffer_len = _loadN(state, data_section,
                                    iovs_addr + (8 * i + 4), 4)
                stdin_length = len(state.file_sys[fd]["content"])

                for j in range(min(stdin_length, buffer_len)):
                    data_to_read = state.file_sys[fd]["content"].pop(0)
                    out_chars.append(data_to_read)
                    char_read_cnt += 1
                    _storeN(state, buffer_ptr + j, data_to_read, 1)

                # if there are more bytes to read, and the buffer is filled
                # update the cursor and move to the next buffer
                if state.file_sys[fd]["content"]:
                    continue
                else:
                    # or the stdin buffer is drained out, break out
                    break

            logging.info(f"\tInput a fd_read string: {out_chars}")
            # set num_bytes_read_addr to bytes_read_cnt
            logging.info(f"\t{char_read_cnt} chars read")
            _storeN(state, num_bytes_read_addr, char_read_cnt, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_write':
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L583
            num_bytes_written_addr, num_iovs, iovs_addr, fd = _extract_params(
                param_str,
                state)
            logging.info(
                f"\tfd_write. fd: {fd}, iovs_addr: {iovs_addr}, num_iovs: {num_iovs}, num_bytes_written_addr: {num_bytes_written_addr}")
            assert fd in state.file_sys, f"fd ({fd}) not in file_sys"
            assert state.file_sys[fd]["status"], f"fd ({fd}) is not opened yet"
            assert 'w' in state.file_sys[fd][
                "flag"], f"fd ({fd}) mode is {state.file_sys[fd]['flag']}, can't be written"

            bytes_written_cnt = 0
            for i in range(num_iovs):
                data_ptr = _loadN(state, data_section, iovs_addr + 8 * i, 4)
                data_len = _loadN(state, data_section,
                                  iovs_addr + (8 * i + 4), 4)

                # data_len could be BitVec
                # if it is, try to concretize it with the current constraints
                if is_bv(data_len):
                    tmp_data_len = BitVec('tmp_data_len', data_len.size())

                    state.solver.add(tmp_data_len == data_len)
                    if sat == state.solver.check():
                        m = state.solver.model()
                        data_len = m[tmp_data_len].as_long()
                    else:
                        raise Exception("the data_len cannot be solved")
                out_str = []
                for j in range(data_len):
                    c = _loadN(state, data_section, data_ptr + j, 1)
                    out_str.append(c)
                state.file_sys[fd]["content"] += out_str

                # logging.info(f"\tOutput a fd_write string: {out_str}")
                bytes_written_cnt += data_len

            _storeN(state, num_bytes_written_addr, bytes_written_cnt, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'proc_exit':
            return_val, = _extract_params(param_str, state)
            logging.info(
                f"\tproc_exit: return_val: {return_val}")

            proc_exit = BitVec('proc_exit', 32)
            state.solver.add(proc_exit == return_val)
            if return_val == 0:
                raise ProcSuccessTermination(return_val)
            else:
                raise ProcFailTermination(return_val)
        elif self.name == 'fd_prestat_get':
            prestat_addr, fd = _extract_params(param_str, state)
            logging.info(
                f"\tfd_prestat_get: fd: {fd}, prestat_addr: {prestat_addr}")

            # we assume there are only two input files, like "demo.wasm a.txt b.txt"
            # if we do not return 8, the loop in `__wasilibc_populate_preopens` will never end
            if fd >= 5:
                state.symbolic_stack.append(BitVecVal(8, 32))
                return [state]

            # the first byte means '__WASI_PREOPENTYPE_DIR', the other three are for align
            _storeN(state, prestat_addr, 0, 4)
            # store the length of file's path in 4 bytes, like 'a.txt' is 5 bytes
            _storeN(state, prestat_addr + 4, 5, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'fd_prestat_dir_name':
            buffer_len, buffer_addr, fd = _extract_params(
                param_str, state)
            logging.info(
                f"\tfd_prestat_dir_name, fd: {fd}, buffer_addr: {buffer_addr}, buffer_len: {buffer_len}")

            # copy the file path into the buffer
            _storeN(
                state, buffer_addr, str_to_little_endian_int('a.txt'),
                buffer_len)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        elif self.name == 'path_open':
            fd_addr, _, _, _, _, _, _, _, dir_fd = _extract_params(
                param_str,
                state)
            logging.info(f"\tpath_open, fd: {dir_fd}")

            _storeN(state, fd_addr, dir_fd, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
        else:
            logging.error(f"{self.name}")
            logging.error(f"{state.symbolic_stack}")
            logging.error(f"{state.symbolic_memory}")
            exit()

        return [state]
