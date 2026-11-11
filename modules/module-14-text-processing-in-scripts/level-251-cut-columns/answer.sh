#!/usr/bin/env bash
set -euo pipefail

# -d, : fields are separated by commas
# -f2,5 : keep field 2 and field 5, in file order, joined by the same delimiter
cut -d, -f2,5 "$1"
