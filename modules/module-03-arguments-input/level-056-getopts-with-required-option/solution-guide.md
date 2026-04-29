# Guide for Getopts with Required Option

Goal: Use `getopts` to require `-f VALUE`. If `-f` is missing or has no value, print nothing and exit with status 1. If present, print `file=<value>`.

Work in this order:

1. Start from `#!/usr/bin/env bash` and `set -euo pipefail`.
2. Read the input using the curriculum concept for this level: error on missing optarg.
3. Print only the required output, with quoted variable expansions.
4. Run the mission tests, including the failure or empty-input case when one is listed.

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

file=""

while getopts ":f:" opt; do
  case "$opt" in
    f) file="$OPTARG" ;;
    :) exit 1 ;;
    \?) exit 1 ;;
  esac
done

if [[ -z $file ]]; then
  exit 1
fi

echo "file=$file"
```
