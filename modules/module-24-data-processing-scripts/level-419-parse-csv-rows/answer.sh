#!/usr/bin/env bash
set -euo pipefail

count=0
cr=$'\r'

{
  read -r _header || true            # throw the header away

  # IFS=, applies to this one read only. The last variable (status) gets
  # whatever is left of the line, including a stray \r from Windows.
  # "|| [[ -n $invoice ]]" lets the loop run once more for a last line that
  # has no newline: read fails on it, but the variables are still filled.
  while IFS=, read -r invoice customer amount status || [[ -n $invoice ]]; do
    invoice=${invoice%"$cr"}        # a blank Windows line is just "\r"
    status=${status%"$cr"}
    [[ -z $invoice ]] && continue    # blank line
    if [[ $status == open ]]; then
      printf '%s | %s | %s\n' "$invoice" "$customer" "$amount"
      count=$((count + 1))
    fi
  done
} < "$1"

printf 'open invoices: %d\n' "$count"
