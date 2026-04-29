# Solution Guide: sed Delete Lines

This level focuses on `sed '/pattern/d'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

sed '/DEBUG/d' fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
