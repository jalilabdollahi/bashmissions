#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh CUSTOMER AMOUNT" >&2
  exit 2
fi
customer=$1
amount=$2

# We build JSON by hand, so the inputs must be safe to paste into it.
if [[ ! $amount =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
  echo "amount must be a number" >&2
  exit 2
fi
if [[ $customer == *'"'* ]]; then
  echo "customer must not contain double quotes" >&2
  exit 2
fi

# String gets quotes, number does not. The whole body is one argument.
json="{\"customer\":\"$customer\",\"amount\":$amount}"

reply=$(curl -s -H 'Content-Type: application/json' -d "$json" \
  https://billing.lanternfish.example/api/v1/invoices)

printf 'reply: %s\n' "$reply"
