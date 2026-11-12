# Common Mistakes

- **Copying the help text into the code.** Wrong: `echo "Usage: tidy-tmp.sh ..."` next to a header that says the same thing; one gets edited and the other does not. Right: print the header itself.
- **Printing the shebang.** Wrong: starting at line 1 shows `#!/usr/bin/env bash` as the first help line. Right: skip `NR == 1`.
- **Not stopping at the end of the block.** Wrong: `grep '^#' "$0"` prints every comment in the file, including ones deep in the code. Right: stop at the first line that is not a comment (`{ exit }`).
- **Losing the blank lines.** Wrong: removing every `#` line that is empty, or stripping `# ` but not a bare `#`, which leaves a stray `#` in the output. Right: `sub(/^# ?/, "")` handles both.
- **Reading `$1` under `set -u` with no argument.** Wrong: `case "$1" in` aborts with "unbound variable" when the script is run bare. Right: `case "${1:-}" in`.
