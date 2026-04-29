# Guide for Your First Script

This level is a true hello-world starter. Keep it simple:

1. Add a shebang.
2. Enable safe defaults.
3. Print exactly one line: `Hello, BashMissions!`

Reference shape:

```bash
#!/usr/bin/env bash
set -euo pipefail

echo "Hello, BashMissions!"
```

The validator checks exact output text, so avoid extra spaces or punctuation changes.
