# Implement an buffer overflow detector

from z3 import *
import logging

from octopus.arch.wasm.utils import bcolors
from octopus.arch.wasm.dawrf_parser import decode_var_type, decode_vararg


class BufferOverflowLaser:
    def __init__(self):
        pass

    def fire(self, analyzer, state, dest, the_string, the_string_len):
        # the destination's type (should be array) and its corresponding size
        _, var_size = decode_var_type(analyzer, state, dest)

        if the_string_len > var_size:
            logging.warning(
                f"{bcolors.WARNING}The string '{the_string}' may result in buffer overflow due to unlimited copy and write{bcolors.ENDC}")
