# Guide for Test Empty String

Goal: Use `-z` to test whether the first argument is empty. Print `empty` for an empty string or missing argument, otherwise print `not empty`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `-z`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

value="${1:-}"

if [ -z "$value" ]; then
  echo "empty"
else
  echo "not empty"
fi
```
