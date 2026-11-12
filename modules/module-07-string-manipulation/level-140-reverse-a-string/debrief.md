# Debrief: Reverse a String

Bash has no built-in reverse, so you built one from two small primitives: the
length `${#s}` and the one-character slice `${s:i:1}`. That pair is the general key
to walking a string character by character, and with it any per-character job is
open to you: reversing, counting, validating, converting.

The shape of the loop is worth studying. The C-style `for (( init; test; step ))`
is the right tool when you need to control the counting. Counting down is a
different kind of loop from the ones you wrote counting up, and it is a classic
place for off-by-one bugs: start at `length - 1` (the last position), keep going
while `i >= 0`, and stop at 0. Printing `i` while debugging is the usual way to
catch a slip.

Notice the empty-string behaviour: it came out right without any `if`, because
the loop condition was false from the beginning. Designing code so that "nothing"
falls out of the normal path is a mark of tidy scripts.

Performance note: appending to a string in a loop is fine for short values like
tokens and file names, but a megabyte of text would be better handled by a
dedicated tool.

Going further: so far you have matched with globs. The next two levels switch to
regular expressions, which can describe shapes like "three digits, a dot, three
digits".
