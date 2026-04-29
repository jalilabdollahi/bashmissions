#!/usr/bin/env bash
set -euo pipefail

x="global"
demo() {
  local x="local"
  echo "inside: $x"
}
demo
echo "outside: $x"
