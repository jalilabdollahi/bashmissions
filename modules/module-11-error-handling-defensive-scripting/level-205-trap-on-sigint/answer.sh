#!/usr/bin/env bash
set -euo pipefail

(
  trap 'echo "sigint=handled"; exit 0' INT
  kill -INT "$BASHPID"
)
