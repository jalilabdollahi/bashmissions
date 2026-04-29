#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  red) echo "red=#ff0000" ;;
  green) echo "green=#00ff00" ;;
  blue) echo "blue=#0000ff" ;;
  *) echo "unknown" ;;
esac
