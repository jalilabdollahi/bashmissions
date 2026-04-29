# Solution Guide: Trap ERR with Context

This level focuses on log command + line.

```bash
#!/usr/bin/env bash
set -euo pipefail

cat > child.sh <<'CHILD'
#!/usr/bin/env bash
set -Eeuo pipefail
trap 'printf "err_line=%s cmd=%s\n" "$LINENO" "$BASH_COMMAND"' ERR
false
CHILD
bash child.sh || true
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
