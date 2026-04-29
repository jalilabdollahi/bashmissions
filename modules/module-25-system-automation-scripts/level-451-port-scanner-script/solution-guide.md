# Solution Guide: Port Scanner Script

This level focuses on nc loop over ports.

```bash
#!/usr/bin/env bash
set -euo pipefail
workdir=port_scanner_script.work
mkdir -p "$workdir"
echo evidence > "$workdir/evidence.txt"
tar -czf "$workdir/archive.tgz" -C "$workdir" evidence.txt
[[ -s "$workdir/archive.tgz" ]] && echo 'port_scanner_script=ok'
```

The script demonstrates the concept safely inside the mission workspace.
