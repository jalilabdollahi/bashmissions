#!/usr/bin/env bash
set -euo pipefail

# Prints the chain of functions that led here. Index 0 of FUNCNAME is stack
# itself; entry i is called from the line BASH_LINENO[i]. The last FUNCNAME
# entry is the pseudo-function "main" (the script's top level): skip it.
stack() {
  local i
  for (( i = 1; i < ${#FUNCNAME[@]} - 1; i++ )); do
    echo "  at ${FUNCNAME[i]}, called from line ${BASH_LINENO[i]}" >&2
  done
}

compress() {
  if [[ $1 == deep ]]; then
    stack
  fi
  : # the real compression would happen here
}

rotate_logs() {
  if [[ $1 == shallow ]]; then
    stack
  fi
  compress "$1"
}

nightly() {
  rotate_logs "$1"
}

if [[ $1 == top ]]; then
  stack
else
  nightly "$1"
fi
echo "rotation finished"
