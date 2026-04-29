# Solution Guide: Trap on ERR

This level focuses on log which command failed.

```bash
#!/usr/bin/env bash
set -u

cat > err-child.sh <<'CHILD'
#!/usr/bin/env bash
set -Ee
trap 'echo "err=handled"' ERR
false
CHILD
bash err-child.sh || true
```

The child script enables `set -Ee`, installs an `ERR` trap, and then runs a failing command. The parent uses `|| true` so the mission can show the trap output without failing the whole checker run.
