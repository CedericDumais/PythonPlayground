#!/usr/bin/env bash

# (wip)
# **TODO: Handle stopping the spinner on failure..
# 
# - Support inline updates (update_spinner_text) 
# - Other effects like blinking or color-fade
# 
# - Variables for <✓ or DONE or Done!> and default message

# ===== Utility Script: spinner.sh =====
# 
# Provides a lightweight spinner animation for CLI scripts.
#
# Usage:
# 	start_spinner "Doing something..."
#	long_running_task
#	stop_spinner $?
#
# Optionally set SPINNER_TEXT beforehand for default text
# 
# Designed to be *sourced* (not executed)
# ======================================

# Spinner characters
_SPINNER_CHARS='-\|/'

# Spinner process ID
_SPINNER_PID=""

# Displayed text (defaults to SPINNER_TEXT or fallback)
_SPINNER_TEXT="${SPINNER_TEXT:-Working...}"

# Function: start_spinner
# Starts the spinner in the background.
# Argument: message to display next to spinner (optional)
start_spinner() {
	local msg="${1:-$_SPINNER_TEXT}"

	# Save cursor position
	tput civis  # Hide cursor
	printf "%s " "$msg"

	# Start spinner animation in background
	(
		i=0
		while true; do
			printf "\b${_SPINNER_CHARS:i++%${#_SPINNER_CHARS}:1}"
			sleep 0.1
		done
	) &
	_SPINNER_PID=$!
	disown
}

# Function: stop_spinner
# Stops the spinner animation.
# Argument: exit code of the operation
# If 0, prints success ✓, else prints failure ✗
stop_spinner() {
	local exit_code=${1:-0}
	kill -9 $_SPINNER_PID 2>/dev/null
	wait $_SPINNER_PID 2>/dev/null

	# Replace spinner with success/fail symbol
	if [ $exit_code -eq 0 ]; then
		printf "\b${GREEN}✓${NC}\n"
	else
		printf "\b${RED}✗${NC}\n"
	fi

	tput cnorm  # Show cursor
}
