#!/usr/bin/env bash
set -euo pipefail

role="${1:-}"
env="${2:-}"

if [ "$role" = "admin" ]; then
  if [ "$env" = "prod" ]; then
    echo "admin-prod"
  else
    echo "admin-other"
  fi
else
  echo "user"
fi
