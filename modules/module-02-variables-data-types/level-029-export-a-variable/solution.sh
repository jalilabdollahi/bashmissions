#!/usr/bin/env bash
set -euo pipefail

export GREETING="$1"
bash -c 'echo "$GREETING"'
