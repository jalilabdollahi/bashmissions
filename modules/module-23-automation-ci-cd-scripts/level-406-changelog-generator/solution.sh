#!/usr/bin/env bash
set -euo pipefail
cat > result.txt <<'OUT'
- fix bug
- add feature
OUT
cat result.txt
