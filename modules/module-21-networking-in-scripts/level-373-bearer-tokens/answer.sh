#!/usr/bin/env bash
set -euo pipefail

# ${LF_TOKEN:-} is safe under set -u even when the variable does not exist.
if [[ -z ${LF_TOKEN:-} ]]; then
  echo "LF_TOKEN is not set" >&2
  exit 2
fi

body_file=$(mktemp)
trap 'rm -f "$body_file"' EXIT

# The token is only ever expanded inside this header. It is never echoed,
# and we do not run with set -x.
code=$(curl -s -o "$body_file" -w '%{http_code}' \
  -H "Authorization: Bearer $LF_TOKEN" \
  https://billing.lanternfish.example/api/v1/balance) || code=000

case $code in
  200) printf 'balance: %s\n' "$(cat "$body_file")" ;;
  401) echo "billing rejected the token" >&2; exit 1 ;;
  *)   echo "unexpected HTTP $code" >&2; exit 1 ;;
esac
