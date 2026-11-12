# Debrief: Return Data on stdout

Shell has no return values for data. `return` is only for the exit status, so the
convention is: a function that produces a result *prints* it, and the caller
captures it with `$( )`. This is not a trick; it is how every Unix tool works.
`basename`, `date` and `wc` produce data by printing it, and you capture them
with the very same syntax.

Under the hood `$( )` runs the function in a subshell, a child copy of the shell,
and connects its stdout to a pipe that Bash reads into the variable. Trailing
newlines are removed. Two consequences matter. First, anything the function
prints ends up in the variable, including stray debugging `echo` lines, so
keep diagnostics on stderr (`>&2`). Second, the child cannot change the parent's
variables (levels 106 and 107 come back to scope).

Good practice: a data-returning function should print *only* its result, and
it should end with a newline, so it also works when called bare in a pipeline.

Real examples: `ts=$(timestamp)`, `host=$(short_hostname "$fqdn")`,
`slug=$(slugify "$title")`.

Going further: the function above used a variable named `slug`. Next you will
learn how to keep such helpers from tampering with the caller's variables.
