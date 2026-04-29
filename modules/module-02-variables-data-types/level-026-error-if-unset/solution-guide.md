# Guide for Error If Unset

Build the script in this order:

1. Start with the bash shebang.
2. Read `$1` with the fail-fast expansion: `name="${1:?missing argument}"`.
3. Print `Hello, $name` — only reached if `$1` was provided.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="${1:?missing argument}"
echo "Hello, $name"
```

Sanity check:

```bash
./solution.sh Jalil      # Hello, Jalil
./solution.sh; echo $?   # error message on stderr, exit 1
```

Inspect the stderr separately: `./solution.sh 2>err.log` then `cat err.log`. Use `answer` if stuck.
