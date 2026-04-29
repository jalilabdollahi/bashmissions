# Guide for for Loop over Range

Goal: Use brace expansion in a `for` loop to print the numbers 1 through 5, one per line.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `for i in {1..10}`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

for i in {1..5}; do
  echo "$i"
done
```
