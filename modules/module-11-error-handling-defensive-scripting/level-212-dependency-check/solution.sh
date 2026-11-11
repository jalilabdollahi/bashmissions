#!/usr/bin/env bash
# Pre-flight check for the deploy: are all the programs named on the command
# line installed? This draft gives up at the first absent tool, so the person
# at the keyboard has to fix things one by one. Make it report all of them.

if (( $# == 0 )); then
  echo "usage: solution.sh TOOL..." >&2
  exit 2
fi

for tool in "$@"; do
  if ! command -v "$tool" > /dev/null 2>&1; then
    echo "missing: $tool" >&2
    exit 1
  fi
done
echo "all $# tools found"
