# Guide for Loop with Counter

Goal: Read the file path in `$1` and print each line with a one-based counter as `N:<line>`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: tracking iterations.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

counter=1
while IFS= read -r line; do
  echo "$counter:$line"
  ((counter += 1))
done < "$1"
```
