#!/usr/bin/env bash
set -u

cat > err-child.sh <<'CHILD'
#!/usr/bin/env bash
set -Ee
trap 'echo "err=handled"' ERR
false
CHILD
bash err-child.sh || true
