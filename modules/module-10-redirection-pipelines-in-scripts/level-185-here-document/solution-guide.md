# Solution Guide: Here-Document

This level focuses on `<<EOF ... EOF`.

```bash
#!/usr/bin/env bash
set -euo pipefail

cat > message.txt <<EOF
name=backup
status=ready
EOF
cat message.txt
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
