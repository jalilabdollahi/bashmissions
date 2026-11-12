# Debrief: Strip a Prefix

The `#` operator trims from the **front**. A handy memory trick from the old
keyboard layout: `#` sits to the left of `$` and `%` on the right, so `#` works on
the left end of the value and `%` on the right. You will use `%` shortly.

The pattern is a glob, not a regular expression, and it must match from the very
first character. `${url#https}` removes a literal "https" only when the value
starts with it; `${url#*://}` removes "whatever comes before the first ://".
Because the match is anchored at the start, it can never accidentally chew the
middle of the string.

When more than one prefix fits, a single `#` takes the shortest, which here meant
"up to the first `://`". There is a longer sibling that takes the longest, and the
next level shows when you want that one instead.

If nothing matches, nothing happens. That makes `#` safe to apply blindly to
data that may or may not carry a prefix: file names with or without `./`, ids
with or without `ID-`, hosts with or without `www.`.

Going further: the same trick removes a whole directory path from a file name.
That needs the longer variant.
