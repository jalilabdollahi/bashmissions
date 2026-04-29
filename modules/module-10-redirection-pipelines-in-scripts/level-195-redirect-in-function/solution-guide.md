# Solution Guide: Redirect in Function

This level focuses on function with fd.

```bash
#!/usr/bin/env bash
set -euo pipefail

write_report() {
  echo "report:start"
  echo "report:done"
}

write_report > report.log
cat report.log
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
