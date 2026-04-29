#!/usr/bin/env bash
set -euo pipefail
echo '{"name":"api"}' | jq -r '.name'
