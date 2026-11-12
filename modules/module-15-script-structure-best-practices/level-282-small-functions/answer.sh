#!/usr/bin/env bash
# Endpoint list cleaner, one job per function.
set -euo pipefail

# Lower-case the host and drop one trailing dot. Prints the result.
normalise_host() {
  local host=${1,,}
  printf '%s\n' "${host%.}"
}

# Succeeds when $1 is 1-5 digits with a value of 1..65535.
# A yes/no question is answered with the exit status, so callers can use "if".
is_port() {
  [[ $1 =~ ^[0-9]{1,5}$ ]] || return 1
  (( 10#$1 >= 1 && 10#$1 <= 65535 ))   # 10# keeps 00080 from being read as octal
}

# Prints the final line for a host and a port.
format_endpoint() {
  printf 'endpoint=%s:%d\n' "$1" "$((10#$2))"
}

main() {
  local line host port
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    if [[ $line != *:* ]]; then
      echo "invalid: $line"
      continue
    fi
    host=$(normalise_host "${line%%:*}")
    port=${line#*:}
    if [ -z "$host" ] || ! is_port "$port"; then
      echo "invalid: $line"
      continue
    fi
    format_endpoint "$host" "$port"
  done
}

main "$@"
