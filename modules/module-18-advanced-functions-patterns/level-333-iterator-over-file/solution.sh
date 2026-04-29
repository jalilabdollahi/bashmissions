#!/usr/bin/env bash
set -euo pipefail

exec 4< fixtures/data.txt
next_line(){ IFS= read -r line <&4 && echo "$line"; }
echo "next=$(next_line)"
echo "next=$(next_line)"
exec 4<&-
