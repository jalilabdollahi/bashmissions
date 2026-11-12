#!/usr/bin/env bash
set -euo pipefail

version=${1:-} url=${2:-} max=${3:-5}
if [[ -z $version || -z $url || ! $max =~ ^[0-9]+$ ]] || (( 10#$max < 1 )); then
  echo "usage: solution.sh VERSION URL [MAX_ATTEMPTS]" >&2
  exit 2
fi
max=$(( 10#$max ))

if ! deployctl push "$version"; then
  echo "deploy failed" >&2
  exit 1
fi

for (( attempt = 1; attempt <= max; attempt++ )); do
  # curl -f turns an HTTP 4xx/5xx into a non-zero exit status; --max-time keeps a
  # hung endpoint from blocking the loop. We only care about the status.
  if curl -fs --max-time 2 "$url" >/dev/null 2>&1; then
    echo "healthy after $attempt attempt(s)"
    exit 0
  fi

  echo "attempt $attempt/$max: not healthy"
  (( attempt < max )) && sleep 2     # no pointless wait after the final try
done

echo "gave up after $max attempts" >&2
exit 1
