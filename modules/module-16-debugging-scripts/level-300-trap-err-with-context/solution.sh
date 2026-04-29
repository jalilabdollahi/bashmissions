#!/usr/bin/env bash
set -euo pipefail

cat > child.sh <<'CHILD'
#!/usr/bin/env bash
set -Eeuo pipefail
trap 'printf "err_line=%s cmd=%s\n" "$LINENO" "$BASH_COMMAND"' ERR
false
CHILD
bash child.sh || true
