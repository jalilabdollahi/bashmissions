#!/usr/bin/env bash
set -euo pipefail

secret="abc123"
log="token=abc123 status=ok"
echo "${log//$secret/******}"
