#!/usr/bin/env python3

import sys
import importlib.util

def module_is_available(module_name: str, print_res: bool = False) -> bool:
    """
    """
    spec = importlib.util.find_spec(module_name)
    if spec is not None:
        if print_res:
            print(f"The module '{module_name}' is available.")
        return True
    else:
        if print_res:
            print(f"The module '{module_name}' is not available.")
        return False


module_name = input("Enter module name to check: ")
module_is_available(module_name, True)

if module_name in sys.modules:
    print(f"The module '{module_name}' has been imported.")
else:
    print(f"The module '{module_name}' has not been imported in this session.")
