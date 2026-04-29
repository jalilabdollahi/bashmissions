#!/usr/bin/env bash
set -euo pipefail
target_user=${USER:-unknown}
echo "target=$target_user"
echo 'drop_privileges=simulated'
