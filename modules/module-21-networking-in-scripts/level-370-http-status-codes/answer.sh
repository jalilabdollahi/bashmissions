#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh URL..." >&2
  exit 2
fi

problems=0
for url in "$@"; do
  # The body goes to /dev/null; -w prints the code once the transfer is over.
  # When the host is unreachable curl still prints 000 but exits non-zero,
  # so "|| true" keeps set -e from stopping the loop.
  code=$(curl -s -o /dev/null -w '%{http_code}' "$url") || true
  printf '%s %s\n' "$code" "$url"
  case $code in
    000|[45][0-9][0-9]) problems=$((problems + 1)) ;;
  esac
done

echo "problems: $problems"
if (( problems > 0 )); then
  exit 1
fi
