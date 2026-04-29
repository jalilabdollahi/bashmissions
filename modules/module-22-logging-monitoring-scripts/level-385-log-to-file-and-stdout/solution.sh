#!/usr/bin/env bash
set -euo pipefail
echo 'build ok' | tee build.log
echo "logged=$(cat build.log)"
