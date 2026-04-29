# Guide for Loop Early Exit Pattern

Goal: Read the file path in `$1` and print lines until a line equals `STOP`. Stop immediately and do not print `STOP` or later lines.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: return/exit from loop.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

while IFS= read -r line; do
  if [ "$line" = "STOP" ]; then
    exit 0
  fi
  echo "$line"
done < "$1"
```
