# Guide for Argument Count

Goal: Print `count: N`, where `N` is the number of arguments passed to the script. Use `$#`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `$#`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "count: $#"
```
