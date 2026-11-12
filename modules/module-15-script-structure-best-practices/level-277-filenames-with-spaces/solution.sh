#!/usr/bin/env bash
# Archive every .txt report from the directory in $1 into ./archive/.
# Prints "archived: NAME" per file, or "no reports" if there are none.
# It works for tidy names and falls over for everything else.
set -euo pipefail

mkdir -p archive
count=0
for f in $1/*.txt; do
  if [ -e $f ]; then
    name=$(basename $f)
    cp $f archive/$name
    echo archived: $name
    count=$((count + 1))
  fi
done
# TODO: quote every expansion above ("$1", "$f", "$name", and the path pieces)
# while leaving the * of the glob outside the quotes.
if [ $count -eq 0 ]; then
  echo "no reports"
fi
