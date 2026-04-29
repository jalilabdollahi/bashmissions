# Guide for Function Arguments

Goal: Define a function that reads its own `$1` and `$2`, then call it with the first two script arguments. Print `<first> -> <second>`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: `$1 $2` inside function.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

show_pair() {
  printf '%s -> %s
' "$1" "$2"
}

show_pair "$1" "$2"
```
