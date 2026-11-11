# Common Mistakes

- **Strict mode below the first command.** Wrong: `cd "$dir"` on line 3 and `set -euo pipefail` on line 6 protects nothing above it. Right: it is the first command after the header comments.
- **A comment instead of a shebang on line 1.** Wrong: a blank line or a `# Description:` before `#!/usr/bin/env bash`; the kernel only honours `#!` at byte zero. Right: shebang first, description second.
- **Writing `set -euo pipefail` and then ignoring the arguments.** `cat $1` with no argument and no `-u` reads stdin forever; `cat "$1"` with `-u` stops with a clear message.
- **Leaving out pipefail.** Wrong: `set -eu` alone; `cat missing | wc -l` still "succeeds". Right: `set -euo pipefail`.
- **Hardcoding `#!/bin/bash`.** On macOS that is bash 3.2, on NixOS it does not exist. Right: `#!/usr/bin/env bash`.
