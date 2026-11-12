#!/usr/bin/env bash
set -euo pipefail

# -E       extended regex (groups and {n} without backslashes)
# ( )      each group remembers what it matched: \1 = day, \2 = month, \3 = year
# \3-\2-\1 the replacement: the same pieces, new order, new separator
# g        convert every date on the line
sed -E 's|([0-9]{2})/([0-9]{2})/([0-9]{4})|\3-\2-\1|g'
