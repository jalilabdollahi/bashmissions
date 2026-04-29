# Guide for Loop with Index

Goal: Store `red green blue` in an array, then use a C-style index loop to print `0:red`, `1:green`, and `2:blue`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: C-style with array index.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

colors=(red green blue)
for ((i = 0; i < ${#colors[@]}; i++)); do
  echo "$i:${colors[$i]}"
done
```
