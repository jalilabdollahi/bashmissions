# Solution Guide: grep -E in Script

This level focuses on extended regex in scripts.

```bash
#!/usr/bin/env bash
set -euo pipefail

grep -E '^(ERROR|WARN):' fixtures/data.txt
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
