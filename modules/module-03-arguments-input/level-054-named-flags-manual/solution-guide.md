# Guide for Named Flags (manual)

Goal: Manually parse `--name VALUE` and `--count VALUE` using a `while` loop, `case`, and `shift`. Print `name=<name> count=<count>`. Default missing values to `unknown` and `0`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: parse `--flag value` with while/case.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

name="unknown"
count="0"

while (( $# > 0 )); do
  case "$1" in
    --name)
      name="$2"
      shift 2
      ;;
    --count)
      count="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

printf 'name=%s count=%s
' "$name" "$count"
```
