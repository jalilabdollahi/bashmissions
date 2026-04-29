# Guide for Convert Bases

Goal: Convert the first decimal integer argument to lowercase hexadecimal with `printf` and print `hex=<value>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: `printf "%x" 255`.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'hex=%x\n' "$1"
```
