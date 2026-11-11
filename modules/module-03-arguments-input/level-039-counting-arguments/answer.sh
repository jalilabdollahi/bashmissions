#!/usr/bin/env bash
set -euo pipefail

# $# expands to the number of positional parameters. It is 0 when there are none,
# so no argument check is needed here.
echo "batch size: $#"
