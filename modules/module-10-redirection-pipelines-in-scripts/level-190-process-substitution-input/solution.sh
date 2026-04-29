#!/usr/bin/env bash
set -euo pipefail

if diff <(printf '%s\n' alpha beta) <(printf '%s\n' alpha beta) > /dev/null; then
  echo "streams match"
else
  echo "streams differ"
fi
