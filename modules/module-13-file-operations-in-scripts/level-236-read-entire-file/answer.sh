#!/usr/bin/env bash
set -euo pipefail

content=$(< fixtures/data.txt)
printf '%s\n' "$content"
