#!/usr/bin/env bash
set -euo pipefail

base="$1"
exp="$2"
echo "power=$((base ** exp))"
