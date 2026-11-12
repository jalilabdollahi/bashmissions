#!/usr/bin/env bash
set -euo pipefail

do_restart() { echo "restarting $1"; }
do_reload()  { echo "reloading $1"; }
do_status()  { echo "$1 is up"; }
do_wipe()    { echo "wiping $1"; }   # exists on purpose: it is not on the list

allowed=(restart reload status)

is_allowed() {
  local candidate=$1 item
  for item in "${allowed[@]}"; do
    # Exact string equality. No patterns, no prefixes.
    [[ $item == "$candidate" ]] && return 0
  done
  return 1
}

refused=0
while read -r action target; do
  [[ -z $action ]] && continue
  if ! is_allowed "$action"; then
    echo "refused: '$action' is not an allowed action" >&2
    refused=1
    continue
  fi
  # Only a name that passed the list reaches this line.
  "do_$action" "$target"
done

(( refused == 0 )) || exit 3
