# Guide for Uppercase Variable

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable.
3. Print `${text^^}`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

text="$1"
echo "${text^^}"
```

Sanity check:

```bash
./solution.sh hello       # HELLO
./solution.sh "MiXeD CaSe" # MIXED CASE
```

Try `${text^}` to uppercase only the first letter. Use `answer` if stuck.
