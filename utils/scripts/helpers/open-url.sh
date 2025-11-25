#!/usr/bin/env bash

# ===== Utility Script: open-url.sh =====
# 
# Opens a URL in the system’s default browser.

# open_url URL — opens URL with xdg-open (Linux) or open (macOS).
# Fails cleanly otherwise.
# 
# Designed to be *sourced* (not executed)
# ======================================

open_url() {
	local url="${1:-}"
	if [[ -z "$url" ]]; then
		echo -e "${RED}Error${NC}: missing URL" >&2
		return 2
	fi
	if command -v xdg-open >/dev/null 2>&1; then
		nohup xdg-open "$url" >/dev/null 2>&1 &
	elif command -v open >/dev/null 2>&1; then
		nohup open "$url" >/dev/null 2>&1 &
	else
		echo -e "${RED}Error${NC}: no opener found (xdg-open/open)" >&2
		return 1
	fi
}
