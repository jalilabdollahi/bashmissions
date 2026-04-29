# Guide for Assign a Variable

Build the script in this order:

1. Start with the bash shebang.
2. Assign `$1` to a named variable: `greeting="$1"`.
3. Print the variable: `echo "$greeting"`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

greeting="$1"
echo "$greeting"
```

Sanity check:

```bash
./solution.sh hello       # hello
./solution.sh "has spaces" # has spaces
```

Use `answer` if stuck.
