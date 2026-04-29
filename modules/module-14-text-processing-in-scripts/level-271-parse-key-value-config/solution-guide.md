# Solution Guide: Parse Key=Value Config

This level focuses on while read + IFS.

```bash
#!/usr/bin/env bash
set -euo pipefail

while IFS='=' read -r key value; do
  [[ -z ${key:-} || $key == \#* ]] && continue
  case $key in
    host|port) echo "$key=$value" ;;
  esac
done < fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
