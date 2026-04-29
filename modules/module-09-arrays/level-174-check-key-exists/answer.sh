#!/usr/bin/env bash
set -euo pipefail

key=${1:-}
declare -A colors=([red]=1 [blue]=1)
if [[ -n $key && -v colors[$key] ]]; then
  echo exists
else
  echo missing
fi
