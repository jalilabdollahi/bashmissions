#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || ! $2 =~ ^[1-9][0-9]*$ ]]; then
  echo "usage: solution.sh FOLDER DAYS" >&2
  exit 2
fi
folder=$1
days=$2
marker="$folder/.last-backup"

if [[ ! -f $marker ]]; then
  echo "no marker: $marker" >&2
  exit 1
fi

# -mtime +N: modified MORE than N whole days (N*24h) ago.
old=$(find "$folder" -type f ! -name .last-backup -mtime +"$days" | sort)

# -newer FILE: modified more recently than FILE. No clock involved, so
# it is also the right tool when "since when" is an event, not a date.
changed=$(find "$folder" -type f ! -name .last-backup -newer "$marker" | sort)

old_count=0
changed_count=0
if [[ -n $old ]]; then
  while IFS= read -r path; do
    echo "old: $path"
    old_count=$(( old_count + 1 ))
  done <<< "$old"
fi
if [[ -n $changed ]]; then
  while IFS= read -r path; do
    echo "changed: $path"
    changed_count=$(( changed_count + 1 ))
  done <<< "$changed"
fi

echo "summary: $old_count old, $changed_count changed"
