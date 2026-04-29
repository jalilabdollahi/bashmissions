# Guide for Power

Goal: Raise the first integer argument to the power of the second using `**`. Print `power=<result>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `$(( base ** exp ))`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

base="$1"
exp="$2"
echo "power=$((base ** exp))"
```
