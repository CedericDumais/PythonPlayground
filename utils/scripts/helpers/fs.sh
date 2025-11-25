#!/usr/bin/env bash

# ===== Utility Script: fs.sh =====
# 
# Filesystem helpers for portable scripts.
# 
# Designed to be *sourced* (not executed)
# =================================

ensure_executable() {
	local file="$1"
	[[ -x "$file" ]] || chmod +x "$file"
}


exists() {
	[[ -e "$1" ]]
}

# ensure_dir PATH — create if missing
ensure_dir() { [[ -d "$1" ]] || mkdir -p "$1"; }

# mktemp_dir — returns a new temp dir path
mktemp_dir() {
	local d
	d="$(mktemp -d 2>/dev/null || mktemp -d -t cg_tmp)"
	echo "$d"
}

# with_tempdir — create CG_TMPDIR and auto-clean it on exit/signals
with_tempdir() {
	local _cg_tmp
	_cg_tmp="$(mktemp_dir)" || return 1
	export CG_TMPDIR="$_cg_tmp"
	# Cleanup on normal exit or interruptions
	trap 'rm -rf "$CG_TMPDIR"' EXIT INT TERM
}
