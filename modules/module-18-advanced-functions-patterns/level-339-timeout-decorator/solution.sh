#!/usr/bin/env bash
set -u

with_timeout(){ timeout 0.1s "$@"; }
with_timeout sleep 1
code=$?
echo "timeout=$code"
