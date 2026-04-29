# Guide for Print Script Name

Build the script in this order:

1. Start with the bash shebang.
2. Capture the bare filename: `$(basename "$0")`.
3. `echo "script: $(basename "$0")"`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "script: $(basename "$0")"
```

Sanity check:

```bash
./solution.sh
# script: solution.sh
bash /tmp/solution.sh
# script: solution.sh
```

Pure-Bash variant (no subprocess): `echo "script: ${0##*/}"`. Use `answer` if stuck.
