# Common Mistakes

- **Redirecting without saving.** Nothing can bring the terminal back.
  - Wrong: `exec > build.log` then trying `exec > /dev/tty` on a machine without one
  - Right: `exec 4>&1` first, then `exec > build.log`
- **Swapping the restore.** `exec 4>&1` after the redirect saves the log, not the screen.
  - Wrong: `exec > build.log; exec 4>&1` (4 points at the log)
  - Right: `exec 4>&1; exec > build.log`
- **Forgetting to close the spare.** Descriptor 4 stays open and leaks into children.
  - Wrong: `exec 1>&4`
  - Right: `exec 1>&4 4>&-`
- **Counting lines while the log is still the destination of your messages.** The summary goes into the file.
  - Wrong: `echo "build finished"` before the restore
  - Right: restore first, then print
