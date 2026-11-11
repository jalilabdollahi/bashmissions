#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  echo "usage: solution.sh DOMAIN..." >&2
  exit 2
fi

declare -A cache=()

# Result goes into the global $registrar. If this printed instead, the caller
# would have to use $(registrar_of ...), which runs in a subshell, and every
# cache entry stored there would be thrown away.
registrar_of() {
  local domain=$1
  # ${cache[$domain]+x} is "x" when the key exists (even with an empty value).
  if [[ -z ${cache[$domain]+x} ]]; then
    cache[$domain]=$(whois-lookup "$domain")
  fi
  registrar=${cache[$domain]}
}

for domain in "$@"; do
  registrar_of "$domain"
  echo "$domain -> $registrar"
done
