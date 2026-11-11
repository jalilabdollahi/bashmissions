#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh OWNERFILE [SERVER...]" >&2
  exit 2
fi
file=$1
shift

# -A makes an ASSOCIATIVE array: keys are arbitrary strings.
# Without it, owners[$server] would try to read "anchovy" as an arithmetic
# index and everything would land in slot 0.
declare -A owners=()

# "server" gets the first word; "owner" gets the whole rest of the line.
while read -r server owner; do
  owners[$server]=$owner        # a later duplicate simply overwrites
done < "$file"

for s in "$@"; do
  echo "$s -> ${owners[$s]:-unassigned}"
done
