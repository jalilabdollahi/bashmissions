# Debrief: Report the Failing Line

An ERR trap is a smoke detector. It does not put out the fire and does not even
stop the script (that is still `set -e`'s job), but it makes sure that when a
command fails you hear about it with context. Bash runs the trap in the failing
command's own place, so `$LINENO` and `$BASH_COMMAND` identify exactly that
command, which turns "exit status 1" into "line 5, cp release/app.tar out/".

The rules for when the trap fires match `set -e`: it does not fire for failures
in `if` conditions, `while` tests, `!` negations, or the non-final parts of `&&`
and `||` lists. Those failures are expected answers, and a noisy detector would
be useless.

Two practical lessons. First, trap strings are code that runs later, so single
quotes are the default; double quotes freeze values at the time of `trap`.
Second, this is a debugging aid and a log line. Do not put heavy logic in the
handler, because it runs in the middle of a failure, and it must not fail
itself.

In practice teams make this a standard header for every script: strict mode plus
an ERR trap that prints the script name, line and command. A night-time failure
then explains itself in the morning log.

Going further: ERR is not the only trap. The next level catches a signal: what
happens when someone presses Ctrl-C.
