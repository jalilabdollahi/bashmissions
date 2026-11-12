#!/usr/bin/env bash
# No "set -e": the guards return non-zero on purpose and the script passes the
# number on with "exit $?".

set_quota() {
  local name=${1:-} gb=${2:-}

  # Guard clauses: reject the bad cases first, each with its own early return.
  if [[ -z $name ]]; then
    echo "error: name required" >&2
    return 2
  fi
  if ! [[ $gb =~ ^[0-9]+$ ]]; then
    echo "error: GB must be a number" >&2
    return 3
  fi
  if (( gb < 1 || gb > 100 )); then
    echo "error: GB must be 1-100" >&2
    return 4
  fi

  # Happy path: by now every input is known to be good, and nothing is nested.
  echo "quota set: $name ${gb}GB"
}

set_quota "${1:-}" "${2:-}"
exit $?
