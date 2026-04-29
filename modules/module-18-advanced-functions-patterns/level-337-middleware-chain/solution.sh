#!/usr/bin/env bash
set -euo pipefail

trim(){ x=${1// /}; echo "$x"; }
wrap(){ echo "[$1]"; }
value=" a b "
value=$(trim "$value")
value=$(wrap "$value")
echo "$value"
