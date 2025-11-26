
# TODO:
# different target for main and game
# 
# target to check/add missing python shebangs, and make all .py file in {specified} dirs executable
# 
# organise 'prompt' target

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
REQUIREMENTS	:= code/games/requirements.txt

# Entry Point
# MAIN	?= code/main.py
MAIN			?= code/games/minecraft-mini.py

# ==============================
# Executables for the 'prompt' target
# ==============================
CODE_DIR	:= code

EXECUTABLES	:= \
	main.py \
	games/minecraft-mini.py \
	turtle/turtle_test.py \
	utils/check_module.py

EXEC_FILES	:= $(addprefix $(CODE_DIR)/, $(EXECUTABLES))

# ==============================
# Makefile Imports
# ==============================
MK_PATH		:= utils/makefiles
MK_FILES	:= utils.mk \
			   dependencies.mk \
			   doc.mk \
			   scripts.mk \
			   tree.mk \
			   python.mk

include $(addprefix $(MK_PATH)/, $(MK_FILES))

# ==============================
# Default
# ==============================
.DEFAULT_GOAL	:= prompt

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
.PHONY: all run prompt

all: py-venv py-install py-test ## Prepares the project (env + deps + tests)

run: ## Run the project (MAIN=... to override)
	@$(call PY_REQUIRE_VENV)
	@$(call TRY_CMD,$(PY_CTX),Running $(MAIN),$(PY) $(MAIN))

prompt: ## Prompt to choose an executable from the 'EXEC_FILES' list, chmod +x, then run it
	@bash -c '\
		files=($(EXEC_FILES)); \
		count=$${#files[@]}; \
		if [ $$count -eq 0 ]; then \
			$(call ERROR,Run,No files listed in EXEC_FILES.); exit 1; \
		fi; \
		choice="$(CHOICE)"; \
		if [ -z "$$choice" ]; then \
			echo "Choose exercise to run:"; \
			for i in $$(seq 1 $$count); do \
				printf "  [%d] %s\n" $$i "$${files[$$((i-1))]}"; \
			done; \
			read -p "Enter your choice (1..$$count): " choice; \
		fi; \
		if ! echo "$$choice" | grep -Eq "^[0-9]+$$"; then \
			$(call ERROR,Run,Invalid choice. Aborting.); exit 1; \
		fi; \
		if [ $$choice -lt 1 ] || [ $$choice -gt $$count ]; then \
			$(call ERROR,Run,Choice out of range. Aborting.); exit 1; \
		fi; \
		file="$${files[$$((choice-1))]}"; \
		if [ ! -f "$$file" ]; then \
			$(call ERROR,Run,File $$file not found.); exit 1; \
		fi; \
		chmod +x "$$file"; \
		$(call INFO,$(NAME),Running $$file...); \
		if head -n 1 "$$file" | grep -q "^#!"; then \
			"./$$file"; \
		else \
			if $(call IS_COMMAND_AVAILABLE,python3); then \
				python3 "$$file"; \
			elif $(call IS_COMMAND_AVAILABLE,python); then \
				python "$$file"; \
			else \
				$(call ERROR,Run,No python interpreter found.); exit 1; \
			fi; \
		fi \
	'

# ==============================
##@ 🧹 Cleanup
# ==============================
.PHONY: clean fclean ffclean re

clean: ## Remove compiled Python junk and tool caches
	@$(MAKE) py-clean-cache
	@$(MAKE) py-clean-bytecode

fclean: clean ## clean + remove build artifacts and venv
	@$(MAKE) py-clean-build
	@$(MAKE) py-clean-venv

ffclean: fclean ## Remove all generated files and folders
# 	@$(call SILENT_CLEANUP,$(NAME),Build Artifacts,$(DEPS_DIR))
# 	@$(call SILENT_CLEANUP,$(PY_CTX),extra artifacts,$(PY_EXTRA_ARTIFACTS))
	@$(call CLEANUP,$(PY_CTX),extra artifacts,$(PY_EXTRA_ARTIFACTS))
# 	@$(MAKE) deps-clean
# 	@$(MAKE) script-clean
# 	@$(MAKE) tree-clean

re: fclean all ## Rebuild everything

# ==============================
##@ 💾 Backup
# ==============================
.PHONY: backup

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
