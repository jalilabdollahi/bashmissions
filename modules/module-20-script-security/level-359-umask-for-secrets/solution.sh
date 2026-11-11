#!/usr/bin/env bash
# Store an API key privately. The file must be born with mode 600, in a folder
# with mode 700, and index.txt must stay at the normal permissions.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh NAME KEY" >&2
  exit 2
fi

name=$1
key=$2
mkdir -p secrets
printf '%s\n' "$key" > "secrets/$name.key"
# TODO: set a restrictive umask, but only around the lines that create secret
# things, then append NAME to index.txt and print the "stored:" line.
printf '%s\n' "$name" >> index.txt
printf 'stored: secrets/%s.key\n' "$name"
