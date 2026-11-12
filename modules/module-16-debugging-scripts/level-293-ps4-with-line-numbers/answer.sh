#!/usr/bin/env bash
# Single quotes matter: Bash expands PS4 each time it prints a trace line, so
# ${LINENO} is the line of the command being traced, not of this assignment.
PS4='+ L${LINENO}: '
set -x

for f in "$@"; do
  if [[ -e $f ]]; then
    echo "found: $f"
  else
    echo "missing: $f"
  fi
done
