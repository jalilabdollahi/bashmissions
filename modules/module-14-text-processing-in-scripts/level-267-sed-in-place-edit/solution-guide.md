# Solution Guide: sed In-Place Edit

This level focuses on `sed -i`.

```bash
#!/usr/bin/env bash
set -euo pipefail

cp fixtures/data.txt config.txt
sed -i 's/enabled=false/enabled=true/' config.txt
cat config.txt
```

The script performs the file or text operation directly, then prints deterministic output for the checker.
