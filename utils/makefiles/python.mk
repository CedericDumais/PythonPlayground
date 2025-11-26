# utils/makefiles/python.mk

# TODO:
# add script targets for new .py creation with template, 
# 	also check and add shebangs in specified dir(s)
# 
# 
# ---- Python dependency list
# $(PYTHON) # pytest
# 
# # Python package builder: build
# # python3 -m pip install --upgrade build
# 
# 

# ==============================
##@ 🐍 Python
# ==============================
ifndef __PYTHON_MK__
__PYTHON_MK__ := 1

# Build Configuration
PYTHON			?= python3
VENV			?= .venv
VENV_BIN		?= $(VENV)/bin
PIP				?= $(VENV_BIN)/pip
PYTHON_IN_VENV	?= $(VENV_BIN)/python

REQUIREMENTS	?= requirements.txt

# Entry point of the project (change if needed)
MAIN			?= main.py

# *!! TODO: implement tests with pytest
TEST_DIR		?= tests

# Enable/disable venv usage (USE_VENV=0 uses system python/pip)
USE_VENV ?= 1

# Pretty log context
PY_CTX := $(if $(strip $(NAME)),$(NAME),Python)

# Tool selection based on venv usage
ifeq ($(USE_VENV),1)
  PY		:= $(PYTHON_IN_VENV)
  PIP_CMD	:= $(PIP)
else
  PY		:= $(PYTHON)
  PIP_CMD	:= pip
endif

# ==============================
# Cleanup Configuration
# ==============================

# The 'find' root (restrict if we want to limit it: e.g., PY_CLEAN_ROOT=code)
PY_CLEAN_ROOT	?= .

# Simple (non-recursive) artifacts and caches (handled by 'CLEANUP' macro)
PY_CLEAN_CACHES	?= \
	.pytest_cache \
	.mypy_cache \
	.coverage \
	tmlcov

# Build/package artifacts
PY_BUILD_ARTIFACTS	?= \
	build \
	dist \
	*.egg-info

# Extras for 'ffclean' target
PY_EXTRA_ARTIFACTS	?= \
	logs \
	.cache

# Recursive junk (handled by 'find')
PY_CLEAN_FIND_FILES	?= "*.pyc" "*.pyo"
PY_CLEAN_FIND_DIRS	?= __pycache__


# ==============================
# Python Utility Macros
# ==============================

# Macro: PY_REQUIRE_VENV
# Prevents confusing failures when someone runs commands 
# without creating the venv
# 
# To use at the top of targets that assume .venv exists:
# run:
# 	$(call PY_REQUIRE_VENV)
# 	$(call INFO,$(PY_CTX),Launching Python shell...)
# 	$(PY)
# 
define PY_REQUIRE_VENV
	if [ "$(USE_VENV)" = "1" ] && [ ! -d "$(VENV)" ]; then \
		$(call ERROR,$(PY_CTX),Virtualenv not found. Run: make venv); \
		exit 1; \
	fi
endef

# ==============================
# Targets
# ==============================
.PHONY: venv py-shell py-install py-test

venv: ## Create virtualenv if it does not exist (USE_VENV=0 to skip)
ifeq ($(USE_VENV),1)
	@test -d $(VENV) || ( \
		$(call INFO,$(PY_CTX),Creating virtualenv in $(VENV)...); \
		$(PYTHON) -m venv $(VENV); \
		$(call SUCCESS,$(PY_CTX),Virtualenv ready.) \
	)
else
	@$(call WARNING,$(PY_CTX),USE_VENV=0: skipping virtualenv setup.)
endif

py-shell: py-venv ## Open a Python REPL
	@$(call PY_REQUIRE_VENV)
	@$(call INFO,$(PY_CTX),Launching Python shell...)
	@$(PY)

py-install: py-venv ## Install dependencies from REQUIREMENTS (REQUIREMENTS=... to override)
	@$(call INFO,$(PY_CTX),Upgrading pip...)
	@$(PIP_CMD) install --upgrade pip
	@if [ -f "$(REQUIREMENTS)" ]; then \
		$(call INFO,$(PY_CTX),Installing deps from $(REQUIREMENTS)...); \
		$(PIP_CMD) install -r $(REQUIREMENTS); \
		$(call SUCCESS,$(PY_CTX),Dependencies installed.); \
	else \
		$(call WARNING,$(PY_CTX),No requirements file found at '$(REQUIREMENTS)'.); \
	fi

py-test: py-venv ## Run tests (pytest by default for now...)
	@if [ -d "$(TEST_DIR)" ]; then \
		$(call INFO,$(PY_CTX),Running tests in $(TEST_DIR)...); \
		$(call TRY_CMD,$(PY_CTX),pytest,$(PY) -m pytest "$(TEST_DIR)"); \
	else \
		$(call WARNING,$(PY_CTX),No '$(TEST_DIR)' directory found. Skipping tests.); \
	fi

# ==============================
# 🧹 Python Cleanup
# ==============================
.PHONY: py-clean-cache py-clean-bytecode py-clean-build py-clean-venv

py-clean-cache: ## Remove tool caches & reports (pytest/mypy/coverage)
# 	@$(call INFO,$(PY_CTX),Cleaning Python caches...)
	@$(call CLEANUP,$(PY_CTX),tool caches,$(PY_CLEAN_CACHES))
# 	@$(call SILENT_CLEANUP,$(PY_CTX),tool caches,$(PY_CLEAN_CACHES))

py-clean-bytecode: ## Remove Python bytecode and __pycache__ (recursive)
# 	@$(call INFO,$(PY_CTX),Cleaning bytecode and __pycache__...)
	@$(call FIND_DELETE_FILES,$(PY_CLEAN_ROOT),$(PY_CLEAN_FIND_FILES))
	@$(call FIND_DELETE_DIRS,$(PY_CLEAN_ROOT),$(PY_CLEAN_FIND_DIRS))

py-clean-build: ## Remove Python build artifacts (build/dist/*.egg-info)
	@$(call CLEANUP,$(PY_CTX),build artifacts,$(PY_BUILD_ARTIFACTS))
# 	@$(call SILENT_CLEANUP,$(PY_CTX),build artifacts,$(PY_BUILD_ARTIFACTS))

py-clean-venv: ## Remove the virtual environment folder
# 	@$(call INFO,$(PY_CTX),Cleaning virtualenv)
	@$(call CLEANUP,$(PY_CTX),virtualenv,$(VENV))
# 	@$(call SILENT_CLEANUP,$(PY_CTX),virtualenv,$(VENV))

endif # __PYTHON_MK__
