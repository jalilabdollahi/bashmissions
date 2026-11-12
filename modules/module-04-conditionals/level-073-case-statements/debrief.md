# Debrief: case Statements

`case` is the shell's menu. You give it one word and a list of patterns, and it
runs the commands of the first pattern that matches. It reads like the
runbook's "if the operator says start, do this; if stop, do that", and the
default branch `*)` turns a typo into a clean usage message instead of a silent
no-op.

## Under the hood

`case` matches the word against each pattern in order, using the same glob rules
as file names (`*`, `?`, `[ ]`), and stops at the first match. The `;;`
terminator ends that branch. Forgetting it is a syntax error, and omitting the
default branch means unknown words quietly do nothing. Matching is
case-sensitive unless you explicitly enable `shopt -s nocasematch`.

Unlike `if`, `case` does not run a test command; it only compares strings. That
limits it to "one value against many patterns", but within that job it is both
shorter and clearer than a ladder.

## Where it shows up

Init scripts (`start|stop|restart`), command-line tools with sub-commands (`git
commit`, `docker run`), option parsing, and anything that dispatches on a
first word.

## Going further

Each branch here matched one fixed word. Branches may also match several words
at once or whole shapes such as `*.tar.gz`. That is the next level.
