#!/usr/bin/env bash

# ===== Utility Script: logging.sh =====
# 
# Logging utilities with optional timestamps.
# 
# Designed to be *sourced* (not executed)
# ANSI colors (assumes ansi-colors.sh has been sourced)
# 
# Bonus knobs (optional)
# - Set LOG_TS=1 globally to have timestamps everywhere.
# - Change format: LOG_TS_FMT="%H:%M:%S.%3N" (milliseconds) or "%Y-%m-%d %H:%M:%S".
# =======================================

# Accept common truthy forms: 1,true,yes,y,on (case-insensitive)
_is_truthy() {
    case "${1,,}" in
        1|true|yes|y|on) return 0 ;;
        *)               return 1 ;;
    esac
}

# Timestamp format is configurable (default HH:MM:SS)
: "${LOG_TS:=0}"            # off by default
: "${LOG_TS_FMT:=%H:%M:%S}" # override if you want different format

# Timestamp helper
_log_ts() {
    if _is_truthy "${LOG_TS:-0}"; then
        printf "[%s] " "$(date +"$LOG_TS_FMT")"
    fi
}

# Core loggers
log_info()		{ echo -e "$(_log_ts)${PURPLE}[☛]${NC} $*"; }
log_success()	{ echo -e "$(_log_ts)${GREEN}[✔]${NC} $*"; }
log_warn()		{ echo -e "$(_log_ts)${YELLOW}[!]${NC} $*"; }
log_error()		{ echo -e "$(_log_ts)${RED}[✖]${NC} $*" >&2; }
log_fatal()		{ log_error "$@"; exit 1; }

# ====================================
# --- Helpers to toggle timestamps ---
# ====================================

# One-liners:
ts_on()  { LOG_TS=1; }
ts_off() { LOG_TS=0; }

# Temporarily enable timestamps for a SINGLE command:
#   with_ts log_info "hello"
with_ts() {
    local _prev="${LOG_TS:-0}"
    LOG_TS=1
    "$@"
    local rc=$?
    LOG_TS="$_prev"
    return $rc
}

# Block-style push/pop (for multiple log calls):
#   ts_push; log_info "a"; log_warn "b"; ts_pop
ts_push() {
    # supports nesting via a simple stack in a string
    LOG_TS_STACK="${LOG_TS_STACK:-}|${LOG_TS:-0}"
    LOG_TS=1
}
ts_pop() {
    local last="${LOG_TS_STACK##*|}"
    LOG_TS_STACK="${LOG_TS_STACK%|*}"
    LOG_TS="${last:-0}"
}

# ----------------------------------------------------------------------------
# Example usage:

# # no timestamps (default)
# log_info     "info (no ts)"
# log_warn     "warn (no ts)"
# log_success  "success (no ts)"
# log_error    "error (no ts)"

# # one-liner with timestamp
# with_ts log_info "info (ts one-liner)"

# # block with timestamp
# ts_push
# log_info    "info (ts block)"
# log_warn    "warn (ts block)"
# log_success "success (ts block)"
# log_error   "error (ts block)"
# ts_pop

# # back to no timestamps
# log_info "info (back to no ts)"
