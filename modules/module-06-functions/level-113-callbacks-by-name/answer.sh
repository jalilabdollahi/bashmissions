#!/usr/bin/env bash
set -euo pipefail

upper_line() {
  echo "${1^^}"
}

length_line() {
  echo "$1: ${#1}"
}

# apply_each CALLBACK ITEM...
# A function name is just a word. Stored in a variable it can be called later.
apply_each() {
  local callback=$1 item
  shift                          # drop the callback; "$@" is now only the items
  for item in "$@"; do
    "$callback" "$item"          # run whichever function was named
  done
}

mode=${1:-}
[[ $# -gt 0 ]] && shift
case $mode in
  upper)  apply_each upper_line "$@" ;;
  length) apply_each length_line "$@" ;;
  *)      echo "unknown mode: $mode" >&2; exit 2 ;;
esac
