#!/usr/bin/env bash
set -euo pipefail

say_hello(){ echo "hello=$1"; }
declare -A dispatch=([hello]=say_hello)
cmd=${1:-hello}
"${dispatch[$cmd]}" bash
