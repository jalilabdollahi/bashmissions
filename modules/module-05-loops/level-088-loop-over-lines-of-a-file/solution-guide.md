# Guide for Loop over Lines of a File

Goal: Read the file path in `$1` line by line with `while IFS= read -r line` and print each line as `line=<value>`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `while IFS= read -r line`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r line; do
  echo "line=$line"
done < "$1"
```
