#!/usr/bin/env bash
set -euo pipefail

if command -v dig >/dev/null || command -v nslookup >/dev/null; then
  echo 'dns_tool=found'
else
  echo 'dns_tool=missing'
fi
