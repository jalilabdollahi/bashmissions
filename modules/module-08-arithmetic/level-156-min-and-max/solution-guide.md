# Guide for Min and Max

Goal: Loop over integer arguments to find the minimum and maximum. Print `min=<min> max=<max>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: compare in loop.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

min="$1"
max="$1"
shift

for n in "$@"; do
  if (( n < min )); then
    min="$n"
  fi
  if (( n > max )); then
    max="$n"
  fi
done

printf 'min=%s max=%s\n' "$min" "$max"
```
