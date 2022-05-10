# Implement an buffer overflow detector

import logging

from eunomia.arch.wasm.dwarfParser import (decode_var_type,
                                           get_func_index_from_state,
                                           get_source_location_string)
from eunomia.arch.wasm.utils import bcolors


class BufferOverflowLaser:
    def __init__(self):
        pass

    def fire(self, analyzer, state, dest, the_string, the_string_len):
        buffer_overflowed = False

        # the destination's type (should be array) and its corresponding size
        # TODO better approach than using global stack pointer
        _, var_size = decode_var_type(
            analyzer, state, dest, use_global_sp=True)
        if var_size is None:
            logging.warning(
                f"{bcolors.WARNING}unable to decode variable type for address {hex(dest)}{bcolors.ENDC}")
            return

        if the_string_len > var_size:
            logging.warning(
                f"{bcolors.WARNING}The string '{the_string}' may result in buffer overflow due to unlimited copy and write{bcolors.ENDC}")
            buffer_overflowed = True

        if buffer_overflowed:
            import datetime
            logging.warning(f'Current Time: {datetime.datetime.now()}')
            func_ind = get_func_index_from_state(analyzer, state)
            func_offset = state.instr.offset
            logging.warning(
                f'{bcolors.WARNING}Buffer overflowed! {get_source_location_string(analyzer, func_ind, func_offset)}{bcolors.ENDC}')
