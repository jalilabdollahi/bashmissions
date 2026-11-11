#!/usr/bin/env bash
set -euo pipefail

# "$*" glues all arguments into ONE string, using the first character of IFS
# between them. Setting IFS for the whole script is fine here: we only use it once.
IFS=,
echo "affected: $*"
