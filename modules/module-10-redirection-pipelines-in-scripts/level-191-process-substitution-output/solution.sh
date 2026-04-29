#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' alpha beta > >(tr '[:lower:]' '[:upper:]' > uppercase.txt)
wait
cat uppercase.txt
