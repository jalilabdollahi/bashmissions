#!/usr/bin/env bash
set -euo pipefail
fleet=(anchovy barracuda cuttlefish dory eel)

for i in "$@"; do
  # Single quotes keep the shell from treating fleet[...] as a filename
  # pattern. Bash itself expands $i inside the subscript.
  unset 'fleet[$i]'
done

echo "left: ${#fleet[@]}"
declare -p fleet     # note the gaps: the survivors keep their old indexes
