#!/usr/bin/env bash
set -euo pipefail

restart_service() {
  echo "restarting $1"
  if [[ $1 == broken ]]; then return 3; fi
}
rotate_logs() { echo "rotated logs for $1"; }

# The one generic wrapper. It receives the function name first, so a single
# copy of this code serves every decorated function.
traced() {
  local fn=$1 rc=0
  shift
  echo ">> $fn $*"
  "orig_$fn" "$@" || rc=$?       # `|| rc=$?` keeps set -e from exiting here
  echo "<< $fn rc=$rc"
  return "$rc"
}

decorate() {
  local fn=$1 def
  # declare -f prints "name () { body }" and fails for anything that is not a function.
  if ! def=$(declare -f "$fn"); then
    echo "decorate: no such function: $fn" >&2
    return 1
  fi
  # def starts with the function's name, so prefixing "orig_" renames it.
  eval "orig_$def"
  # New front door: same name, hands everything to the generic wrapper.
  eval "$fn() { traced $fn \"\$@\"; }"
}

decorate "$1"
"$1" "$2"
