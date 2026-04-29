#!/usr/bin/env bash
set -euo pipefail

if command -v printf > /dev/null; then
  echo "printf=found"
else
  echo "printf=missing"
fi
