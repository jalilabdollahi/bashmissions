# Solution Guide: grep -P in Script

This level focuses on Perl regex (where available).

```bash
#!/usr/bin/env bash
set -euo pipefail

grep -Po 'id=\K[0-9]+' fixtures/data.txt
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
