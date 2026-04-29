#!/usr/bin/env bash
set -euo pipefail

return_seven() {
  return 7
}

set +e
return_seven
code=$?
set -e

echo "code=$code"
