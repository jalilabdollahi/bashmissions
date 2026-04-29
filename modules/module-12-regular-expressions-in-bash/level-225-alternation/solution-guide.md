# Solution Guide: Alternation

This level focuses on `(foo|bar)`.

```bash
#!/usr/bin/env bash
set -euo pipefail

cmd=${1:-}
if [[ $cmd =~ ^(start|stop)$ ]]; then
  echo "command=allowed"
else
  echo "command=blocked"
fi
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
