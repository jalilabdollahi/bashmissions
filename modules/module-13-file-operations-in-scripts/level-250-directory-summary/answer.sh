#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh FOLDER" >&2
  exit 2
fi
folder=$1
if [[ ! -d $folder ]]; then
  echo "no such folder: $folder" >&2
  exit 1
fi

declare -A count=()
total=0

# Process substitution keeps the loop in this shell, so count[] and total
# survive it (a pipe into "while" would run it in a subshell).
while IFS= read -r path; do
  name=${path##*/}                 # file name only: folders may contain dots
  stem=${name%.*}                  # name without its last ".something"
  ext=${name##*.}                  # text after the last dot
  # No dot at all -> ext == name. A leading-dot name (.gitignore) has an
  # empty stem. A trailing dot (notes.) has an empty ext.
  if [[ $name == *.* && -n $stem && -n $ext ]]; then
    ext=${ext,,}
  else
    ext="(none)"
  fi
  count[$ext]=$(( ${count[$ext]:-0} + 1 ))
  total=$(( total + 1 ))
done < <(find "$folder" -type f)

for ext in "${!count[@]}"; do
  printf '%s %d\n' "$ext" "${count[$ext]}"
done | sort -k2,2nr -k1,1 | while read -r ext n; do
  echo "$ext: $n"
done

echo "total: $total files"
