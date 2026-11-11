#!/usr/bin/env bash
# Existence checker for a list of paths. Each argument is reported as found or
# missing, and the trace must tell us which line of this file each command is.

# TODO 1: choose the trace prefix: PS4 (single quotes!) with the line number.
# TODO 2: switch tracing on.

for f in "$@"; do
  if [[ -e $f ]]; then
    echo "found: $f"
  else
    echo "missing: $f"
  fi
done
