# Debrief: A die() Helper

`die` is probably the most copied helper in shell scripting. It captures a
convention: errors go to stderr, are recognisable (`error:` prefix) and end the
script with a non-zero status that tells the caller what kind of failure it was.

Why a function and not a one-liner? Because the policy lives in one place. When Priya
decides that errors also have to go to the system log, or that the message should
include the script name, you change `die` and every script that sources it follows.
(Level 110 showed how to share it as a library.)

Mind the difference between `return` and `exit`. `return` leaves the function;
`exit` leaves the shell, which in a script means the script. Inside a `$( )`
command substitution, though, `exit` only ends the subshell that was created for
it, so `value=$(find_it || die 3 "...")` does not stop the main script the way
you might expect. Handle the failure outside the substitution.

Under `set -e`, a plain `exit 1` from `die` gives the same result, but the explicit
code lets callers distinguish usage errors (2), missing input (3) and bad content (4).
Conventions vary; pick yours and document it.

Going further: not every message is fatal. The next level makes a helper for
informational and warning lines too.
