from enum import Enum

from z3 import BitVec, Extract


class Enable_Lasers(Enum):
    OVERFLOW = 1
    DIVZERO = 2
    BUFFER = 4
    ANOTHER = 8


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'


class Configuration:
    """
    The static class that maintain the user's input option
    """
    _user_asked_lasers = 0
    _source_type = 'c'  # the original source file's type, currently 'c' or 'go'
    _algo = 'interval'       # the traverse algorithm, default is interval
    _symbol_globals = False   # init the global with the declaration in global sections
    _verbose_flag = 'warning'    # if user set -v flag, the debugging info would be printed
    # the backend SMT solver, may integrate our lab's own backend in the future
    _solver = 'z3'
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
    _func_index_to_func_name = {}
    # if enable the instruction-level coverage calculation
    _coverage = False
    # the stdin buffer, can be a list of char or symbols with length of 8 bits
    _stdin_buffer = []
    # how many files can be opened in total
    _sym_file_limit = 0
    # how many bytes a sym file can hold
    _sym_file_byte_limit = 0
    # keep z3 cache
    # each value is a tuple, consisting of query times, sat or not, and solver
    _z3_cache_dict = {}
    # used by args_sizes_get in wasi.py
    _argc_addr = None
    _arg_buf_size_addr = None
    # each element is a list, consisting of argc and size of each argv
    # like (2, 4, 3) means there are 2 args, the first one is in 4 bytes, and the second is in 3 bytes
    _argc_arg_buf_size = []
    # enable the incremental solving or not
    _incremental_solving = False

    @ staticmethod
    def set_lasers(overflow, divzero, buffer):
        if overflow:
            Configuration._user_asked_lasers ^= Enable_Lasers.OVERFLOW.value
        if divzero:
            Configuration._user_asked_lasers ^= Enable_Lasers.DIVZERO.value
        if buffer:
            Configuration._user_asked_lasers ^= Enable_Lasers.BUFFER.value

    @ staticmethod
    def get_lasers():
        return Configuration._user_asked_lasers

    @ staticmethod
    def set_source_type(source_type):
        Configuration._source_type = source_type

    @ staticmethod
    def get_source_type():
        return Configuration._source_type

    @ staticmethod
    def set_algo(algo):
        Configuration._algo = algo

    @ staticmethod
    def get_algo():
        return Configuration._algo

    @ staticmethod
    def set_symbol_globals(symbol_globals):
        Configuration._symbol_globals = symbol_globals

    @ staticmethod
    def get_symbol_globals():
        return Configuration._symbol_globals

    @ staticmethod
    def set_verbose_flag(verbose_flag):
        Configuration._verbose_flag = verbose_flag

    @ staticmethod
    def get_verbose_flag():
        return Configuration._verbose_flag

    @ staticmethod
    def get_solver():
        return Configuration._solver

    @ staticmethod
    def set_solver(solver):
        Configuration._solver = solver

    @ staticmethod
    def get_args():
        return Configuration._args

    @ staticmethod
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
                    BitVec(f"sym_arg_{i + 1}", 8 * sym_len))

    @ staticmethod
    def get_file_name():
        return Configuration._file_name

    @ staticmethod
    def get_file_path():
        return Configuration._file_path

    @ staticmethod
    def set_file(file_path):
        Configuration._file_path = file_path
        # keep the file name without path and extended type
        Configuration._file_name = file_path.split('/')[-1].split('.')[0]

    @ staticmethod
    def get_start_time():
        return Configuration._start_time

    @ staticmethod
    def set_start_time(start_time):
        Configuration._start_time = start_time

    @ staticmethod
    def get_entry():
        return Configuration._entry_func

    @ staticmethod
    def set_entry(entry_func):
        Configuration._entry_func = entry_func[0]

    @ staticmethod
    def get_func_index_to_func_name():
        return Configuration._func_index_to_func_name

    @ staticmethod
    def set_func_index_to_func_name(ana_names, func_prototypes):
        if ana_names:
            # if the wasm has name section
            for item in ana_names:
                index, _, func_name = item
                func_name = func_name.decode()
                if "__imported_wasi_snapshot_preview1_" in func_name:
                    func_name = func_name[34:]
                Configuration._func_index_to_func_name[index] = func_name
        else:
            for index, item in enumerate(func_prototypes):
                func_name = item[0]
                Configuration._func_index_to_func_name[index] = func_name

    @ staticmethod
    def get_coverage():
        return Configuration._coverage

    @ staticmethod
    def set_coverage(coverage):
        Configuration._coverage = coverage

    @ staticmethod
    def set_stdin(stdin, sym_stdin):
        """
        Store stdin buffer into the `stdin_buffer`
        """
        if stdin and sym_stdin:
            exit("Cannot set `stdin` and `sym_stdin` simultaneously")

        if stdin:
            # the encode is necessary
            stdin_encoded = stdin.encode().replace(b'\\n', b'\n')
            Configuration._stdin_buffer = list(stdin_encoded)
        elif sym_stdin:
            sym_stdin_len = sym_stdin[0]
            raw_symbol = BitVec('sym_stdin', sym_stdin_len * 8)
            # split by chars
            for i in range(sym_stdin_len, 0, -1):
                Configuration._stdin_buffer.append(
                    Extract(i * 8 - 1, (i - 1) * 8, raw_symbol))
        else:
            # no stdin is given
            pass

    @ staticmethod
    def get_stdin():
        """
        return the stdin buffer
        """
        return Configuration._stdin_buffer

    @ staticmethod
    def set_sym_files(sym_files):
        """
        the sym files take two arguments:
        the first is how many files will be opened;
        the second is how many btyes are in each of them.

        So, we store these two information
        """
        if not sym_files:
            return
        sym_file_num, sym_file_byte = sym_files
        Configuration._sym_file_limit = sym_file_num
        Configuration._sym_file_byte_limit = sym_file_byte

    @ staticmethod
    def get_sym_file_limits():
        return Configuration._sym_file_limit, Configuration._sym_file_byte_limit

    @ staticmethod
    def get_visualize():
        return Configuration._visualize_flag

    @ staticmethod
    def set_visualize(visualize_flag):
        Configuration._visualize_flag = visualize_flag

    @ staticmethod
    def set_incremental_solving(incremental_solving_flag):
        Configuration._incremental_solving = incremental_solving_flag

    @ staticmethod
    def get_incremental_solving():
        return Configuration._incremental_solving
