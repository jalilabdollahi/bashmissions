#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh TOOL" >&2
  exit 2
fi

tool="$1"

# command -v prints where Bash would find the tool and succeeds, or prints
# nothing and fails. We only need the yes/no, so its output is thrown away.
if command -v "$tool" >/dev/null 2>&1; then
  echo "found: $("$tool" --version)"
else
  echo "missing: $tool" >&2
  exit 1
fi
