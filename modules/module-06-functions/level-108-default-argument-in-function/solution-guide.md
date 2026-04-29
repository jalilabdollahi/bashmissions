# Guide for Default Argument in Function

Goal: Define a function that uses `${1:-guest}` for its argument and prints `Hello, <name>`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: `${1:-default}`.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

greet() {
  local name="${1:-guest}"
  echo "Hello, $name"
}

greet "${1:-}"
```
