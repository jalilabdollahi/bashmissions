# Solution Guide: Join Two Files

This level focuses on `join`, `paste`.

```bash
#!/usr/bin/env bash
set -euo pipefail

paste -d: fixtures/names.txt fixtures/scores.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
