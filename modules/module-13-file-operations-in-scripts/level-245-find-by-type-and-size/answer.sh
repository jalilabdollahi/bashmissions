#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || ! $2 =~ ^[0-9]+$ ]]; then
  echo "usage: solution.sh FOLDER BYTES" >&2
  exit 2
fi
folder=$1
bytes=$2
if [[ ! -d $folder ]]; then
  echo "no such folder: $folder" >&2
  exit 1
fi

# "+Nc" = more than N bytes. The "c" unit is what makes this portable:
# without it, -size counts in 512-byte blocks and rounds up.
find "$folder" -type f -size +"${bytes}"c | sort | while IFS= read -r path; do
  echo "big: $path"
done

# Size 0 only matches truly empty files.
find "$folder" -type f -size 0 | sort | while IFS= read -r path; do
  echo "empty: $path"
done

# find -type d also lists FOLDER itself, so subtract one.
dirs=$(( $(find "$folder" -type d | wc -l) - 1 ))
echo "folders: $dirs"
