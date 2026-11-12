# Debrief: Local Variables

In Bash, a variable assigned anywhere is global by default: every function and the
main script share one namespace. `local` creates a new variable that exists only
while the function runs (and in functions it calls), and it shadows any global of
the same name. When the function returns, the outer value is back untouched.

This is the difference between a function that is a tidy black box and one that
has side effects. With `local` you may use short, obvious names like `i`, `tmp`
or `total` without worrying that some other part of a 400-line script is also
using them.

Under the hood Bash keeps a stack of scopes for function calls. `local` puts the
name into the current scope; lookups search from the innermost scope outwards.
This is "dynamic scoping", so a function you call from inside also sees your
locals, which is occasionally a surprise.

A trap: `local x=$(cmd)` reports the status of `local`, not of `cmd`, so errors are
swallowed. Declare first, assign afterwards.

Going further: next level you get a script where somebody forgot `local`, and you
have to find out why the numbers are wrong.
