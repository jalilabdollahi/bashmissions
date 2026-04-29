#!/usr/bin/env bash
set -euo pipefail

colors=(red green blue)
unset 'colors[1]'
printf '%s\n' "${colors[@]}"
