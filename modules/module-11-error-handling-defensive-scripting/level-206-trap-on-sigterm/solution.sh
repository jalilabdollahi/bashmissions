#!/usr/bin/env bash
set -euo pipefail

(
  trap 'echo "sigterm=handled"; exit 0' TERM
  kill -TERM "$BASHPID"
)
