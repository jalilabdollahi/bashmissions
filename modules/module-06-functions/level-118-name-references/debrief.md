# Debrief: Name References

Everything so far returned data by printing it. That is awkward for structured
results and impossible for a function that must *modify* something the caller owns,
because `$( )` runs in a subshell and changes made there vanish. A name reference
solves it. `local -n ref=NAME` makes `ref` an alias for the variable called NAME, so
reading `ref` reads that variable and assigning to `ref` assigns to it. The change
happens in the caller's own shell. No copy, no printing.

Think of it as a pointer by name. The caller passes `seen` (a word), the
function dereferences it. This is how a function can fill an array, increment a
counter or set several variables at once.

Two warnings. First, if your reference has the same name as the variable you are
pointing at (`local -n seen=$1` when called with `seen`), Bash reports a circular
reference. Pick unusual alias names such as `list` or `_out` inside helper
functions. Second, a function with a name reference reaches into its caller's
world, so document it clearly. Name references need Bash 4.3 or later, so on very old
systems (such as the macOS system Bash 3.2) they do not exist.

The older technique is `eval`, which builds code from strings and is both clumsy
and dangerous. Name references are the safe replacement.

Going further: the next level returns several values to the caller without any
name references at all.
