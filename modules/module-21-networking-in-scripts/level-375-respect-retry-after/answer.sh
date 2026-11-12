#!/usr/bin/env bash
set -euo pipefail

url=https://reports.lanternfish.example/api/v1/monthly
max_attempts=4

headers=$(mktemp)
body=$(mktemp)
trap 'rm -f "$headers" "$body"' EXIT

for (( attempt = 1; attempt <= max_attempts; attempt++ )); do
  code=$(curl -s -D "$headers" -o "$body" -w '%{http_code}' "$url")

  case $code in
    200)
      cat "$body"
      exit 0
      ;;
    429)
      # Header names are case-insensitive (grep -i) and each line ends in \r\n.
      wait_for=$(grep -i '^retry-after:' "$headers" | tr -d '\r' | cut -d: -f2 | tr -d ' ' || true)
      if [[ ! $wait_for =~ ^[0-9]+$ ]]; then
        wait_for=1
      fi
      # No point sleeping when there is no next attempt.
      if (( attempt < max_attempts )); then
        sleep "$wait_for"
      fi
      ;;
    *)
      echo "unexpected HTTP $code" >&2
      exit 1
      ;;
  esac
done

echo "still rate limited after $max_attempts attempts" >&2
exit 1
