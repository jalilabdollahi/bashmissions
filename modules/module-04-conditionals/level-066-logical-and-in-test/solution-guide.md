# Guide for Logical AND in Test

Goal: Use `&&` inside `[[ ]]` to check that both the first and second arguments are non-empty. Print `complete` only when both are present; otherwise print `incomplete`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `&&` inside `[[ ]]`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

first="${1:-}"
second="${2:-}"

if [[ -n $first && -n $second ]]; then
  echo "complete"
else
  echo "incomplete"
fi
```
