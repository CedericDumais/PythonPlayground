#!/usr/bin/env bash

# ===== Utility Script: ansi-colors.sh =====
# 
# Provides ANSI escape sequences for colorful terminal output.
# 
# Honors NO_COLOR=1 (or non-TTY) to disable colors automatically.
# 
# Designed to be *sourced* (not executed)
# ==========================================

# If NO_COLOR=1 or stdout isn't a TTY, strip all colors.
: "${NO_COLOR:=0}"
if [[ "$NO_COLOR" == "1" || ! -t 1 ]]; then
	NC='' RED='' GREEN='' YELLOW='' BLUE='' PURPLE='' CYAN='' WHITE=''
	ORANGE='' PINK='' PINK_HOT='' PINK_LIGHT='' PINK_PASTEL=''
	BRED='' BGREEN='' BYELLOW='' BBLUE='' BPURPLE='' BCYAN='' BWHITE=''
else
	# Text Reset
	readonly NC='\033[0m' # No Color

	# Regular Colors
	readonly RED='\033[0;31m'
	readonly GREEN='\033[0;32m'
	readonly YELLOW='\033[0;33m'
	readonly BLUE='\033[0;34m'
	readonly PURPLE='\033[0;35m'
	readonly CYAN='\033[0;36m'
	readonly WHITE='\033[0;37m'

	# 256-color examples
	readonly ORANGE='\033[0;38;5;208m'
	readonly PINK='\033[0;38;5;205m'
	readonly PINK_HOT='\033[0;38;5;198m'
	readonly PINK_LIGHT='\033[0;38;5;200m'
	readonly PINK_PASTEL='\033[0;38;5;219m'

	# Bold
	readonly BRED='\033[1;31m'
	readonly BGREEN='\033[1;32m'
	readonly BYELLOW='\033[1;33m'
	readonly BBLUE='\033[1;34m'
	readonly BPURPLE='\033[1;35m'
	readonly BCYAN='\033[1;36m'
	readonly BWHITE='\033[1;37m'
fi
