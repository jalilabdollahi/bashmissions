#!/usr/bin/env bash
set -euo pipefail

echo 'status=ready' | sed 's/\(.*\)/[\1]/'
