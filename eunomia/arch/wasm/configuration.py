from enum import Enum

from z3 import BitVec


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
    _concrete_globals = False   # init the global with the declaration in global sections
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
    def set_files_buffer(stdin, sym_stdin, sym_files):
        """
        the sym files take two arguments:
        the first is how many files will be opened;
        the second is how many btyes are in each of them.

        So, we store these two information in two separate table

        Also, the stdin is given concretely, like "123"; but the sym_stdin is given with designated length, like [3]
        """
        if stdin:
            Configuration._fd_table['stdin'] = 0
            # the replace is neccessary
            Configuration._content_table[0] = stdin.encode().replace(
                b'\\n', b'\n')

        if sym_stdin:
            length = sym_stdin[0]
            Configuration._fd_table['stdin'] = 0
            Configuration._content_table[0] = BitVec("sym_stdin", 8 * length)

        if sym_files:
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
        for file, fd in Configuration._fd_table.items():
            yield file, fd
        # assert file_name in Configuration._fd_table, f"{file_name} is not maintained in the fd table"
        # return Configuration._fd_table.get(file_name)

    @staticmethod
    def get_content(fd):
        assert fd in Configuration._content_table, f"fd {fd} is not maintained in the content table"
        return Configuration._content_table.get(fd)

    @staticmethod
    def get_visualize():
        return Configuration._visualize_flag

    @staticmethod
    def set_visualize(visualize_flag):
        Configuration._visualize_flag = visualize_flag
