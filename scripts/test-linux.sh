#!/usr/bin/env bash
# Run the level validator inside a minimal Debian container (GNU tools, bash 5)
# (mawk, GNU coreutils/sed/grep/find) to catch macOS-only habits. Usage: scripts/test-linux.sh [validator args...]
#   scripts/test-linux.sh --module 7 --no-uniqueness
set -euo pipefail
cd "$(dirname "$0")/.."
image="bashmissions-linux-check:2"
if ! docker image inspect "$image" >/dev/null 2>&1; then
  docker build -q -t "$image" - <<'DOCKERFILE' >/dev/null
FROM python:3.12-slim
RUN pip install --no-cache-dir "rich>=13" "pyyaml>=6"
RUN useradd -m player
USER player
DOCKERFILE
fi
[[ $# -gt 0 ]] || set -- --all --no-uniqueness
docker run --rm -v "$PWD":/game:ro -w /game "$image" \
  python3 -B scripts/validate_levels.py "$@"
