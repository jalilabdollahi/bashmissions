# Guide for Continue in Loop

Goal: Loop over the numbers 1 through 5 and use `continue` to skip 3. Print the remaining numbers, one per line.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: skip iteration.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

for n in {1..5}; do
  if [ "$n" -eq 3 ]; then
    continue
  fi
  echo "$n"
done
```
