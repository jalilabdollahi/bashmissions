#!/usr/bin/env bash
set -euo pipefail

build(){ :; }
if declare -F build >/dev/null; then echo "build=exists"; fi
