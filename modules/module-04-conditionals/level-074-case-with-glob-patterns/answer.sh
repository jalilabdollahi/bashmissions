#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  *.sh) echo "shell" ;;
  *.txt) echo "text" ;;
  *) echo "other" ;;
esac
