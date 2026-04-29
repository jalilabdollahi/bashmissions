# Guide for Call a Function

Goal: Define a function named `status` and invoke it twice so the script prints `ready` on two lines.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: function invocation.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

status() {
  echo "ready"
}

status
status
```
