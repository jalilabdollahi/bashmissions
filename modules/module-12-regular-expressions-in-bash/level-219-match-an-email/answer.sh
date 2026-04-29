#!/usr/bin/env bash
set -euo pipefail

email=${1:-}
regex='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'
if [[ $email =~ $regex ]]; then
  echo "email=valid"
else
  echo "email=invalid"
fi
