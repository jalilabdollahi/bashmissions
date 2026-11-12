#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 3 ]]; then
  echo "usage: solution.sh FILE REGION MIN_GB" >&2
  exit 2
fi

# -v hands shell values to awk as variables: no quoting accidents when the
# region contains a space. "$3 ~ regex" guards against "n/a" and empty cells,
# and "+ 0" makes both sides numbers so that 9 < 10 (as text, "9" > "10").
awk -F, -v region="$2" -v min="$3" '
  { sub(/\r$/, "") }
  NR == 1 { print; next }
  $2 == region &&
  $3 ~ /^[0-9]+(\.[0-9]+)?$/ &&
  $3 + 0 >= min + 0 &&
  $4 != "retired"
' "$1"
