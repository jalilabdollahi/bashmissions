# Guide for Loop with Pipe

Goal: Read piped input with a `while read` loop and count the lines. With piped input, print `piped=<count>`; without piped input, print `piped=0`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `while read` from pipe.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

count=0
if [ -p /dev/stdin ]; then
  while IFS= read -r _line; do
    ((count += 1))
  done
fi

echo "piped=$count"
```
