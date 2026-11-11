#!/usr/bin/env bash
set -euo pipefail

# Succeeds (status 0) for a regular file whose size is zero.
# The status of the last command in the function becomes the function's status,
# so no explicit return is needed.
is_empty_file() {
  [[ -f $1 && ! -s $1 ]]
}

for f in "$@"; do
  if [[ ! -e $f ]]; then
    echo "$f: missing"
  elif is_empty_file "$f"; then      # the function IS the condition
    echo "$f: empty"
  else
    echo "$f: ok"
  fi
done
