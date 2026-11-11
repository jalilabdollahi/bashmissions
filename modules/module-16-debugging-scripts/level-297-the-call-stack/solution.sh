#!/usr/bin/env bash
set -euo pipefail
# Log rotation with a broken-down call chain: nightly -> rotate_logs -> compress.
# Argument 1 is the mode (deep, shallow or top) that decides where stack runs.

# TODO: define stack(). Loop over the FUNCNAME array from index 1 (index 0 is
# stack itself) up to, but not including, the last entry ("main"), and print
#   "  at NAME, called from line N"   to stderr, N taken from BASH_LINENO.

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
