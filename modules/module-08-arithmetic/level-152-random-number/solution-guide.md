# Guide for Random Number

Goal: Use `$RANDOM` and print `random=<number>`. The output must be a valid integer.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `$RANDOM`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "random=$RANDOM"
```
