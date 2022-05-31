# These functions are imported from WASI
# we will emulate their behaviors

import logging
from datetime import datetime

from eunomia.arch.wasm.configuration import Configuration
from eunomia.arch.wasm.lib.utils import _extract_params, _loadN, _storeN
from eunomia.arch.wasm.solver import SMTSolver
from eunomia.arch.wasm.utils import getConcreteBitVec, str_to_little_endian_int
from z3 import (BitVec, BitVecVal, Concat, Extract, is_bv, sat, simplify)


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

            # insert the `argc` into the corresponding addr
            argc = len(state.args)

            _storeN(state, argc_addr, argc, 4)
            # the length of `argv` into the corresponding addr
            # the `+ 1` is defined in the source code
            argv_len = 0
            for arg_i in state.args:
                if isinstance(arg_i, str):
                    argv_len += len(arg_i) + 1
                elif is_bv(arg_i):
                    argv_len += arg_i.size() // 8 + 1
            _storeN(state, arg_buf_size_addr, argv_len, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'args_get':
            # this is not the complete version
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIArgsEnvs.cpp
            arg_buf_addr, argv_addr = _extract_params(param_str, state)

            # emulate the official implementation
            args = state.args
            next_arg_buf_addr = arg_buf_addr
            for arg_index in range(len(args)):
                arg = args[arg_index]

                if isinstance(arg, str):
                    num_arg_bytes = len(arg) + 1
                    # insert the arg
                    _storeN(
                        state, next_arg_buf_addr,
                        str_to_little_endian_int(arg),
                        num_arg_bytes)

                elif is_bv(arg):
                    num_arg_bytes = arg.size() // 8 + 1
                    # insert the arg
                    _storeN(state, next_arg_buf_addr, simplify(
                        Concat(BitVecVal(0, 8), arg)), num_arg_bytes)

                # insert the next_arg_buf_addr
                _storeN(state, argv_addr + 4 * arg_index,
                        next_arg_buf_addr, 4)
                # update the next_arg_buf_addr
                next_arg_buf_addr += num_arg_bytes

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'environ_sizes_get':
            env_buf_size_addr, env_count_addr = _extract_params(
                param_str, state)

            _storeN(state, env_count_addr, 0, 4)
            _storeN(state, env_buf_size_addr, 0, 4)

            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_advise':
            # ref: https://man7.org/linux/man-pages/man2/posix_fadvise.2.html
            advice, length, offset, fd = _extract_params(param_str, state)
            logging.info(
                f"Encounter fd_advise, fd: {fd}, offset: {offset}, length: {length}, advice: {advice}")

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_fdstat_get':
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L717
            fd_stat_addr, fd = _extract_params(param_str, state)
            # fs_filetype is 1 byte, possible 0-7
            # fs_filetype = BitVec(
            #     f'fs_filetype_{datetime.timestamp(datetime.now()):.0f}', 8)
            # TODO we temporarily to concretize the fs_filetype as 1, i.e., __WASI_FILETYPE_CHARACTER_DEVICE
            fs_filetype = 2
            _storeN(state, fd_stat_addr, fs_filetype, 1)
            # TODO the fs_filetype could be 0-7, jump over temporarily
            # state.constraints.append(
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
            # state.constraints.append(
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

            logging.info(
                f"Encounter fd_fdstat_get, fd: {fd}, fd_stat_addr: {fd_stat_addr}")

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_tell':
            # TODO, do not precisely emulate this function, just insert 0 temporarily
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L695
            offset_addr, fd = _extract_params(param_str, state)
            fd_tell_var = BitVec(
                f"fd_tell_{datetime.timestamp(datetime.now()):.0f}", 32)
            _storeN(state, offset_addr, fd_tell_var, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_seek':
            # TODO, similar to fd_tell, do not precisely emulate this function
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L657
            new_offset_addr, whence, offset, fd = _extract_params(
                param_str, state)
            fd_seek_var = BitVec(
                f"fd_seek_{datetime.timestamp(datetime.now()):.0f}", 32)
            _storeN(state, new_offset_addr, fd_seek_var, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_close':
            # I did not emulate the fdMap, just return the success flag here
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L322
            fd, = _extract_params(param_str, state)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_read':
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L554
            num_bytes_read_addr, num_iovs, iovs_addr, fd = _extract_params(
                param_str,
                state)

            # if there is no stdin chars
            # just set the num_bytes_read_addr as 0 and return 0 immediately
            if (isinstance(state.stdin_buffer, str) and not state.stdin_buffer) or (is_bv(state.stdin_buffer) and state.stdin_buffer.size() < 8):
                _storeN(state, num_bytes_read_addr, 0, 4)
                # append a 0 as return value, means success
                state.symbolic_stack.append(BitVecVal(0, 32))
                return

            logging.info(
                f"fd_read. fd: {fd}, iovs_addr: {iovs_addr}, num_iovs: {num_iovs}, num_bytes_read_addr: {num_bytes_read_addr}")
            # assert fd == 0, 'only support stdin now'

            char_read_cnt = 0
            out_chars = []
            for i in range(num_iovs):
                # the buffer where to store data
                buffer_ptr = _loadN(state, data_section, iovs_addr + 8 * i, 4)
                # the buffer capacity
                buffer_len = _loadN(state, data_section,
                                    iovs_addr + (8 * i + 4), 4)

                assert isinstance(state.stdin_buffer, str) ^ is_bv(
                    state.stdin_buffer), "The stdin type is wrong, please recheck"
                if isinstance(state.stdin_buffer, str):
                    stdin_length = len(state.stdin_buffer)
                else:
                    stdin_length = state.stdin_buffer.size() // 8

                for j in range(min(stdin_length, buffer_len)):
                    if isinstance(state.stdin_buffer, str):
                        data_to_read = state.stdin_buffer[0]
                        state.stdin_buffer = state.stdin_buffer[1:]
                    else:
                        data_to_read = simplify(Extract(8 * (stdin_length - char_read_cnt) - 1, 8 * (
                            stdin_length - char_read_cnt) - 8, state.stdin_buffer))
                        if (stdin_length - char_read_cnt) == 1:
                            state.stdin_buffer = BitVec('dummy', 1)
                        else:
                            state.stdin_buffer = simplify(
                                Extract(
                                    8 * (stdin_length - char_read_cnt) - 9, 0,
                                    state.stdin_buffer))

                    out_chars.append(data_to_read)
                    char_read_cnt += 1
                    if isinstance(state.stdin_buffer, str):
                        _storeN(
                            state, buffer_ptr + j,
                            str_to_little_endian_int(data_to_read),
                            len(data_to_read))
                    else:
                        _storeN(state, buffer_ptr + j, data_to_read, 1)

                # if there are more bytes to read, and the buffer is filled
                # update the cursor and move to the next buffer
                if (isinstance(state.stdin_buffer, str) and len(state.stdin_buffer) > 0) or (is_bv(state.stdin_buffer) and state.stdin_buffer.size() > 1):
                    continue
                else:
                    # or the stdin buffer is drained out, break out
                    break
            all_char = True
            for ele in out_chars:
                if not isinstance(ele, str):
                    all_char = False
                    break
            if all_char:
                out_chars = [ele.encode() for ele in out_chars]
                logging.info(
                    f"================Input a fd_read string: {b''.join(out_chars)}=================")
            else:
                logging.info(
                    f"================Input a fd_read string: {out_chars}=================")
            # set num_bytes_read_addr to bytes_read_cnt
            logging.info(f"{char_read_cnt} chars read.")
            _storeN(state, num_bytes_read_addr, char_read_cnt, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_write':
            # ref: https://github.com/WebAssembly/wasm-jit-prototype/blob/65ca25f8e6578ffc3bcf09c10c80af4f1ba443b2/Lib/WASI/WASIFile.cpp#L583
            num_bytes_written_addr, num_iovs, iovs_addr, fd = _extract_params(
                param_str,
                state)

            logging.info(
                f"fd_write. fd: {fd}, iovs_addr: {iovs_addr}, num_iovs: {num_iovs}, num_bytes_written_addr: {num_bytes_written_addr}")

            if fd == 2:
                logging.info(f"fd_write to stderr")
            elif fd == 1:
                logging.info(f"fd_write to stdout")

            bytes_written_cnt = 0
            for i in range(num_iovs):
                data_ptr = _loadN(state, data_section, iovs_addr + 8 * i, 4)
                data_len = _loadN(state, data_section,
                                  iovs_addr + (8 * i + 4), 4)

                # data_len could be BitVec
                # if it is, try to concretize it with the current constraints
                if is_bv(data_len):
                    s = SMTSolver(Configuration.get_solver())
                    s += state.constraints
                    tmp_data_len = BitVec('tmp_data_len', data_len.size())
                    s.add(tmp_data_len == data_len)
                    if sat == s.check():
                        m = s.model()
                        data_len = m[tmp_data_len].as_long()
                    else:
                        raise Exception("the data_len cannot be solved")
                out_str = []
                for j in range(data_len):
                    c = _loadN(state, data_section, data_ptr + j, 1)
                    if isinstance(c, int):
                        c = chr(c)
                    elif is_bv(c):
                        c = c
                    else:
                        raise Exception(
                            f"The loaded char: {c} is with type: {type(c)}")
                    out_str.append(c)

                if fd == 1:
                    state.stdout_buffer += out_str
                elif fd == 2:
                    state.stderr_buffer += out_str

                all_char = True
                for ele in out_str:
                    if not isinstance(ele, str):
                        all_char = False
                        break
                if all_char:
                    out_str = [ele.encode() for ele in out_str]
                    logging.info(
                        f"================Output a fd_write string: {b''.join(out_str)}=================")
                else:
                    logging.info(
                        f"================Output a fd_write string: {out_str}=================")
                bytes_written_cnt += data_len

            _storeN(state, num_bytes_written_addr, bytes_written_cnt, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'proc_exit':
            return_val, = _extract_params(param_str, state)

            proc_exit = BitVec('proc_exit', 32)
            state.constraints.append(proc_exit == return_val)
            return
            # if return_val == 0:
            #     raise ProcSuccessTermination(return_val)
            # else:
            #     raise ProcFailTermination(return_val)
        elif self.name == 'fd_prestat_get':
            prestat_addr, fd = _extract_params(param_str, state)

            # we assume there are only two input files, like "demo.wasm a.txt b.txt"
            # if we do not return 8, the loop in `__wasilibc_populate_preopens` will never end
            if fd >= 5:
                state.symbolic_stack.append(BitVecVal(8, 32))
                return

            logging.info(
                f"Encounter fd_prestat_get, fd: {fd}, prestat_addr: {prestat_addr}")
            # the first byte means '__WASI_PREOPENTYPE_DIR', the other three are for align
            _storeN(state, prestat_addr, 0, 4)
            # store the length of file's path in 4 bytes, like 'a.txt' is 5 bytes
            _storeN(state, prestat_addr + 4, 5, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'fd_prestat_dir_name':
            buffer_len, buffer_addr, fd = _extract_params(
                param_str, state)
            logging.info(
                f"Encounter fd_prestat_dir_name, fd: {fd}, buffer_addr: {buffer_addr}, buffer_len: {buffer_len}")

            # copy the file path into the buffer
            _storeN(
                state, buffer_addr, str_to_little_endian_int('a.txt'),
                buffer_len)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        elif self.name == 'path_open':
            fd_addr, _, _, _, _, _, _, _, dir_fd = _extract_params(
                param_str,
                state)
            logging.info(f"Encounter path_open, fd: {dir_fd}")

            _storeN(state, fd_addr, dir_fd, 4)

            # append a 0 as return value, means success
            state.symbolic_stack.append(BitVecVal(0, 32))
            return
        else:
            logging.error(f"{self.name}")
            logging.error(f"{state.symbolic_stack}")
            logging.error(f"{state.symbolic_memory}")
            exit()

        if return_str:
            tmp_bitvec = getConcreteBitVec(
                return_str,
                f'{self.name}_ret_{return_str}_{self.cur_func}_{str(state.instr.offset)}')
            state.symbolic_stack.append(tmp_bitvec)
