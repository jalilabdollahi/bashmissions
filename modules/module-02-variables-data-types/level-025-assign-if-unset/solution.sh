#!/usr/bin/env bash
set -euo pipefail

name="$1"
: "${name:=guest}"
echo "Welcome, $name"
