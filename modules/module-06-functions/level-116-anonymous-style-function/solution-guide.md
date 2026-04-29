# Guide for Anonymous-Style Function

Goal: Use an inline function definition inside a subshell or grouped block and print `inline`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: inline definition.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

(
  task() {
    echo "inline"
  }
  task
)
```
