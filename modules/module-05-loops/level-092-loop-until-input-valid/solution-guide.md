# Guide for Loop until Input Valid

Goal: Loop over the arguments until you find the first all-numeric value. Print `valid=<value>` and stop. If none is found, print `no valid input`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: retry read loop.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

while (( $# > 0 )); do
  if [[ $1 =~ ^[0-9]+$ ]]; then
    echo "valid=$1"
    exit 0
  fi
  shift
done

echo "no valid input"
```
