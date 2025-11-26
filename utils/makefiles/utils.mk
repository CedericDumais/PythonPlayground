# utils.mk

# ==============================
# Utility Variables
# ==============================

# Default MAKEFLAGS (can be overridden by command line)
MAKEFLAGS	+= --no-print-directory

# Utility commands
MKDIR		:= mkdir -p
REMOVE		:= rm -rf
NPD			:= --no-print-directory
VOID		:= /dev/null

# System Information
OS			:= $(shell uname)
USER		:= $(shell whoami)
ROOT_DIR	:= $(notdir $(shell pwd))
TIME		:= $(shell date "+%H:%M:%S")
DATE		:= $(shell date "+%d/%m/%y")
TIMESTAMP	:= $(shell date "+%Y%m%d-%H%M%S")

# Redirection variables
STDOUT_NULL		:= > /dev/null
STDERR_STDOUT	:= 2>&1
IN_BACKGROUND	:= &

# Platform-specific adjustments (Linux or macOS)
ifeq ($(OS), Linux)
	OPEN		:= xdg-open
	SED_INPLACE	:= sed -i
	PLAY_SOUND	:= aplay
	NC_FLAG		:= -C
else ifeq ($(OS), Darwin)
	OPEN		:= open
	SED_INPLACE	:= sed -i ''
	PLAY_SOUND	:= afplay
	NC_FLAG		:= -c
endif

# Conditional flag for Linux to allow implicit fall-through in C++ switch statements
ifeq ($(OS), Linux)
	C_FLAGS += -Wno-error=implicit-fallthrough -Wimplicit-fallthrough=0
endif

# Default values if OS detection fails
OPEN		?= open
SED_INPLACE	?= sed -i
PLAY_SOUND	?= aplay
NC_FLAG		?= -C

# ==============================
# ANSI Escape Codes
# ==============================
ESC			:= \033
RESET		:= $(ESC)[0m
BOLD		:= $(ESC)[1m
ITALIC		:= $(ESC)[3m
UNDERLINE	:= $(ESC)[4m
RED			:= $(ESC)[91m
GREEN		:= $(ESC)[32m
YELLOW		:= $(ESC)[93m
ORANGE		:= $(ESC)[38;5;208m
BLUE		:= $(ESC)[94m
PURPLE		:= $(ESC)[95m
CYAN		:= $(ESC)[96m
GRAYTALIC	:= $(ESC)[3;90m

UP			:= $(ESC)[A
ERASE_LINE	:= $(ESC)[2K

PINK		:= $(ESC)[38;5;205m
PINK_HOT	:= $(ESC)[38;5;198m
PINK_LIGHT	:= $(ESC)[38;5;200m
PINK_PASTEL	:= $(ESC)[38;5;219m

# ==============================
# Standardized Output Macros
# ==============================

# Macro: INFO
# Logs an informational message with optional additional details.
# 
# Parameters:
# $(1): Context or section name (e.g., task name).
# $(2): Main informational message.
# $(3): Optional additional details.
# 
# Behavior:
# Formats the message with bold and colored context,
# orange for the main message,
# and gray italics for details.
INFO	= printf "[$(BOLD)$(PURPLE)%s$(RESET)]\t%b$(RESET)$(GRAYTALIC)%b$(RESET)\n" "$(1)" "$(2)" "$(3)"

# Macro: SUCCESS
# Logs a success message.
# 
# Parameters:
# $(1): Context or section name (e.g., task name).
# $(2): Success message.
# 
# Behavior:
# Formats the message with bold and colored context
# and green for the success message.
SUCCESS	= printf "[$(BOLD)$(PURPLE)%s$(RESET)]\t$(GREEN)%s$(RESET)\n" "$(1)" "$(2)"

# Macro: WARNING
# Logs a warning message.
# 
# Parameters:
# $(1): Context or section name (e.g., task name).
# $(2): Warning message.
# 
# Behavior:
# Formats the message with bold and colored context
# and yellow for the warning message.
WARNING	= printf "[$(BOLD)$(PURPLE)%s$(RESET)]\t$(YELLOW)%s$(RESET)\n" "$(1)" "$(2)"

# Macro: ERROR
# Logs an error message and highlights it in red.
# 
# Parameters:
# $(1): Main error context (e.g., error type or task).
# $(2): Detailed error message.
# 
# Behavior:
# Displays the error with a red icon and message for immediate visibility.
ERROR	= printf "❌ $(BOLD)$(RED)Error$(RESET): %s\n" "$(1): $(2)"

# Macro: UPCUT
# Moves the cursor up one line and clears it,
# useful for refreshing messages in loops.
# 
# Behavior:
# Uses ANSI escape codes to move the cursor up and clear the line.
UPCUT	= printf "$(UP)$(ERASE_LINE)"

# ==============================
# Utility Macros
# ==============================

# *!! WIP
# 
# Macro: TRY_CMD (**! to change for something better)
# (description)
# 
# Parameters:
# $(1): Label/Context
# $(2): Message or current task information.
# $(3): Command to try and execute.
# 
# Behavior:
# ()
# 
# Example Usage:
# $(call TRY_CMD,$(PY_CTX),Upgrading pip,$(PIP_CMD) install --upgrade pip)
# 
define TRY_CMD
	$(call INFO,$(1),$(2))
	bash -c '$(3)' || { $(call ERROR,$(1),Command failed: $(2)); exit 1; }
endef

# Macro: CLEANUP
# 
# Parameters:
# $(1): Caller context (e.g., the project name or task name).
# $(2): Name of the cleanup task (for logging clarity).
# $(3): Files/Directories/Globs list to clean.
# $(4): Optional custom success message (when cleaned).
# $(5): Optional custom warning message (when nothing to clean).
# 
# Behavior:
# Checks if the specified files/directories/globs exist.
# If they exist, logs an info message, removes the files, and logs a success message.
# If they do not exist, logs a warning message.
# 
# Example Usage:
# $(call CLEANUP,$(NAME),object files,$(OBJ_DIR))
# $(call CLEANUP,$(NAME),test artifacts,testfile.txt received_file.txt,"All test artifacts removed.","No artifacts to clean.")
# 
define CLEANUP
	if [ -n "$(wildcard $(3))" ]; then \
		$(REMOVE) $(3); \
		$(call SUCCESS,$(1),$(if $(strip $(4)),$(4),Removed $(2).)); \
	else \
		$(call WARNING,$(1),$(if $(strip $(5)),$(5),No $(2) to remove.)); \
	fi
endef

# Macro: SILENT_CLEANUP
# 
# Parameters:
# $(1): Caller context (e.g., the project name or task name).
# $(2): Name of the cleanup task (for logging clarity).
# $(3): Files/Directories to clean.
# $(4): Optional custom success message (when cleaned).
# 
# Behavior:
# Checks if the specified files/directories exist.
# If they exist, logs an info message, removes the files, and logs a success message.
# If they do not exist, exits silently.
# 
# Example Usage:
# $(call SILENT_CLEANUP,$(NAME),object files,$(OBJ_DIR))
# $(call SILENT_CLEANUP,$(NAME),test artifacts,testfile.txt received_file.txt,"All test artifacts removed.")
# 
define SILENT_CLEANUP
	if [ -n "$(wildcard $(3))" ]; then \
		$(REMOVE) $(3); \
		$(call SUCCESS,$(1),$(if $(strip $(4)),$(4),Removed $(2).)); \
	fi
endef

# *!! WIP
# 
# Macro: FIND_DELETE_FILES
# Recursive file delete helper
# 
# Parameters:
# $(1): Root (**more info)
# $(2): Patterns (space-separated, like "*.pyc" "*.pyo")
# 
# Behavior:
# For each file in the second argument (patterns), 
# Uses 'find' with the '-delete' flag to remove matching files.
# 
# Example Usage:
# 	$(call FIND_DELETE_FILES,)
#	$(call FIND_DELETE_FILES,$(PY_CLEAN_ROOT),$(PY_CLEAN_FIND_FILES))
define FIND_DELETE_FILES
	for pat in $(2); do \
		find "$(1)" -name "$$pat" -delete; \
	done
endef

# *!! WIP
# 
# Macro: FIND_DELETE_DIRS
# short description
# 
# Parameters:
# $(1): Root (**more info)
# $(2): dirnames (space-separated, like __pycache__)
# 
# Behavior:
# For each directory in the second argument (dirnames), 
# Uses 'find' and 'rm -rf' to remove matching directories.
# 
# Example Usage:
# 	$(call FIND_DELETE_DIRS,$(PY_CLEAN_ROOT),$(PY_CLEAN_FIND_DIRS))
define FIND_DELETE_DIRS
	for d in $(2); do \
		find "$(1)" -name "$$d" -type d -exec rm -rf {} +; \
	done
endef

# **************************************************************************** #

# Macro: IS_COMMAND_AVAILABLE
# Checks whether a given command is available on the system.
#
# Parameters:
# $(1): Command name to check.
#
# Behavior:
# - Returns `0` (true) if the command exists.
# - Returns `1` (false) if the command is missing.
#
# Example Usage:
# if $(call IS_COMMAND_AVAILABLE,lsof); then echo "lsof is installed!"; fi
#
define IS_COMMAND_AVAILABLE
	command -v $(1) > /dev/null 2>&1
endef

# # Returns "yes" or empty
# CMD_EXISTS = $(shell command -v $(1) >/dev/null 2>&1 && echo yes)

# **************************************************************************** #

# Macro: CHECK_COMMAND
# Checks if a specific command is available on the system.
# If the command is missing, it prints an **error** and exits with status `1`.
# 
# Parameters:
# $(1): Command name to check.
# 
# Behavior:
# - Uses `IS_COMMAND_AVAILABLE` to verify the command.
# - If missing, prints an **error message** and exits with **status `1`**.
# 
# Example Usage:
# $(call CHECK_COMMAND,docker)
# 
define CHECK_COMMAND
	if ! $(call IS_COMMAND_AVAILABLE,$(1)); then \
		$(call ERROR,Command Missing,Command '$(1)' not found.); \
		exit 1; \
	fi
endef

# **************************************************************************** #

# ============================================================================
# Internal helper: __KILL_WITH_FINDER
# Runs a "finder" command to produce PIDs, prints (optionally), then kill -9.
#
# Parameters:
#  $(1) Context label (e.g., "Port 3000" or "Process 'godot'")
#  $(2) Pre-info message (e.g., "Killing process(es) using port 3000:" )
#  $(3) Finder command that outputs PIDs (space/newline separated)
#  $(4) Optional: "print" to list PIDs before killing
#  $(5) Success message
#  $(6) Warning message when nothing found (optional)
# ============================================================================
define __KILL_WITH_FINDER
	PIDS=$$($(3)); \
	if [ -n "$$PIDS" ]; then \
		$(call INFO,$(1),$(2)); \
		if [ "$(4)" = "print" ]; then \
			for PID in $$PIDS; do \
				printf "\t\t$(ORANGE)%s$(RESET)\n" "$$PID"; \
			done; \
		fi; \
		kill -9 $$PIDS; \
		$(call SUCCESS,$(1),$(5)); \
	else \
		$(call WARNING,$(1),$(if $(strip $(6)),$(6),No matching processes found.)); \
	fi
endef

# Macro: KILL_PROCESS_BY_NAME
# Kills processes matching a name (uses full command line with -f).
#
# Parameters:
#  $(1): name/pattern (e.g., "godot")
#  $(2): Optional "print" to list PIDs before killing
#
define KILL_PROCESS_BY_NAME
	$(call CHECK_COMMAND,pgrep)
	$(call __KILL_WITH_FINDER,Process '$(1)',Killing process(es) matching '$(1)':,pgrep -f "$(1)",$(2),Killed process(es) named '$(1)'.,"No process found matching '$(1)'.")
endef


.PHONY: kill __kill-by-name
kill:
	@bash -c '\
		read -p "Enter process name to kill: " pname; \
		if [ -z "$$pname" ]; then \
			echo "❌ No process name provided."; exit 1; \
		fi; \
		exec make __kill-by-name PROCESS_NAME="$$pname" --no-print-directory \
	'

__kill-by-name:
	@$(call KILL_PROCESS_BY_NAME,$(PROCESS_NAME),print)
