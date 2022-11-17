#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import json
import sys
from datetime import datetime
from os import makedirs, path

from eunomia.arch.wasm.configuration import Configuration
from eunomia.arch.wasm.graph import Graph
from eunomia.arch.wasm.visualizator import visualize


def main():
    parser = argparse.ArgumentParser(
        description='Eunomia, a symbolic execution engine for Wasm module')

    inputs = parser.add_argument_group('Input arguments')
    inputs.add_argument('-f', '--file',
                        type=argparse.FileType('rb'),
                        help='binary file (.wasm)',
                        metavar='WASMMODULE', required=True)
    inputs.add_argument(
        '--source_type', default='c', const='c', nargs='?',
        choices=['c', 'go', 'rust'],
        help='type of source file, used by library function emulator')
    inputs.add_argument('--stdin',
                        action='store',
                        type=str,
                        help='The stream of stdin')
    inputs.add_argument('--sym_stdin',
                        action='store',
                        type=int,
                        nargs=1,
                        help='Bytes of stdin')
    inputs.add_argument('--args',
                        action='store',
                        type=str,
                        help='The args that run the to be analyzed program')
    inputs.add_argument(
        '--sym_args', type=int, nargs='+',
        help="Replace the argument by a symbolic argument with length N")
    inputs.add_argument(
        '--sym_files', type=int, nargs=2,
        help="Create multiple symbolic files")

    features = parser.add_argument_group('Features')
    features.add_argument(
        '-v', '--verbose', default='warning', const='warning', nargs='?',
        choices=['warning', 'info', 'debug'],
        help='set the logging level. debug is instruction level, info is function level')
    features.add_argument(
        '--visualize', action='store_true',
        help='visualize the ICFG on basic blocks level')
    features.add_argument(
        '--symbol_globals', action='store_true',
        help='use symbolic globals as the entry functions cannot determine their concrete values')
    features.add_argument(
        '--coverage', action='store_true',
        help='calculate the instruction coverage')
    features.add_argument(
        '--incremental', action='store_true',
        help='enable incremental solving')
    features.add_argument(
        '--dsl', action='store_true',
        help='Indicating the file is instrumented by dsl')

    # vulnerability detector
    lasers = parser.add_argument_group('Lasers')
    lasers.add_argument(
        '--overflow', action='store_true',
        help="fire the integer overflow vulnerability detector")
    lasers.add_argument(
        '--divzero', action='store_true',
        help="fire the div-zero vulnerability detector")
    lasers.add_argument(
        '--buffer', action='store_true',
        help="fire the buffer overflow vulnerability detector")

    analyze = parser.add_argument_group('Analyze')
    analyze = analyze.add_mutually_exclusive_group()
    analyze.add_argument(
        '-s', '--symbolic', action='store_true',
        help='perform the symbolic execution')
    analyze.add_argument(
        '-g', '--cfg', action='store_true',
        help='generate the control flow graph (CFG) (instruction level)')
    analyze.add_argument(
        '-c', '--call', action='store_true',
        help='generate the call flow graph (function level)')

    graph = parser.add_argument_group('Graph options')
    graph.add_argument('--simplify', action='store_true',
                       help='generate a simplify CFG')
    graph.add_argument('--functions', action='store_true',
                       help='create subgraph for each function')
    graph.add_argument(
        '--onlyfunc', type=str, nargs=1, default=["__original_main"],
        help='only generate the CFG for this list of function name')

    args = parser.parse_args()

    octo_bytecode = args.file.read()

    # conduct symbolic execution
    if args.symbolic:
        Configuration.set_verbose_flag(args.verbose)
        Configuration.set_file(args.file.name)
        Configuration.set_entry(args.onlyfunc)
        Configuration.set_coverage(args.coverage)
        Configuration.set_visualize(args.visualize)
        Configuration.set_lasers(args.overflow, args.divzero, args.buffer)
        Configuration.set_source_type(args.source_type)
        Configuration.set_symbol_globals(args.symbol_globals)
        Configuration.set_stdin(args.stdin, args.sym_stdin)
        Configuration.set_sym_files(args.sym_files)
        Configuration.set_incremental_solving(args.incremental)
        Configuration.set_dsl_flag(args.dsl)

        command_file_name = f"./log/result/{Configuration.get_file_name()}_{Configuration.get_start_time()}/command.json"
        makedirs(path.dirname(command_file_name), exist_ok=True)
        with open(command_file_name, 'w') as fp:
            json.dump({"Command": " ".join(sys.argv)}, fp, indent=4)

        # --args and --sym_args can exist simultaneously
        # their order are fixed, i.e., --args is in front of --sym_args
        # the file_name is always the argv[0]
        Configuration.set_args(
            Configuration.get_file_name(),
            args.args, args.sym_args)

        # import necessary part
        from eunomia.arch.wasm.emulator import WasmSSAEmulatorEngine

        wasmVM = WasmSSAEmulatorEngine(octo_bytecode)
        # run the emulator for SSA
        Graph.wasmVM = wasmVM
        Graph.initialize()
        # draw the ICFG on basic block level, and exit
        if Configuration.get_visualize():
            # draw here
            visualize(Graph)

            print(f"The visualization of ICFG is done.")
            return
        graph = Graph()
        graph.traverse()
    # Visualize CFG or Call Graph
    elif args.cfg or args.call:
        from eunomia.analysis.graph import CFGGraph
        from eunomia.arch.wasm.cfg import WasmCFG

        octo_cfg = WasmCFG(octo_bytecode)

        if args.call:
            octo_cfg.visualize_call_flow()

        if args.cfg:
            octo_graph = CFGGraph(octo_cfg)
            if args.functions or args.onlyfunc:
                octo_graph.view_functions(only_func_name=args.onlyfunc,
                                          simplify=args.simplify
                                          )
            else:
                octo_graph.view(simplify=args.simplify)
    else:
        parser.print_help()


if __name__ == '__main__':
    job_start_time = datetime.now()
    current_time_start = job_start_time.strftime("%Y-%m-%d %H:%M:%S")
    print(f"Start to analyze: {current_time_start}", flush=True)
    Configuration.set_start_time(current_time_start)

    print(f"Running...", flush=True)
    main()
    print(f"Finished.", flush=True)

    job_end_time = datetime.now()
    current_time_end = job_end_time.strftime("%Y-%m-%d %H:%M:%S")
    print(f"End of analyze: {current_time_end}", flush=True)
    elapsed_time = job_end_time - job_start_time
    print(f"Time elapsed: {elapsed_time}", flush=True)
