#!/usr/bin/env bash
set -euo pipefail
echo 'hello http' > page.txt
curl -s "file://$PWD/page.txt"
