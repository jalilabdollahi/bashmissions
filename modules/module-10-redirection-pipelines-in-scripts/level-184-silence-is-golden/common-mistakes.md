# Common Mistakes

- **Silencing only stdout.** The tool's errors still leak onto the screen.
  - Wrong: `if probe-host "$host" > /dev/null; then`
  - Right: `if probe-host "$host" > /dev/null 2>&1; then`
- **Reversing the pair.** (Order matters, as you just learned.)
  - Wrong: `probe-host "$host" 2>&1 > /dev/null` (stderr still reaches the terminal)
  - Right: `probe-host "$host" > /dev/null 2>&1`
- **Typing the path wrong.** A typo like `/dev/nul` creates a regular file in /dev (or fails), it does not silence anything.
  - Right: `/dev/null`
- **Testing `$?` after the echo.** The `echo` overwrites the status.
  - Wrong: `probe-host "$host" >/dev/null 2>&1; echo checked; if [[ $? -eq 0 ]]`
  - Right: put the command directly in the `if`
