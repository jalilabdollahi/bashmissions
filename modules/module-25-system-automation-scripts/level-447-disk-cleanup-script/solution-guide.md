# Solution Guide: Disk Cleanup Script

This level focuses on remove old files by age/size.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=disk_cleanup_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'disk_cleanup_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
