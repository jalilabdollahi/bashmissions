#!/usr/bin/env bash
set -euo pipefail

# Defaults first: a flag only overrides them if it appears.
customer=""
plan="basic"
dry_run="no"

# Loop until every argument has been consumed. Each branch removes what it used.
while [[ $# -gt 0 ]]; do
  case $1 in
    --customer) customer=${2:-}; shift 2 ;;   # flag + value: drop both
    --plan)     plan=${2:-};     shift 2 ;;
    --dry-run)  dry_run="yes";   shift ;;     # switch: drop just the flag
    *)          echo "error: unknown option: $1" >&2; exit 2 ;;
  esac
done

[[ -z $customer ]] && { echo "usage: solution.sh --customer NAME [--plan PLAN] [--dry-run]" >&2; exit 2; }

echo "customer=$customer plan=$plan dry_run=$dry_run"
