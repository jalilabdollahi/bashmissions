#!/usr/bin/env bash
set -euo pipefail
sed -n 's/^\[.*\] ERROR \(.*\)$/error=\1/p' fixtures/app.log
