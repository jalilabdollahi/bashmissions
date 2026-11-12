#!/usr/bin/env bash
# Retire machines from the live inventory. Each argument is an index of the
# ORIGINAL array. Remove those elements, then show the survivors with their
# indexes: "left: N" followed by declare -p fleet.
fleet=(anchovy barracuda cuttlefish dory eel)

for i in "$@"; do
  # TODO: remove element number $i from fleet (with unset)
  :
done

echo "left: ${#fleet[@]}"
declare -p fleet
