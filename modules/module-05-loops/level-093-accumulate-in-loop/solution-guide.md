# Guide for Accumulate in Loop

Goal: Loop over all numeric arguments, accumulate their sum, and print `sum=<total>`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: summing, concatenating.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

total=0
for n in "$@"; do
  ((total += n))
done

echo "sum=$total"
```
