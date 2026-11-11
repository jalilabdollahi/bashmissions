#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh FOLDER OLD NEW" >&2
  exit 2
fi
folder=$1
old=$2
new=$3

if [[ ! -d $folder ]]; then
  echo "no such folder: $folder" >&2
  exit 1
fi

# With no match the glob would stay as the literal text "*.jpeg".
shopt -s nullglob

renamed=0
skipped=0
for path in "$folder"/*."$old"; do
  [[ -f $path ]] || continue
  target="${path%."$old"}.$new"        # cut ".old" off the end, add ".new"
  if [[ -e $target ]]; then
    echo "skipped: ${path##*/} -> ${target##*/} already exists"
    skipped=$(( skipped + 1 ))
    continue
  fi
  mv "$path" "$target"
  echo "renamed: ${path##*/} -> ${target##*/}"
  renamed=$(( renamed + 1 ))
done

echo "done: $renamed renamed, $skipped skipped"
