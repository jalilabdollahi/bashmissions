# Solution Guide: BASH_SOURCE

This level focuses on source file tracking.

```bash
#!/usr/bin/env bash
set -euo pipefail

printf 'source=%s\n' "${BASH_SOURCE[0]##*/}"
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
