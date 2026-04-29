#!/usr/bin/env bash
set -euo pipefail

tmp=$(mktemp)
trap 'rm -f "$tmp"; echo "temp=removed"' EXIT
echo "temp=created"
