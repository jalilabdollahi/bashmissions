# Guide for until Loop

Goal: Use an `until [ condition ]` loop to print `count=1`, `count=2`, and `count=3`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `until [ condition ]`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

count=1
until [ "$count" -gt 3 ]; do
  echo "count=$count"
  ((count += 1))
done
```
