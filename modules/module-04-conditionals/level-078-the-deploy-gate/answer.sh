#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh ENV TESTS APPROVALS" >&2
  exit 2
fi

env_name="$1"
tests="$2"
approvals="$3"

# Reject unknown environments first so the rest can assume staging or prod.
if [[ $env_name != staging && $env_name != prod ]]; then
  echo "unknown environment: $env_name" >&2
  exit 2
fi

# Outer decision: red tests block everything.
if [[ $tests != pass ]]; then
  echo "BLOCKED: tests are not passing"
else
  # Inner decision: tests are green, so the environment decides what else is needed.
  if [[ $env_name == staging ]]; then
    echo "DEPLOY: staging"
  else
    # Innermost decision: the production-only rules, in policy order.
    if [[ -e freeze.flag ]]; then
      echo "BLOCKED: change freeze is active"
    elif (( approvals < 2 )); then
      echo "BLOCKED: prod needs 2 approvals, has $approvals"
    else
      echo "DEPLOY: prod"
    fi
  fi
fi
