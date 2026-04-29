#!/usr/bin/env bash
set -euo pipefail
input='bad;name$(rm) ok'
clean=$(printf '%s' "$input" | tr -cd 'A-Za-z0-9._-')
echo "clean=$clean"
