# Guide for Test Non-Empty String

Goal: Use `-n` to test whether the first argument is non-empty. Print `present` when it has text, otherwise print `missing`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `-n`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

value="${1:-}"

if [ -n "$value" ]; then
  echo "present"
else
  echo "missing"
fi
```
