#!/usr/bin/env bash
set -euo pipefail

n=0
while IFS= read -r row || [[ -n $row ]]; do
  n=$((n + 1))

  # [^,] matches any character that is NOT a comma; replacing every one of them
  # with nothing leaves a string made only of the commas.
  commas=${row//[^,]/}
  count=${#commas}

  if (( count == 3 )); then
    echo "row $n: ok"
  else
    echo "row $n: bad ($count)"
  fi
done
