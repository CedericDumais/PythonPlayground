#!/usr/bin/env bash

# ===== Utility Script: realpath-fallback.sh =====
# 
# Function: realpath_fallback
#
# Purpose:
#   Resolve an absolute path from a relative or symbolic path.
#   Works even if `realpath` is not installed.
#
# Parameters:
#   $1 → Path to resolve (relative or absolute)
#
# Behavior:
#   1. Uses system `realpath` if available
#   2. Falls back to `readlink -f` (Linux usually)
#   3. Naively resolves via `cd` + `pwd` if neither is available
#
# Example usage:
#   abs_path="$(realpath_fallback ./file.txt)"
#   echo "$abs_path"
# 
# Designed to be *sourced* (not executed)
# ================================================

realpath_fallback() {
    local target="$1"
	# Use realpath if available
    if command -v realpath >/dev/null 2>&1; then
        realpath "$target"
    elif readlink -f / >/dev/null 2>&1; then
        readlink -f "$target"
    else
        # Fallback: naive absolute resolution
        local dir
        dir="$(cd "$(dirname "$target")" >/dev/null 2>&1 && pwd)"
        echo "$dir/$(basename "$target")"
    fi
}
# Optional: realpath fallback *function* (quick one).
# Prefer the standalone script in Make.

# ( cd "$(dirname "$target")" >/dev/null 2>&1 && pwd )/$(basename "$target")
