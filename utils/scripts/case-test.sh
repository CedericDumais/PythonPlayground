#!/usr/bin/env bash
# File: utils/scripts/case-test.sh

set -Eeuo pipefail

# ===== Script: case-test.sh =====
# 
# Script to test input normalization.
# 
# ------------------------------------------------------------------------------

# ──────────────────────────────────────────────────────────────────────────────
# -------- Shared utility sourcing ---------------------------------------------
# Locate the project root via '.project-root' or '.git'
find_project_root() {
    local dir="$PWD"
    while [[ "$dir" != "/" ]]; do
        [[ -f "$dir/.project-root" ]] && { echo "$dir"; return 0; }
        [[ -d "$dir/.git" ]] && { echo "$dir"; return 0; }
        dir="$(dirname "$dir")"
    done
    echo "Error: .project-root not found." >&2
    return 1
}
PROJECT_ROOT="$(find_project_root)" || exit 1

# Source all shared utilities through the aggregator
source "$PROJECT_ROOT/utils/scripts/helpers/common.sh"
# ------------------------------------------------------------------------------

# ──────────────────────────────────────────────────────────────────────────────
# ---- Input & normalization ---------------------------------------------------
read -rp "Enter an example class name (e.g., ExampleClass or example_class): " USER_INPUT
if [[ -z "${USER_INPUT:-}" ]]; then
    log_fatal "Class name cannot be empty. Exiting"
fi

# --- Derivatives --------------------------------------------------------------
FLAT="$(to_compact "${USER_INPUT}")"                           # exampleclass
UPPER="$(to_upper_flat "${USER_INPUT}")"                       # EXAMPLECLASS
CAMEL="$(to_camel "${USER_INPUT}")"                            # exampleClass
PASCAL="$(to_pascal "${USER_INPUT}")"                          # ExampleClass
SNAKE="$(to_snake "${USER_INPUT}")"                            # example_class
SCREAMIN_SNAKE="$(to_screaming_snake "${USER_INPUT}")"         # EXAMPLE_CLASS
CAMEL_SNAKE="$(to_camel_snake "${USER_INPUT}")"                # example_Class
PASCAL_SNAKE="$(to_pascal_snake "${USER_INPUT}")"              # example_Class
TITLE="$(to_title_spaces "${USER_INPUT}")"                     # Example Class
KEBAB="$(to_kebab "${USER_INPUT}")"                            # example-class
TRAIN="$(to_train_case "${USER_INPUT}")"                       # Example-Class
DOT="$(to_dot "${USER_INPUT}")"                                # example.class
DOT_TITLE="$(to_dot_title "${USER_INPUT}")"                    # Example.Class
PATH_CASE="$(to_path "${USER_INPUT}")"                         # example/path
NAMESPACE_PASCAL="$(to_cpp_namespace_pascal "${USER_INPUT}")"  # Example::Class
NAMESPACE_LOWER="$(to_cpp_namespace_lower "${USER_INPUT}")"    # example::class

echo -e "${CYAN}→ Resolved names:${NC}
  flatcase            = ${GREEN}${FLAT}${NC}
  UPPERCASE           = ${GREEN}${UPPER}${NC}
  camelCase           = ${GREEN}${CAMEL}${NC}
  PascalCase          = ${GREEN}${PASCAL}${NC}
  snake_case          = ${GREEN}${SNAKE}${NC}
  SCREAMIN_SNAKE_CASE = ${GREEN}${SCREAMIN_SNAKE}${NC}
  camel_Snake_Case    = ${GREEN}${CAMEL_SNAKE}${NC}
  Pascal_Snake_Case   = ${GREEN}${PASCAL_SNAKE}${NC}
  Title Case          = ${GREEN}${TITLE}${NC}
  kebab-case          = ${GREEN}${KEBAB}${NC}
  Train-Case          = ${GREEN}${TRAIN}${NC}
  dot.case            = ${GREEN}${DOT}${NC}
  Dot.Title.Case      = ${GREEN}${DOT_TITLE}${NC}
  path/case           = ${GREEN}${PATH_CASE}${NC}
  Pascal::Namespace   = ${GREEN}${NAMESPACE_PASCAL}${NC}
  lower::namespace    = ${GREEN}${NAMESPACE_LOWER}${NC}"

# --- C symbols (tests) --------------------------------------------------------

C_SYMBOL="$(to_c_symbol "${USER_INPUT}")"                      # _1Example
C_SYMBOL_LOWER="$(to_c_symbol_lower "${USER_INPUT}")"          # _1Example
C_SYMBOL_UPPER="$(to_c_symbol_upper "${USER_INPUT}")"          # _1Example
C_SYMBOL_UPPER2="$(to_c_symbol_upper2 "${USER_INPUT}")"        # _1Example
C_SYMBOL_PRESERVE="$(to_c_symbol_preserve "${USER_INPUT}")"    # _1Example
C_SYMBOL_PRESERVE2="$(to_c_symbol_preserve2 "${USER_INPUT}")"  # _1Example
C_SYMBOL_PRESERVE3="$(to_c_symbol_preserve3 "${USER_INPUT}")"  # _1Example
C_SYMBOL_DROP="$(to_c_symbol_drop "${USER_INPUT}")"            # _1Example

echo -e "${CYAN}→ C Symbols (W.I.P):${NC}
  _1c_symbol           = ${GREEN}${C_SYMBOL}${NC}
  _1c_symbol_lower     = ${GREEN}${C_SYMBOL_LOWER}${NC}
  _1C_SYMBOL_UPPER_    = ${GREEN}${C_SYMBOL_UPPER}${NC}
  _1C_SYMBOL_UPPER_    = ${GREEN}${C_SYMBOL_UPPER2}${NC}
  _1c_SyMbol_preserVe  = ${GREEN}${C_SYMBOL_PRESERVE}${NC}
  _1c_SyMbol_preserVe2 = ${GREEN}${C_SYMBOL_PRESERVE2}${NC}
  _1c_SyMbol_preserVe3 = ${GREEN}${C_SYMBOL_PRESERVE3}${NC}
  _1c_symbol_drop      = ${GREEN}${C_SYMBOL_DROP}${NC}"

# --- Entry Symbol (To use with '*.gdextension' template files) ----------------

ENTRY_SYMBOL="$(to_c_symbol "${USER_INPUT}_init")"             # exampleclass_init * (for .gdextension file..)

echo -e "${CYAN}→ GDExtension entry symbol:${NC}
  GDextension entry symbol = ${GREEN}${ENTRY_SYMBOL}${NC}"

# --------------------------------------------------------------------------------
