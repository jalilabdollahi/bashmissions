#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh SRC DEST STAMP" >&2
  exit 2
fi
src=${1%/}        # drop one trailing slash so basename/dirname behave
dest=$2
stamp=$3

if [[ ! -d $src ]]; then
  echo "no such directory: $1" >&2
  exit 1
fi

name=$(basename "$src")
parent=$(dirname "$src")
archive=$dest/$name-$stamp.tar.gz

mkdir -p "$dest"
if [[ -e $archive ]]; then
  echo "archive already exists: $archive" >&2
  exit 1
fi

# -C moves into the parent first, so the archive holds "name/..." and not
# the whole path of the source.
tar -czf "$archive" -C "$parent" "$name"

# Read the archive back: a backup you never looked into is only a hope.
files=$(tar -tzf "$archive" | grep -vc '/$' || true)

echo "created $archive"
echo "files: $files"
