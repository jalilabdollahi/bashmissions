# Guide for Print a Banner

Build the script in this order:

1. Start with the bash shebang.
2. Use `printf` with a left-aligned, minimum-width field for the title.
3. Surround it with `== ` and ` ==`, end with `\n`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf '== %-10s ==\n' "$1"
```

Sanity check:

```bash
./solution.sh hi          # == hi         ==
./solution.sh banner      # == banner     ==
./solution.sh BashMission # == BashMission ==   (overflows; spaces shrink to none)
```

Try `%10s` (no minus) to see right-aligned padding. Use `answer` if stuck.
