from eunomia.arch.wasm.utils import Enable_Lasers
from z3 import BitVec


class Configuration:
    """
    The static class that maintain the user's input option
    """
    _user_asked_lasers = 0
    _source_type = 'c'  # the original source file's type, currently 'c' or 'go'
    _algo = 'dfs'       # the traverse algorithm, default is dfs, we also have 'interval'
    _concrete_globals = False   # init the global with the declaration in global sections
    _verbose_flag = 'warning'    # if user set -v flag, the debugging info would be printed
    # the backend SMT solver, may integrate our lab's own backend in the future
    _solver = 'z3'
    # the stdin buffer
    _stdin_buffer = b''
    # the command to run the to be analyzed program, like ['base64', a]
    # where 'a' is a symbol
    _args = []
    # the to-be-analyzed file's path and name
    _file_path = ''
    _file_name = ''
    # the start time of analyze
    _start_time = ''
    # the entry function
    _entry_func = ''
    # the mapping of func index to func name
    _func_index_to_func_name = None
    # if enable the instruction-level coverage calculation
    _coverage = False
    # the file name with its fd
    _fd_table = dict()
    # the fd with its file content, represented in BitVec
    _content_table = dict()

    @staticmethod
    def set_lasers(overflow, divzero, buffer):
        if overflow:
            Configuration._user_asked_lasers ^= Enable_Lasers.OVERFLOW.value
        if divzero:
            Configuration._user_asked_lasers ^= Enable_Lasers.DIVZERO.value
        if buffer:
            Configuration._user_asked_lasers ^= Enable_Lasers.BUFFER.value

    @staticmethod
    def get_lasers():
        return Configuration._user_asked_lasers

    @staticmethod
    def set_source_type(source_type):
        Configuration._source_type = source_type

    @staticmethod
    def get_source_type():
        return Configuration._source_type

    @staticmethod
    def set_algo(algo):
        Configuration._algo = algo

    @staticmethod
    def get_algo():
        return Configuration._algo

    @staticmethod
    def set_concrete_globals(concrete_globals):
        Configuration._concrete_globals = concrete_globals

    @staticmethod
    def get_concrete_globals():
        return Configuration._concrete_globals

    @staticmethod
    def set_verbose_flag(verbose_flag):
        Configuration._verbose_flag = verbose_flag

    @staticmethod
    def get_verbose_flag():
        return Configuration._verbose_flag

    @staticmethod
    def get_solver():
        return Configuration._solver

    @staticmethod
    def set_solver(solver):
        Configuration._solver = solver

    @staticmethod
    def get_stdin_buffer():
        return Configuration._stdin_buffer

    @staticmethod
    def set_stdin_buffer(stdin_buffer):
        """
        The `stdin_buffer` can by two types:
        1. str: the stdin is given concretely, like "123"
        2. [int]: the stdin is given with designated length, like [3]
        """
        if isinstance(stdin_buffer, str):
            # the replace is neccessary
            Configuration._stdin_buffer = stdin_buffer.encode().replace(b'\\n', b'\n')
        elif isinstance(stdin_buffer, list):
            length = stdin_buffer[0]
            Configuration._stdin_buffer = BitVec("sym_stdin", 8 * length)

    @staticmethod
    def get_args():
        return Configuration._args

    @staticmethod
    def set_args(filename, args, sym_args):
        """
        Parse the given args and symbolic args into the _args

        args: str: typically is the argv[0] and is given concretely, like "base64"
        sym_args: [int, ...]: each symbolic arg is given with designated length, like [1, 2]
        """
        # the filename is argv[0]
        Configuration._args += [filename]

        if args:
            Configuration._args += args.split(" ")

        if sym_args:
            for i, sym_len in enumerate(sym_args):
                Configuration._args.append(
                    BitVec(f"sym_args_{i + 1}", 8 * sym_len))

    @staticmethod
    def get_file_name():
        return Configuration._file_name

    @staticmethod
    def get_file_path():
        return Configuration._file_path

    @staticmethod
    def set_file(file_path):
        Configuration._file_path = file_path
        # keep the file name without path and extended type
        Configuration._file_name = file_path.split('/')[-1].split('.')[0]

    @staticmethod
    def get_start_time():
        return Configuration._start_time

    @staticmethod
    def set_start_time(start_time):
        Configuration._start_time = start_time

    @staticmethod
    def get_entry():
        return Configuration._entry_func

    @staticmethod
    def set_entry(entry_func):
        Configuration._entry_func = entry_func[0]

    @staticmethod
    def get_func_index_to_func_name():
        return Configuration._func_index_to_func_name

    @staticmethod
    def set_func_index_to_func_name(func_index_to_func_name):
        Configuration._func_index_to_func_name = func_index_to_func_name

    @staticmethod
    def get_coverage():
        return Configuration._coverage

    @staticmethod
    def set_coverage(coverage):
        Configuration._coverage = coverage

    @staticmethod
    def set_sym_files(sym_files):
        """
        the sym files take two arguments:
        the first is how many files will be opened;
        the second is how many btyes are in each of them.

        So, we store these two information in two separate table
        """
        sym_file_num, sym_file_length = sym_files

        # assert sym_file_num is no larger than 26, as we use 'A', 'B' as file names
        assert sym_file_num <= 26, f"The sym_file_num is {sym_file_num}, greater than 26"
        for i in range(sym_file_num):
            Configuration._fd_table[chr(i + 65)] = i + 3

        for k, v in Configuration._fd_table.items():
            Configuration._content_table[v] = BitVec(
                f"file_{k}", sym_file_length * 8)

    @staticmethod
    def get_fd():
        for k, v in Configuration._fd_table.items():
            yield k, v
        # assert file_name in Configuration._fd_table, f"{file_name} is not maintained in the fd table"
        # return Configuration._fd_table.get(file_name)

    @staticmethod
    def get_content(fd):
        assert fd in Configuration._content_table, f"fd {fd} is not maintained in the content table"
        return Configuration._content_table.get(fd)
