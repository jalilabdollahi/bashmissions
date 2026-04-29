# Guide for String Length

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable.
3. Print `${#text}`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

text="$1"
echo "${#text}"
```

Sanity check:

```bash
./solution.sh hello        # 5
./solution.sh BashMissions # 12
./solution.sh ""           # 0
```

Skip the variable: `echo "${#1}"` works directly on the positional parameter. Use `answer` if stuck.
