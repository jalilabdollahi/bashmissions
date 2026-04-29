#!/usr/bin/env bash
set -euo pipefail

cat > child.sh <<'CHILD'
message="verbose"
printf '%s\n' "$message"
CHILD
bash -v child.sh > output.log 2> verbose.log
cat output.log
grep -q 'message="verbose"' verbose.log && echo 'verbose=written'
