#!/usr/bin/env bash
set -euo pipefail

read -r -s password < "$1"
printf 'Password length: %s
' "${#password}"
