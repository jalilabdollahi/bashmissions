# Solution Guide: Here-Document No Expand

This level focuses on `<<'EOF'`.

```bash
#!/usr/bin/env bash
set -euo pipefail

name=backup
cat <<'EOF'
$name
$(date)
EOF
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
