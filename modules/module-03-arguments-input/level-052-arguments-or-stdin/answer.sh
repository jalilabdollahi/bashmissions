#!/usr/bin/env bash
set -euo pipefail

# ${1:-} is "$1 or nothing": it avoids the unbound-variable error under set -u.
host=${1:-}

# Only touch stdin when the argument was missing. "|| true" covers end-of-file.
[[ -z $host ]] && { read -r host || true; }

# Still nothing? Then the caller gave us no hostname at all.
[[ -z $host ]] && { echo "usage: solution.sh [HOSTNAME]" >&2; exit 2; }

echo "checking $host"
