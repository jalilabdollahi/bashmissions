#!/usr/bin/env bash
set -euo pipefail
echo ok > page.txt
code=$(curl -s -o /dev/null -w '%{http_code}' "file://$PWD/page.txt")
echo "code=$code"
