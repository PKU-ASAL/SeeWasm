# This file defines our own exceptions
INVALIDMEMORY = -2
ASSERT_FAIL = -3


class UnsupportZ3TypeError(Exception):
    """
    used in `utils.py`
    indicating that the variable type is not in ['i32', 'i64', 'f32', 'f64']
    """
    pass


class UninitializedLocalVariableError(Exception):
    """
    used in `emulator.py`
    indicating the local variable is not initialized before retriving
    """
    pass


class UnsupportGlobalTypeError(Exception):
    """
    used in `emulator.py`
    indicating the unsupport global type encoutering global.get
    """
    pass


class UnsupportInstructionError(Exception):
    """
    used in `emulator.py`
    indicating the unsupport instructions
    """
    pass


class NotDeterminedRetValError(Exception):
    """
    indicateing the return value is bool but cannot be determined as True or False
    """
    pass


class UninitializedStateError(Exception):
    """
    indicateing the state is not initialized before emulate_one_function
    """
    pass


class MemoryLoadError(Exception):
    """
    indicating the memory load error
    """
    pass


class UnsupportExternalFuncError(Exception):
    """
    indicating the library function is not emulated by us
    """
    pass


class UnexpectedDataType(Exception):
    """
    Typically raised if there is a `if-elif-else` statement
    depending on the data type
    """
    pass


class ProcSuccessTermination(Exception):
    """
    Indicate the process is successfully terminated
    """

    def __init__(self, value):
        self.value = value

    # __str__ is to print() the value
    def __str__(self):
        return (repr(self.value))


class ProcFailTermination(Exception):
    """
    Indicate the process is failedly terminated
    """

    def __init__(self, value):
        self.value = value

    # __str__ is to print() the value
    def __str__(self):
        return (repr(self.value))

class HaltTermination(Exception):
    def __init__(self):
        pass
