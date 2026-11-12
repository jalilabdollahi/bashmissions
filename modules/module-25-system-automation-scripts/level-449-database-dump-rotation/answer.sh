#!/usr/bin/env bash
# pipefail matters here: without it "pg_dump | gzip" reports gzip's success even
# when pg_dump died, and a truncated dump would be treated as good.
set -euo pipefail

if [[ $# -ne 4 ]]; then
  echo "usage: solution.sh DB OUTDIR STAMP KEEP" >&2
  exit 2
fi
db=$1 outdir=$2 stamp=$3 keep=$4
if [[ ! $db =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo "bad database name: $db" >&2
  exit 2
fi
if [[ ! $keep =~ ^[0-9]+$ ]] || (( keep < 1 )); then
  echo "bad keep count: $keep" >&2
  exit 2
fi

mkdir -p "$outdir"
final=$outdir/$db-$stamp.sql.gz
partial=$final.partial

if ! pg_dump --no-owner "$db" | gzip > "$partial"; then
  rm -f "$partial"
  echo "dump failed for $db" >&2
  exit 1
fi
gzip -t "$partial"
mv "$partial" "$final"
echo "dumped $final"

# Only now is it safe to remove anything. The glob needs digits after "db-",
# so "app-staging-2026...." is not matched when pruning "app".
shopt -s nullglob
dumps=("$outdir/$db"-[0-9]*.sql.gz)
excess=$(( ${#dumps[@]} - keep ))
for (( i = 0; i < excess; i++ )); do
  rm -f -- "${dumps[i]}"
  echo "pruned ${dumps[i]##*/}"
done

remaining=$(( ${#dumps[@]} > keep ? keep : ${#dumps[@]} ))
echo "kept $remaining dumps"
