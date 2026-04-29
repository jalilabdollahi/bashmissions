#!/usr/bin/env bash
set -euo pipefail
secret='abc123'
line='login token=abc123 user=ada'
echo "${line//$secret/[REDACTED]}"
