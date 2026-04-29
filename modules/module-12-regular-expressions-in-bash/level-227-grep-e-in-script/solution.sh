#!/usr/bin/env bash
set -euo pipefail

grep -E '^(ERROR|WARN):' fixtures/data.txt
