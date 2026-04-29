#!/usr/bin/env bash
set -euo pipefail

record="user:alice"
if [[ $record =~ ^user:([a-z]+)$ ]]; then
  echo "name=${BASH_REMATCH[1]}"
fi
