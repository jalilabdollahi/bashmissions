#!/usr/bin/env bash
set -e

# Single quotes: the variables are expanded when the trap FIRES, so they describe
# the command that failed. With double quotes they would be frozen right here.
trap 'echo "error: line $LINENO: $BASH_COMMAND" >&2' ERR

mkdir -p out
cp release/app.tar out/
grep -q ^version= release/app.version
echo "packaged"
