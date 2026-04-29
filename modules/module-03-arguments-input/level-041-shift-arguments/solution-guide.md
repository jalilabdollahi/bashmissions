# Guide for Shift Arguments

Goal: Use `shift` once to discard the first argument, then print the new `$1` as `next: <arg>`. This shows how arguments move left after shifting.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `shift`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

shift
echo "next: $1"
```
