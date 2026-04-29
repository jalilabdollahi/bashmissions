#!/usr/bin/env bash
set -euo pipefail

if [[ ${1:-} == "yes" || ${2:-} == "yes" ]]; then
  echo "allowed"
else
  echo "denied"
fi
