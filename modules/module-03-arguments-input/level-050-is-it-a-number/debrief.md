# Debrief: Is It a Number?

Until now your scripts trusted what they were given. Anything that comes from a
person, a file or another system is *untrusted input*, and its shape needs to be
checked before it is used. Validation turns a confusing failure later ("integer
expression expected" somewhere deep in the script) into one clear message at the
door.

`=~` brings regular expressions into Bash. The key habit is the anchors: a
pattern without `^` and `$` answers "does it contain...", usually not the question
you meant. `^[0-9]+$` answers "is it entirely digits, and not empty".

The right side of `=~` is deliberately left unquoted; quoting it makes Bash
compare literally. When a pattern gets long, store it in a variable
(`re='^[0-9]+$'; [[ $x =~ $re ]]`) and use the variable unquoted.

Digits-only is the strict, safe definition of a count or size. Signs and decimal
points are separate decisions that deserve their own patterns, usually in an
arithmetic context (module 8).

Going further: an empty value is another kind of bad input, and it needs its own
check, which is next.
