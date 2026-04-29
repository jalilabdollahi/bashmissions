# Guide for Default Argument

Goal: Print `Hello, <name>` where `<name>` is the first argument if provided, otherwise `guest`. Use `${1:-guest}` rather than an `if` statement.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `${1:-default}`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="${1:-guest}"
echo "Hello, $name"
```
