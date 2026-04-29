#!/usr/bin/env bash
set -euo pipefail

count=$(printf '%s\n' alpha beta beta gamma | grep -c 'beta')
echo "beta_count=$count"
