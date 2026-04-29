#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  exit 1
fi

echo "arg: $1"
