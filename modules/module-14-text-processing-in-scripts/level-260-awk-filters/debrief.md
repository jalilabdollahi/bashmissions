# Debrief: awk Filters

You have now seen the whole shape of awk: `pattern { action }`, evaluated for
every line. A missing pattern means "always", a missing action means "print the
line". That is why `awk '$3 > 100'` is a complete, working program: a filter
in six characters.

The subtle part is the type of a comparison. awk has no declared types, but it
does remember where a value came from. A field that looks like a number is a
"strnum" and is compared numerically against a number; compared against a
string literal, it is compared as text. So `$3 > 3` handles `12`, while
`$2 == "P1"` is exact text matching (no regular expression, no case folding,
`p1` does not match). When in doubt, put quotes around text and none around
numbers.

This is the same filter philosophy as before. The program does not loop over
the file, open it, or close it: it describes which lines matter and what to do
with them, and awk supplies the rest. Conditions can use `&&`, `||` and `!`
exactly like Bash's `[[ ]]`.

Going further: filtering picks lines; the next level collects numbers from
them and prints a total once the input ends.
