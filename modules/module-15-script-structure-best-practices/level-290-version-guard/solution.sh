#!/usr/bin/env bash
set -euo pipefail

if (( BASH_VERSINFO[0] >= 4 )); then
  printf 'bash_version=ok\n'
else
  printf 'bash_version=too_old\n'
  exit 1
fi
