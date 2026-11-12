#!/usr/bin/env bash
# Size report for an upload folder.
set -euo pipefail

dir=$1
found=0
# The shell expands the glob itself: one word per entry, no re-splitting, and
# hidden files are left out by default. Quoting "$dir" keeps spaces in the folder name.
for f in "$dir"/*; do
  # If nothing matches, the loop sees the literal pattern; -f filters that out
  # together with directories.
  if [ -f "$f" ]; then
    size=$(wc -c < "$f")
    # ${f##*/} removes everything up to the last slash. $(( )) strips the padding
    # that some wc implementations add.
    printf '%s: %d bytes\n' "${f##*/}" "$((size))"
    found=1
  fi
done

if [ "$found" -eq 0 ]; then
  echo "empty"
fi
