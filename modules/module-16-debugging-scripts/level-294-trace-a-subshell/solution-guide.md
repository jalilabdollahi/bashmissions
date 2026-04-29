# Solution Guide: Trace a Subshell

This level focuses on `bash -x script.sh`.

```bash
#!/usr/bin/env bash
set -euo pipefail

cat > child.sh <<'CHILD'
word="subshell"
printf '%s\n' "$word"
CHILD
bash -x child.sh > output.log 2> trace.log
cat output.log
grep -q 'word=subshell' trace.log && echo 'subtrace=ok'
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
