# Solution Guide: Config Diff

This level focuses on compare two config files.

```bash
#!/usr/bin/env bash
set -euo pipefail

{ diff -u fixtures/old.conf fixtures/new.conf || true; } | grep '^[+-]port=' | sed 's/^- /old: /; s/^-/old:/; s/^+/new:/'
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
