# Guide for Return Exit Code

Goal: Define a function that returns success for `ok` and failure for anything else. Print `success` or `failure` based on the function return code.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: `return N`.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

check_ok() {
  if [ "${1:-}" = "ok" ]; then
    return 0
  fi
  return 1
}

if check_ok "${1:-}"; then
  echo "success"
else
  echo "failure"
fi
```
