# Guide for Read from Stdin

Goal: Read one line from the file path in `$1` using `read -r value < "$1"`, then print `You said: <value>`. This practices the same `read` pattern used for stdin while keeping tests non-interactive.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `read var`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

read -r value < "$1"
echo "You said: $value"
```
