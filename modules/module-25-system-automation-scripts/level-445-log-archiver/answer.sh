#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh LOGDIR DAYS" >&2
  exit 2
fi
dir=$1
days=$2
if [[ ! $days =~ ^[0-9]+$ ]]; then
  echo "bad day count: $days" >&2
  exit 2
fi
if [[ ! -d $dir ]]; then
  echo "no such directory: $dir" >&2
  exit 1
fi

archived=0 skipped=0
# -maxdepth 1: top level only. sort: find's order is arbitrary.
while IFS= read -r path; do
  name=${path##*/}
  out=$dir/archive/$name.gz
  if [[ -e $out ]]; then
    echo "skipped $name (already archived)"
    skipped=$(( skipped + 1 ))
    continue
  fi
  mkdir -p "$dir/archive"
  # Work on a .partial name so a crash never leaves a half file that looks finished.
  gzip -c "$path" > "$out.partial"
  gzip -t "$out.partial"
  mv "$out.partial" "$out"
  rm "$path"
  echo "archived $name"
  archived=$(( archived + 1 ))
done < <(find "$dir" -maxdepth 1 -type f -name '*.log' -mtime +"$days" | sort)

echo "archived $archived, skipped $skipped"
