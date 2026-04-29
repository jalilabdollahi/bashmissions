#!/usr/bin/env bash
set -euo pipefail
logger -t bashmissions 'test message' 2>/dev/null || true
echo 'logger=sent'
