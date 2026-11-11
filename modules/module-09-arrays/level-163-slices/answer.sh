#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh OFFSET SIZE [MACHINE...]" >&2
  exit 2
fi
offset=$1
size=$2
shift 2

machines=("$@")

# Slice: ${array[@]:start:count}. Variables are fine for both numbers, and a
# negative start counts from the end. The slice is a fresh list of words;
# "machines" itself is not touched.
wave=("${machines[@]:offset:size}")

# printf with an empty list would print one blank line, so guard it.
if (( ${#wave[@]} > 0 )); then
  printf '%s\n' "${wave[@]}"
fi
