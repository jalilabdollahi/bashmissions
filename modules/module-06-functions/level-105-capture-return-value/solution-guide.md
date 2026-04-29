# Guide for Capture Return Value

Goal: Call a function that returns exit code 7, capture `$?`, and print `code=7`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: `$?` after call.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

return_seven() {
  return 7
}

set +e
return_seven
code=$?
set -e

echo "code=$code"
```
