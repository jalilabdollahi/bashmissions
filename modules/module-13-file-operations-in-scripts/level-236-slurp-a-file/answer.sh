#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh FILE" >&2
  exit 2
fi
file=$1

if [[ ! -f $file || ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi

# $(<file) is the shell reading the file itself: no cat, no extra process.
# Command substitution also drops trailing newlines, which is what we want.
token=$(<"$file")

echo "length=${#token}"
echo "masked=${token:0:4}****"
