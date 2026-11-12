#!/usr/bin/env bash
if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1
if [[ ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi

# IFS= stops read from trimming leading/trailing blanks; -r stops it from eating backslashes.
while IFS= read -r line; do
  echo "|$line|"
done < "$file"
