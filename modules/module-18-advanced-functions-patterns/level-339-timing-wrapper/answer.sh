#!/usr/bin/env bash
set -euo pipefail

timed() {
  local start end rc=0 ms
  start=${EPOCHREALTIME/./}            # 1700000000.123456 -> 1700000000123456 (microseconds)
  "$@" || rc=$?                        # keep the status; a failure must not skip the report
  end=${EPOCHREALTIME/./}
  ms=$(( (end - start) / 1000 ))
  # "$*" joins the command words with spaces, which is what the report wants.
  printf 'timed: %s took %d.%03ds\n' "$*" $(( ms / 1000 )) $(( ms % 1000 )) >&2
  return "$rc"
}

if (( $# == 0 )); then
  echo "usage: solution.sh COMMAND [ARG...]" >&2
  exit 2
fi

status=0
timed "$@" || status=$?
exit "$status"
