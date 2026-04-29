# Guide for Print Environment Variable

Build the script in this order:

1. Start with the bash shebang.
2. Use `echo` (or `printf`) with a double-quoted string so `$VAR` expands.
3. Reference `$HOME` and `$USER` directly — they're already set in the environment.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "HOME=$HOME USER=$USER"
```

Sanity check:

```bash
./solution.sh
# HOME=/home/jalil USER=jalil
```

Run `env | head` to see what other variables are around. Try writing it yourself first; use `answer` if you're stuck.
