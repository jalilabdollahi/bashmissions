# Solution Guide: set -v Verbose

This level focuses on `set -v`.

```bash
#!/usr/bin/env bash
set -euo pipefail

cat > child.sh <<'CHILD'
message="verbose"
printf '%s\n' "$message"
CHILD
bash -v child.sh > output.log 2> verbose.log
cat output.log
grep -q 'message="verbose"' verbose.log && echo 'verbose=written'
```

The script demonstrates the structure or debugging pattern while keeping checker output predictable.
