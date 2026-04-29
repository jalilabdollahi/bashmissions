#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
let "result = a * b"
echo "result=$result"
