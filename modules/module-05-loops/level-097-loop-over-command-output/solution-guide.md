# Guide for Loop over Command Output

Goal: Use process substitution to loop over command output from `printf`. Print each generated word as `cmd=<word>`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `while IFS= read -r line < <(cmd)`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r line; do
  echo "cmd=$line"
done < <(printf '%s
' build test deploy)
```
