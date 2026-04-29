# Solution Guide: sed Multi-command

This level focuses on `-e`.

```bash
#!/usr/bin/env bash
set -euo pipefail

sed -e 's/error/ERROR/' -e '/skip/d' fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
