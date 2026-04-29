#!/usr/bin/env bash
set -euo pipefail

sort fixtures/data.txt | uniq -c | sort -rn | awk '{print $2 "=" $1}'
