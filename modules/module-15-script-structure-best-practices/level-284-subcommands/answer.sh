#!/usr/bin/env bash
# notes: a sticky note for the night shift, stored in ./notes.txt.
#   solution.sh add TEXT... | list | remove N
set -euo pipefail

readonly NOTES=notes.txt

usage() {
  echo "usage: solution.sh add TEXT... | list | remove N" >&2
  exit 2
}

cmd_add() {
  [ "$#" -ge 1 ] || usage
  local text="$*"                 # "$*" joins the words with single spaces
  printf '%s\n' "$text" >> "$NOTES"
  echo "added: $text"
}

cmd_list() {
  if [ ! -s "$NOTES" ]; then
    echo "no notes"
    return 0
  fi
  awk '{ printf "%d) %s\n", NR, $0 }' "$NOTES"
}

cmd_remove() {
  [ "$#" -eq 1 ] || usage
  local n=$1 count=0
  [ -f "$NOTES" ] && count=$(( $(wc -l < "$NOTES") ))
  # Reject anything that is not a positive whole number inside the range.
  if ! [[ $n =~ ^[1-9][0-9]*$ ]] || [ "$n" -gt "$count" ]; then
    echo "solution.sh: no such note: $n" >&2
    exit 1
  fi
  echo "removed: $(sed -n "${n}p" "$NOTES")"
  sed "${n}d" "$NOTES" > "$NOTES.tmp"
  mv "$NOTES.tmp" "$NOTES"
}

main() {
  local verb=${1:-}
  [ "$#" -ge 1 ] || usage
  shift                        # the verb is consumed; the verb's arguments remain
  case "$verb" in
    add)    cmd_add "$@" ;;
    list)   cmd_list "$@" ;;
    remove) cmd_remove "$@" ;;
    *)
      echo "solution.sh: unknown command: $verb" >&2
      exit 2
      ;;
  esac
}

main "$@"
