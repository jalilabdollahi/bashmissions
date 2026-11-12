#!/usr/bin/env bash
# Who owns this server? Argument 1: ownership file with lines
# "<server> <owner, may contain spaces>". Other arguments: servers to look up.
# Print "<server> -> <owner>" or "<server> -> unassigned", in the order given.
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh OWNERFILE [SERVER...]" >&2
  exit 2
fi
file=$1
shift

# TODO: create a map keyed by server name (what must you declare first?)
owners=()

while read -r server owner; do
  # TODO: store owner under the key server
  owners[$server]=$owner
done < "$file"

# TODO: look up each remaining argument; unknown ones are "unassigned"
for s in "$@"; do
  echo "$s -> ${owners[$s]}"
done
