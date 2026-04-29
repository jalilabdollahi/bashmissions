# Guide for Nested Loops

Goal: Use nested loops to print all row/column pairs for rows `A B` and columns `1 2` in row-major order.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: matrix iteration.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

for row in A B; do
  for col in 1 2; do
    echo "$row$col"
  done
done
```
