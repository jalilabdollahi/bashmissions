#!/usr/bin/env bash
set -euo pipefail

cat > child.sh <<'CHILD'
word="subshell"
printf '%s\n' "$word"
CHILD
bash -x child.sh > output.log 2> trace.log
cat output.log
grep -q 'word=subshell' trace.log && echo 'subtrace=ok'
