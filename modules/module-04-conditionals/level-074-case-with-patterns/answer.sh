#!/usr/bin/env bash
set -euo pipefail

file="$1"

# Patterns are tried top to bottom. *.tar.gz must come before *.gz,
# otherwise every tarball would be offered "gunzip".
# A | joins alternatives that share one branch.
case "$file" in
  *.tar.gz | *.tgz)
    echo "extract with: tar -xzf $file"
    ;;
  *.tar)
    echo "extract with: tar -xf $file"
    ;;
  *.zip)
    echo "extract with: unzip $file"
    ;;
  *.gz)
    echo "extract with: gunzip $file"
    ;;
  *)
    echo "unknown archive type: $file" >&2
    exit 1
    ;;
esac
