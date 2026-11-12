#!/usr/bin/env bash
# Theo's ticket filer. It works for "Harbour" and breaks for anything the
# shell finds interesting. Make the customer name travel as ONE word.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh CUSTOMER" >&2
  exit 2
fi

customer=$1
cp fixtures/ticket-template.txt tickets/$customer.txt
# TODO: the printed message has the same problem as the cp line above.
echo filed: tickets/$customer.txt
