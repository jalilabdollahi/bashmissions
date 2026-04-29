# Guide for Nested if Statements

Goal: Use nested `if` statements to classify two arguments: role and environment. Print `admin-prod`, `admin-other`, or `user`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: decision trees.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

role="${1:-}"
env="${2:-}"

if [ "$role" = "admin" ]; then
  if [ "$env" = "prod" ]; then
    echo "admin-prod"
  else
    echo "admin-other"
  fi
else
  echo "user"
fi
```
