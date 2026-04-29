# Guide for Validate Numeric Input

Goal: Validate that the first argument contains only digits using `[[ $value =~ ^[0-9]+$ ]]`. If valid, print `number: <value>`; otherwise print nothing and exit with status 1.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: test with regex `[[ $var =~ ^[0-9]+$ ]]`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

value="$1"
if [[ ! $value =~ ^[0-9]+$ ]]; then
  exit 1
fi

echo "number: $value"
```
