#!/usr/bin/env bash
set -euo pipefail

join_args(){ printf '<%s>\n' "$@"; }
wrapper(){ join_args "$@"; }
wrapper alpha "two words"
