#!/usr/bin/env bash
# Tonight's watch rota: three servers, given as arguments.
# Keep them in ONE array called rota and show it with declare -p rota.
if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh SERVER1 SERVER2 SERVER3" >&2
  exit 2
fi

# TODO: build the array rota from the three arguments (round brackets!)
rota=$1

# TODO: print it with declare -p rota
declare -p rota
