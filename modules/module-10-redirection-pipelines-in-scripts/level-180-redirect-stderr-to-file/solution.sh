#!/usr/bin/env bash
set -euo pipefail

log=stderr.log
{ echo "warning: disk low" >&2; } 2> "$log"
cat "$log"
