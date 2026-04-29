# Guide for Validate Non-Empty

Goal: Validate that the first argument is not empty. If it is empty or missing, print nothing and exit with status 1. Otherwise print `value: <arg>`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: check `-z`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

value="${1:-}"
if [[ -z $value ]]; then
  exit 1
fi

echo "value: $value"
```
