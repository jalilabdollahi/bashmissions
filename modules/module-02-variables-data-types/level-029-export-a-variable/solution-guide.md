# Guide for Export a Variable

Build the script in this order:

1. Start with the bash shebang.
2. `export GREETING="$1"` — the export and assignment in one line.
3. Spawn a child shell with `bash -c 'echo "$GREETING"'`. **Single quotes** around the inner command keep the parent from expanding `$GREETING` first.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

export GREETING="$1"
bash -c 'echo "$GREETING"'
```

Sanity check:

```bash
./solution.sh hello       # hello
./solution.sh "hi there"  # hi there
```

Drop the `export` and watch the child print an empty line. Use `answer` if stuck.
