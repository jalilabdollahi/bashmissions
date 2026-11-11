#!/usr/bin/env bash
set -euo pipefail
pool=(anchovy barracuda)

# "|| [[ -n $line ]]" keeps a final line that has no newline: read returns
# failure for it, but it has still filled $line.
while IFS= read -r line || [[ -n $line ]]; do
  pool+=("$line")        # round brackets: add ONE new element at the end
done

printf '%s\n' "${pool[@]}"
echo "total: ${#pool[@]}"
