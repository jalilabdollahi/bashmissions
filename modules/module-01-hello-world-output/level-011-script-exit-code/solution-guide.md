# Guide for Script Exit Code

Build the script in this order:

1. Start with the bash shebang.
2. Print `exit code: $1` to stdout — `echo "exit code: $1"` works.
3. Call `exit "$1"` so the script ends with the status the user passed in.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "exit code: $1"
exit "$1"
```

Verify by hand:

```bash
./solution.sh 0; echo "got $?"   # got 0
./solution.sh 1; echo "got $?"   # got 1
./solution.sh 7; echo "got $?"   # got 7
```

Try writing it yourself first. If you are still stuck, run `answer` to see the reference solution.
