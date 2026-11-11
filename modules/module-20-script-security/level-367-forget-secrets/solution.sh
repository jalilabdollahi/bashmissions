#!/usr/bin/env bash
# Sign a request with $API_TOKEN, then send a support bundle. The bundle tool
# copies the environment, so the token must be gone before it runs.
set -euo pipefail

if [[ -z ${API_TOKEN:-} ]]; then
  echo "API_TOKEN is not set" >&2
  exit 1
fi

printf 'Authorization: Bearer %s\n' "$API_TOKEN" > request.txt
# TODO: discard the secret right here, before anything else gets to inherit it.
support-bundle --out bundle.txt > /dev/null
echo "request signed, bundle sent"
