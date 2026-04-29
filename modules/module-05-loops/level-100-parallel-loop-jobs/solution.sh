#!/usr/bin/env bash
set -euo pipefail

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

for job in 1 2 3; do
  {
    printf 'job %s done\n' "$job" > "$tmpdir/$job.out"
  } &
done

wait

for job in 1 2 3; do
  cat "$tmpdir/$job.out"
done
