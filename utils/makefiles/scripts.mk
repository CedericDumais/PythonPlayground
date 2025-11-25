
# TODO:
# (if more than one script template) in 'new-script' target, prompt selection from template list
# Append ".sh" in 'new-script' name prompt. (unless already included in user input)
# 

# ==============================
##@ 📜 Scripts
# ==============================
ifndef __SCRIPTS_MK__
__SCRIPTS_MK__ := 1

PROJECT_ROOT		:= .project-root
EDITOR				?= code

# Scripts Paths  (relative to the main Makefile's location)
SCRIPT_DIR			:= utils/scripts
SCRIPT_INDEX		:= $(SCRIPT_DIR)/script-index.txt

# Utility Scripts
SCRIPT_UTILS		:= $(SCRIPT_DIR)/helpers
SCRIPT_COMMON		:= $(SCRIPT_UTILS)/common.sh

# Script Templates
TEMPLATE_DIR		?= utils/templates
SCRIPT_TEMPLATE_DIR	:= $(TEMPLATE_DIR)/script-templates
SCRIPT_TEMPLATE		:= $(SCRIPT_TEMPLATE_DIR)/new-script.sh.template

# Scripts Logs and Artifacts
SCRIPT_LOG_DIR		:= $(SCRIPT_DIR)/tmp_scripts_logs
SCRIPT_LOG_FILE		:= $(SCRIPT_LOG_DIR)/SCRIPT_$(TIMESTAMP).log
SCRIPT_ARTIFACTS	:= $(SCRIPT_INDEX) $(PROJECT_ROOT)

# Decide REALPATH tool once
ifeq ($(shell command -v realpath >/dev/null 2>&1 && echo yes),yes)
  REALPATH := realpath
else
  REALPATH := $(SCRIPT_UTILS)/realpath-fallback.sh
endif
# rel_path := $$( $(REALPATH) --relative-to="$(SCRIPT_DIR)" "$$path" )

# ==============================
# Script Related Utilty Macros
# ==============================

# Macro: SCRIPT_LOG_PATH
# Generate a cleaner and more specific log file name per script,
# including:
# 	- the script's name
# 	- the current timestamp
# 
# Parameters:
# $(1): Script filename (e.g. "test-script.sh")
# 
# Output:
# 	$(SCRIPT_LOG_DIR)/test-script_$(TIMESTAMP).log
# 
# Example Usage:
# (In RUN_SCRIPT macro)
# 
# log_file=$(call SCRIPT_LOG_PATH,$(notdir $(2)));
# $(2) >> $$log_file 2>&1;
# 
SCRIPT_LOG_PATH = $(SCRIPT_LOG_DIR)/$(basename $(1))-$(TIMESTAMP).log


# Macro: RUN_SCRIPT
# Run a script with optional logging
# 
# Parameters:
# $(1): Name of the script (for logging and clarity).
# $(2): Path to the script.
# $(3): Boolean to enable logging
# 
# Behavior:
# Ensures the script exists and is executable.
# Runs the script.
# If logging is enabled, appends the output to a log file.
# Displays appropriate success messages based on logging status.
# 
# Example Usage:
# $(call RUN_SCRIPT,Create Users,$(SHOW_COLORS))
# $(call RUN_SCRIPT,Create Users,$(SHOW_COLORS),true)
# 
define RUN_SCRIPT
	if [ ! -f "$(2)" ]; then \
		$(call ERROR,Script Missing,Script '$(2)' does not exist.); \
		exit 1; \
	fi; \
	if [ ! -x "$(2)" ]; then \
		chmod +x $(2); \
	fi; \
	$(call INFO,Scripts,Running '$(1)' script...); \
	if [ "$(3)" = "true" ]; then \
		log_file=$(call SCRIPT_LOG_PATH,$(notdir $(2))); \
		$(2) >> $$log_file 2>&1; \
		$(call SUCCESS,Scripts,Script '$(1)' executed successfully.); \
		$(call INFO,Scripts,Logged in $$log_file); \
	else \
		$(2); \
		$(call SUCCESS,Scripts,Script '$(1)' executed successfully.); \
	fi
endef

# Macro: NEW_SCRIPT
# Create a new script from template with placeholder replacement and logging
# 
# Parameters:
# $(1): The script name (e.g. "color-demo.sh")
# $(2): The template path to use
#
# Example Usage:
#   $(call NEW_SCRIPT,color-demo.sh,$(SCRIPT_TEMPLATE))
#
define NEW_SCRIPT
	script_dir="$(SCRIPT_DIR)"; \
	target_path="$(SCRIPT_DIR)/$(1)"; \
	script_utils_common="$(SCRIPT_COMMON)"; \
	if [ -e "$$target_path" ]; then \
		$(call ERROR,Script Already exists,Use a different name or delete: $$target_path); \
		exit 1; \
	fi; \
	if [ ! -f "$(2)" ]; then \
		$(call ERROR,Template Missing,Template not found at: $(2)); \
		exit 1; \
	fi; \
	$(MKDIR) "$$(dirname "$$target_path")"; \
	cp "$(2)" "$$target_path"; \
	$(SED_INPLACE) "s|{{SCRIPT_DIR}}|$$script_dir|g" "$$target_path"; \
	$(SED_INPLACE) "s|{{SCRIPT_NAME}}|$(1)|g" "$$target_path"; \
	$(SED_INPLACE) "s|{{SCRIPT_UTILS_COMMON}}|$$script_utils_common|g" "$$target_path"; \
	chmod +x "$$target_path"; \
	\
	# Prevent duplicate script entries when rebuilding or recreating \
	grep -qxF "$(1): $$target_path" $(SCRIPT_INDEX) || echo "$(1): $$target_path" >> $(SCRIPT_INDEX);
	$(call SUCCESS,Scripts,New script created and registered: $(SCRIPT_DIR)/$(1))
endef

# Macro: EDIT_SCRIPT
# Open a script in the specified editor, or $(OPEN) by default.
#
# Parameters:
# $(1): Script name as listed in $(SCRIPT_INDEX) (e.g., "crypt-script.sh")
# $(2): Editor command (optional, e.g., "code" or "nano")
#
# Behavior:
# - Finds script path in $(SCRIPT_INDEX) by exact name match before the colon.
# - Checks existence — if the path isn’t found or the file doesn’t exist, it errors out.
# - Editor choice — if parameter 2 is empty, it uses $(OPEN) (which you probably already have defined, e.g., to xdg-open or open on macOS).
# - Runs the editor — with the full path to the script.

# Example Usage:
#   $(call EDIT_SCRIPT,crypt-script.sh,code)
#   $(call EDIT_SCRIPT,crypt-script.sh)  # uses $(OPEN)
#
define EDIT_SCRIPT
	script_name="$(1)"; \
	editor_cmd="$(strip $(2))"; \
	script_path="$$(grep -F "$$script_name" $(SCRIPT_INDEX) | awk -F': ' '{print $$2}' | head -n1)"; \
	if [ -z "$$script_path" ]; then \
		$(call ERROR,Script Not Found,"$$script_name" not found in $(SCRIPT_INDEX)); \
		exit 1; \
	fi; \
	if [ ! -f "$$script_path" ]; then \
		$(call ERROR,Script Missing,"$$script_path" does not exist); \
		exit 1; \
	fi; \
	if [ -z "$$editor_cmd" ]; then \
		$(OPEN) "$$script_path"; \
	else \
		$$editor_cmd "$$script_path"; \
	fi
endef

# **************************************************************************** #
# ** TO TEST **
# **************************************************************************** #
# # Macro: SELECT_SCRIPT
# # Show a list from $(SCRIPT_INDEX) and forward the choice to a follow-up target.
# # Params:
# #   $(1): Title (string)
# #   $(2): Index file (usually $(SCRIPT_INDEX))
# #   $(3): Next make target to exec with SCRIPT_NAME & SCRIPT_PATH set
# define SELECT_SCRIPT
# 	@bash -c '\
# 		title="$(1)"; index="$(2)"; next="$(3)"; \
# 		if [ ! -s "$$index" ]; then echo "No scripts indexed. Run: make script-index-rebuild"; exit 1; fi; \
# 		echo ""; echo "$$title"; \
# 		i=0; declare -a labels; declare -a paths; \
# 		while IFS=: read -r label path; do \
# 			labels[$$i]=$$label; paths[$$i]=$$path; \
# 			printf "%2d) %s\n" $$i "$$label"; ((i++)); \
# 		done < "$$index"; \
# 		echo ""; read -p "Enter your choice: " choice; \
# 		if [[ "$$choice" =~ ^[0-9]+$$ && "$$choice" -ge 0 && "$$choice" -lt $$i ]]; then \
# 			SCRIPT_PATH="$${paths[$$choice]}"; SCRIPT_NAME=$$(basename "$$SCRIPT_PATH"); \
# 			exec make $$next SCRIPT_NAME="$$SCRIPT_NAME" SCRIPT_PATH="$$SCRIPT_PATH" LOG_ENABLED="$$LOG_ENABLED" EDITOR="$(EDITOR)"; \
# 		else \
# 			echo "❌ Invalid choice: $$choice"; exit 1; \
# 		fi'
# endef

# # Macro: PICK_EDITOR
# # Offer VS Code / Vim / Nano / Default opener and forward to next target.
# # Params:
# #   $(1): Next target to exec with EDITOR resolved (empty => use $(OPEN) in EDIT_SCRIPT)
# define PICK_EDITOR
# 	@bash -c '\
# 		next="$(1)"; \
# 		echo ""; echo "🧰 Choose an editor:"; \
# 		opt_i=0; declare -a opt_cmds; declare -a opt_labels; \
# 		opt_cmds[$$opt_i]="__OPEN__"; opt_labels[$$opt_i]="Default opener ($(OPEN))"; echo "  $$opt_i) $${opt_labels[$$opt_i]}"; ((opt_i++)); \
# 		if command -v code >/dev/null 2>&1; then opt_cmds[$$opt_i]="code"; opt_labels[$$opt_i]="VS Code (code)"; echo "  $$opt_i) $${opt_labels[$$opt_i]}"; ((opt_i++)); fi; \
# 		if command -v vim  >/dev/null 2>&1; then opt_cmds[$$opt_i]="vim";  opt_labels[$$opt_i]="Vim (vim)";       echo "  $$opt_i) $${opt_labels[$$opt_i]}"; ((opt_i++)); fi; \
# 		if command -v nano >/dev/null 2>&1; then opt_cmds[$$opt_i]="nano"; opt_labels[$$opt_i]="Nano (nano)";     echo "  $$opt_i) $${opt_labels[$$opt_i]}"; ((opt_i++)); fi; \
# 		default_idx=0; \
# 		for idx in "$${!opt_cmds[@]}"; do \
# 			if [[ -n "$(EDITOR)" && "$${opt_cmds[$$idx]}" = "$(EDITOR)" ]]; then default_idx=$$idx; break; fi; \
# 		done; \
# 		read -p "Editor choice [$$default_idx]: " editor_choice; editor_choice=$${editor_choice:-$$default_idx}; \
# 		if [[ ! "$$editor_choice" =~ ^[0-9]+$$ || "$$editor_choice" -lt 0 || "$$editor_choice" -ge $$opt_i ]]; then \
# 			echo "❌ Invalid editor choice: $$editor_choice"; exit 1; \
# 		fi; \
# 		editor_cmd="$${opt_cmds[$$editor_choice]}"; \
# 		if [ "$$editor_cmd" = "__OPEN__" ]; then \
# 			exec make $$next SCRIPT_NAME="$$SCRIPT_NAME" SCRIPT_PATH="$$SCRIPT_PATH" EDITOR=""; \
# 		else \
# 			exec make $$next SCRIPT_NAME="$$SCRIPT_NAME" SCRIPT_PATH="$$SCRIPT_PATH" EDITOR="$$editor_cmd"; \
# 		fi'
# endef

# # Tiny helper targets that do the actual work
# .PHONY: __run-selected __edit-selected

# # Uses your existing RUN_SCRIPT macro
# __run-selected:
# 	@$(call RUN_SCRIPT,$(SCRIPT_NAME),$(SCRIPT_PATH),$(LOG_ENABLED))

# # Uses your existing EDIT_SCRIPT macro
# __edit-selected:
# 	@$(call EDIT_SCRIPT,$(SCRIPT_NAME),$(EDITOR))

# # User facing targets
# # Rebuild the index, then pick & run
# script: script-index-rebuild
# 	$(call SELECT_SCRIPT,📜 Choose a script to run:,$(SCRIPT_INDEX),__run-selected)

# # Rebuild the index, then pick script, then pick editor, then open
# script-edit: script-index-rebuild
# 	$(call SELECT_SCRIPT,📝 Choose a script to edit:,$(SCRIPT_INDEX),__pick-editor-next)

# # Small bridge so we can chain macros neatly
# .PHONY: __pick-editor-next
# __pick-editor-next:
# 	$(call PICK_EDITOR,__edit-selected)
# **************************************************************************** #
# **************************************************************************** #

# ==============================
# Script Utility Targets
# ==============================
.PHONY: create-new-script run-script edit-script script-index-rebuild

$(PROJECT_ROOT):
	@$(call SENTINEL_MARKER,$@,print)

create-new-script:
	@$(call NEW_SCRIPT,$(SCRIPT_NAME),$(SCRIPT_TEMPLATE))

run-script:
	@$(call RUN_SCRIPT,$(SCRIPT_TYPE),$(SCRIPT_CHOICE),$(LOG_ENABLED))

## Open a script from $(SCRIPT_INDEX). Usage: make edit-script SCRIPT_NAME=name.sh [EDITOR=code]
edit-script:
	@if [ -z "$(SCRIPT_NAME)" ]; then \
		$(call ERROR,Scripts,Missing SCRIPT_NAME. Try: make edit-script SCRIPT_NAME=test.sh EDITOR=code); \
		exit 1; \
	fi; \
	$(call EDIT_SCRIPT,$(SCRIPT_NAME),$(EDITOR))

## Rebuild script index grouped by folder
script-index-rebuild:
	@$(call INFO,Scripts,Rebuilding script index grouped by category...)
	@> $(SCRIPT_INDEX); \
	find $(SCRIPT_DIR) -type f -name "*.sh" \
		! -path "$(SCRIPT_UTILS)/*" \
		| while read path; do \
		rel_path=$$(realpath --relative-to="$(SCRIPT_DIR)" "$$path"); \
		category=$$(dirname "$$rel_path"); \
		[ "$$category" = "." ] && category="scripts"; \
		label="$$(basename $$path)"; \
		printf "[%s] %s: %s\n" "$$category" "$$label" "$$path"; \
	done >> $(SCRIPT_INDEX)
	@$(call SUCCESS,Scripts,Script index rebuilt: $(SCRIPT_INDEX))

# script-index-rebuild-test:
# 	@$(call INFO,Scripts,Rebuilding script index grouped by category...)
# 	@> $(SCRIPT_INDEX); \
# 	find $(SCRIPT_DIR) -type f -name "*.sh" \
# 		! -path "$(SCRIPT_UTILS)/*" \
# 	| while read path; do \
# 		# If the chosen realpath supports --relative-to, use it; otherwise strip the prefix
# 		if $(REALPATH_CMD) --help 2>/dev/null | grep -q -- '--relative-to'; then \
# 			rel_path="$$( $(REALPATH_CMD) --relative-to="$(SCRIPT_DIR)" "$$path" )"; \
# 		else \
# 			rel_path="$$( printf '%s\n' "$$path" | sed -e 's#^$(SCRIPT_DIR)/##' )"; \
# 		fi; \
# 		category="$$( dirname "$$rel_path" )"; \
# 		[ "$$category" = "." ] && category="scripts"; \
# 		label="$$( basename "$$path" )"; \
# 		printf "[%s] %s: %s\n" "$$category" "$$label" "$$path"; \
# 	done >> $(SCRIPT_INDEX)
# 	@$(call SUCCESS,Scripts,Script index rebuilt: $(SCRIPT_INDEX))

# ==============================
# Script Targets
# ==============================
.PHONY: new-script script script-edit script-clean

new-script: $(PROJECT_ROOT) ## Create a new script from the template
	@bash -c '\
		if [ -z "$(name)" ]; then \
			read -p "Enter script name (e.g. color-demo.sh): " script_name; \
		else \
			script_name="$(name)"; \
		fi; \
		echo -e "Use default script template: '\''$(CYAN)$(SCRIPT_TEMPLATE)$(RESET)'\''?"; \
		read -p "[y/Y] for yes, or enter custom: " script_template; \
		if [ "$$script_template" = "y" ] || [ "$$script_template" = "Y" ] || [ -z "$$script_template" ]; then \
			script_template="$(SCRIPT_TEMPLATE)"; \
		fi; \
		exec make create-new-script SCRIPT_NAME="$$script_name" SCRIPT_TEMPLATE="$$script_template"\
		'

script: $(PROJECT_ROOT) script-index-rebuild ## Interactive script selection menu
	@bash -c '\
		# clear; \
		read -p "Do you want to log script output? (y/n): " log_choice; \
		if [ "$$log_choice" = "y" ] || [ "$$log_choice" = "Y" ] || [ -z "$$log_choice" ]; then \
			$(MKDIR) $(SCRIPT_LOG_DIR); \
			LOG_ENABLED=true; \
		else \
			LOG_ENABLED=false; \
		fi; \
		\
		echo ""; \
		echo "📜 Choose a script to run:"; \
		i=0; \
		declare -a labels; \
		declare -a paths; \
		while IFS=: read -r label path; do \
			labels[$$i]=$$label; \
			paths[$$i]=$$path; \
			printf "%2d) %s\n" $$i "$$label"; \
			((i++)); \
		done < $(SCRIPT_INDEX); \
		echo ""; \
		read -p "Enter your choice: " choice; \
		if [[ "$$choice" =~ ^[0-9]+$$ && "$$choice" -ge 0 && "$$choice" -lt $$i ]]; then \
			SCRIPT_TYPE="$${labels[$$choice]}"; \
			SCRIPT_CHOICE="$${paths[$$choice]}"; \
			SCRIPT_NAME=$$(basename "$$SCRIPT_CHOICE"); \
			$(MAKE) run-script SCRIPT_TYPE="$$SCRIPT_NAME" SCRIPT_CHOICE="$$SCRIPT_CHOICE" LOG_ENABLED="$$LOG_ENABLED"; \
		else \
			$(call ERROR,Invalid choice,"$$choice"); \
			exit 1; \
		fi'


# script-edit: script-index-rebuild ## Interactive: choose a script to open in editor (EDITOR=code to override)
# 	@bash -c '\
# 		echo ""; \
# 		echo "📝 Choose a script to edit:"; \
# 		i=0; \
# 		declare -a labels; \
# 		declare -a paths; \
# 		while IFS=: read -r label path; do \
# 			labels[$$i]=$$label; \
# 			paths[$$i]=$$path; \
# 			printf "%2d) %s\n" $$i "$$label"; \
# 			((i++)); \
# 		done < $(SCRIPT_INDEX); \
# 		echo ""; \
# 		read -p "Enter your choice: " choice; \
# 		if [[ "$$choice" =~ ^[0-9]+$$ && "$$choice" -ge 0 && "$$choice" -lt $$i ]]; then \
# 			SCRIPT_LABEL="$${labels[$$choice]}"; \
# 			SCRIPT_PATH="$${paths[$$choice]}"; \
# 			SCRIPT_NAME=$$(basename "$$SCRIPT_PATH"); \
# 			# Forward to the macro with optional EDITOR env if provided \
# 			$(MAKE) edit-script SCRIPT_NAME="$$SCRIPT_NAME" EDITOR="$(EDITOR)"; \
# 		else \
# 			$(call ERROR,Scripts,Invalid choice: $$choice); \
# 			exit 1; \
# 		fi'

script-edit: script-index-rebuild ## Interactive: choose a script, then pick an editor (default: EDITOR or $(OPEN))
	@bash -c '\
		echo ""; \
		echo "📝 Choose a script to edit:"; \
		i=0; \
		declare -a labels; \
		declare -a paths; \
		while IFS=: read -r label path; do \
			labels[$$i]=$$label; \
			paths[$$i]=$$path; \
			printf "%2d) %s\n" $$i "$$label"; \
			((i++)); \
		done < $(SCRIPT_INDEX); \
		echo ""; \
		read -p "Enter your choice: " choice; \
		if [[ "$$choice" =~ ^[0-9]+$$ && "$$choice" -ge 0 && "$$choice" -lt $$i ]]; then \
			SCRIPT_PATH="$${paths[$$choice]}"; \
			SCRIPT_NAME=$$(basename "$$SCRIPT_PATH"); \
			\
			# ----- Editor menu ----- \
			echo ""; \
			echo "🧰 Choose an editor:"; \
			opt_i=0; \
			declare -a opt_cmds; \
			declare -a opt_labels; \
			# 0) Default opener ($(OPEN)) \
			opt_cmds[$$opt_i]="__OPEN__"; opt_labels[$$opt_i]="Default opener ($(OPEN))"; echo "  $$opt_i) $${opt_labels[$$opt_i]}"; ((opt_i++)); \
			# VS Code \
			if command -v code >/dev/null 2>&1; then opt_cmds[$$opt_i]="code"; opt_labels[$$opt_i]="VS Code (code)"; echo "  $$opt_i) $${opt_labels[$$opt_i]}"; ((opt_i++)); fi; \
			# Vim \
			if command -v vim  >/dev/null 2>&1; then opt_cmds[$$opt_i]="vim";  opt_labels[$$opt_i]="Vim (vim)";       echo "  $$opt_i) $${opt_labels[$$opt_i]}"; ((opt_i++)); fi; \
			# Nano \
			if command -v nano >/dev/null 2>&1; then opt_cmds[$$opt_i]="nano"; opt_labels[$$opt_i]="Nano (nano)";     echo "  $$opt_i) $${opt_labels[$$opt_i]}"; ((opt_i++)); fi; \
			\
			# Suggest default (your Makefile EDITOR if present in menu; otherwise 0) \
			default_idx=0; \
			for idx in "$${!opt_cmds[@]}"; do \
				if [[ -n "$(EDITOR)" && "$${opt_cmds[$$idx]}" = "$(EDITOR)" ]]; then default_idx=$$idx; break; fi; \
			done; \
			read -p "Editor choice [$$default_idx]: " editor_choice; \
			editor_choice=$${editor_choice:-$$default_idx}; \
			if [[ ! "$$editor_choice" =~ ^[0-9]+$$ || "$$editor_choice" -lt 0 || "$$editor_choice" -ge $$opt_i ]]; then \
				echo "❌ Invalid editor choice: $$editor_choice"; \
				exit 1; \
			fi; \
			editor_cmd="$${opt_cmds[$$editor_choice]}"; \
			\
			# Call your macro via the non-interactive target \
			if [ "$$editor_cmd" = "__OPEN__" ]; then \
				$(MAKE) edit-script SCRIPT_NAME="$$SCRIPT_NAME" EDITOR=""; \
			else \
				$(MAKE) edit-script SCRIPT_NAME="$$SCRIPT_NAME" EDITOR="$$editor_cmd"; \
			fi; \
		else \
			$(call ERROR,Scripts,Invalid choice: $$choice); \
			exit 1; \
		fi'


script-clean: ## Clean up test artifacts and logs
	@$(call SILENT_CLEANUP,Scripts,Script log files,$(SCRIPT_LOG_DIR))
	@$(call SILENT_CLEANUP,Scripts,Script artifacts,$(SCRIPT_ARTIFACTS))

# ==============================
# Script Misc Utils
# ==============================
.PHONY: list-scripts \
		script-make-exec script-make-exec-silent

list-scripts: ## List available scripts
	@find $(SCRIPT_DIR) -type f -name "*.sh" | sort

script-make-exec: ## Make all scripts in SCRIPT_DIR executable
	@$(call INFO,Scripts,Making all scripts in $(SCRIPT_DIR) executable...)
	@count_file=$$(mktemp); \
	echo 0 > $$count_file; \
	find $(SCRIPT_DIR) -type f -name "*.sh" | while read script; do \
		if [ -x "$$script" ]; then \
			echo "$(YELLOW)Already executable: $$(basename "$$script")$(RESET)"; \
		else \
			chmod +x $$script; \
			echo "$(GREEN)Made executable: $$(basename "$$script")$(RESET)"; \
			count=$$(cat $$count_file); \
			count=$$((count + 1)); \
			echo $$count > $$count_file; \
		fi; \
	done; \
	total=$$(cat $$count_file); \
	rm -f $$count_file; \
	echo "$(CYAN)Total scripts made executable: $$total$(RESET)"

script-make-exec-silent: ## Run script-make-exec but suppress all output
	@$(MAKE) script-make-exec $(STDOUT_NULL) $(STDERR_STDOUT)

endif # __SCRIPTS_MK__
