# Guide for Read-Only Variables

Build the script in this order:

1. Start with the bash shebang.
2. Declare and assign in one step: `readonly NAME="$1"`.
3. Attempt a reassignment in a **subshell** so the failure can be caught: `( NAME="changed" ) 2>/dev/null || true`. A direct `NAME=changed || true` is killed by `set -e` before `||` runs.
4. Print `$NAME` — it should still hold the original value.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

readonly NAME="$1"
( NAME="changed" ) 2>/dev/null || true
echo "$NAME"
```

Sanity check:

```bash
./solution.sh original   # original
./solution.sh v1.0.0     # v1.0.0
```

Drop the subshell parens and watch the script die — `set -e` treats readonly violations as fatal, before the `||` can save you. Use `answer` if stuck.
