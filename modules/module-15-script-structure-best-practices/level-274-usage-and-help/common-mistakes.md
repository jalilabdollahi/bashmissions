# Common Mistakes

- **Sending errors to stdout.** Wrong: `usage; exit 2` prints the text into the pipe that a caller is reading. Right: `usage >&2; exit 2`.
- **Exiting 0 after a usage error.** Wrong: `usage >&2; exit`. A bare `exit` reuses the last status, which is 0. Right: `exit 2`.
- **Touching `$1` before checking `$#`.** With `set -u`, `if [ "$1" = -h ]` crashes when no argument was given. Right: `${1:-}`, or test `$#` first.
- **Duplicating the help text.** Wrong: one `echo` block in the help branch and a slightly different one in the error branch, which drift apart. Right: one `usage()` function called from both.
- **Treating `--help` as just another argument.** Wrong: checking `$# -ne 2` first means `ticket.sh --help` complains instead of helping. Right: handle the help flag before counting.
