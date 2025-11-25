#!/usr/bin/env bash

# (wip)
# TODO: handle wrong input to loop ?

# ===== Utility Script: prompt.sh =====
# 
# Common interactive input helpers for scripts.
# 
# Designed to be *sourced* (not executed)
# =====================================

# yes_no "Prompt text" [default_y_or_n]
# Returns 0 for yes, 1 for no
yes_no() {
	local prompt="${1:?prompt text missing}"
	local def="${2:-y}"
	local ans
	read -r -p "$prompt [y/n] " ans
	ans="${ans:-$def}"
	[[ "$ans" =~ ^[Yy]$ ]]
}

# prompt_yes_no() {
# 	local message=\"$1\"
# 	local default=${2:-Y}
# 	read -r -p \"$message [Y/n]: \" response
# 	response=${response:-$default}
# 	[[ \"${response,,}\" =~ ^(y|yes)$ ]]
# }

# select_menu "Title" "opt1" "opt2" ...
# On success: sets SELECT_MENU_CHOICE to the chosen string and returns 0
# On failure: returns 1 (no selection / invalid)
select_menu() {
	local title="${1:?title missing}"; shift
	local i=0 opt
	echo "$title"
	for opt in "$@"; do
		printf " %2d) %s\n" "$i" "$opt"
		((i++))
	done
	local choice
	read -r -p "Enter choice: " choice
	if [[ "$choice" =~ ^[0-9]+$ && "$choice" -ge 0 && "$choice" -lt "$i" ]]; then
		# ${@:2} won't work since we shifted, use indirection:
		# The (choice+2) trick is only for Makefiles; here use a small loop:
		i=0
		for opt in "$@"; do
		if [[ $i -eq $choice ]]; then SELECT_MENU_CHOICE="$opt"; return 0; fi
			((i++))
		done
	fi
	return 1
}
