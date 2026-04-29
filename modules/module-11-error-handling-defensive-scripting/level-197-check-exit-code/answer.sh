#!/usr/bin/env bash
set -u

grep -q beta fixtures/data.txt
code=$?
echo "grep_exit=$code"
