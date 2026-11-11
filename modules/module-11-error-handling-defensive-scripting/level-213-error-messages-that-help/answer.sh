#!/usr/bin/env bash
set -euo pipefail

config=${1:-}

if [[ -z $config ]]; then
  echo "usage: solution.sh CONFIG" >&2
  exit 2
fi

# Every error below answers three questions: what happened (line 1),
# where it happened (file, line number) and what to do (the indented "fix:" line).
if [[ ! -r $config ]]; then
  echo "error: config file not found: $config" >&2
  echo "  fix: create it with: lanternctl init $config" >&2
  exit 1
fi

lineno=0
keys=0
while IFS= read -r line; do
  lineno=$(( lineno + 1 ))
  [[ -z $line || $line == \#* ]] && continue
  if [[ $line != *=* ]]; then
    echo "error: $config:$lineno: not a key=value line: \"$line\"" >&2
    echo "  fix: write it as name=value, or start the line with # to comment it out" >&2
    exit 1
  fi
  keys=$(( keys + 1 ))
done < "$config"

if ! grep -q '^domain=' "$config"; then
  echo "error: $config: required key \"domain\" is missing" >&2
  echo "  fix: add a line such as domain=example.com" >&2
  exit 1
fi

echo "config ok: $keys keys"
