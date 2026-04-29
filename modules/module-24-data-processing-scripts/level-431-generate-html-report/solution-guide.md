# Solution Guide: Generate HTML Report

This level focuses on heredoc HTML.

```bash
#!/usr/bin/env bash
set -euo pipefail
cat <<'HTML'
<table><tr><td>ok</td></tr></table>
HTML
```

The script uses a small fixture so the data operation is visible and deterministic.
