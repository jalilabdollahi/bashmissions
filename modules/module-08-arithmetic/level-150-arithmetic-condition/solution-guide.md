# Guide for Arithmetic Condition

Goal: Use an arithmetic condition to compare the first two integer arguments. Print `greater` if the first is greater, otherwise `not greater`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `(( a > b ))` as if condition.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
if (( a > b )); then
  echo "greater"
else
  echo "not greater"
fi
```
