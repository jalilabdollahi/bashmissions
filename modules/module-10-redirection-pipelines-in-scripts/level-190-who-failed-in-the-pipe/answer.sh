#!/usr/bin/env bash
# No "set -e" / "pipefail": we inspect every stage ourselves.
fetch-logs | scrub-pii | ship-lines

# PIPESTATUS is rewritten by every command, including this assignment's
# own right-hand side, so copy it in ONE step, on the very next line.
status=("${PIPESTATUS[@]}")

echo "fetch=${status[0]} scrub=${status[1]} ship=${status[2]}"

names=(fetch-logs scrub-pii ship-lines)
for i in 0 1 2; do
  if (( status[i] != 0 )); then
    echo "pipeline failed at stage $(( i + 1 )) (${names[i]})" >&2
    exit 1
  fi
done
