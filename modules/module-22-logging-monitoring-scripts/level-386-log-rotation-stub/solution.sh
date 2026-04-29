#!/usr/bin/env bash
set -euo pipefail
printf '%0200d\n' 1 > app.log
if (( $(wc -c < app.log) > 100 )); then mv app.log app.log.1; fi
echo "rotated=$([[ -f app.log.1 ]] && echo yes || echo no)"
