#!/usr/bin/env bash
set -euo pipefail

attempt=0
flaky(){ ((++attempt)); (( attempt >= 2 )); }
retry(){ until "$@"; do echo "retry=$attempt"; done; }
retry flaky
echo "success=$attempt"
