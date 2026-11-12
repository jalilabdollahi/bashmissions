#!/usr/bin/env bash
set -euo pipefail

minutes="$1"

# Integer division throws away the fraction: 4507 / 1440 is 3, not 3.13.
days=$(( minutes / 1440 ))

# % gives what is left over after the days are taken out (0..1439).
# Dividing that leftover by 60 gives whole hours.
hours=$(( minutes % 1440 / 60 ))

# The remainder of the minutes alone is already "minutes past the hour".
mins=$(( minutes % 60 ))

echo "uptime: ${days}d ${hours}h ${mins}m"
