#!/usr/bin/env bash
set -euo pipefail

awk '{sum += $1} END {print sum}' fixtures/data.txt
