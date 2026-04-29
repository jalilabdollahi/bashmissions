# Solution Guide: Download File Safely

This level focuses on verify checksum.

```bash
#!/usr/bin/env bash
set -euo pipefail
echo 'artifact' > artifact.txt
expected=$(sha256sum artifact.txt | awk '{print $1}')
curl -s "file://$PWD/artifact.txt" -o downloaded.txt
actual=$(sha256sum downloaded.txt | awk '{print $1}')
[[ $actual == "$expected" ]] && echo 'checksum=ok'
```

The script demonstrates the concept safely inside the mission workspace.
