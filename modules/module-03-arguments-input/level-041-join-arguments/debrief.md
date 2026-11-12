# Debrief: Join Arguments

You now know both quoted forms of "all the arguments", and they are opposites.
`"$@"` keeps N separate words; `"$*"` produces exactly one word, built by
inserting the first character of `IFS` between the pieces. Use `"$@"` to pass
arguments to another command and `"$*"` when you need a single string to print,
log, or display.

`IFS` is Bash's word-glue and word-cutter at once: it is also what `read` and
word splitting use to *cut* strings apart (you will see that in the read levels).
Here it works in reverse, to join.

A professional habit: changing `IFS` globally affects everything after it, so in
longer scripts it is common to limit the change, for example by running the join
inside a function or a subshell `( IFS=,; echo "$*" )`. In this tiny script a
global setting is harmless.

Going further: next you will consume arguments one at a time with `shift`, which
changes both `$#` and what `"$*"` contains.
