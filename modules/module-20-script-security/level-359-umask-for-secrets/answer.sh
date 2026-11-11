#!/usr/bin/env bash
# Store an API key with permissions that are right from the first byte.
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh NAME KEY" >&2
  exit 2
fi

name=$1
key=$2

# umask 077 removes all group/other bits from anything created from now on:
# files become 600, folders 700. The parentheses start a subshell, so the
# umask dies with it and the rest of the script keeps the normal one.
(
  umask 077
  mkdir -p secrets
  printf '%s\n' "$key" > "secrets/$name.key"
)

printf '%s\n' "$name" >> index.txt
printf 'stored: secrets/%s.key\n' "$name"
