#!/usr/bin/env bash
# Hash-chained audit log: edit, delete or reorder a line and the chain breaks.
set -euo pipefail

usage() {
  echo "usage: solution.sh append LOG MESSAGE | verify LOG" >&2
  exit 2
}

# checksum PREV SEQ MESSAGE -> prints the crc number only.
# printf '%s' adds no newline, so the text is exactly "PREV|SEQ|MESSAGE".
checksum() {
  local sum _size
  read -r sum _size < <(printf '%s' "$1|$2|$3" | cksum)
  echo "$sum"
}

# walk LOG: sets $entries to the count and $last_sum to the final SUM.
# Returns 1 and sets $bad to the line number at the first inconsistency.
walk() {
  local log=$1 prev=0 n=0 seq sum msg
  entries=0
  last_sum=0
  bad=0
  [[ -f $log ]] || return 0
  while IFS='|' read -r seq sum msg; do
    n=$((n + 1))
    if [[ $seq != "$n" || $sum != "$(checksum "$prev" "$n" "$msg")" ]]; then
      bad=$n
      return 1
    fi
    prev=$sum
  done < "$log"
  entries=$n
  last_sum=$prev
}

[[ $# -ge 1 ]] || usage
case $1 in
  verify)
    [[ $# -eq 2 ]] || usage
    if [[ ! -r $2 ]]; then
      echo "cannot read $2" >&2
      exit 2
    fi
    if walk "$2"; then
      echo "OK: $entries entries"
    else
      echo "TAMPERED: line $bad"
      exit 1
    fi
    ;;
  append)
    [[ $# -eq 3 ]] || usage
    log=$2
    if ! walk "$log"; then
      echo "refusing to append: log is tampered" >&2
      exit 1
    fi
    next=$((entries + 1))
    printf '%s|%s|%s\n' "$next" "$(checksum "$last_sum" "$next" "$3")" "$3" >> "$log"
    echo "appended #$next"
    ;;
  *)
    usage
    ;;
esac
