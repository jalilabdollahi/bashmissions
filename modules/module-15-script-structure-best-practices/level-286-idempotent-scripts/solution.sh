#!/usr/bin/env bash
# Site setup for support. Works exactly once, then it makes a mess:
# mkdir fails when the folder exists, the page is overwritten, and the name is
# appended to sites.list again every time.
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1

mkdir -p sites
mkdir "sites/$name"
echo "dir: created"

echo "<h1>$name</h1>" > "sites/$name/index.html"
echo "index: created"

echo "$name" >> sites.list
echo "list: added"

# TODO: before each step, check whether it is already done. Report
# created/exists, created/exists and added/present accordingly.
