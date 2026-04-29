# Guide for Random in Range

Goal: Generate a random integer from 0 through 9 using modulo and print `n=<value>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `$(( RANDOM % N ))`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

n=$((RANDOM % 10))
echo "n=$n"
```
