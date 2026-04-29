# Guide for Variable Indirection

Build the script in this order:

1. Start with the bash shebang.
2. Define `COLOR_RED="red"` and `COLOR_BLUE="blue"`.
3. Read the lookup key from `$1`.
4. Use `${!key}` to dereference and `echo` it.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

COLOR_RED="red"
COLOR_BLUE="blue"
key="$1"
echo "${!key}"
```

Sanity check:

```bash
./solution.sh COLOR_RED    # red
./solution.sh COLOR_BLUE   # blue
```

Try `./solution.sh COLOR_GREEN` and watch `set -u` abort because `${!key}` resolves to an unset variable. Use `answer` if stuck.
