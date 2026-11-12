# Debrief: mapfile from a Command

`mapfile -t arr < <(command)` loads the output of any command into an array, and keeps the array in your shell.

## How it works
`<(command)` is process substitution. Bash starts the command in the background, connects its output to a temporary pipe or file descriptor, and replaces the whole `<(...)` with a name that can be opened like a file. The first `<` is an ordinary input redirect for `mapfile`, which therefore sees the output as if it were a file. Compare level 166: the same built-in, with a different source of lines.

Why not a pipe? In `command | mapfile -t arr`, each side of the pipe runs in its own subshell, and the variable assigned in the right-hand side is gone when the pipeline ends. Process substitution puts the command in the subshell instead and `mapfile` in yours. If you remember level 94, this is the same cure.

The exit status of the command inside `<(...)` is invisible to `set -e`, so check things you care about in a separate step (the directory check above).

## In real work
Anything produced by tools: `find` results, `git`-style listings, `grep -l` matches, sorted unique values. Capture once, then loop, count or index as much as you like.

## Going further
You can now fill arrays from arguments, files and commands. Next: looking things up inside them.
