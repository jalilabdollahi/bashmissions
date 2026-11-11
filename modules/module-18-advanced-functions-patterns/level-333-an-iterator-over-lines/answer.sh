#!/usr/bin/env bash
set -euo pipefail

file=$1

if [[ ! -r $file ]]; then
  echo "lines: cannot read '$file'" >&2
  exit 1
fi

mapfile -t lines < "$file"
cursor=0                     # index of the next line to hand out

# The iterator: state is (lines, cursor). Status 1 means "exhausted".
next_line() {
  (( cursor < ${#lines[@]} )) || return 1
  LINE=${lines[cursor]}
  cursor=$(( cursor + 1 ))
}

while next_line; do
  name=$LINE
  start=$cursor              # cursor is now 1-based position of the name's line
  if ! { next_line && plan=$LINE && next_line && price=$LINE; }; then
    echo "incomplete record starting at line $start" >&2
    exit 1
  fi
  echo "$name: $plan plan, $price EUR/month"
done
