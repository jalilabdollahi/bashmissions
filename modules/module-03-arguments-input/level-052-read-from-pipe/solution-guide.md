# Guide for Read from Pipe

Goal: Detect whether stdin is a pipe with `[ -p /dev/stdin ]`. With piped input, count lines and print `pipe: N lines`; without piped input, print `no pipe`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: detecting piped input.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

if [ -p /dev/stdin ]; then
  count=0
  while IFS= read -r _line; do
    ((count += 1))
  done
  printf 'pipe: %s lines
' "$count"
else
  echo "no pipe"
fi
```
