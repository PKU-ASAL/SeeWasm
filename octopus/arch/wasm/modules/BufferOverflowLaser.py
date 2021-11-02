# Implement an buffer overflow detector

from z3 import *
import logging

from octopus.arch.wasm.utils import bcolors
from octopus.arch.wasm.dawrf_parser import decode_var_type, decode_vararg, get_func_index_from_state, get_source_location


class BufferOverflowLaser:
    def __init__(self):
        pass

    def fire(self, analyzer, state, dest, the_string, the_string_len):
        buffer_overflowed = False

        # the destination's type (should be array) and its corresponding size
        _, var_size = decode_var_type(analyzer, state, dest)

        if the_string_len > var_size:
            logging.warning(
                f"{bcolors.WARNING}The string '{the_string}' may result in buffer overflow due to unlimited copy and write{bcolors.ENDC}")
            buffer_overflowed = True

        if buffer_overflowed:
            func_ind = get_func_index_from_state(analyzer, state)
            func_offset = state.instr.offset
            original_file, line_no, col_no = get_source_location(
                analyzer, func_ind, func_offset)
            logging.warning(
                f'{bcolors.WARNING}Buffer overflowed! In file {original_file}, line no: {line_no}, col no: {col_no}{bcolors.ENDC}')
