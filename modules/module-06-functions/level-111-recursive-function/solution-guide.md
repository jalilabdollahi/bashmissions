# Guide for Recursive Function

Goal: Write a recursive `factorial` function and print `factorial(5)=120`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: factorial.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

factorial() {
  local n="$1"
  if [ "$n" -le 1 ]; then
    echo 1
    return
  fi
  local previous
  previous=$(factorial $((n - 1)))
  echo $((n * previous))
}

result=$(factorial 5)
echo "factorial(5)=$result"
```
