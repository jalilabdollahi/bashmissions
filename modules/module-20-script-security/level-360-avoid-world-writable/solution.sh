#!/usr/bin/env bash
set -euo pipefail
: > report.txt
chmod 600 report.txt
echo "perm=$(stat -c '%a' report.txt)"
