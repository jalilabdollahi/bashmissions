#!/usr/bin/env bash
set -euo pipefail
name='alpha; touch hacked'
printf 'safe=<%s>\n' "$name"
printf 'hacked=%s\n' "$([[ -e hacked ]] && echo yes || echo no)"
