#!/usr/bin/env bash
set -euo pipefail

read -r first_line < "$0"
echo "shebang=$first_line"
