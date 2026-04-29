#!/usr/bin/env bash
set -euo pipefail

make_value() {
  echo "generated"
}

value=$(make_value)
echo "value=$value"
