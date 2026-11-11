#!/usr/bin/env bash
# Rack 4 map. Arguments = slots from the top; "-" means the slot is empty.
# Print "slot N: name" for each occupied slot, N counted from 1.
rack=("$@")

# TODO: loop over the INDEXES of rack, not its values,
#       skip the dashes, and print slot <index+1>: <name>
for machine in "${rack[@]}"; do
  echo "slot ?: $machine"
done
