#!/usr/bin/env bash
set -euo pipefail
TOKEN='secret-value'
[[ -n $TOKEN ]] && echo 'used=yes'
unset TOKEN
echo "token_set=$([[ -v TOKEN ]] && echo yes || echo no)"
