#!/usr/bin/env bash
# Access review. Argument 1: roster file of "login=role" lines.
# Other arguments: logins to revoke. Remove them from the map, then print
#   revoked: N          (how many of them really existed)
# and the survivors as login=role, sorted by login.
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh ROSTER [LOGIN...]" >&2
  exit 2
fi
file=$1
shift

declare -A roster
while IFS= read -r line || [[ -n $line ]]; do
  [[ -z $line ]] && continue
  roster[${line%%=*}]=${line#*=}
done < "$file"

revoked=0
for login in "$@"; do
  # TODO: if the login is in the roster, REMOVE it (not just blank it)
  #       and count it
  roster[$login]=""
done

echo "revoked: $revoked"
# TODO: print the survivors, sorted by login
