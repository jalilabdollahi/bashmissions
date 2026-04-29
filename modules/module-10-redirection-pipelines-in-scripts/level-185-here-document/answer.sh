#!/usr/bin/env bash
set -euo pipefail

cat > message.txt <<EOF
name=backup
status=ready
EOF
cat message.txt
