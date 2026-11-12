#!/usr/bin/env bash
set -euo pipefail

# Prints to stderr only when DEBUG=1. ${DEBUG:-} is empty instead of an
# "unbound variable" error when the variable does not exist (set -u).
# An if, not "[[ ... ]] && echo ...": that form returns 1 when the test is
# false, and a function whose last command fails would stop the script (set -e).
debug() {
  if [[ ${DEBUG:-} == 1 ]]; then
    echo "debug: $*" >&2
  fi
}

debug "sites=$2"
first=8000
last=$(( first + 2 * $2 - 1 ))
debug "last=$last"
echo "$1 uses ports $first-$last"
