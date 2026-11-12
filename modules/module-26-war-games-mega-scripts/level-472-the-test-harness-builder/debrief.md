# Debrief: The Test Harness Builder

Writing a test harness teaches you something about Bash that few scripts reveal: *how errors flow*.
A subshell isolates variables, directory changes and traps, which is exactly what a test
needs; and the only channels back to the parent are the exit status, files and the output you
captured. The harness turns those channels into a vocabulary: status 0 is pass, 77 is skip,
anything else is failure, a message file carries the reason.

The `set -e` behaviour is the lesson to remember. Errexit is suppressed in any context where the shell
is already testing a command's status (`if`, `while`, `&&`, `||`, `!`), and the suppression applies
*inside* functions and subshells called from there. That is why checking a command
and having `set -e` care about its inner failures are mutually exclusive in one expression, and why
the harness switches `set +e` on explicitly around the subshell. You will meet the same issue in any
script that runs user-supplied steps.

Other transferable ideas: discover work by reading text instead of executing it; give every unit of
work a fresh temp directory and clean it up with a trap; make failures report *why*; and validate
syntax before running, so one bad file does not turn into noise. These are the same ideas behind
bats, shunit2 and every CI system.

Going further: the next mission builds on discovery again, but for runtime extensions: a plugin
system.
