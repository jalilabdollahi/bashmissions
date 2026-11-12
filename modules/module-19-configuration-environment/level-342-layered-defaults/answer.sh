#!/usr/bin/env bash
set -euo pipefail

# Layer 1: what we ship.
host=localhost
port=25
tls=off

trim() {
  local s=$1
  s=${s#"${s%%[![:space:]]*}"}
  s=${s%"${s##*[![:space:]]}"}
  printf '%s' "$s"
}

# Layer 2: the customer's file (optional).
if [[ -n ${1:-} && -r ${1:-} ]]; then
  # IFS='=' splits at the first "=" only; the last variable keeps the rest.
  while IFS='=' read -r key value || [[ -n $key ]]; do
    key=$(trim "$key")
    value=$(trim "${value:-}")
    [[ -n $value ]] || continue            # empty means "not provided"
    case $key in
      RELAY_HOST) host=$value ;;
      RELAY_PORT) port=$value ;;
      RELAY_TLS)  tls=$value ;;
    esac                                    # comments and unknown names fall through
  done < "$1"
fi

# Layer 3: today's environment. ":-" falls back when unset OR empty.
host=${RELAY_HOST:-$host}
port=${RELAY_PORT:-$port}
tls=${RELAY_TLS:-$tls}

echo "host=$host"
echo "port=$port"
echo "tls=$tls"
