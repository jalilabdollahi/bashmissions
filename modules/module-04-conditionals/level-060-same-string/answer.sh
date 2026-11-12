#!/usr/bin/env bash
set -euo pipefail

expected="$1"
running="$2"

# Quotes on the RIGHT side of == switch pattern matching off, so a tag
# such as "*" is compared as the one-character string it is.
if [[ $running == "$expected" ]]; then
  echo "in sync: $running"
else
  echo "DRIFT: expected $expected but found $running"
fi
