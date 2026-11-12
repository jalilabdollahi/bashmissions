#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh LEVEL MESSAGE..." >&2
  exit 2
fi

level=$1
shift                      # what is left in "$@" is the message

stamp=$(date '+%Y-%m-%d %H:%M:%S')

# >> creates the file if needed and always writes at the end.
echo "[$stamp] $level: $*" >> ops.log

cat ops.log
