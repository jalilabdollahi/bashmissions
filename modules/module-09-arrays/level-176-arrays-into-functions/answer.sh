#!/usr/bin/env bash
set -euo pipefail
web=()
db=()
past_separator=0
for arg in "$@"; do
  if [[ $arg == -- ]]; then
    past_separator=1
  elif (( past_separator )); then
    db+=("$arg")
  else
    web+=("$arg")
  fi
done

summarize() {
  # "list" is now another name for the array called $1. No copy is made;
  # reading ${list[@]} reads the caller's array. The reference must not be
  # called web or db, or it would point at itself.
  local -n list=$1
  if (( ${#list[@]} == 0 )); then
    echo "$1: 0 hosts"
  else
    echo "$1: ${#list[@]} hosts (first=${list[0]}, last=${list[-1]})"
  fi
}

summarize web
summarize db
