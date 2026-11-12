# Debrief: Contains a Substring

`[[ $s == *sub* ]]` is the third member of a family: `pre*` starts with, `*suf`
ends with, `*sub*` contains. All three are the same glob comparison with the star
placed differently. Once you see that, there is nothing new to memorise.

The interesting part of this level is **quoting inside the pattern**. In the
`[[ ]]` comparison, the unquoted parts of the right-hand side are pattern, the
quoted parts are text. That gives you a precise tool: stars outside the quotes
stay wildcards, anything inside the quotes (a user-supplied word, say) is taken
literally. This is the safe way to do what a naive "unquoted variable" would do
dangerously: a word like `*` or `[abc]` would otherwise match far more than
intended.

The loop shows the pattern for filtering input in plain Bash: read a line,
update counters, print what matters, report a summary at the end. It is slower
than `grep` on large files (Bash executes the loop line by line), so reach for
`grep` when the input is big, and for the built-in when the environment is tiny
or the data is short.

Going further: sometimes "contains" is not precise enough, for example "a number
of 3 digits" or "looks like a version". Patterns are limited there; regular
expressions, a few levels from now, take over.
