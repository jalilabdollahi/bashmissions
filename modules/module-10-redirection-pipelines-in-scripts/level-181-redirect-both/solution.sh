#!/usr/bin/env bash
set -euo pipefail

log=combined.log
{
  echo "stdout: ready"
  echo "stderr: warning" >&2
} &> "$log"
cat "$log"
