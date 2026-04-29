#!/usr/bin/env bash
set -euo pipefail

trap 'echo "reload=handled"' HUP
kill -HUP $$
