#!/usr/bin/env bash

# ===== Utility Script: project-root.sh =====
# 
# Locate the project root by walking up until we see 
# the top-level marker '.project-root' or '.git'.
# 
# Designed to be *sourced* (not executed)
# ===========================================

locate_project_root() {
	local dir="$PWD"
	while [[ "$dir" != "/" ]]; do
		[[ -f "$dir/.project-root" ]] && { echo "$dir"; return 0; }
		[[ -d "$dir/.git" ]] && { echo "$dir"; return 0; }
		dir="$(dirname "$dir")"
	done
	echo "Error: .project-root not found." >&2
	return 1
}
