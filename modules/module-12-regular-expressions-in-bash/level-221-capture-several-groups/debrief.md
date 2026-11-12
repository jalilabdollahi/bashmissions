# Debrief: Capture Several Groups

One match can hand you many values. Every pair of parentheses becomes a slot in
`BASH_REMATCH`, numbered by where its opening bracket sits, reading from left to
right. The mental model is a template with blanks: the literal parts and the
anchors check the shape, and the parentheses mark the blanks you want filled in.

Two habits make this reliable. First, escape the separators that are special:
a dot, a bracket or a plus that should be literal needs a backslash, or you will
match more than you meant. Second, always anchor when you validate. Without `^`
and `$`, `v2.14.3-rc1` would be accepted and your tracker would record a
version that looks fine but is not.

Numbering also grows nested. When groups sit inside other groups, the *outer*
bracket opens first and gets the lower number. If you ever lose track, a quick
debugging line `declare -p BASH_REMATCH` prints the whole array, group by group.

A regex does the work of three jobs at once here: it validates the format, splits
it, and names the pieces. In real scripts you will use it for version strings,
timestamps, `host:port` pairs and the lines of many log formats.

Going further: next you will apply the same method to a data type everybody
validates badly: the email address.
