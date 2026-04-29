#!/usr/bin/env bash
set -u
curl --fail -s "file://$PWD/missing.txt" >/dev/null 2>&1
code=$?
echo "curl_exit=$code"
