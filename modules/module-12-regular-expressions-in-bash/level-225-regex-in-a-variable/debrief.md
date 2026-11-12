# Debrief: Regex in a Variable

The right-hand side of `=~` is the one place in Bash where quotes change the
*meaning* of the pattern and not just the splitting. Unquoted, it is a regex.
Quoted (single or double), every character is taken literally. That rule is
useful, because it gives you "contains this exact text" for free, and treacherous
because you used to quote everything.

The safe habit has three parts:

1. Write the regex in single quotes **in a variable**: `re='^[0-9]{3}$'`. Single
   quotes stop the shell from touching `$`, backslashes and spaces.
2. Use the variable **unquoted** in the test: `[[ $x =~ $re ]]`. That is one of
   the very few places where an unquoted expansion is correct, and it does not
   word-split inside `[[ ]]`.
3. Quote it only when you want *text*: `[[ $x =~ "$userinput" ]]`.

The third point is also a safety feature. If a pattern comes from a user (as in
today's script), unquoted use lets them supply a regex, possibly one that is
invalid or surprising. When you only need "contains this text", quote it.

Why a variable at all? Inline, `[[ $s =~ (a|b) ]]` is fine, but a regex with a
space, `|`, or `)` outside of parentheses needs escaping that makes it hard to
read. In a single-quoted variable it reads like the regex it is. Everything from
here on in this module keeps its regexes in variables.

Going further: next the same regex language leaves Bash and goes to work in
`grep -E`.
