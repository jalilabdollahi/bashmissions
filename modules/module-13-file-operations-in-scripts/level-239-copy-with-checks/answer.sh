#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh SOURCE FOLDER" >&2
  exit 2
fi
src=$1
folder=$2

[[ -f $src && -r $src ]] || { echo "cannot read $src" >&2; exit 1; }
[[ -d $folder ]]         || { echo "no such folder: $folder" >&2; exit 1; }

dest=$folder/$(basename "$src")
[[ ! -e $dest ]] || { echo "refusing to overwrite $dest" >&2; exit 1; }

cp "$src" "$dest"

# cp's own exit status only says "I did not notice a problem".
# cmp -s is silent and answers with its status: 0 = identical.
if ! cmp -s "$src" "$dest"; then
  rm -f "$dest"
  echo "copy of $src is corrupt, removed $dest" >&2
  exit 3
fi

echo "copied $src -> $dest"
