#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 3 ]]; then
  echo "usage: solution.sh MACHINE MACHINE MACHINE..." >&2
  exit 2
fi

# "$@" expands to every argument as its own word, so spaces survive.
rack=("$@")

echo "top: ${rack[0]}"
echo "third: ${rack[2]}"      # indexes start at 0, so the third is [2]
echo "bottom: ${rack[-1]}"    # negative indexes count from the end
