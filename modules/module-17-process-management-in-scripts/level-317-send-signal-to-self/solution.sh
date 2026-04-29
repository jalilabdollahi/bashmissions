#!/usr/bin/env bash
set -euo pipefail

trap 'echo "usr1=handled"' USR1
kill -USR1 $$
