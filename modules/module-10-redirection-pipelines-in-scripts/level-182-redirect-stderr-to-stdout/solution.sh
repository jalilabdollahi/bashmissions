#!/usr/bin/env bash
set -euo pipefail

{ echo "error: missing config" >&2; } 2>&1 | sed 's/^/captured: /'
