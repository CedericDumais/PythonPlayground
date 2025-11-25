#!/usr/bin/env bash
# File: utils/scripts/test-loggers.sh

set -Eeuo pipefail

# ===== Script: test-loggers.sh =====
# 
# Script to test log utility functions
# 
# ----------------------------------------------------------------------------

# -------- Shared utility sourcing -------------------------------------------
# Locate the project root via '.project-root' or '.git'
find_project_root() {
	local dir="$PWD"
	while [[ "$dir" != "/" ]]; do
		[[ -f "$dir/.project-root" ]] && { echo "$dir"; return 0; }
		[[ -d "$dir/.git" ]] && { echo "$dir"; return 0; }
		dir="$(dirname "$dir")"
	done
	echo "Error: .project-root not found." >&2
	return 1
}
PROJECT_ROOT="$(find_project_root)" || exit 1

# Source all shared utilities through the aggregator
source "$PROJECT_ROOT/utils/scripts/helpers/common.sh"
# ----------------------------------------------------------------------------

# -------- Script logic starts here ------------------------------------------
log_info "Project root detected: ${BPURPLE}$PROJECT_ROOT${NC}"
log_info "Utilities sourced from: ${BBLUE}$PROJECT_ROOT/utils/scripts/helpers/common.sh${NC}"
log_success "Script ${BGREEN}test-loggers.sh${NC} is working!"

echo -e "\nTesting Loggers with timestamp options\n"

# -------- logging.sh --------------------------------------------------------

# no timestamps (default)
log_info     "This is an info message"
log_warn     "This is a warning"
log_error    "This is an error (goes to stderr)"
log_success  "This is a success message"
# ==============================
# log_info     "info (no ts)"
# log_warn     "warn (no ts)"
# log_success  "success (no ts)"
# log_error    "error (no ts)"
# ==============================
(
	LOG_TS=true
	log_info "Timestamped info"
	log_warn "Timestamped warning"
	log_success "Timestamped success"
	log_error "Timestamped error"
)
# ==============================
# # one-liner with timestamp
with_ts log_info "info (ts one-liner)"

# block with timestamp
ts_push
log_info    "info (ts block)"
log_warn    "warn (ts block)"
log_success "success (ts block)"
log_error   "error (ts block)"
ts_pop

# back to no timestamps
log_info "info (back to no ts)"
# ==============================

log_fatal "PROBLEM"
log_info  "should not print"
