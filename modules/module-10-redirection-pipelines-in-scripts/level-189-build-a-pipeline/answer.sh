#!/usr/bin/env bash
set -euo pipefail
log=$1

if [[ ! -f $log ]]; then
  echo "log not found: $log" >&2
  exit 1
fi

# grep exits 1 when nothing matches, which pipefail would turn into a failure
# of the whole pipeline; "|| true" says "no match is fine here".
top=$( { grep -E '" 404 ' "$log" || true; } \
  | cut -d' ' -f1 \
  | sort \
  | uniq -c \
  | sort -rn \
  | head -n 3 \
  | awk '{ print $2 ": " $1 }' )

if [[ -z $top ]]; then
  echo "no 404 responses"
else
  echo "$top"
fi
