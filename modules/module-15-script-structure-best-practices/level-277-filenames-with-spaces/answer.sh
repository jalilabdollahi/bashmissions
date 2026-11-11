#!/usr/bin/env bash
# Archive every .txt report from the directory in $1 into ./archive/.
set -euo pipefail

mkdir -p archive
count=0
# The directory is quoted so spaces survive; the /*.txt stays outside the quotes
# so the shell still expands it. The glob result is one word per file, however
# odd the name.
for f in "$1"/*.txt; do
  # With no match the glob stays literal ("dir/*.txt"), so check the file is real.
  if [ -e "$f" ]; then
    name=$(basename "$f")
    cp "$f" "archive/$name"
    echo "archived: $name"
    count=$((count + 1))
  fi
done

if [ "$count" -eq 0 ]; then
  echo "no reports"
fi
