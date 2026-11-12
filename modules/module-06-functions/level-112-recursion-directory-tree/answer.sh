#!/usr/bin/env bash
set -euo pipefail

# walk DIR INDENT: list the entries of DIR, then dive into each sub-directory.
walk() {
  local dir=$1 indent=$2 entry name
  for entry in "$dir"/*; do          # the glob is sorted alphabetically (LC_ALL=C)
    [[ -e $entry ]] || continue      # an empty folder leaves the pattern unexpanded
    name=${entry##*/}                # strip everything up to the last slash
    if [[ -d $entry ]]; then
      echo "$indent$name/"
      walk "$entry" "$indent  "      # the recursive call: same job, one level deeper
    else
      echo "$indent$name"
    fi
  done
}

root=${1:-}
if [[ ! -d $root ]]; then
  echo "no such directory: $root" >&2
  exit 1
fi

root=${root%/}                        # tolerate a trailing slash on the argument
echo "$root/"
walk "$root" "  "
