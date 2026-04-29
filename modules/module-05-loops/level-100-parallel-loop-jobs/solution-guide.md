# Guide for Parallel Loop Jobs

Goal: Start three background jobs in a loop with `&`, wait for them with `wait`, then print `job 1 done`, `job 2 done`, and `job 3 done` in order.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `&` background + `wait`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
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
```
