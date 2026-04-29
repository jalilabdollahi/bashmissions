# Guide for Local Variables

Goal: Use `local` inside a function so changing `name` inside the function does not change the global `name`. Print `inside=local` and `outside=global`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: `local var=value`.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="global"

show_scope() {
  local name="local"
  echo "inside=$name"
}

show_scope
echo "outside=$name"
```
