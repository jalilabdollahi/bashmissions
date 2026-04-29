#!/usr/bin/env bash
set -euo pipefail

workspace="$1"
cd "$workspace"

plain=$(bash solution.sh)
if [[ "$plain" != "no pipe" ]]; then
  echo "Expected no pipe without piped stdin, got: $plain"
  exit 1
fi

piped=$(printf 'red
blue
green
' | bash solution.sh)
if [[ "$piped" != "pipe: 3 lines" ]]; then
  echo "Expected pipe: 3 lines with piped stdin, got: $piped"
  exit 1
fi

echo "pipe detection works"
