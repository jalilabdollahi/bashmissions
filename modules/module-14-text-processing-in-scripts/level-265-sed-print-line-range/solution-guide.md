# Solution Guide: sed Print Line Range

This level focuses on `sed -n '5,10p'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

sed -n '2,4p' fixtures/data.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
