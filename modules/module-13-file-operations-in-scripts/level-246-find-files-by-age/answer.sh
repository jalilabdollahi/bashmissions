#!/usr/bin/env bash
set -euo pipefail

touch new.log
touch -d '3 days ago' old.log
find . -maxdepth 1 -type f -name '*.log' -mtime +1 -printf '%f\n' | sort
