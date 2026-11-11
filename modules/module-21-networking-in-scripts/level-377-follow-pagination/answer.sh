#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh CUSTOMER_ID" >&2
  exit 2
fi
base="https://billing.lanternfish.example/api/v1/customers/$1/invoices"

next="?page=1"
pages=0
total=0

# An empty "next" ends the loop: that is what we store for the JSON value null.
while [[ -n $next ]]; do
  if (( pages >= 10 )); then
    echo "too many pages (limit 10)" >&2
    exit 1
  fi
  pages=$((pages + 1))

  url=$base$next
  if ! page=$(curl -sS --fail "$url" 2>/dev/null); then
    echo "failed to fetch $url" >&2
    exit 1
  fi

  # Ids look like "inv-1234"; grep -o prints each match on its own line.
  ids=$(printf '%s\n' "$page" | grep -oE '"inv-[0-9]+"' | tr -d '"' || true)
  if [[ -n $ids ]]; then
    printf '%s\n' "$ids"
    total=$((total + $(printf '%s\n' "$ids" | wc -l)))
  fi

  # "next":"?page=2" gives ?page=2 ; "next":null does not match, so next becomes empty.
  next=$(printf '%s\n' "$page" | sed -nE 's/.*"next": *"([^"]*)".*/\1/p')
done

echo "total: $total"
