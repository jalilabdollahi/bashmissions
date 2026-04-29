#!/usr/bin/env bash
set -euo pipefail

name="global"

show_scope() {
  local name="local"
  echo "inside=$name"
}

show_scope
echo "outside=$name"
