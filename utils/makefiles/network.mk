

# ==============================
# Network Utility Macros
# ==============================
ifndef __NETWORK_MK__
__NETWORK_MK__ := 1

# IRC_SERVER_IP	:= 
# IRC_SERVER_PORT	:= 
# BACKEND_PORT	:= 

# Macro: CHECK_CONNECTION
# Checks network connectivity to a specific IP and Port
# 
# Parameters:
# $(1): IP address to check.
# $(2): Port number to check.
# 
# Behavior:
# Uses nc -z to check connectivity to the given IP and port.
# If unreachable, an error message is displayed, and the script exits with status 1.
# 
# Example Usage:
# $(call CHECK_CONNECTION,$(IRC_SERVER_IP),$(IRC_SERVER_PORT))
# 
define CHECK_CONNECTION
	if ! nc -z $(1) $(2); then \
		$(call ERROR,Connection Error,Unable to reach $(1):$(2).\nCheck if the server is running.); \
		exit 1; \
	fi
endef

# **************************************************************************** #

# Macro: WAIT_FOR_CONNECTION
# Waits for a specific IP and port to become available before proceeding
# 
# Parameters:
# $(1): IP address to wait for.
# $(2): Port number to wait for.
# 
# Behavior:
# Continuously checks the IP and port using nc -z.
# Displays an info message every second while waiting.
# Once reachable, displays a success message.
# 
# Example Usage:
# $(call WAIT_FOR_CONNECTION,$(IRC_SERVER_IP),$(IRC_SERVER_PORT))
# 
define WAIT_FOR_CONNECTION
	while ! nc -z $(1) $(2); do \
		$(call INFO,Connection,,Waiting for $(1):$(2) to become available...); \
		sleep 1; \
		$(call UPCUT); \
	done
	@$(call SUCCESS,Connection,$(1):$(2) is now reachable!)
endef

# **************************************************************************** #

# Macro: IS_PORT_IN_USE
# Checks whether a specific port is currently in use.
#
# Parameters:
# $(1): Port number to check.
#
# Behavior:
# - If `lsof` exists, checks for processes using the port.
# - Otherwise, if `netstat` exists, checks for active listeners on the port.
# - If neither tool exists, it prints a **warning** and returns **2**.
#
# Exit Codes:
# - `0` → Port is **in use**.
# - `1` → Port is **free**.
# - `2` → Port check **could not be performed**.
#
# Example Usage:
# if $(call IS_PORT_IN_USE,$(BACKEND_PORT)); then echo "Port is occupied!"; fi
#
define IS_PORT_IN_USE
	if $(call IS_COMMAND_AVAILABLE,lsof); then \
		lsof -t -i :$(1) > /dev/null 2>&1; \
	elif $(call IS_COMMAND_AVAILABLE,netstat); then \
		netstat -an | grep -q ":$(1) .*LISTEN"; \
	else \
		$(call WARNING,Port Check,Neither 'lsof' nor 'netstat' is available. Skipping check.); \
		exit 2; \
	fi
endef

# **************************************************************************** #

# Macro: CHECK_PORT
# Checks if a specific port is in use and optionally prints a message.
#
# Parameters:
# $(1): Port number to check.
# $(2): (Optional) Use `"print"` to display port availability.
#
# Behavior:
# - Calls `IS_PORT_IN_USE` to check if the port is occupied.
# - If the port is in use, prints an **error message** and exits (`1`).
# - If the port is free and `"print"` is passed, prints a **success message**.
# - If neither `lsof` nor `netstat` is available, prints a **warning** and exits (`2`).
#
# Example Usage:
# $(call CHECK_PORT,$(BACKEND_PORT))          # Exits if port is in use.
# $(call CHECK_PORT,$(BACKEND_PORT),print)    # Prints availability if port is free.
#
define CHECK_PORT
	IS_USED=$$( $(call IS_PORT_IN_USE,$(1)) ); \
	if [ "$$IS_USED" -eq 0 ]; then \
		$(call ERROR,Port already in use,$(1)); \
		exit 1; \
	elif [ "$$IS_USED" -eq 2 ]; then \
		$(call WARNING,Port $(1),Could not determine if the port is in use. Skipping check.); \
		exit 2; \
	elif [ "$(2)" = "print" ]; then \
		$(call SUCCESS,Port $(1),Port is available.); \
	fi
endef

# **************************************************************************** #

# Macro: KILL_PROCESS_ON_PORT
# Terminates all processes using a specific port.
# 
# Parameters:
# $(1): Port number to use for the kill signal
# $(2): (Optional) Use "print" to display killed process IDs.
#
# Behavior:
# - Checks if any processes are using the given port using `lsof`.
# - If found, terminates them using `kill -9`.
# - If "print" is passed as the second parameter:
#   - Lists all process IDs before terminating them.
# - Provides success and error messages for clarity.
# 
# Example Usage:
# $(call KILL_PROCESS_ON_PORT,$(BACKEND_PORT))        # Kills but doesn't print PIDs.
# $(call KILL_PROCESS_ON_PORT,$(BACKEND_PORT),print)  # Kills and prints all PIDs first.
# 
define KILL_PROCESS_ON_PORT
	PIDS=$$(lsof -t -i :$(1)); \
	if [ -n "$$PIDS" ]; then \
		$(call INFO,Port $(1),Killing process(es) using port $(1):); \
		if [ "$(2)" = "print" ]; then \
			for PID in $$PIDS; do \
				echo "\t\t$(ORANGE)$$PID$(RESET)"; \
			done; \
		fi; \
		kill -9 $$PIDS; \
		$(call SUCCESS,Port $(1),All processes on port $(1) have been killed.); \
	else \
		$(call WARNING,Port $(1),No process is using port $(1).); \
	fi
endef
# $(call INFO,Port $(1),- Process $(ORANGE)$$PID$(RESET)); \


# # Macro: KILL_PROCESS_ON_PORT
# # Terminates all processes using a specific port (shares core with name-kill).
# #
# # Params:
# #  $(1): Port number
# #  $(2): Optional "print" to list PIDs before killing
# #
# define KILL_PROCESS_ON_PORT
# 	$(call CHECK_COMMAND,lsof)
# 	$(call __KILL_WITH_FINDER,Port $(1),Killing process(es) using port $(1):,lsof -t -i :$(1),$(2),All processes on port $(1) have been killed.,No process is using port $(1).)
# endef

endif # __NETWORK_MK__
