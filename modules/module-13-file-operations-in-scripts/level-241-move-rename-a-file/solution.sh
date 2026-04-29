#!/usr/bin/env bash
set -euo pipefail

echo "renamed content" > original.txt
mv original.txt renamed.txt
cat renamed.txt
