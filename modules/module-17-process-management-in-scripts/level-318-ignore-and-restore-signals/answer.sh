#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1

# An empty command means "ignore this signal".
trap '' TERM
kill -TERM $$            # nothing happens: the signal is thrown away
echo "shielded $name"

# Ignored signals are inherited across fork and exec, so the worker
# cannot be killed by its own TERM either.
status=0
worker || status=$?
echo "phase 1 ($name): status $status"

# "-" puts the default action back (terminate).
trap - TERM

status=0
worker || status=$?
echo "phase 2 ($name): status $status"
