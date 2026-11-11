#!/usr/bin/env bash
set -euo pipefail

used="$1"
total="$2"

if (( total == 0 )); then
  echo "total must not be zero" >&2
  exit 2
fi

# Work in tenths of a percent: 37.5% is the integer 375.
# Multiply FIRST, then divide, so the fraction is not thrown away too early.
tenths=$(( used * 1000 / total ))

# Whole percent is tenths / 10; the decimal digit is what is left over.
echo "usage: $(( tenths / 10 )).$(( tenths % 10 ))%"
