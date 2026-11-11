# Common Mistakes

- **Double quotes around the PS4 value.** Wrong: `PS4="+ L${LINENO}: "` freezes the number of the PS4 line, so every trace line says the same thing. Right: `PS4='+ L${LINENO}: '`.
- **Setting PS4 after `set -x`.** Then the first few trace lines use the default `+ ` prefix. Set PS4 first, then switch tracing on.
- **Using `$LINENO` without braces next to text.** `PS4='+ L$LINENO: '` works, but `L$LINENO_x` would read a variable named `LINENO_x`. Braces (`${LINENO}`) are the habit that never bites.
- **Blaming the number when lines have moved.** The number is the line in the file that is running. If you edit the script after copying a trace into a ticket, the numbers no longer match; keep the trace and the script version together.
- **Expecting the PS4 assignment itself to be traced.** It is not, because tracing was not on yet. The first traced command is whatever follows `set -x`.
