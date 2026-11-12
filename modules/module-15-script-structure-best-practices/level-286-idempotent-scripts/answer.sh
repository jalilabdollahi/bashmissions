#!/usr/bin/env bash
# Site setup for support. Safe to run any number of times.
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1
site="sites/$name"

# Step 1: the directory. Test first, so "already there" is a normal outcome.
if [ -d "$site" ]; then
  echo "dir: exists"
else
  mkdir -p "$site"
  echo "dir: created"
fi

# Step 2: the page. Never overwrite something a customer may have edited.
if [ -e "$site/index.html" ]; then
  echo "index: exists"
else
  printf '<h1>%s</h1>\n' "$name" > "$site/index.html"
  echo "index: created"
fi

# Step 3: the list entry. -x whole line, -F fixed string (no regex surprises),
# -q quiet. The file may not exist yet, so test that first.
if [ -f sites.list ] && grep -qxF -- "$name" sites.list; then
  echo "list: present"
else
  printf '%s\n' "$name" >> sites.list
  echo "list: added"
fi
