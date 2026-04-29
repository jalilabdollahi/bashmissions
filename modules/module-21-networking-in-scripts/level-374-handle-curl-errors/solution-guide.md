# Solution Guide: Handle curl Errors

This level focuses on `--fail` flag.

```bash
#!/usr/bin/env bash
set -u
curl --fail -s "file://$PWD/missing.txt" >/dev/null 2>&1
code=$?
echo "curl_exit=$code"
```

The script demonstrates the concept safely inside the mission workspace.
