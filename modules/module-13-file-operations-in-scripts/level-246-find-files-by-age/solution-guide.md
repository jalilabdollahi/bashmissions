# Solution Guide: Find Files by Age

This level focuses on `find -mtime`.

```bash
#!/usr/bin/env bash
set -euo pipefail

touch new.log
touch -d '3 days ago' old.log
find . -maxdepth 1 -type f -name '*.log' -mtime +1 -printf '%f\n' | sort
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
