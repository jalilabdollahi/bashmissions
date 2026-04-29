# Guide for Substring Extraction

Build the script in this order:

1. Start with the bash shebang.
2. Copy `$1` into a named variable.
3. Print `${text:1:4}`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

text="$1"
echo "${text:1:4}"
```

Sanity check:

```bash
./solution.sh BashMissions   # ashM
./solution.sh hello          # ello
./solution.sh abcdef         # bcde
```

Try `${text:0:4}` and `${text: -4}` (note the space) to compare. Use `answer` if stuck.
