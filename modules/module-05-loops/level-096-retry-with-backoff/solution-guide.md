# Guide for Retry with Backoff

Goal: Simulate three retry attempts with exponential backoff values. Print `attempt=1 wait=1`, `attempt=2 wait=2`, and `attempt=3 wait=4`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: exponential wait in loop.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

wait_time=1
for attempt in 1 2 3; do
  echo "attempt=$attempt wait=$wait_time"
  ((wait_time *= 2))
done
```
