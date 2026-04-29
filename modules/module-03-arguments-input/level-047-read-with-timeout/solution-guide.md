# Guide for Read with Timeout

Goal: Use `read -r -t 1` to read from the file path in `$1`. If the read succeeds, print `read: <value>`; if it times out or fails, print `timeout` and exit with status 1.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `read -t`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

if read -r -t 1 value < "$1"; then
  echo "read: $value"
else
  echo "timeout"
  exit 1
fi
```
