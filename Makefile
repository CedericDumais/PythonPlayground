


# ==============================
# Project Info
# ==============================
NAME		:= PythonPlayground
AUTHOR		:= CedericDumais
REPO_LINK	:= https://github.com/CedericDumais/PythonPlayground

# ==============================
# Build Configuration
# ==============================
PYTHON			?= python3
VENV			?= .venv
PIP				?= $(VENV)/bin/pip
PYTHON_IN_VENV	:= $(VENV)/bin/python
REQUIREMENTS	:= code/games/requirements.txt

# Entry Point
# MAIN	?= code/main.py
MAIN	?= code/games/minecraft-mini.py

# ==============================
# Makefile Imports
# ==============================
MK_PATH		:= utils/makefiles
MK_FILES	:= \
	utils.mk \
	dependencies.mk \
	doc.mk \
	scripts.mk \
	tree.mk

include $(addprefix $(MK_PATH)/, $(MK_FILES))

# ==============================
# Default
# ==============================
.DEFAULT_GOAL	:= help

.DEFAULT:
	$(info make: *** No rule to make target '$(MAKECMDGOALS)'.  Stop.)
	@$(MAKE) help

# ==============================
##@ 🛠  Utility
# ==============================
.PHONY: help repo

help: ## Display available targets
	@echo "\nAvailable targets:"
	@awk 'BEGIN {FS = ":.*##";} \
		/^[a-zA-Z_0-9-]+:.*?##/ { \
			printf "   $(CYAN)%-15s$(RESET) %s\n", $$1, $$2 \
		} \
		/^##@/ { \
			printf "\n$(BOLD)%s$(RESET)\n", substr($$0, 5) \
		}' $(MAKEFILE_LIST)

repo: ## Open the GitHub repository
	@$(call INFO,$(NAME),Opening $(AUTHOR)'s github repo...)
	@$(OPEN) $(REPO_LINK);

# ==============================
##@ 🎯 Main Targets
# ==============================
.PHONY: all run

# all: help
all: venv install test ## Prepares the project (env + deps + optional tests)

run: venv ## Run the project
	$(PYTHON_IN_VENV) $(MAIN)

venv: ## Create virtualenv if it does not exist
	test -d $(VENV) || $(PYTHON) -m venv $(VENV)

install: venv ## Install dependencies from requirements.txt if it exists
	$(PIP) install --upgrade pip
	if [ -f $(REQUIREMENTS) ]; then \
		$(PIP) install -r $(REQUIREMENTS); \
	fi

test: venv ## Run tests (pytest by default for now...)
	$(PYTHON_IN_VENV) -m pytest tests || echo "No tests or pytest failed"

fast: ## Fast build using parallel jobs
	@$(MAKE) MAKEFLAGS="$(MAKEFLAGS) -j$(shell nproc)" all

# ==============================
##@ 🧹 Cleanup
# ==============================
.PHONY: clean fclean ffclean re

clean: ## Remove compiled Python junk and test caches
# 	@$(call CLEANUP,$(NAME),object files,$(OBJ_DIR))
	find . -name "*.py[co]" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} +
	rm -rf .pytest_cache .mypy_cache .coverage htmlcov
# Removes Python "object-like" files:
# __pycache__, *.pyc, *.pyo
# Test and tool caches like .pytest_cache, .mypy_cache.

fclean: clean ## clean + remove build artifacts and venv
# 	@$(call CLEANUP,$(NAME),executable,$(NAME))
	rm -rf $(VENV)
	rm -rf build/ dist/ *.egg-info
# Does clean plus removes:
# Virtualenv (.venv)
# Build artifacts: build/, dist/, *.egg-info.

ffclean: fclean ## Remove all generated files and folders
# 	@$(call SILENT_CLEANUP,$(NAME),Build Artifacts,$(DEPS_DIR))
# 	@$(MAKE) deps-clean
# 	@$(MAKE) script-clean
# 	@$(MAKE) tree-clean
	rm -rf logs/ .cache
	@echo "Full force clean done."
# Does fclean plus any extra junk we consider generated:
# logs/, .cache, etc.
# We can add coverage reports, generated docs, whatever fits our project.

re: fclean all ## Rebuild everything


# ==============================

# TODO: target to check/add missing python shebangs, and make all .py file in {specified} dirs executable


# ==============================
##@ 💾 Backup
# ==============================
.PHONY: backup tp-zip

BACKUP_DIR  := $(ROOT_DIR)_$(USER)_$(TIMESTAMP)
MOVE_TO     := ~/Desktop

backup: fclean ## Prompt and create a .zip or .tar.gz backup of the project
	@$(call INFO,$(NAME),Preparing backup...); \
	read -p "Choose backup format: [1] .zip  [2] .tar.gz : " choice; \
	case $$choice in \
		1) \
			tool=zip; \
			cmd="zip -r --quiet"; \
			file="$(BACKUP_DIR).zip"; \
			;; \
		2) \
			tool=tar; \
			cmd="tar -czf"; \
			file="$(BACKUP_DIR).tar.gz"; \
			;; \
		*) \
			$(call ERROR,Invalid choice,Aborting backup.); \
			exit 1; \
			;; \
	esac; \
	if $(call IS_COMMAND_AVAILABLE,$$tool); then \
		$(call INFO,$(NAME),$(ORANGE)Creating archive: $(CYAN)$$file) ; \
		eval $${cmd} "$$file" ./* || { $(call ERROR,Backup,Archive creation failed.); exit 1; }; \
		$(MKDIR) $(MOVE_TO); \
		mv "$$file" $(MOVE_TO)/ || { $(call ERROR,Backup,Move to $(MOVE_TO) failed.); exit 1; }; \
		$(call SUCCESS,$(NAME),Backup created: $(MOVE_TO)/$$file); \
	else \
		$(call ERROR,Backup,Required tool '\''$$tool'\'' not found. Please install it.); \
		exit 1; \
	fi

