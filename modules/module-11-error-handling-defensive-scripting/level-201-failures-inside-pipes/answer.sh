#!/usr/bin/env bash
# With pipefail the pipeline fails if ANY stage fails (the status of the
# right-most failing stage). Without it, only sort's status would count.
set -o pipefail

if fetchlog "$1" | sort -u > summary.txt; then
  echo "summary ready: $(( $(wc -l < summary.txt) )) distinct lines"
else
  echo "fetch failed for $1" >&2
  exit 3
fi
