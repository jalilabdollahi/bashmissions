#!/usr/bin/env bash
set -euo pipefail

HOST=localhost
required=(HOST PORT)
missing=()
for key in "${required[@]}"; do [[ -v $key ]] || missing+=("$key"); done
if ((${#missing[@]})); then echo "missing=${missing[*]}"; else echo ok; fi
