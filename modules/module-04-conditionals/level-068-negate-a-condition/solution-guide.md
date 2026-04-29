# Guide for Negate a Condition

Goal: Use `!` to negate a condition. Print `guest` when the first argument is not `admin`; print `admin` when it is exactly `admin`.

Work in this order:

1. Identify the value or path being tested.
2. Write the conditional form from this level: `!`.
3. Quote variable expansions unless the syntax specifically needs an unquoted pattern.
4. Match the expected output and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ ! ${1:-} == "admin" ]]; then
  echo "guest"
else
  echo "admin"
fi
```
