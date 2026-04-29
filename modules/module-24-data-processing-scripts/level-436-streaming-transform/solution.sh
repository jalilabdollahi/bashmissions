#!/usr/bin/env bash
set -euo pipefail
while IFS= read -r line; do echo "item=${line^^}"; done < fixtures/data.txt
