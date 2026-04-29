#!/usr/bin/env bash
set -euo pipefail

name=${1:-bash}
printf 'hello=%s\n' "$name"
