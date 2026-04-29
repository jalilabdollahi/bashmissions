#!/usr/bin/env bash
set -euo pipefail

read -r value < "$1"
echo "You said: $value"
