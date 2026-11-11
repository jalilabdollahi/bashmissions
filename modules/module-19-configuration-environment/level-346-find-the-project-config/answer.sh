#!/usr/bin/env bash
set -euo pipefail

# Real, absolute spellings: no "..", no relative paths, no symlinks in the way.
start=$(cd "$1" 2>/dev/null && pwd -P) || { echo "not a directory: $1" >&2; exit 2; }
root=$(cd "$2" 2>/dev/null && pwd -P)  || { echo "not a directory: $2" >&2; exit 2; }

if [[ $start != "$root" && $start != "$root"/* ]]; then
  echo "$1 is not inside $2" >&2
  exit 2
fi

found=
dir=$start
while true; do
  if [[ -f $dir/.lanternrc ]]; then
    found=$dir
    break
  fi
  # The guard that makes the climb finite: the root is the last stop.
  if [[ $dir == "$root" ]]; then
    break
  fi
  dir=$(dirname "$dir")
done

if [[ -z $found ]]; then
  echo "no .lanternrc between $1 and $2" >&2
  exit 1
fi

project="(none)"
while IFS='=' read -r key value || [[ -n $key ]]; do
  key=${key#"${key%%[![:space:]]*}"};       key=${key%"${key##*[![:space:]]}"}
  value=${value:-}
  value=${value#"${value%%[![:space:]]*}"}; value=${value%"${value##*[![:space:]]}"}
  if [[ $key == project ]]; then
    project=$value
  fi
done < "$found/.lanternrc"

# ${found#"$root"} is "" for the root itself, or "/apps/web" below it.
echo "config: .${found#"$root"}/.lanternrc"
echo "project: $project"
