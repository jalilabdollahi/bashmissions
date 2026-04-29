#!/usr/bin/env bash
set -euo pipefail

trap 'echo cleanup=done' EXIT
echo "work=done"
