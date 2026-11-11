#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh ID FIELD" >&2
  exit 2
fi
id=$1
field=$2

if ! json=$(curl -sS --fail "https://billing.lanternfish.example/api/v1/customers/$id" 2>/dev/null); then
  echo "customer not found: $id" >&2
  exit 1
fi

# "FIELD": then optional spaces, an optional opening quote, and the value up to
# the next quote, comma or closing brace. Including the quotes around the key
# keeps "id" from matching inside "customer_id". -n with p prints only on a match.
value=$(printf '%s\n' "$json" | sed -nE 's/.*"'"$field"'": *"?([^",}]*).*/\1/p')

if [[ -z $value ]]; then
  echo "field not found: $field" >&2
  exit 1
fi
printf '%s\n' "$value"
