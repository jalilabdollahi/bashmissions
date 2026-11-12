#!/usr/bin/env bash
set -euo pipefail

host="$1"

# A guard clause: deal with the wrong case first and leave early,
# so the real work below needs no extra indentation.
if [[ $host != dory ]]; then
  echo "refusing to run on $host: this job belongs to dory" >&2
  exit 1
fi

echo "dory: starting nightly report"
