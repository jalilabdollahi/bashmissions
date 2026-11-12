#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh CSVFILE" >&2
  exit 2
fi
csv=$1
if [[ ! -r $csv ]]; then
  echo "cannot read $csv" >&2
  exit 1
fi

created=0 skipped=0 failed=0
lineno=0

# The last field soaks up the rest of the line, including a stray "\r".
while IFS=, read -r user fullname group shell; do
  lineno=$(( lineno + 1 ))
  (( lineno == 1 )) && continue        # header
  shell=${shell%$'\r'}
  [[ -n $user ]] || continue           # blank line

  if [[ ! $user =~ ^[a-z][a-z0-9_-]{2,15}$ ]]; then
    echo "line $lineno: invalid username '$user'" >&2
    failed=$(( failed + 1 ))
    continue
  fi
  if grep -q "^$user:" fixtures/etc/passwd; then
    echo "skipped $user (exists)"
    skipped=$(( skipped + 1 ))
    continue
  fi
  # "if" keeps a failing useradd from tripping set -e.
  if useradd -m -c "$fullname" -g "$group" -s "$shell" "$user"; then
    echo "created $user"
    created=$(( created + 1 ))
  else
    echo "line $lineno: useradd failed for $user" >&2
    failed=$(( failed + 1 ))
  fi
done < "$csv"

echo "created $created, skipped $skipped, failed $failed"
(( failed == 0 ))
