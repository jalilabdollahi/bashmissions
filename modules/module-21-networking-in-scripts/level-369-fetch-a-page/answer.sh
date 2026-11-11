#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1

# -s: no progress meter, no error text. We write our own message instead.
# The "if !" keeps set -e from ending the script before we can explain.
if ! text=$(curl -s "https://status.lanternfish.example/components/$name.txt"); then
  echo "status page unreachable" >&2
  exit 1
fi

# ${text:-...} also covers the empty-page case.
printf '%s: %s\n' "$name" "${text:-no data}"
