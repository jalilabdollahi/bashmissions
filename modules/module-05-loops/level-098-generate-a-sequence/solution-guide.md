# Guide for Generate a Sequence

Goal: Use `seq` in a loop to print `num=1` through `num=4`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `seq` in loop.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

for n in $(seq 1 4); do
  echo "num=$n"
done
```
