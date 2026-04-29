# Solution Guide: Safe eval Usage

This level focuses on never eval user input.

```bash
#!/usr/bin/env bash
set -euo pipefail
input='list; touch hacked'
case "$input" in list) echo list ;; status) echo status ;; *) echo 'rejected=unsafe' ;; esac
printf 'hacked=%s\n' "$([[ -e hacked ]] && echo yes || echo no)"
```

The script demonstrates the concept safely inside the mission workspace.
