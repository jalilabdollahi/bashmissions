# Guide for Functions in a Loop

Goal: Define a function that formats one item, then call it from a loop over `build test deploy`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: repeated calls.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

print_step() {
  echo "step=$1"
}

for step in build test deploy; do
  print_step "$step"
done
```
