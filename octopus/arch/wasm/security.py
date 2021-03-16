import json
import logging
import pkgutil

from octopus.arch.wasm import modules


# logging level
# logging.basicConfig(level=logging.DEBUG)

def engine_start(wasmVM):
    logging.info("-")
    logging.info("--------------------------------------------------")
    logging.info("Starting symbolic execution")
    logging.info("--------------------------------------------------")

    sym_exe = wasmVM.emulate_functions(list_functions_name=['apply'])
    return sym_exe


def fire_lasers_by_module_name(wasmVM, sym_exe, index2state, module_name):
    _issues = []
    _modules = []

    for loader, name, is_pkg in pkgutil.walk_packages(modules.__path__):
        _modules.append(loader.find_module(name).load_module(name))

    logging.info("-")
    logging.info("--------------------------------------------------")
    logging.info("Starting analysis of module: " + module_name)
    logging.info("--------------------------------------------------")

    for module in _modules:
        if str(module).find(module_name) == -1:
            continue
        logging.info("Executing " + str(module))
        _issues_per_module = module.execute(wasmVM, sym_exe, index2state)
        if _issues_per_module:
            _issues.extend(_issues_per_module)
        break

    # to avoid some type cannot be json dumped
    for _issue in _issues:
        _issue['constraints'] = [str(i) for i in _issue['constraints']]

        _issue['constraints'] = [c.replace('\n', '') for c in _issue['constraints']]
        _issue['constraints'] = [c.replace(' ', '') for c in _issue['constraints']]

    return json.dumps(_issues)


def fire_quick_check_by_module_name(keys, constraints, module_name):
    _issues = []
    _modules = []

    for loader, name, is_pkg in pkgutil.walk_packages(modules.__path__):
        _modules.append(loader.find_module(name).load_module(name))

    logging.debug("-")
    logging.debug("--------------------------------------------------")
    logging.debug("Starting quick check of module: " + module_name)
    logging.debug("--------------------------------------------------")

    for module in _modules:
        if str(module).find(module_name) == -1:
            continue
        logging.debug("Executing " + str(module))
        # if keys:
        _issues_per_module = module.quick_check(keys, constraints)
        if _issues_per_module:
            _issues.extend(_issues_per_module)
        # else:
        #     continue
        break

    # to avoid some type cannot be json dumped
    for _issue in _issues:
        _issue['constraints'] = [str(i) for i in _issue['constraints']]

        _issue['constraints'] = [c.replace('\n', '') for c in _issue['constraints']]
        _issue['constraints'] = [c.replace(' ', '') for c in _issue['constraints']]

    return json.dumps(_issues)
