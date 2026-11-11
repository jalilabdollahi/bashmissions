# Common Mistakes

- **Installing the trap after the signal.** Wrong: `kill -HUP $$` placed before `trap reload HUP` terminates the script, because HUP's default action is to exit. Right: `trap` first, signal after.
- **Overwriting the live value before validating.** Wrong: `level=$(read_level)` inside the handler stores an empty string when the file is broken. Right: read into `fresh`, then `level=$fresh` only inside the `if`.
- **Two copies of the parsing code.** Wrong: the handler parses the file slightly differently from the start-up code, so a config that loads fine is rejected on reload. Right: both call `read_level`.
- **Using `kill -HUP $!` or a hard-coded pid.** Wrong: `$!` is the last background job, usually empty here. Right: `$$` is the current shell.
- **Letting a failing function abort the handler.** Wrong: calling `read_level` bare under `set -e` kills the script on a broken file. Right: use it as an `if` condition and report the failure yourself.
