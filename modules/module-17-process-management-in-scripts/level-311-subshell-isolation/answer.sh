#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LABEL" >&2
  exit 2
fi
label=$1

LOG_LEVEL=info
export LOG_LEVEL

# Everything between ( and ) runs in a copy of this shell. Changes to
# variables, and the exit 7, only affect that copy.
status=0
(
  export LOG_LEVEL=debug
  export PROBE_LABEL=$label
  probe
  exit 7
) || status=$?
echo "subshell exited with $status"

# Back in the original shell: nothing changed.
probe
echo "main LOG_LEVEL=$LOG_LEVEL"
