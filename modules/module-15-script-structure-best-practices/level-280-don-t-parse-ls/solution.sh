#!/usr/bin/env bash
# Size report for an upload folder: "<name>: <bytes> bytes" per regular file,
# or "empty". Theo's version splits the output of ls, which is not safe.
set -euo pipefail

dir=$1
found=0
for name in $(ls $dir); do
  if [ -f $dir/$name ]; then
    size=$(wc -c < $dir/$name)
    echo "$name: $((size)) bytes"
    found=1
  fi
done
# TODO: no ls. Loop over "$dir"/* , use [ -f "$f" ], and cut the directory off
# with ${f##*/}. Quote everything.
if [ $found -eq 0 ]; then
  echo "empty"
fi
