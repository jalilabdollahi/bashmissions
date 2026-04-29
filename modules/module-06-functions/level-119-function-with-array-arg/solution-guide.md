# Guide for Function with Array Arg

Goal: Pass an array to a function using a nameref and print `count=3 first=red last=blue`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: passing arrays via nameref.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

summarize_array() {
  local -n items_ref="$1"
  local last_index=$((${#items_ref[@]} - 1))
  printf 'count=%s first=%s last=%s\n' "${#items_ref[@]}" "${items_ref[0]}" "${items_ref[$last_index]}"
}

colors=(red green blue)
summarize_array colors
```
