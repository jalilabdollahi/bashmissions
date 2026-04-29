# Guide for Subtraction & Multiplication

Goal: Use arithmetic expansion to subtract and multiply the first two integer arguments. Print `diff=<a-b> product=<a*b>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `$(( a * b ))`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
printf 'diff=%s product=%s\n' "$((a - b))" "$((a * b))"
```
