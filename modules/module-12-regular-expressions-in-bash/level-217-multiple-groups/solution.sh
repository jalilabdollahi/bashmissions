#!/usr/bin/env bash
set -euo pipefail

date="2026-04-29"
if [[ $date =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})$ ]]; then
  echo "year=${BASH_REMATCH[1]}"
  echo "month=${BASH_REMATCH[2]}"
  echo "day=${BASH_REMATCH[3]}"
fi
