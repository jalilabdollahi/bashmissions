# Guide for Getopts Basics

Goal: Use `getopts "ab:" opt` to parse `-a` as a boolean flag and `-b VALUE` as an option with an argument. Print `a=<true|false> b=<value>`, defaulting to `a=false b=none`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: `getopts "ab:" opt`.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

a="false"
b="none"

while getopts "ab:" opt; do
  case "$opt" in
    a) a="true" ;;
    b) b="$OPTARG" ;;
  esac
done

printf 'a=%s b=%s
' "$a" "$b"
```
