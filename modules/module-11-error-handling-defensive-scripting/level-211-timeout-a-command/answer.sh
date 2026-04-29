#!/usr/bin/env bash
set -u

timeout 0.1s sleep 1
code=$?
echo "timeout_exit=$code"
