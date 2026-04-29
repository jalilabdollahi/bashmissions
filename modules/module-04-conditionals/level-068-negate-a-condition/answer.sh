#!/usr/bin/env bash
set -euo pipefail

if [[ ! ${1:-} == "admin" ]]; then
  echo "guest"
else
  echo "admin"
fi
