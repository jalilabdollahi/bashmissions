#!/usr/bin/env bash
# Config validator for hosted sites. All the checks below work; the messages do
# not. Rewrite each one so it answers what / where / how to fix (see objective),
# on two lines, on stderr.

config=${1:-}

if [[ -z $config ]]; then
  echo "usage: solution.sh CONFIG" >&2
  exit 2
fi

if [[ ! -r $config ]]; then
  echo "bad config"
  exit 1
fi

lineno=0
keys=0
while IFS= read -r line; do
  lineno=$(( lineno + 1 ))
  [[ -z $line || $line == \#* ]] && continue
  if [[ $line != *=* ]]; then
    echo "error: bad line"
    exit 1
  fi
  keys=$(( keys + 1 ))
done < "$config"

if ! grep -q '^domain=' "$config"; then
  echo "error: missing key"
  exit 1
fi

echo "config ok: $keys keys"
