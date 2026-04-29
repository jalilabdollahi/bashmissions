#!/usr/bin/env bash
set -euo pipefail

status="global"
set_status() {
  local status="local"
  printf 'inside=%s\n' "$status"
}
set_status
printf 'outside=%s\n' "$status"
