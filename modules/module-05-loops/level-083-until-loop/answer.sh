#!/usr/bin/env bash
set -euo pipefail

count=1
until [ "$count" -gt 3 ]; do
  echo "count=$count"
  ((count += 1))
done
