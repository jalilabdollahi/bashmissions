# Solution Guide: Non-Greedy in sed

This level focuses on `sed 's/a.*?b/X/'` (POSIX).

```bash
#!/usr/bin/env bash
set -euo pipefail

text='a123b a456b'
echo "$text" | sed 's/a[^b]*b/X/'
```

The script keeps the regex focused and prints only the deterministic result expected by the checker.
