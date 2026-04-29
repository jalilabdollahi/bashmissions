#!/usr/bin/env bash
set -euo pipefail
mkdir -p app
created=no
[[ -d app ]] && exists=yes
echo "created=$created"
echo "exists=$exists"
