# Guide for Function Library

Goal: Source `fixtures/helpers.sh` and call its `say_library` function so the script prints `from library`.

Work in this order:

1. Define the function needed for the level.
2. Use the function pattern from this concept: source a helper file.
3. Call the function with quoted arguments when values may contain spaces.
4. Match stdout and exit status exactly.

Reference solution:

```bash
#!/usr/bin/env bash
set -euo pipefail

source fixtures/helpers.sh
say_library
```
