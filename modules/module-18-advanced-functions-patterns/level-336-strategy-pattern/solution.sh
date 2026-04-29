#!/usr/bin/env bash
set -euo pipefail

upper(){ tr '[:lower:]' '[:upper:]' <<< "$1"; }
lower(){ tr '[:upper:]' '[:lower:]' <<< "$1"; }
strategy=upper
echo "result=$($strategy Bash)"
