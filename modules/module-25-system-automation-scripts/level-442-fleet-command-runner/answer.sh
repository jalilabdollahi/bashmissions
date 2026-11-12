#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh HOSTFILE COMMAND [ARGS...]" >&2
  exit 2
fi
hostfile=$1
shift
if [[ ! -r $hostfile ]]; then
  echo "cannot read $hostfile" >&2
  exit 1
fi

total=0 ok=0 failed=0
while IFS= read -r host; do
  [[ -z $host || $host == \#* ]] && continue
  total=$(( total + 1 ))

  # -n: do not read stdin (it is our host file!). BatchMode: never ask for a password.
  # "|| rc=$?" captures a failing status without tripping set -e.
  rc=0
  out=$(ssh -n -o BatchMode=yes "$host" "$*" 2>&1) || rc=$?

  if (( rc == 255 )); then
    echo "$host: UNREACHABLE"
    failed=$(( failed + 1 ))
    continue
  fi
  while IFS= read -r line; do
    echo "$host: $line"
  done <<< "$out"
  if (( rc == 0 )); then
    ok=$(( ok + 1 ))
  else
    echo "$host: FAILED (exit $rc)"
    failed=$(( failed + 1 ))
  fi
done < "$hostfile"

echo "hosts: $total, ok: $ok, failed: $failed"
(( failed == 0 ))
