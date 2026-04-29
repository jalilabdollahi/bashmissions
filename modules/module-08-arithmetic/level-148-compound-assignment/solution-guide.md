# Guide for Compound Assignment

Goal: Start with the first integer argument, add 5 with compound assignment, multiply by 2 with compound assignment, then print `value=<result>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `(( i += 5 ))`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

i="$1"
((i += 5))
((i *= 2))
echo "value=$i"
```
