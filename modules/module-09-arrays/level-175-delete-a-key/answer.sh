#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh ROSTER [LOGIN...]" >&2
  exit 2
fi
file=$1
shift

declare -A roster=()
while IFS= read -r line || [[ -n $line ]]; do
  [[ -z $line ]] && continue
  roster[${line%%=*}]=${line#*=}
done < "$file"

revoked=0
for login in "$@"; do
  if [[ -v roster[$login] ]]; then
    # The single quotes stop the shell from treating roster[...] as a glob.
    # unset deletes the key itself; roster[$login]="" would leave it behind
    # with an empty value.
    unset 'roster[$login]'
    revoked=$(( revoked + 1 ))
  fi
done

echo "revoked: $revoked"
if (( ${#roster[@]} > 0 )); then
  while IFS= read -r login; do
    echo "$login=${roster[$login]}"
  done < <(printf '%s\n' "${!roster[@]}" | sort)
fi
