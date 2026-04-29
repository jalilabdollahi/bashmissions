#!/usr/bin/env bash
set -euo pipefail

log=stdout.log
echo "first" > "$log"
echo "second" >> "$log"
cat "$log"
