# Guide for Recursive Tree Walk

Goal: Recursively walk `fixtures/tree` and print each file path relative to that directory in sorted traversal order.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: directory traversal.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

walk() {
  local dir="$1"
  local base="$2"
  local item rel
  for item in "$dir"/*; do
    [ -e "$item" ] || continue
    rel="${item#$base/}"
    if [ -d "$item" ]; then
      walk "$item" "$base"
    else
      echo "$rel"
    fi
  done
}

walk fixtures/tree fixtures/tree
```
