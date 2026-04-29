#!/usr/bin/env bash
set -euo pipefail

while (( $# > 0 )); do
  if [[ $1 =~ ^[0-9]+$ ]]; then
    echo "valid=$1"
    exit 0
  fi
  shift
done

echo "no valid input"
