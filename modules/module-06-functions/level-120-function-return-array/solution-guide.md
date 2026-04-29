# Guide for Function Return Array

Goal: Make a function output three values, capture them into an array with `mapfile`, and print `values=alpha,beta,gamma`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: returning multiple values.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

make_values() {
  printf '%s\n' alpha beta gamma
}

mapfile -t values < <(make_values)
joined=$(IFS=,; echo "${values[*]}")
echo "values=$joined"
```
