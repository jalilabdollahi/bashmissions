#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh CUSTOMER_ID" >&2
  exit 2
fi
id=$1

# Capture curl's exit status without tripping set -e: "|| rc=$?" runs only on failure.
rc=0
plan=$(curl -sS --fail "https://billing.lanternfish.example/api/v1/customers/$id/plan") || rc=$?

case $rc in
  0)  printf 'plan: %s\n' "$plan" ;;
  22) echo "plan lookup failed: the API refused the request" >&2; exit 3 ;;
  *)  echo "plan lookup failed: network error (curl exit $rc)" >&2; exit 4 ;;
esac
