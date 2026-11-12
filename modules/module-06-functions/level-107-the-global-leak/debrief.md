# Debrief: The Global Leak

The bug in this level is the most common one in Bash functions. There is a single
flat namespace unless you ask for more: when a function assigns `count=...`, and
the caller also has a `count`, they are the same variable. Nothing warns you. The
script simply behaves strangely, and the bug often shows up far from the cause.

Debugging strategy: when a value changes unexpectedly, search for every
assignment to that name (`grep -n 'count=' script.sh`) and look at which functions
run between the last good value and the first bad one. Printing the variable to
stderr after each call, as in the walkthrough, pins the culprit in minutes.

Prevention is a habit: every variable in a function body is `local` unless you
mean to hand it back. When you do mean it, such as the `bar` here, say so in a
comment. Some teams prefix intentional globals (`RESULT_bar`) so they stand out.

Real incidents look just like this: a helper reuses `i`, `tmp` or `file`, and a
loop in the main script silently restarts or skips.

Going further: a function can also hand results back through stdout, which
avoids shared names completely. A later level shows how to return several values
that way.
