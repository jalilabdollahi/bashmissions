#!/usr/bin/env bash
set -euo pipefail

API_TOKEN="supersecret"
if [[ -n $API_TOKEN ]]; then echo "token=loaded"; fi
