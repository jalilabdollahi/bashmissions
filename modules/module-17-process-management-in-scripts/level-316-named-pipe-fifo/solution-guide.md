# Solution Guide: Named Pipe (FIFO)

This level focuses on `mkfifo`.

```bash
#!/usr/bin/env bash
set -euo pipefail

fifo=messages.fifo
mkfifo "$fifo"
{ echo "from fifo" > "$fifo"; } &
read -r line < "$fifo"
wait
echo "line=$line"
rm -f "$fifo"
```

The script demonstrates the pattern in a small, deterministic way suitable for the mission runner.
