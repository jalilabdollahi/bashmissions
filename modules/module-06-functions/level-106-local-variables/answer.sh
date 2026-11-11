#!/usr/bin/env bash
set -euo pipefail

line_total() {
  # "local" ties these names to this one call. Anything outside that also uses
  # the name "total" is left completely alone.
  local subtotal tax total
  subtotal=$(( $1 * $2 ))
  tax=$(( subtotal / 10 ))
  total=$(( subtotal + tax ))
  echo "line total: $total"
}

line_total "$1" "$2"
# ${total:-none} means "the value of total, or the word none if it is not set".
echo "leaked total: ${total:-none}"
