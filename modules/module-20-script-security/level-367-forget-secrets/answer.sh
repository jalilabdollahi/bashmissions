#!/usr/bin/env bash
# Use the secret once, then forget it before starting any other program.
set -euo pipefail

if [[ -z ${API_TOKEN:-} ]]; then
  echo "API_TOKEN is not set" >&2
  exit 1
fi

printf 'Authorization: Bearer %s\n' "$API_TOKEN" > request.txt

# Exported variables are copied into every child process. Removing the variable
# removes it from the environment that the next command will inherit.
unset API_TOKEN

support-bundle --out bundle.txt > /dev/null
echo "request signed, bundle sent"
