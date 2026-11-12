#!/usr/bin/env bash
set -euo pipefail

cut -d' ' -f3 "$1" |            # just the path
  sort |                        # equal paths become neighbours
  uniq -c |                     # "   3 /menu": count, then the line
  sed 's/^ *//' |               # macOS and Linux pad differently; drop the padding
  sort -k1,1nr -k2,2            # count desc (numeric), then path asc
