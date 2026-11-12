#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  echo "usage: solution.sh STEP..." >&2
  exit 2
fi

total=$#
n=0
for step in "$@"; do
  n=$(( n + 1 ))
  echo "step $n/$total: $step"

  # "cmd || rc=$?" is a tested command, so set -e does not kill us here and
  # we still get the real exit status in rc.
  rc=0
  bash "$step" || rc=$?

  if (( rc != 0 )); then
    echo "FAILED at step $n: $step (exit $rc)" >&2
    exit "$rc"          # the pipeline fails with the step's own code
  fi
done

echo "pipeline passed: $total step(s)"
