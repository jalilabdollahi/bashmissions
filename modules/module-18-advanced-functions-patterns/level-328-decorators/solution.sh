#!/usr/bin/env bash
set -euo pipefail
# Decorator demo. solution.sh FUNCTION ARG
# decorate FN wraps FN: print ">> FN args", run the original, print "<< FN rc=N", keep the status.

restart_service() {
  echo "restarting $1"
  if [[ $1 == broken ]]; then return 3; fi
}
rotate_logs() { echo "rotated logs for $1"; }

# TODO 1: write decorate FN.
#         Get FN's source with declare -f (it fails if FN is not a function: report that and return 1).
#         Re-create the same body under another name, for example orig_FN.
#         Then redefine FN so it prints the ">>" line, calls orig_FN "$@", prints the "<<" line
#         and returns the original status. Remember the status of a failing call under set -e.
# TODO 2: decorate "$1", then call it with "$2".
