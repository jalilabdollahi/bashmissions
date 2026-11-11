#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh SERVER1 SERVER2 SERVER3" >&2
  exit 2
fi

# Round brackets make an array. Quoting each argument keeps a name with
# spaces in one piece, one argument = one element.
rota=("$1" "$2" "$3")

declare -p rota
