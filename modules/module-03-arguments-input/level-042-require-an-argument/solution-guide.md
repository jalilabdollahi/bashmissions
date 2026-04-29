# Guide for Require an Argument

Goal: Require at least one argument. If none is provided, print nothing and exit with status 1. Otherwise print `arg: <first-arg>`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: check `$#`, exit if missing.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

if (( $# == 0 )); then
  exit 1
fi

echo "arg: $1"
```
