# Solution Guide: sed with Capture Group

This level focuses on `sed 's/\(.*\)/[\1]/'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

echo 'status=ready' | sed 's/\(.*\)/[\1]/'
```

The sed expression captures the entire line with `\(.*\)` and reuses it as `\1` inside square brackets.
