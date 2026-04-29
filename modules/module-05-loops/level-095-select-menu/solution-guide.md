# Guide for Select Menu

Goal: Use the `select` built-in with options `apple`, `banana`, and `cherry`. Read the numeric choice from `$1` non-interactively and print `selected=<option>`.

Work in this order:

1. Identify what the loop should iterate over.
2. Use the loop pattern from this level: `select` built-in.
3. Keep the loop body small and print only the required output.
4. Make sure the loop stops; infinite loops must have an obvious `break` or exit path.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

PS3="choice: "
select item in apple banana cherry; do
  echo "selected=$item"
  break
done <<< "${1:-1}"
```
