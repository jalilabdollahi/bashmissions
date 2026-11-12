#!/usr/bin/env bash
set -uo pipefail     # no -e: a failing lanternpush is expected and handled

max=${1:-}
if [[ ! $max =~ ^[0-9]+$ ]] || (( max < 1 )); then
  echo "usage: solution.sh MAX" >&2
  exit 2
fi

for (( attempt = 1; attempt <= max; attempt++ )); do
  if lanternpush > /dev/null 2>&1; then
    echo "pushed on attempt $attempt"
    exit 0
  fi
  echo "attempt $attempt failed"
  # Only wait when another attempt will follow.
  if (( attempt < max )); then
    sleep 0.1
  fi
done

echo "giving up after $max attempts" >&2
exit 1
