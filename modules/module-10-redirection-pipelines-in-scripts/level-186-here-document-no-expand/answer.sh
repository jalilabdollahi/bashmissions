#!/usr/bin/env bash
set -euo pipefail

name=backup
cat <<'EOF'
$name
$(date)
EOF
