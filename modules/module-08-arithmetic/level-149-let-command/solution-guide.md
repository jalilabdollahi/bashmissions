# Guide for let Command

Goal: Use `let` to multiply the first two integer arguments and print `result=<product>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `let "result = a * b"`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

a="$1"
b="$2"
let "result = a * b"
echo "result=$result"
```
