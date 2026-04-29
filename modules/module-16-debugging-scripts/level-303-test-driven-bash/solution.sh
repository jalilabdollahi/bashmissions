#!/usr/bin/env bash
set -euo pipefail

slugify() {
  local input=$1
  printf '%s\n' "${input// /-}"
}

actual=$(slugify "hello bash")
if [[ $actual == "hello-bash" ]]; then
  echo "test=pass"
else
  echo "test=fail"
  exit 1
fi
