#!/usr/bin/env bash
# File: utils/scripts/helpers/case.sh

# TODO: add dot.case, path/case, etc

# ===== Utility Script: case.sh =====
# 
# Case/identifier normalization helpers.
# 
# Designed to be *sourced* (not executed)
# ----------------------------------------------------------------------------

# Include guard
[[ -n "${__CASE_HELPERS_SH__:-}" ]] && return 0
__CASE_HELPERS_SH__=1

# ──────────────────────────────────────────────────────────────────────────────
# -------- Core tokenizer ------------------------------------------------------

# Convert arbitrary input to snake_case tokens (lowercased)
# Handles CamelCase, acronyms, digits, spaces, dashes, dots, etc.
name_to_snake() {
  local input=$1
  printf '%s' "$input" \
  | sed -E '
      s/[^A-Za-z0-9]+/_/g;                       # non-alnum -> _
      s/([A-Z]+)([A-Z][a-z])/\1_\2/g;            # ABCd -> AB_Cd  (acronyms)
      s/([a-z0-9])([A-Z])/\1_\2/g;               # aB  -> a_B     (camel)
      s/_+/_/g; s/^_+//; s/_+$//;                # collapse/trim _
    ' \
  | tr '[:upper:]' '[:lower:]'
}

# ──────────────────────────────────────────────────────────────────────────────
# -------- Internals -----------------------------------------------------------

# __tokenize_args ARGS...
# Normalize raw args -> __SNAKE (string) and __TOKENS (array, lowercased).
__tokenize_args() {
  __SNAKE="$(name_to_snake "$*")"
  IFS='_' read -r -a __TOKENS <<< "$__SNAKE"
}

# __join_with SEP TOKENS...
# Join tokens with the given separator. Returns empty string if no tokens.
__join_with() {
  local sep=$1; shift
  local out="" first=1
  for x in "$@"; do
    if (( first )); then out="$x"; first=0
    else out="$out$sep$x"
    fi
  done
  printf '%s' "$out"
}

# __cap_first WORD
# Uppercase first character, lowercase the rest (ASCII-only). "hTTP" -> "Http".
__cap_first() {
  local w=$1
  local first=${w:0:1}
  local rest=${w:1}
  first=$(printf '%s' "$first" | tr '[:lower:]' '[:upper:]')
  rest=$(printf '%s' "$rest" | tr '[:upper:]' '[:lower:]')
  printf '%s%s' "$first" "$rest"
}

# ──────────────────────────────────────────────────────────────────────────────
# -------- Public: each accepts RAW input directly (no pre-processing) ---------

# Concatenate tokens with no separator. "Example Class" -> "exampleclass".
to_compact() {
  __tokenize_args "$@"
  printf '%s' "${__TOKENS[@]}"
}

# snake_case (lowercase with underscores). -> "example_class_name".
to_snake() {
  __tokenize_args "$@"
  printf '%s' "$__SNAKE"
}

# kebab-case (lowercase with hyphens). -> "example-class-name".
to_kebab() {
  __tokenize_args "$@"
  __join_with "-" "${__TOKENS[@]}"
}

# dot.case (lowercase with dots). -> "example.class.name".
to_dot() {
  __tokenize_args "$@"
  __join_with "." "${__TOKENS[@]}"
}

# path/case (lowercase with slashes). -> "example/class/name".
to_path() {
  __tokenize_args "$@"
  __join_with "/" "${__TOKENS[@]}"
}

# Space-separated lowercase words. -> "example class name".
to_space_lower() {
  __tokenize_args "$@"
  __join_with " " "${__TOKENS[@]}"
}

# PascalCase (capitalize each token, no separators). -> "ExampleClassName".
to_pascal() {
  __tokenize_args "$@"
  local out="" w
  for w in "${__TOKENS[@]}"; do out+="$(__cap_first "$w")"; done
  printf '%s' "$out"
}

# camelCase (lower first token, then Pascal for the rest). -> "exampleClassName".
to_camel() {
  __tokenize_args "$@"
  local out="" w i=0
  for w in "${__TOKENS[@]}"; do
    if (( i==0 )); then out+="$w"
    else out+="$(__cap_first "$w")"
    fi
    ((i++))
  done
  printf '%s' "$out"
}

# SCREAMING_SNAKE_CASE (uppercase snake). -> "EXAMPLE_CLASS_NAME".
to_screaming_snake() {
  __tokenize_args "$@"
  printf '%s' "$__SNAKE" | tr '[:lower:]' '[:upper:]'
}

# UPPERFLAT (uppercase with no separators). -> "EXAMPLECLASSNAME".
to_upper_flat() {
  __tokenize_args "$@"
  to_compact "${__TOKENS[@]}" | tr '[:lower:]' '[:upper:]'
}

# Title Case with spaces. -> "Example Class Name".
to_title_spaces() {
  __tokenize_args "$@"
  local out="" w first=1
  for w in "${__TOKENS[@]}"; do
    if (( first )); then out="$(__cap_first "$w")"; first=0
    else out="$out $(__cap_first "$w")"
    fi
  done
  printf '%s' "$out"
}

# Train-Case (Title-Case with hyphens). -> "Example-Class-Name".
to_train_case() {
  __tokenize_args "$@"
  local out="" w first=1
  for w in "${__TOKENS[@]}"; do
    if (( first )); then out="$(__cap_first "$w")"; first=0
    else out="$out-$(__cap_first "$w")"
    fi
  done
  printf '%s' "$out"
}

# # --- "Mixed" separators with capitalization rules

# Pascal_Snake_Case (capitalized tokens with underscores). -> "Example_Class_Name".
to_pascal_snake() {
  __tokenize_args "$@"
  local out="" w first=1
  for w in "${__TOKENS[@]}"; do
    if (( first )); then out="$(__cap_first "$w")"; first=0
    else out="${out}_$(__cap_first "$w")"
    fi
  done
  printf '%s' "$out"
}

# camel_Snake_Case (lower first token, then capitalized tokens with underscores). -> "example_Class_Name".
to_camel_snake() {
  __tokenize_args "$@"
  local out="" w i=0
  for w in "${__TOKENS[@]}"; do
    if (( i==0 )); then out+="$w"
    else out+="_$(__cap_first "$w")"
    fi
    ((i++))
  done
  printf '%s' "$out"
}

# --- Title.Dots and Train.Case with dots

# Dot.Title.Case (capitalized tokens with dots). -> "Example.Class.Name".
to_dot_title() {
  __tokenize_args "$@"
  local out="" w first=1
  for w in "${__TOKENS[@]}"; do
    if (( first )); then out="$(__cap_first "$w")"; first=0
    else out="$out.$(__cap_first "$w")"
    fi
  done
  printf '%s' "$out"
}

# --- C/C++/C# namespace-like

# Pascal::Namespace. -> "Example::Class::Name".
to_cpp_namespace_pascal() {
  __tokenize_args "$@"
  local out="" w first=1
  for w in "${__TOKENS[@]}"; do
    if (( first )); then out="$(__cap_first "$w")"; first=0
    else out="$out::$(__cap_first "$w")"
    fi
  done
  printf '%s' "$out"
}

# lower::namespace. -> "example::class::name".
to_cpp_namespace_lower() {
  __tokenize_args "$@"
  local out="" w first=1
  for w in "${__TOKENS[@]}"; do
    if (( first )); then out="$w"; first=0
    else out="$out::$w"
    fi
  done
  printf '%s' "$out"
}

# ──────────────────────────────────────────────────────────────────────────────
# -------- C Symbols (w.i.p.) --------------------------------------------------


# Sanitize to a valid C identifier: map non [A-Za-z0-9_] to '_'; prefix '_' if it starts with a digit.
# "1st value!" -> "_1st_value_".
to_c_symbol() {
  # Using snake gives us [a-z0-9_]* already; still sanitize + digit-guard.
  __tokenize_args "$@"
  local s="$__SNAKE"
  s=$(printf '%s' "$s" | sed -E 's/[^A-Za-z0-9_]/_/g')
  [[ $s =~ ^[0-9] ]] && s="_$s"
  printf '%s' "$s"
}

to_c_symbol_lower() {
  local s="$*"
  s=$(printf '%s' "$s" | sed -E 's/[^A-Za-z0-9_]/_/g' | tr '[:upper:]' '[:lower:]')
  [[ $s =~ ^[0-9] ]] && s="_$s"
  printf '%s' "$s"
}

# Uppercase C symbol (rarely used except for macro-like identifiers)
to_c_symbol_upper() {
  __tokenize_args "$@"
  local s="$__SNAKE"
  # local s="$*"
  s=$(printf '%s' "$s" | tr '[:lower:]' '[:upper:]')
  [[ $s =~ ^[0-9] ]] && s="_$s"
  printf '%s' "$s"
}

to_c_symbol_upper2() {
  local s="$*"
  s=$(printf '%s' "$s" | sed -E 's/[^A-Za-z0-9_]/_/g' | tr '[:lower:]' '[:upper:]')
  [[ $s =~ ^[0-9] ]] && s="_$s"
  printf '%s' "$s"
}

# Preserve original letter case; just sanitize to [A-Za-z0-9_], digit-guard.
to_c_symbol_preserve() {
  local s="$*"
  s=$(printf '%s' "$s" | sed -E 's/[^A-Za-z0-9_]/_/g')
  [[ $s =~ ^[0-9] ]] && s="_$s"
  printf '%s' "$s"
}

# Preserve original letter case; just sanitize to [A-Za-z0-9_], digit-guard.
# Collapse multiple '_' and trim ends.
to_c_symbol_preserve2() {
  local s="$*"
  s=$(printf '%s' "$s" | sed -E 's/[^A-Za-z0-9_]+/_/g; s/^_+//; s/_+$//')
  [[ $s =~ ^[0-9] ]] && s="_$s"
  printf '%s' "$s"
}

# Preserve case but produce a valid C identifier:
# - map non [A-Za-z0-9_] -> '_'
# - collapse multiple '_'
# - trim leading/trailing '_'
# - add a safe prefix maybe? (like "mod_")
to_c_symbol_preserve3() {
  local s="$*"
  s="$(printf '%s' "$s" | sed -E 's/[^A-Za-z0-9_]+/_/g; s/_+/_/g; s/^_+//; s/_+$//')"
  # Optional: guard if it starts with a digit
  [[ $s =~ ^[A-Za-z] ]] || s="mod_${s}"
  printf '%s' "$s"
}

# Drop punctuation instead of replacing it.
to_c_symbol_drop() {
  local s="$*"
  s=$(printf '%s' "$s" | sed -E 's/[^A-Za-z0-9_]+//g')
  [[ $s =~ ^[0-9] ]] && s="_$s"
  printf '%s' "$s"
}

# --- Aliases

# Alias of SCREAMING_SNAKE_CASE. -> "EXAMPLE_CONSTANT".
to_constant() {
  to_screaming_snake "$@"
}
