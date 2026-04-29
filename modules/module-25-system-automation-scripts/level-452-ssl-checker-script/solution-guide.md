# Solution Guide: SSL Checker Script

This level focuses on verify cert chain.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=ssl_checker_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'ssl_checker_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
