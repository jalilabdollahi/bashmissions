#!/usr/bin/env bash
set -euo pipefail

mw_trim() {
  local s=$1
  s=${s#"${s%%[![:space:]]*}"}      # drop leading whitespace
  s=${s%"${s##*[![:space:]]}"}      # drop trailing whitespace
  printf '%s' "$s"
}
mw_lower() { printf '%s' "${1,,}"; }
mw_squeeze() {
  local s=$1
  while [[ $s == *"  "* ]]; do s=${s//  / }; done   # halve double spaces until none are left
  printf '%s' "$s"
}
mw_mask() { printf '%s' "${1//[0-9]/#}"; }
mw_clip() { printf '%s' "${1:0:12}"; }

chain=("$@")

# Validate the whole chain up front: no output if any step is unknown.
for step in "${chain[@]}"; do
  if ! declare -F "mw_$step" > /dev/null; then
    echo "unknown middleware: $step" >&2
    exit 2
  fi
done

# IFS= and -r: take the line exactly as written (plain read would trim it).
while IFS= read -r line; do
  value=$line
  for step in "${chain[@]}"; do
    value=$("mw_$step" "$value")    # output of one step is input of the next
  done
  echo "[$value]"
done
