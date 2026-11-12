# Debrief: Command Groups

## What you learned

`{ list; }` turns several commands into one *compound command* that runs in the
**current shell**. Anything you can do to a single command, you can do to the
whole group: redirect its output, pipe it, put it after `&&` or `||`. The
price is syntax: a space after `{`, and a `;` or newline before `}`.

## Under the hood

Braces and parentheses look alike but behave oppositely. `( ... )` forks a
child shell, so variables and `exit` stay inside. `{ ...; }` forks nothing: the
same shell runs the commands, so an `exit` ends the script and an assignment is
still there afterwards. A redirection on a group is applied once, by the
shell, before the first command runs; the group's commands all inherit that
open file as their standard output.

One catch: in a pipeline such as `{ ... } | sort`, the group is placed in a subshell
because it is one side of a pipe. Then the "current shell" rule no longer holds.

## In real work

The `|| { echo "..." >&2; exit 1; }` line is the most common use: a tidy
"die" in two statements. Redirecting a whole block (`{ ...; } > file`) is how
reports, config files and multi-line logs get written in one go.

## Going further

Program-to-program plumbing so far used files and ordinary pipes. Next: a
pipe that has a name and lives in the file system.
