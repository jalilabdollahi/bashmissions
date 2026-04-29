#!/usr/bin/env bash
set -euo pipefail

result=$(cd /; pwd)
echo "subshell_pwd=$result"
