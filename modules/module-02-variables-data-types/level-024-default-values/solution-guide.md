# Guide for Default Values

Build the script in this order:

1. Start with the bash shebang.
2. Read `$1` with a fallback: `name="${1:-anonymous}"`.
3. Print `Hello, $name`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="${1:-anonymous}"
echo "Hello, $name"
```

Sanity check:

```bash
./solution.sh Jalil   # Hello, Jalil
./solution.sh         # Hello, anonymous
```

Try `${1-anonymous}` (no colon) — same in both cases here, but pass an empty string and you'll see the difference. Use `answer` if stuck.
