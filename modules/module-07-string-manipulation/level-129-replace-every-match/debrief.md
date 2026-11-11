# Debrief: Replace Every Match

A second slash turns the replacement from "first" to "all". That is the only
difference from the previous level, but it opens many everyday jobs: turning
spaces into underscores, normalising path separators, deleting a character
everywhere (a replacement of nothing: `${s//,/}` strips all commas).

Two details are worth keeping in mind. First, escaping: inside the expansion the
slash is syntax, so a literal one needs `\/`. A backslash is the general way of
saying "this character is just a character" in patterns. Second, order: the passes
run one after another, each on the result of the previous one. If you replaced
`a` by `b` and then `b` by `c`, the first set of replacements would be swept up
by the second.

The same glob-pattern rule applies as before: `${s//[ \/]/_}` would replace both
spaces and slashes in one go, since `[...]` matches any one character from the
set. That shortcut is fine once you read it fluently, but two clear lines are
easier to maintain.

This is how upload handlers, backup scripts and exporters make names "safe"
before they touch a file system.

Going further: sometimes you only want a replacement at the very start or the
very end of the value. That is the next level.
