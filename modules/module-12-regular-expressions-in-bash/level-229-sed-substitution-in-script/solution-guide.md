# Solution Guide: sed Substitution in Script

This level focuses on `sed 's/old/new/'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

echo 'color=red' | sed 's/red/blue/'
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
