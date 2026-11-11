# Debrief: Require an Argument

Good tools fail early, loudly and in a machine-readable way. This level added all
three: the check happens before any work is done, the message tells the human how
to fix it, and the exit status tells the *calling program* what went wrong.

Two conventions are worth memorising. First, diagnostics go to stderr so that
`./tool > out.txt` never fills `out.txt` with error text. Second, `0` means
success, `1` is a general failure, and `2` is widely used for command-line misuse,
which is why the objective asked for it. Callers can check `$?` to react.

Under the hood `[[ ... ]]` is a command that returns success or failure, and `&&`
runs the next command only after success. The braces make a command group so two
commands share one condition.

In real work this guard is the first three lines of nearly every script that takes
arguments, and `usage: name ARGS` is the format users expect, the same as `cp` or
`grep` print.

Going further: sometimes the argument should be optional, with a sensible
default. That is the next level.
