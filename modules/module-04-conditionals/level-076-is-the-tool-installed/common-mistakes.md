# Common Mistakes

- **Using `which`.** It is not a built-in and behaves differently on macOS, Debian and Alpine.
  - Wrong: `if which "$tool"; then`
  - Right: `if command -v "$tool" >/dev/null 2>&1; then`
- **Leaving the output on.** Without the redirect, `command -v` prints the path before your own message.
  - Wrong: `if command -v "$tool"; then echo "found"`
  - Right: `if command -v "$tool" >/dev/null 2>&1; then echo "found"`
- **Running the tool to find out if it exists.** `"$tool" --version` fails for many reasons, and under `set -e` the script may die before you can say "missing".
  - Wrong: `if "$tool" --version; then ... else echo missing`
  - Right: check with `command -v` first, and only then run the tool
- **Forgetting the no-argument case.** Under `set -u`, a bare `$1` aborts with "unbound variable" before your friendly message.
  - Wrong: `tool="$1"` as the first line
  - Right: check `$#` first, then read `$1`
