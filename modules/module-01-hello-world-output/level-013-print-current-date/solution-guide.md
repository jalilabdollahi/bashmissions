# Guide for Print Current Date

Build the script in this order:

1. Start with the bash shebang.
2. Run `date +%Y-%m-%d` and capture its output with `$(...)`.
3. Embed the result in a string and `echo` it.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "today is $(date +%Y-%m-%d)"
```

Quick check:

```bash
./solution.sh
# today is 2026-04-29
```

Try `date +%F` for the same result with less typing. Use `answer` if stuck.
