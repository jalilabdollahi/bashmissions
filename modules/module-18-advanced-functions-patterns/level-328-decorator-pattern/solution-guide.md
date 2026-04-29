# Solution Guide: Decorator Pattern

This level focuses on wrap and extend a function.

```bash
#!/usr/bin/env bash
set -euo pipefail

work(){ echo work; }
decorated(){ echo before; work; echo after; }
decorated
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
