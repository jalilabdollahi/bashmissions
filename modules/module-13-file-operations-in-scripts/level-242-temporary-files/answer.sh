#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh LIST" >&2
  exit 2
fi
list=$1
if [[ ! -f $list || ! -r $list ]]; then
  echo "cannot read $list" >&2
  exit 1
fi

# mktemp picks an unused random name inside $TMPDIR and creates the file.
scratch=$(mktemp)
trap 'rm -f "$scratch"' EXIT       # runs on success, on error, on exit 1...

# sed '/^[[:space:]]*$/d' deletes blank lines.
before=$(( $(sed '/^[[:space:]]*$/d' "$list" | wc -l) ))

# NOT "sort -u list > list": the shell would empty list before sort reads it.
tr 'A-Z' 'a-z' < "$list" | sed '/^[[:space:]]*$/d' | sort -u > "$scratch"

after=$(( $(wc -l < "$scratch") ))
cat "$scratch" > "$list"           # cat > keeps the list's own permissions

echo "kept $after of $before addresses"
