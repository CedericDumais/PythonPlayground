#!/usr/bin/env python3

import sys
import importlib.util

def module_is_available(module_name: str, print_res: bool = False) -> bool:
    """Check if specific module is available

    Args:
        module_name (str): the module to check
        print_res (bool): boolean flag to print the result
    
    Returns:
        (bool): True if module is available, False otherwise
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

def module_is_imported(module_name: str, print_res: bool = False) -> bool:
    """Check if specific module has been imported in this session

    Args:
        module_name (str): the module to check
        print_res (bool): boolean flag to print the result
    
    Returns:
        (bool): True if module is imported, False otherwise
    """
    if module_name in sys.modules:
        if print_res:
            print(f"The module '{module_name}' has been imported.")
        return True
    else:
        if print_res:
            print(f"The module '{module_name}' has not been imported in this session.")
        return False


def main() -> None:
    """Interactive main to verify if module is available and imported in current session
    """
    module_name = input("Enter module name to check: ")
    module_is_available(module_name, True)
    module_is_imported(module_name, True)


if __name__ == "__main__":
    main()    
