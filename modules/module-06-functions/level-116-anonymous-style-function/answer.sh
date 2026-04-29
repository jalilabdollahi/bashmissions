#!/usr/bin/env bash
set -euo pipefail

(
  task() {
    echo "inline"
  }
  task
)
