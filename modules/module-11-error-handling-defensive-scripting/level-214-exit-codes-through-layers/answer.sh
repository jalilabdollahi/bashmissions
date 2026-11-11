#!/usr/bin/env bash
# With pipefail, "lanternci | tee" fails when lanternci fails; the status is the
# right-most failing stage, and tee (which succeeds) cannot hide it.
set -o pipefail

run_stage() {
  local name=$1 status
  echo "[$name] start"
  lanternci "$name" 2>&1 | tee "$name.log"
  status=${PIPESTATUS[0]}      # lanternci's status, read right after the pipe
  if (( status != 0 )); then
    echo "[$name] failed with status $status" >&2
    return "$status"           # hand the same number to the caller
  fi
}

# "|| exit $?": $? still holds run_stage's status at that point.
run_stage build || exit $?
run_stage test  || exit $?
run_stage ship  || exit $?

echo "deployed"
