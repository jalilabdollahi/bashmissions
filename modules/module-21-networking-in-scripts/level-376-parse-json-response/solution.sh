#!/usr/bin/env bash
set -euo pipefail
echo '{"status":"ok","count":2}' > response.json
jq -r '.status' response.json
