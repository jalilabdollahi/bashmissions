#!/usr/bin/env bash
set -euo pipefail

workspace="$1"
shift

stdout_file="$(mktemp)"
stderr_file="$(mktemp)"
trap 'rm -f "$stdout_file" "$stderr_file"' EXIT

"$workspace/solution.sh" "$@" >"$stdout_file" 2>"$stderr_file"

stdout="$(cat "$stdout_file")"
stderr="$(cat "$stderr_file")"
expected="Error: ${1:-}"

if [[ -n "$stdout" ]]; then
  echo "Expected empty stdout, got: $stdout"
  exit 1
fi

if [[ "$stderr" != "$expected" ]]; then
  echo "Expected stderr '$expected', got '$stderr'"
  exit 1
fi

exit 0
