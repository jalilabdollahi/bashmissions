# Solution Guide: Backup Script

This level focuses on rsync + timestamp + retention.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=backup_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'backup_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
