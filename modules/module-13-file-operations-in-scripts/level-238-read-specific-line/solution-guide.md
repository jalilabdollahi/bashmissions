# Solution Guide: Read Specific Line

This level focuses on `sed -n '5p'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

sed -n '5p' fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
