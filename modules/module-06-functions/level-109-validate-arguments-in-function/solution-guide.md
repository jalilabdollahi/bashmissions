# Guide for Validate Arguments in Function

Goal: Write a function that requires one non-empty argument. If missing, print nothing and exit 1; otherwise print `valid=<value>`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: guard clause pattern.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

require_value() {
  if [ -z "${1:-}" ]; then
    return 1
  fi
  echo "valid=$1"
}

require_value "${1:-}"
```
