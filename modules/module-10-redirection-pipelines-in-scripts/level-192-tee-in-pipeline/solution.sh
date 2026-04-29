#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' alpha beta gamma | tee pipeline.log | wc -l | awk '{print "lines=" $1}'
echo "logged=$(wc -l < pipeline.log)"
