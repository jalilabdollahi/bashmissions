# Debrief: Local by Default

In bash, a function is not a separate world. It shares the caller's variables, so an
assignment inside a function overwrites a global of the same name. `local` creates a
fresh variable that exists only for the duration of the function (and for functions
it calls) and then disappears, restoring whatever was there before. Bash implements
this as a stack of scopes: `local name` pushes a new binding that shadows the global;
returning pops it.

The effect on your code is the effect of private fields on an object: changing a
helper's internals can no longer break callers. That is what makes a function a unit
you can reason about on its own. Without it, adding a harmless line in one function
changes the output of another, which is the bug this level shows. Names like `i`,
`name`, `line` and `tmp` are the usual collision victims.

The professional habit is: every variable assigned in a function is declared `local`,
the only exceptions being globals you mean to set, which then deserve a comment. Also
declare and assign separately when the right side is a command, so you do not mask its
exit status.

Going further: private variables make small functions safe. Level 282 is about how
small: each function doing exactly one job.
