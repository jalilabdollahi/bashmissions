# Guide for Function as Callback

Goal: Pass a function name as a callback to another function. Use it to print `HELLO`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: passing function name.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

uppercase() {
  echo "${1^^}"
}

run_callback() {
  local callback="$1"
  local value="$2"
  "$callback" "$value"
}

run_callback uppercase hello
```
