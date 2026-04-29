#!/usr/bin/env bash
set -euo pipefail

declare -A colors=([red]=1 [blue]=1)
unset 'colors[red]'
if [[ -v colors[red] ]]; then
  echo 'red=present'
else
  echo 'red=missing'
fi
echo "blue=${colors[blue]}"
