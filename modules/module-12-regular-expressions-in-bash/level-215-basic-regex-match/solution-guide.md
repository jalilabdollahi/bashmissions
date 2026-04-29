# Solution Guide: Basic Regex Match

This level focuses on `[[ $str =~ pattern ]]`.

```bash
#!/usr/bin/env bash
set -euo pipefail

value="server-42"
if [[ $value =~ [0-9]+ ]]; then
  echo "match=yes"
else
  echo "match=no"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
