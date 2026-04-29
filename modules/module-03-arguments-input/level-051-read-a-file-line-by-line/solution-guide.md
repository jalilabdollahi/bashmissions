# Guide for Read a File Line by Line

Goal: Read the file path in `$1` line by line with `while IFS= read -r line`. Print each line with a one-based line number as `N: <line>`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: while read loop.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

line_number=1
while IFS= read -r line; do
  printf '%s: %s
' "$line_number" "$line"
  ((line_number += 1))
done < "$1"
```
