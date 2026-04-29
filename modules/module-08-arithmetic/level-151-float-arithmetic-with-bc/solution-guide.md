# Guide for Float Arithmetic with bc

Goal: Use `bc` to divide the first number by the second with scale 2. Print `result=<value>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `echo "scale=2; 1/3" | bc`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
result=$(echo "scale=2; $a / $b" | bc)
echo "result=$result"
```
