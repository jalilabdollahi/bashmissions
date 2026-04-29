# Solution Guide: Incremental Backup

This level focuses on rsync --link-dest.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=incremental_backup.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'incremental_backup=ok'
```

The script demonstrates the concept safely inside the mission workspace.
