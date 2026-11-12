#!/usr/bin/env bash
set -euo pipefail

# With no file argument, sort reads standard input. The test environment sets
# LC_ALL=C, so the order is plain byte order: digits, capitals, lowercase.
sort
