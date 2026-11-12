#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  echo "usage: solution.sh FILE..." >&2
  exit 2
fi

failed=()
for linter in shellcheck yamllint markdownlint; do
  rc=0
  "$linter" -q "$@" || rc=$?     # keep going whatever the linter says

  if (( rc == 0 )); then
    echo "$linter: ok"
  else
    echo "$linter: FAILED (exit $rc)"
    failed+=("$linter")
  fi
done

if (( ${#failed[@]} > 0 )); then
  echo "lint failed: ${failed[*]}" >&2     # "${arr[*]}" joins with spaces
  exit 1
fi
echo "all linters passed"
