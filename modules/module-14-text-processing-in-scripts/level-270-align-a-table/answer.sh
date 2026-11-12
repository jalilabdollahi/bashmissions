#!/usr/bin/env bash
set -euo pipefail

# One format string for the header and the rows keeps them aligned:
#   %-12s  left-aligned, padded to 12 characters
#   %5s    right-aligned, padded to 5 characters
awk -F, '
  BEGIN { fmt = "%-12s %-10s %5s\n"; printf fmt, "HOST", "ROLE", "CPU%" }
  { printf fmt, $1, $2, $3 }
' "$1"
