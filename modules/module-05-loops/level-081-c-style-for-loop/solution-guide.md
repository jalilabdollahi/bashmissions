# Guide for C-Style for Loop

Goal: Use a C-style `for` loop to print `index=0`, `index=1`, and `index=2`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `for ((i=0;i<10;i++))`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

for ((i = 0; i < 3; i++)); do
  echo "index=$i"
done
```
