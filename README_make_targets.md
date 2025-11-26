
# 📘 Makefile Targets


## 🛠  Utility
- `help`:  Display available targets
- `repo`:  Open the GitHub repository

## 🎯 Main Targets
- `all`:  Prepares the project (env + deps + tests)
- `run`:  Run the project (MAIN=... to override)
- `prompt`:  Prompt to choose an executable from the 'EXEC_FILES' list, chmod +x, then run it

## 🧹 Cleanup
- `clean`:  Remove compiled Python junk and tool caches
- `fclean`:  clean + remove build artifacts and venv
- `ffclean`:  Remove all generated files and folders
- `re`:  Rebuild everything

## 💾 Backup
- `backup`:  Prompt and create a .zip or .tar.gz backup of the project

## 📦 Dependency setup
- `deps`:  Initialize/check all dependencies
- `deps-status`:  Print a quick overview of dependency state
- `deps-clean`:  Remove dependency sentinel markers (does not remove submodules/libs)
- `deps-sys`:  Verify required system packages (fatal if DEPS_FAIL_ON_MISSING=1)
- `deps-sys-check`:  Show which required system packages are present
- `deps-submodules`:  Initialize and update all git submodules (idempotent)
- `deps-submodules-update`:  Update submodules to their tracked commit/branch
- `deps-submodules-clean`:  Forget we've initialized submodules (so next deps re-inits)

## 📚 Documentation
- `doc`:  Show documentation links
- `help-md`:  Generate markdown documentation for all Make targets

## 📜 Scripts
- `new-script`:  Create a new script from the template
- `script`:  Interactive script selection menu
- `script-edit`:  Interactive: choose a script, then pick an editor (default: EDITOR or $(OPEN))
- `script-clean`:  Clean up test artifacts and logs
- `list-scripts`:  List available scripts
- `script-make-exec`:  Make all scripts in SCRIPT_DIR executable
- `script-make-exec-silent`:  Run script-make-exec but suppress all output

## 🌳 File Structure
- `tree`:  Show file structure (without file listed in TREE_IGNORES)
- `tree-log`:  Logs file structure in TREE_OUTFILE
- `tree-clean`:  Remove 'tree' outfile

## 🐍 Python
- `py-shell`:  Open a Python REPL
- `py-venv`:  Create virtualenv if it does not exist (USE_VENV=0 to skip)
- `py-install`:  Install dependencies from REQUIREMENTS (REQUIREMENTS=... to override)
- `py-test`:  Run tests (pytest by default for now...)
- `py-clean-cache`:  Remove tool caches & reports (pytest/mypy/coverage)
- `py-clean-bytecode`:  Remove Python bytecode and __pycache__ (recursive)
- `py-clean-build`:  Remove Python build artifacts (build/dist/*.egg-info)
- `py-clean-venv`:  Remove the virtual environment folder

📄 Generated at Wed 26 Nov 2025 12:08:20 AM EST
