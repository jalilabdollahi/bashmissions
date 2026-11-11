#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: solution.sh NAME" >&2
  exit 2
fi
name=$1
base=https://downloads.lanternfish.example/releases

# Nothing is called NAME until it has been verified. The trap removes the
# temporary files on every way out; after "mv" the temp name no longer exists.
tmp_file=$(mktemp)
tmp_sum=$(mktemp)
trap 'rm -f "$tmp_file" "$tmp_sum"' EXIT

if ! curl -sS --fail -o "$tmp_file" "$base/$name" 2>/dev/null; then
  echo "download failed: $name" >&2
  exit 1
fi
if ! curl -sS --fail -o "$tmp_sum" "$base/$name.cksum" 2>/dev/null; then
  echo "no checksum published for $name" >&2
  exit 1
fi

# "cksum < file" reads stdin, so its output has no file name: just "CRC SIZE".
actual=$(cksum < "$tmp_file")
# The published line is "CRC SIZE NAME": keep the first two fields.
expected=$(cut -d' ' -f1,2 "$tmp_sum")

if [[ $actual != "$expected" ]]; then
  echo "checksum mismatch for $name" >&2
  exit 1
fi

mv "$tmp_file" "$name"
echo "verified: $name"
