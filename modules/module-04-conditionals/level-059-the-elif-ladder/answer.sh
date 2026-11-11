#!/usr/bin/env bash
set -euo pipefail

code="$1"

# Bash tries the tests from the top; the first one that is true wins and
# the rest of the ladder is skipped. else catches everything left over.
if [[ $code == 200 ]]; then
  echo "healthy: nothing to do"
elif [[ $code == 301 ]]; then
  echo "moved: check the redirect"
elif [[ $code == 404 ]]; then
  echo "not found: tell Noor"
elif [[ $code == 503 ]]; then
  echo "backend down: page Mara"
else
  echo "unexpected status $code: ask Theo"
fi
