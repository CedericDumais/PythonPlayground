
# ==============================
##@ 📦 Dependency setup
# ==============================
ifndef __DEPS_MK__
__DEPS_MK__	:= 1

# Marker files so init only happens once unless cleaned
DEPS_DIR			?= .sentinel-markers
SUBMODULE_SENTINEL	= $(DEPS_DIR)/.submodules-initialized

# ---- System dependency list
SYS_DEPS ?= git $(PYTHON)

# If set to 1, 'deps-sys' will fail the build when something is missing
DEPS_FAIL_ON_MISSING ?= 0


# ==============================
# Dependency Utilty Macros
# ==============================

# Macro: SENTINEL_MARKER
# Create a sentinel marker file for dependency management
# 
# Parameters:
# $(1): Name of sentinel marker
# $(2): (Optional) Use "print" to enable confirmation output.
# $(3): (Optional) Use "print skip" to enable skipping output.
# 
# Behavior:
# Creates the sentinel marker file.
# If sentinel file already exists, exits silently.
# If second argument is "print"; Message on sentinel creation.
# If third argument is "print skip"; Message when sentinal already exists.
# 
# Example Usage:
# $(call SENTINEL_MARKER,$(PROJECT_ROOT),print)
# $(call SENTINEL_MARKER,.proof-something-happened,print,print skip)
# 
define SENTINEL_MARKER
	if [ ! -f "$(1)" ]; then \
		touch $(1); \
		if [ "$(2)" = "print" ]; then \
			$(call SUCCESS,Sentinel Marker,$(1) created.); \
		fi; \
	else \
		if [ "$(3)" = "print skip" ]; then \
			$(call WARNING,Sentinel Marker,$(1) already exists. Skipping); \
		fi; \
	fi
endef

# ==============================
# Targets
# ==============================
.PHONY: deps deps-status deps-clean

deps: deps-sys deps-submodules ## Initialize/check all dependencies

deps-status: ## Print a quick overview of dependency state
	@$(MAKE) $(NPD) deps-sys-check
	@if [ -f "$(SUBMODULE_SENTINEL)" ]; then \
		$(call SUCCESS,Dependencies,Submodules initialized); \
	else \
		$(call WARNING,Dependencies,Submodules not initialized); \
	fi

deps-clean: ## Remove dependency sentinel markers (does not remove submodules/libs)
	@$(call SILENT_CLEANUP,Dependencies,Sentinel Markers,$(SUBMODULE_SENTINEL))

# ==============================
# System tools
# ==============================
.PHONY: deps-sys deps-sys-check

deps-sys: deps-sys-check ## Verify required system packages (fatal if DEPS_FAIL_ON_MISSING=1)
	@if [ "$(DEPS_FAIL_ON_MISSING)" = "1" ]; then \
		MISSING=$$(for c in $(SYS_DEPS); do command -v $$c >/dev/null 2>&1 || echo $$c; done); \
		if [ -n "$$MISSING" ]; then \
			$(call ERROR,Dependencies,Missing tools: $$MISSING); \
			exit 1; \
		fi; \
	fi

deps-sys-check: ## Show which required system packages are present
	@$(call INFO,Dependencies,Checking required system packages...)
	@for cmd in $(SYS_DEPS); do \
		if command -v $$cmd >/dev/null 2>&1; then \
			printf "  ✅ %s\n" "$$cmd"; \
		else \
			printf "  ❌ %s\n" "$$cmd"; \
		fi; \
	done

# ==============================
# Submodules
# ==============================
.PHONY: deps-submodules deps-submodules-update deps-submodules-clean

deps-submodules: $(SUBMODULE_SENTINEL) ## Initialize and update all git submodules (idempotent)

$(SUBMODULE_SENTINEL): .gitmodules
	@$(MKDIR) $(DEPS_DIR)
	@if [ -f .gitmodules ]; then \
		$(call INFO,Dependencies,Initializing and updating submodules...); \
		git submodule update --init --recursive; \
		$(call SENTINEL_MARKER,$@); \
		$(call SUCCESS,Dependencies,Submodules ready); \
	else \
		$(call WARNING,Dependencies,No .gitmodules found. Skipping submodules.); \
	fi

deps-submodules-update: ## Update submodules to their tracked commit/branch
	@$(call INFO,Dependencies,Updating submodules (remote, recursive)...)
	@git submodule update --remote --recursive
	@$(call SUCCESS,Dependencies,Submodules updated)

deps-submodules-clean: ## Forget we've initialized submodules (so next deps re-inits)
	@$(call SILENT_CLEANUP,Dependencies,Sentinel Markers,$(SUBMODULE_SENTINEL))

endif # __DEPS_MK__
