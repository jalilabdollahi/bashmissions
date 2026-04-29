# Guide for Replace in String

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable.
3. Print `${text// /-}`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

text="$1"
echo "${text// /-}"
```

Sanity check:

```bash
./solution.sh "hello world"   # hello-world
./solution.sh "a b c d"       # a-b-c-d
./solution.sh nospaces        # nospaces
```

Compare with `${text/ /-}` (single slash, replaces first only). Use `answer` if stuck.
