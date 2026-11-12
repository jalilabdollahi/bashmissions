#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "usage: solution.sh LOG FROM TO" >&2
  exit 2
fi

# Inside [[ ]], > compares strings (in the C locale: byte by byte).
if [[ $2 > $3 ]]; then
  echo "error: FROM is after TO" >&2
  exit 1
fi

# ISO-8601 puts the biggest unit first and pads every field with zeros, all in
# one time zone (Z). Alphabetical order is therefore chronological order, and a
# shorter bound like "2026-03-04" is simply a smaller prefix.
awk -v from="$2" -v to="$3" '
  { sub(/\r$/, "") }
  $0 == "" { next }
  $1 !~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]Z$/ {
    printf "skipped line %d\n", NR > "/dev/stderr"
    next
  }
  $1 >= from && $1 < to
' "$1"
