# Guide for Sum a List

Goal: Loop over all integer arguments, accumulate their sum, and print `sum=<total>`.

Work in this order:

1. Read the numeric input from the argument list.
2. Use the arithmetic feature from this concept: loop accumulator.
3. Keep integer arithmetic inside `$(( ))` or `(( ))`; use `bc` only for the floating-point level.
4. Print the exact requested label and value.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

total=0
for n in "$@"; do
  ((total += n))
done

echo "sum=$total"
```
