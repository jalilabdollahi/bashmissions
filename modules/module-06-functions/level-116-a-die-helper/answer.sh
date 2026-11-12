#!/usr/bin/env bash
set -euo pipefail

# die CODE MESSAGE...  - report a fatal problem and stop the whole script.
die() {
  local code=$1
  shift                        # the rest of the arguments is the message
  echo "error: $*" >&2
  exit "$code"                 # exit (not return): we want the script to end
}

[[ $# -ge 1 ]] || die 2 "usage: solution.sh FILE"
file=$1

[[ -e $file ]] || die 3 "no such file: $file"
[[ -s $file ]] || die 4 "file is empty: $file"

# awk counts a final line even when it has no trailing newline; wc -l would not.
lines=$(awk 'END { print NR }' "$file")
echo "$file: $lines lines"
