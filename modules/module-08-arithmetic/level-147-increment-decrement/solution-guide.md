# Guide for Increment / Decrement

Goal: Start with the first integer argument, increment once, decrement twice, then print `value=<result>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `(( i++ ))`, `(( i-- ))`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

i="$1"
((i++)) || true
((i--)) || true
((i--)) || true
echo "value=$i"
```
