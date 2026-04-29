#!/usr/bin/env bash
set -euo pipefail

workspace="$1"
cd "$workspace"

plain=$(bash solution.sh)
if [[ "$plain" != "piped=0" ]]; then
  echo "Expected piped=0 without piped stdin, got: $plain"
  exit 1
fi

piped=$(printf 'alpha
beta
gamma
' | bash solution.sh)
if [[ "$piped" != "piped=3" ]]; then
  echo "Expected piped=3 with piped stdin, got: $piped"
  exit 1
fi

echo "pipe loop works"
