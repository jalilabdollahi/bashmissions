# Debrief: Anchors

A regex without anchors is a search: it succeeds if the shape appears
*anywhere*. Anchors turn the search into a statement about position. `^` stands
for the invisible spot before the first character, and `$` for the invisible
spot after the last one. They do not match any character themselves; they match
a place.

That is why `^$` identifies an empty line: the start and the end are in the same
place only when nothing lies between them. It is also why `^yes$` is a whole
string test, while `yes` alone is "contains".

Anchors are the cheapest way to make a regex *precise*. Most regex bugs in real
scripts are not "it failed to match the good input" but "it also matched
garbage": a commented-out line treated as live config, `yesterday` read as `yes`.
When you validate input (an email, an IP address, a date), you will almost always
want both anchors, so that nothing extra can sit around the part you checked.

In the shell, `$` has a second life as the start of a variable expansion. Inside
`[[ =~ ]]` a `$` at the very end of the pattern is the anchor, but remember
this when you put a regex in a double-quoted string.

Going further: so far every pattern was literal text. Next you will describe
*kinds* of characters (any digit, any lowercase letter) with character classes.
