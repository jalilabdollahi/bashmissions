# Guide for Colorized Output

Build the script in this order:

1. Start with the bash shebang.
2. Use `printf` so backslash escapes get interpreted.
3. Emit `\033[32m` (green on), then `OK`, then `\033[0m` (reset), then `\n`.

A working shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

printf '\033[32mOK\033[0m\n'
```

Sanity check:

```bash
./solution.sh        # OK in green if your terminal supports color
./solution.sh | cat -v
# ^[[32mOK^[[0m       # raw escapes when piped
```

Try also `printf '\033[1;31m%s\033[0m\n' 'BOLD RED'` to see attributes combined. Use `answer` if stuck.
