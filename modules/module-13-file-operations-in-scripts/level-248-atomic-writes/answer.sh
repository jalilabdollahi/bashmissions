#!/usr/bin/env bash
set -euo pipefail

mkdir -p config

# Same folder as the target = same disk, which is what makes mv a rename.
tmp=$(mktemp config/.app.conf.XXXXXX)
cat > "$tmp"                           # all of stdin into the temp file

if ! grep -Eq '^port=[0-9]+$' "$tmp"; then
  rm -f "$tmp"
  echo "invalid config: no port= line, keeping the old file" >&2
  exit 1
fi

chmod 644 "$tmp"                       # mktemp files are private (600)
mv "$tmp" config/app.conf              # the atomic step

lines=$(( $(wc -l < config/app.conf) ))
echo "installed config/app.conf ($lines lines)"
