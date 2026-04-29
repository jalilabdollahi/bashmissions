#!/usr/bin/env bash
set -euo pipefail

set -a
source fixtures/app.env
set +a
echo "host=$HOST"
echo "port=$PORT"
