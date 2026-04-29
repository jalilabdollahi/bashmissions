# Solution Guide: Tee in Pipeline

This level focuses on `tee` for logging.

```bash
#!/usr/bin/env bash
set -euo pipefail

printf '%s\n' alpha beta gamma | tee pipeline.log | wc -l | awk '{print "lines=" $1}'
echo "logged=$(wc -l < pipeline.log)"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
