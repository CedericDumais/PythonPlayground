#!/usr/bin/env bash

# ===== Main Utility Script: common.sh =====
# 
# Aggregator: source all helper scripts in this folder (except itself) once.
# 
# Designed to be *sourced* (not executed)
# 
# How to use from any script:
# (Place following function at the start of the script)
# ==============================

# -------------------------------------------------------------------------
# #!/usr/bin/env bash
# set -Eeuo pipefail

# # Locate the project root via '.project-root' or '.git'
# find_project_root() {
#     local dir="$PWD"
#     while [[ "$dir" != "/" ]]; do
#         [[ -f "$dir/.project-root" ]] && { echo "$dir"; return 0; }
#         [[ -d "$dir/.git" ]] && { echo "$dir"; return 0; }
#         dir="$(dirname "$dir")"
#     done
#     echo "Error: .project-root not found." >&2
#     return 1
# }

# PROJECT_ROOT="$(find_project_root)" || exit 1

# # Source shared utilities
# source "$PROJECT_ROOT/utils/scripts/helpers/common.sh"

# # Script logic starts here...
# -------------------------------------------------------------------------

# ==============================
# After sourcing, you get:
# - colors (ansi-colors.sh)         -> ${RED}, ${NC}, etc.
# - logging (logging.sh)            -> log_info, log_success, log_warn, log_error, log_fatal
# - prompt (prompt.sh)              -> yes_no, select_menu
# - fs utilities (fs.sh)            -> ensure_dir, mktemp_dir, with_tempdir
# - project root (project-root.sh)  -> find_project_root
# - opener (open-url.sh)            -> open_url
# - spinner (spinner.sh)            -> start_spinner, stop_spinner
# - input converter (case.sh)       -> 
# ==============================

# -------------------------------------------------------------------------
# Prevent multiple sourcing (idempotent import)
# -------------------------------------------------------------------------
# [[ -n "$__COMMON_SH_IMPORTED" ]] && return 0
# __COMMON_SH_IMPORTED=1

# HELPER_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# -------------------------------------------------------------------------
# Source helpers in a specific order for dependency consistency
# -------------------------------------------------------------------------
# source "$HELPER_DIR/ansi-colors.sh"
# source "$HELPER_DIR/logging.sh"
# source "$HELPER_DIR/prompt.sh"
# source "$HELPER_DIR/fs.sh"
# source "$HELPER_DIR/project-root.sh"
# source "$HELPER_DIR/open-url.sh"
# source "$HELPER_DIR/spinner.sh"

# -------------------------------------------------------------------------
# Dynamically source all helper scripts in this folder, excluding this file
# -------------------------------------------------------------------------
for file in "${BASH_SOURCE%/*}"/*.sh; do
    [[ "$file" != *"/common.sh" ]] && source "$file"
done

# # -------------------------------------------------------------------------
# # Function: realpath_fallback
# #
# # Purpose:
# #   Resolve an absolute path from a relative or symbolic path.
# #   Works even if `realpath` is not installed.
# #
# # Parameters:
# #   $1 → Path to resolve (relative or absolute)
# #
# # Behavior:
# #   1. Uses system `realpath` if available
# #   2. Falls back to `readlink -f` (Linux usually)
# #   3. Naively resolves via `cd` + `pwd` if neither is available
# #
# # Example usage:
# #   abs_path="$(realpath_fallback ./file.txt)"
# #   echo "$abs_path"
# # -------------------------------------------------------------------------
# realpath_fallback() {
#     local target="$1"
#     if command -v realpath >/dev/null 2>&1; then
#         realpath "$target"
#     elif readlink -f / >/dev/null 2>&1; then
#         readlink -f "$target"
#     else
#         # Fallback: naive absolute resolution
#         local dir
#         dir="$(cd "$(dirname "$target")" >/dev/null 2>&1 && pwd)"
#         echo "$dir/$(basename "$target")"
#     fi
# }
# # Optional: realpath fallback *function* (quick one). Prefer the standalone script in Make.
