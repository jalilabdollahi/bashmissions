# Guide for Loop over Arguments

Goal: Loop over all command-line arguments with `for arg in "$@"` and print each as `arg=<value>`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `for arg in "$@"`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

for arg in "$@"; do
  echo "arg=$arg"
done
```
