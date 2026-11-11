#!/usr/bin/env bash
set -euo pipefail
# Backup retention. Usage: solution.sh KEEP  < names-oldest-first

keep=$1
mapfile -t files          # one array element per input line
total=${#files[@]}

# Everything except the newest KEEP is total - keep items, at indexes
# 0 .. total-keep-1. The loop must therefore stop BEFORE total - keep: "<", not "<=".
deleted=0
for (( i = 0; i < total - keep; i++ )); do
  echo "delete: ${files[i]}"
  deleted=$(( deleted + 1 ))
done

echo "kept: $(( total - deleted ))"
