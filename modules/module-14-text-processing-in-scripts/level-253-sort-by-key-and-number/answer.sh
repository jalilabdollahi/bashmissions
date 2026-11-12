#!/usr/bin/env bash
set -euo pipefail

# -t,        fields are separated by commas
# -k3,3nr    first key: field 3 only (",3" ends the key), numeric, reversed
# -k1,1      tie-break: field 1 only, ordinary text order
sort -t, -k3,3nr -k1,1 "$1"
