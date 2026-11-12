#!/usr/bin/env bash
set -euo pipefail
# Backup retention, Theo's version. Usage: solution.sh KEEP  < names-oldest-first
# Prints "delete: NAME" for everything except the newest KEEP, then "kept: N".
#
# BUG REPORT: "with KEEP=3 and five backups only two are left". Fix it.
# Tip: try  printf 'a\nb\nc\nd\ne\n' | bash -x ./solution.sh 3

keep=$1
mapfile -t files          # one array element per input line
total=${#files[@]}

deleted=0
for (( i = 0; i <= total - keep; i++ )); do
  echo "delete: ${files[i]}"
  deleted=$(( deleted + 1 ))
done

echo "kept: $(( total - deleted ))"
