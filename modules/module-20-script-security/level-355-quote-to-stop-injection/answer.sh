#!/usr/bin/env bash
# Ticket filer: the customer name is data, so every expansion is quoted.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh CUSTOMER" >&2
  exit 2
fi

customer=$1
target="tickets/$customer.txt"   # quoting once, here, protects every later use

cp fixtures/ticket-template.txt "$target"
printf 'filed: %s\n' "$target"
