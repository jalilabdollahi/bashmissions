#!/usr/bin/env bash
# No set -e: every failure below is handled on purpose, with its own code.
set -u

# Named codes document the contract with the monitoring dashboard.
readonly E_USAGE=2 E_NOCONFIG=3 E_BADCONFIG=4 E_DOWN=5

config=${1:-}

if [[ -z $config ]]; then
  echo "usage: solution.sh CONFIG" >&2
  exit "$E_USAGE"
fi

if [[ ! -r $config ]]; then
  echo "config not found: $config" >&2
  exit "$E_NOCONFIG"
fi

# First port= line; "|| true" because grep exits 1 when there is none.
port=$(grep '^port=' "$config" | head -n 1 | cut -d= -f2 || true)
if [[ ! $port =~ ^[0-9]+$ ]]; then
  echo "config has no valid port: $config" >&2
  exit "$E_BADCONFIG"
fi

if ! probe "$port" 2>/dev/null; then
  echo "service on port $port is down" >&2   # portable-ok
  exit "$E_DOWN"
fi

echo "healthy: port $port"
