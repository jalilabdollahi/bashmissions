# Solution Guide: Pipeline Exit Code

This level focuses on `${PIPESTATUS[@]}`.

```bash
#!/usr/bin/env bash
set -u

false | true
statuses=("${PIPESTATUS[@]}")
echo "statuses=${statuses[*]}"
```

The key is to use the redirection or pipeline operator for the work, then print deterministic output for the mission checker.
