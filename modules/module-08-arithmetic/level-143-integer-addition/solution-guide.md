# Guide for Integer Addition

Goal: Add the first two integer arguments with arithmetic expansion and print `sum=<result>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `$(( a + b ))`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
echo "sum=$((a + b))"
```
