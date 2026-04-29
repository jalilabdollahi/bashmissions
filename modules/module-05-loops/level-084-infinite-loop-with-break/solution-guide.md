# Guide for Infinite Loop with Break

Goal: Use `while true` with `break` to print `tick=1`, `tick=2`, and `done`, then stop.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `while true; do ... break; done`.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

tick=1
while true; do
  if [ "$tick" -gt 2 ]; then
    echo "done"
    break
  fi
  echo "tick=$tick"
  ((tick += 1))
done
```
