# Guide for for Loop over List

Goal: Use `for item in alpha beta gamma` to print each word on its own line.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `for x in a b c`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

for item in alpha beta gamma; do
  echo "$item"
done
```
