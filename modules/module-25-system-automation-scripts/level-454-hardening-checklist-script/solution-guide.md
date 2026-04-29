# Solution Guide: Hardening Checklist Script

This level focuses on check security settings.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=hardening_checklist_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'hardening_checklist_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
